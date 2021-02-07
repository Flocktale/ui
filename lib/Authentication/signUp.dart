import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mootclub_app/Models/sharedPrefKey.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/providers/userData.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen();
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _loading = false;

  _changeLoading() {
    if (!this.mounted) return;

    setState(() {
      _loading = !_loading;
    });
  }

  _signUpWithBackend() async {
    if (_nameController.text.isEmpty || _usernameController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter all the fields');
      return;
    }

    _changeLoading();

    final service = Provider.of<DatabaseApiService>(context, listen: false);

    final _prefs = await SharedPreferences.getInstance();
    final userId = _prefs.getString(SharedPrefKeys.USERID);
    final email = _prefs.getString(SharedPrefKeys.EMAIL);

    final newUser = BuiltUser((b) => b
      ..userId = userId
      ..name = _nameController.text.trim()
      ..email = email
      ..username = _usernameController.text.trim());

    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    final response =
        await service.createNewUser(newUser, authorization: authToken);

    if (response != null && response.body != null) {
      Fluttertoast.showToast(msg: 'Your registration is successfull!');

      final fcmToken = await FirebaseMessaging().getToken();
      final authToken = Provider.of<UserData>(context, listen: false).authToken;

      // sending device token to backend to get notifications for this user on current device.
      Provider.of<DatabaseApiService>(context, listen: false).registerFCMToken(
          BuiltFCMToken((b) => b..deviceToken = fcmToken),
          authorization: authToken);

      Provider.of<UserData>(context, listen: false).updateUser = newUser;
      Navigator.of(context).popUntil(ModalRoute.withName("/"));

      // We don't need to push from here as Consumer at root path will automatically change the screen to home screen on listening changes of auth status;

    }

    _changeLoading();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                        child: Text(
                          'Signup',
                          style: TextStyle(
                              fontSize: 80.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(260.0, 125.0, 0.0, 0.0),
                        child: Text(
                          '.',
                          style: TextStyle(
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
                  child: Column(children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                                labelText: 'NAME',
                                labelStyle: TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[400]),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.amber))),
                            validator: (val) {
                              if (val.isEmpty) return 'Please fill this field';
                              return null;
                            },
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                                labelText: 'USER NAME ',
                                labelStyle: TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[400]),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.amber))),
                            validator: (val) {
                              if (val.isEmpty) return 'Please fill this field';
                              return null;
                            },
                          ),
                          SizedBox(height: 50),
                          InkWell(
                            onTap: _signUpWithBackend,
                            child: Container(
                                height: 40.0,
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.0),
                                  shadowColor: Colors.amberAccent,
                                  color: Colors.amber,
                                  elevation: 7.0,
                                  child: Center(
                                    child: Text(
                                      'SUBMIT',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Lato'),
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ]),
                )
              ]));
  }
}
