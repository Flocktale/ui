import 'package:flutter/material.dart';
import 'package:mootclub_app/Authentication/signUp.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/Models/sharedPrefKey.dart';
import 'package:mootclub_app/aws/cognito.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mootclub_app/services/chopper/user_database_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mootclub_app/providers/userData.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
class Register extends StatefulWidget {
  Register();
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _register = true;

  bool _askConfirmCode = false;

  bool _loading = false;

  String _confirmCodeController;
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

  _changeLoading() {
    if (!this.mounted) return;

    setState(() {
      _loading = !_loading;
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                  child: Text(
                    'Signup',
                    style:
                    TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold),
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
          !_askConfirmCode?Container(
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
                                  borderSide: BorderSide(color: Colors.green))),
                          validator: (val) {
                            if (val.isEmpty) return 'Please fill this field';
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
                                  borderSide: BorderSide(color: Colors.green))),
                          validator: (val) {
                            if (val.isEmpty) return 'Please fill this field';
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
                                  borderSide: BorderSide(color: Colors.green))),
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
                  Container(
                      height: 40.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.amberAccent,
                        color: Colors.amber,
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () async {
                            if(_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              if(_register)
                                await _registerUser();
                              else
                                Fluttertoast.showToast(msg: 'User already registered.');
                            }
                          },
                          child: Center(
                            child: Text(
                              'SIGNUP',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Lato'),
                            ),
                          ),
                        ),
                      )),
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
                        child:

                        Center(
                          child: Text('Go Back',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Lato')),
                        ),


                      ),
                    ),
                  ),
                ],
              )
          ):
          Container(
            padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
            child: Column(
              children: <Widget>[
                Text('Enter the OTP'),
                SizedBox(height: size.height/50),
                OTPTextField(
                  length: 6,
                  fieldStyle: FieldStyle.underline,
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold,
                  ),
                  onCompleted: (pin){
                    setState(() {
                      _confirmCodeController = pin;
                    });
                  },
                ),
                SizedBox(height: 5.0,),
                Container(
                  alignment: Alignment(1.0, 0.0),
                  padding: EdgeInsets.only(top:15.0,left:20.0),
                  child: InkWell(
                    onTap: () async{
                      await reSendConfirmationCode(
                          _emailController.text.trim());
                    },
                    child: Text(
                      'Resend OTP',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50.0),
                Container(
                    height: 40.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.amberAccent,
                      color: Colors.amber,
                      elevation: 7.0,
                      child: GestureDetector(
                        onTap: () async {
                          final bool res = await confirmUserCognito(
                          email: _emailController.text.trim(),
                          code: _confirmCodeController.trim());

                          if (res == true) {
                            final userId = await startSession(
                                email: _emailController.text.trim(),
                                password:
                                _passwordController.text.trim());
                            if (userId != null) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (_) => SignUpScreen(
                                          userId: userId,
                                          email: _emailController.text
                                              .trim())));
                            }

                          }
                        },
                        child: Center(
                          child: Text(
                            'SUBMIT',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lato'),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),

        ]));
  }
}