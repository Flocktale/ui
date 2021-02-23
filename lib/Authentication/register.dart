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
  final _tagLineController = TextEditingController();

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
    final size = MediaQuery.of(context).size;
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: !_askConfirmCode
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
              Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(size.width/20, size.height/10, 0, 0),
                      child: Text(
                        'Signup',
                        style: TextStyle(
                            fontSize: size.width/5, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(size.width/1.5, size.height/9, 0.0, 0.0),
                      child: Text(
                        '.',
                        style: TextStyle(
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
                                          BorderSide(color: Colors.red))),
                              validator: (value) {
                                if (value.isEmpty ||
                                    !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value)) {
                                  return 'Enter a valid email!';
                                 
                                }
                               
                                return null;
                              },
                            ),
                            SizedBox(height: size.height/100),
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
                                          BorderSide(color: Colors.red))),
                              validator: (val) {
                                if (val.isEmpty)
                                  return 'Please fill this field';
                                return null;
                              },
                              obscureText: true,
                            ),
                            SizedBox(height: size.height/100),
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
                                          BorderSide(color: Colors.red))),
                              obscureText: true,
                              validator: (val) {
                                if (val.isEmpty)
                                  return 'Please fill this field';
                                else if (_register == true &&
                                    _passwordController.text.trim() !=
                                        val.trim()) return 'password mismatch';
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height/20),
                      InkWell(
                        onTap: () async {
                          // for(int i=0;i<100;i++)
                          // print("$i$_register");
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
                            height: size.height/20,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Colors.redAccent,
                              color: Colors.red,
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
                      SizedBox(height: size.height/40),
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
              email: _emailController.text,
              password: _passwordController.text,
            ),
    );
  }
}
