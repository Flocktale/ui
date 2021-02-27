import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';
import 'package:mootclub_app/Authentication/OtpScreen.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
class PhoneLogin extends StatefulWidget {
  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  TextEditingController _controller;
  TextEditingController _otpController;
  bool hasError = false;
  bool phoneNumberSubmitted = false;
  String phoneNumber;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
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
                ),
              ],
            ),
            SizedBox(
              height: size.height/10,
            ),
            FittedBox(
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  children: [
                    Container(
                      child: !phoneNumberSubmitted?
                      CountryCodePicker(
                        showDropDownButton: true,
                        initialSelection: 'IN',
                      ):Container(),
                    ),
                    SizedBox(
                      width: size.width/20,
                    ),
                    Container(
                        width: !phoneNumberSubmitted?size.width/1.5:size.width,
                        child: !phoneNumberSubmitted?
                        Form(
                          key: _formKey,
                          child:
                          TextFormField(
                            controller: _controller,
                            keyboardType: TextInputType.number,
                            initialValue: phoneNumber,
                            decoration: new InputDecoration(
                                hintText: "Phone number",
                                hintStyle: TextStyle(
                                  fontFamily: "Lato",
                                ),
                                labelText: "Phone Number for login",
                              labelStyle: TextStyle(
                                fontFamily: "Lato",
                              ),
                            ),
                            style: TextStyle(
                              fontFamily: "Lato",
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0
                            ),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                            validator: (value){
                              if(value.isEmpty){
                                Fluttertoast.showToast(msg: 'Please enter your phone number');
                                return "This field cannot be empty";
                              }
                              else if(value.length!=10){
                                return "Phone number should be of 10 digits";
                              }
                              return null;
                            },
                          )):
                          FittedBox(
                            child: PinCodeTextField(
                              maxLength: 6,
                              controller: _otpController,
                              hasError: hasError,
                              onDone: (value){
                                if(value.length==6){
                                  setState(() {
                                    hasError = false;
                                  });
                                }
                                else{
                                  setState(() {
                                    hasError = true;
                                  });
                                  Fluttertoast.showToast(msg: 'OTP should have six digits');
                                }
                              },
                            ),
                          ),
                    )
                  ],
                ),
              ),
            ),
            phoneNumberSubmitted?
            SizedBox(
              height: size.height/200,
            ):Container(),
            phoneNumberSubmitted?
            Container(
              alignment: Alignment(1.0, 0.0),
              padding: EdgeInsets.only(top: size.height/85, left: 20.0,right: 10),
              child: InkWell(
                onTap: (){

                },
                child: Text(
                  'Resend OTP',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ):Container(),
            SizedBox(
              height: size.height/10,
            ),
            !phoneNumberSubmitted?
            Center(
              child: ButtonTheme(
                minWidth: size.width / 3.5,
                child: RaisedButton(
                  onPressed: () {
                    if (!_formKey.currentState.validate()) {
                      Fluttertoast.showToast(msg: 'Please enter a valid phone number');
                      print("@@@@@@");
                      print(_controller?.text);
                      return;
                    } else {
                      _formKey.currentState.save();
                      setState(() {
                        phoneNumber = _controller?.text;
                        phoneNumberSubmitted = true;
                      });
                    }
                  },
                  color: Colors.red[600],
                  child: Text('Send OTP',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                      )),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    //side: BorderSide(color: Colors.red[600]),
                  ),
                ),
              ),
            ):
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtonTheme(
                  minWidth: size.width / 3.5,
                  child: RaisedButton(
                    onPressed: () {
                      setState(() {
                        phoneNumberSubmitted = false;
                      });
                    },
                    color: Colors.white,
                    child: Text('Back',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lato',
                        )),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      //side: BorderSide(color: Colors.red[600]),
                    ),
                  ),
                ),
                ButtonTheme(
                  minWidth: size.width / 3.5,
                  child: RaisedButton(
                    onPressed: () {
                    },
                    color: Colors.red[600],
                    child: Text('Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lato',
                        )),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      //side: BorderSide(color: Colors.red[600]),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
