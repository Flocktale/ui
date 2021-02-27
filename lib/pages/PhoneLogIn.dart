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
  String _otpController;
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
            !phoneNumberSubmitted?
            FittedBox(
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  children: [
                    Container(
                      child: CountryCodePicker(
                        showDropDownButton: true,
                        initialSelection: 'IN',
                      ),
                    ),
                    SizedBox(
                      width: size.width/20,
                    ),
                    Container(
                        width: size.width/1.5,
                        child: TextFormField(
                          key: _formKey,
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
                          onChanged: (val){
                            setState(() {
                              phoneNumber = val;
                            });
                          },
                          onSaved: (value){
                            phoneNumber = value;
                          },
                          validator: (value){
                            if(_controller.text.isEmpty){
                              Fluttertoast.showToast(msg: 'Please enter your phone number');
                              return "This field cannot be empty";
                            }
                            else if(_controller.text.length!=10){
                              return "Phone number should be of 10 digits";
                            }
                            return null;
                          },
                        )
                    )
                  ],
                ),
              ),
            ):
            FittedBox(
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: PinCodeTextField(
                  key: _formKey,
                  maxLength: 6,
                  hasError: hasError,
                  onDone: (value){
                    if(value.length==6){
                      setState(() {
                        hasError = false;
                        _otpController = value;
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
              )
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
                    if (phoneNumber==null||phoneNumber.length!=10) {
                      Fluttertoast.showToast(msg: 'Please enter a valid phone number');
                      print("@@@@@@");
                      print(phoneNumber);
                      return;
                    } else {
                  //    _formKey.currentState.save();
                      setState(() {
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
