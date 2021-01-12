import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mootclub_app/Authentication/signUp.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/Models/sharedPrefKey.dart';
import 'package:mootclub_app/aws/cognito.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mootclub_app/providers/userData.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class OtpScreen extends StatefulWidget {
  String emailController;
  String passwordController;
  OtpScreen({this.emailController,this.passwordController});
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _confirmCodeController;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: size.height/30),
              Stack(
                children: [
                  Text('Enter the \nOTP',style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 60,
                  ),),
                  Container(
                    padding: EdgeInsets.fromLTRB(120.0, 55.0, 0.00, 0.00),
                    child: Text(
                      '.',
                      style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 80.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber),
                    ),
                  ),
                ],
              ),

              SizedBox(height: size.height/5),
              Container(
                height: 50,
                width: size.width,
                child: OTPTextField(
                  length: 6,
                  fieldStyle: FieldStyle.underline,
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                    decorationColor: Colors.green
                  ),
                  onCompleted: (pin){
                    setState(() {
                      _confirmCodeController = pin;
                    });
                  },
                ),
              ),
              SizedBox(height: 5.0,),
              Container(
                alignment: Alignment(1.0, 0.0),
                padding: EdgeInsets.only(top:15.0,left:20.0),
                child: InkWell(
                  onTap: () async{
                    await reSendConfirmationCode(
                        widget.emailController.trim());
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
                    child: InkWell(
                      onTap: () async {
                        final bool res = await confirmUserCognito(
                            email: widget.emailController.trim(),
                            code: _confirmCodeController.trim());

                        if (res == true) {
                          final userId = await startSession(
                              email: widget.emailController.trim(),
                              password:
                              widget.passwordController.trim());
                          if (userId != null) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) => SignUpScreen(
                                        userId: userId,
                                        email: widget.emailController
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
      ),
    );
  }
}
