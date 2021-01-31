import 'package:flutter/material.dart';
import 'package:mootclub_app/Authentication/OtpScreen.dart';
import 'package:mootclub_app/aws/cognito.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Register extends StatefulWidget {
  Register();
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _register = true;

  bool _askConfirmCode = false;

  _registerUser() async {
    final bool result = await signUpWithCognito(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim());

    if (result) {
      setState(() {
        _askConfirmCode = true;
        _register = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: !_askConfirmCode
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
              Widget>[
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
                  child: Column(
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                  labelText: 'EMAIL',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[400]),
                                  // hintText: 'EMAIL',
                                  // hintStyle: ,
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green))),
                              validator: (val) {
                                if (val.isEmpty)
                                  return 'Please fill this field';
                                return null;
                              },
                            ),
                            SizedBox(height: 10.0),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                  labelText: 'PASSWORD ',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[400]),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green))),
                              validator: (val) {
                                if (val.isEmpty)
                                  return 'Please fill this field';
                                return null;
                              },
                              obscureText: true,
                            ),
                            SizedBox(height: 10.0),
                            TextFormField(
                              controller: _confirmPasswordController,
                              decoration: InputDecoration(
                                  labelText: 'CONFIRM PASSWORD ',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[400]),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green))),
                              obscureText: true,
                              validator: (val) {
                                if (val.isEmpty)
                                  return 'Please fill this field';
                                else if (_register == true &&
                                    _confirmPasswordController.text.trim() !=
                                        val.trim()) return 'password mismatch';
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50.0),
                      InkWell(
                        onTap: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            if (_register)
                              await _registerUser();
                            else
                              Fluttertoast.showToast(
                                  msg: 'User already registered.');
                          }
                        },
                        child: Container(
                            height: 40.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Colors.amberAccent,
                              color: Colors.amber,
                              elevation: 7.0,
                              child: Center(
                                child: Text(
                                  'SIGNUP',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Lato'),
                                ),
                              ),
                            )),
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
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Center(
                              child: Text('Go Back',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Lato')),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))
            ])
          : OtpScreen(
              emailController: _emailController.text,
              passwordController: _passwordController.text,
            ),
    );
  }
}
