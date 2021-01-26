import 'package:flutter/material.dart';
import 'package:mootclub_app/Authentication/register.dart';
import 'package:mootclub_app/Authentication/signUp.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/Models/sharedPrefKey.dart';
import 'package:mootclub_app/aws/cognito.dart';
import 'package:mootclub_app/providers/webSocket.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mootclub_app/providers/userData.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _askConfirmCode = false;

  _logInUser() async {
    // print("11111111111111111");
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => Loading()));
    List<String> codes = [
      'NotAuthorizedException', //incorrect username or password
      'UserNotConfirmedException', // User is not confirmed
    ];
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      Navigator.pop(context);
      return;
    }
    // print(_emailController.);

    final userId = await startSession(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim());

    if (userId == codes[0]) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: 'Incorrect Username or Password', gravity: ToastGravity.TOP);
      return;
    } else if (userId == codes[1]) {
      Navigator.of(context).pop();

      setState(() {
        _askConfirmCode = true;
      });

      return;
    }

    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final user = (await service.getUserProfile(userId))?.body?.user;
    Navigator.of(context).pop();

    if (user == null)
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => SignUpScreen(
              userId: userId, email: _emailController.text.trim())));
    else {
      final _prefs = await SharedPreferences.getInstance();
      await _prefs.setString(SharedPrefKeys.USERID, userId);

      Provider.of<UserData>(context, listen: false).updateUser = user;
      // Provider.of<MySocket>(context,listen: false).update(userId);
      Navigator.of(context).pushNamed('/');
      // We don't need to push from here as Consumer at root path will automatically change the screen to home screen on listening changes of auth status;

    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.00, 0.00),
                  child: Text(
                    'Hello',
                    style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 80.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 175.0, 0.00, 0.00),
                  child: Text(
                    'There',
                    style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 80.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(225.0, 175.0, 0.00, 0.00),
                  child: Text(
                    '.',
                    style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 80.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
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
                          borderSide: BorderSide(color: Colors.amber))),
                ),
                SizedBox(
                  height: 20.0,
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
                          borderSide: BorderSide(color: Colors.amber))),
                  obscureText: true,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  alignment: Alignment(1.0, 0.0),
                  padding: EdgeInsets.only(top: 15.0, left: 20.0),
                  child: InkWell(
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
                Container(
                  height: 40.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Colors.amberAccent,
                    color: Colors.amber,
                    elevation: 7.0,
                    child: InkWell(
                      onTap: () {
                        // Navigator.of(context).pushNamed(Loading);
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
                SizedBox(height: 20.0),
                Container(
                  height: 40.0,
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
                        SizedBox(width: 10.0),
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
                      color: Colors.amber,
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
