import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/services/SecureStorage.dart';
import 'package:mootclub_app/aws/cognito.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mootclub_app/providers/userData.dart';

import '../services/SecureStorage.dart';
import '../services/SecureStorage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  void _logInUser() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      return;
    }

    setState(() {
      _loading = true;
    });

    List<String> codes = [
      'NotAuthorizedException', //incorrect username or password
      'UserNotConfirmedException', // User is not confirmed
    ];

    final _email = _emailController.text.trim();
    final _password = _passwordController.text.trim();

    final cognitorError = await startSession(
        email: _email,
        password: _password,
        callback: (String id, CognitoUserSession session) {
          Provider.of<UserData>(context, listen: false).userId = id;
          Provider.of<UserData>(context, listen: false).cognitoSession =
              session;
        });

    if (cognitorError != null) {
      if (cognitorError == codes[0]) {
        Fluttertoast.showToast(
            msg: 'Incorrect Username or Password', gravity: ToastGravity.TOP);
      } else if (cognitorError == codes[1]) {
        Fluttertoast.showToast(
            msg: 'User Not Confirmed', gravity: ToastGravity.TOP);
      }
      setState(() {
        _loading = false;
      });
      return;
    }

    // user is logged in

    final fcmToken = await FirebaseMessaging().getToken();
    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    final userId = Provider.of<UserData>(context, listen: false).userId;

// sending device token to backend to get notifications for this user on current device.
    Provider.of<DatabaseApiService>(context, listen: false).registerFCMToken(
      userId: userId,
      body: BuiltFCMToken((b) => b..deviceToken = fcmToken),
      authorization: authToken,
    );

    // final _prefs = await SharedPreferences.getInstance();
    // final _storage = new FlutterSecureStorage();
    final _storage = SecureStorage();
    await _storage.setEmail(_email);
    await _storage.setPassword(_password);

// current navigation path is "/" , i.e. we are in RootPage class
// so Provider.of<UserData>(context, listen: false).fetchUserFromBackend(); will automatically handle further action,
// which is whether to go to sign up or home page
    Provider.of<UserData>(context, listen: false).fetchUserFromBackend();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(15, size.height/10, 0, 0),
                        child: Text(
                          'Hello',
                          style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: size.width/5,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15, size.height/5, 0, 0),
                        child: Text(
                          'There',
                          style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: size.width/5,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(size.width/1.75, size.height/5, 0, 0),
                        child: Text(
                          '.',
                          style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: size.width/5,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: size.height/30, left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                            labelText: 'EMAIL',
                            labelStyle: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[400]),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red))),
                      ),
                      SizedBox(
                        height: size.height/50,
                      ),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                            labelText: 'PASSWORD',
                            labelStyle: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[400]),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red))),
                        obscureText: true,
                      ),
                      SizedBox(
                        height: size.height/200,
                      ),
                      Container(
                        alignment: Alignment(1.0, 0.0),
                        padding: EdgeInsets.only(top: size.height/85, left: 20.0),
                        child: InkWell(
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height/25),
                      Container(
                        height: size.height/20,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.redAccent,
                          color: Colors.red,
                          elevation: 7.0,
                          child: InkWell(
                            onTap: () {
                              _logInUser();
                            },
                            child: Center(
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Lato'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height/50),
                      Container(
                        height: size.height/20,
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black,
                                  style: BorderStyle.solid,
                                  width: 1.0),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: ImageIcon(
                                    AssetImage('assets/images/facebook.png')),
                              ),
                              SizedBox(width: size.height/100),
                              Center(
                                child: Text('Log in with facebook',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Lato')),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'New to MootClub ?',
                      style: TextStyle(fontFamily: 'Lato'),
                    ),
                    SizedBox(width: 5.0),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('/register');
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                            color: Colors.red,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                )
              ],
            ),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
