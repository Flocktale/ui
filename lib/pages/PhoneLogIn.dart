import 'package:flocktale/Widgets/otpBox.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

class PhoneLogin extends StatefulWidget {
  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  TextEditingController _controller = TextEditingController();

  String _dialCode;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _listenForCode() async {
    await SmsAutoFill().listenForCode;
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  void initState() {
    SmsAutoFill().getAppSignature.then((value) {
      for (int i = 0; i < 10; i++) print('app signature : $value');
    });

    _listenForCode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: size.width / 5,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
                Text(
                  'There.',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: size.width / 5,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
          PhoneFieldHint(),
          SizedBox(height: 40),
          FittedBox(
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                children: [
                  Container(
                      child: CountryCodePicker(
                    showDropDownButton: true,
                    onInit: (CountryCode countryCode) {
                      _dialCode = countryCode.dialCode;
                    },
                    initialSelection: 'IN',
                    favorite: ['IN'],
                    onChanged: (CountryCode countryCode) {
                      _dialCode = countryCode.dialCode;
                    },
                  )),
                  Container(
                    width: size.width / 1.5,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Phone number",
                          hintStyle: TextStyle(
                            fontFamily: "Lato",
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.redAccent,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            ),
                          ),
                          labelText: "Phone Number for login",
                          labelStyle: TextStyle(
                              fontFamily: "Lato", color: Colors.white),
                        ),
                        style: TextStyle(
                            fontFamily: "Lato",
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                            color: Colors.white),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                        ],
                        validator: (value) {
                          if (value.isEmpty) {
                            Fluttertoast.showToast(
                                msg: 'Please enter your phone number');
                            return "This field cannot be empty";
                          } else if (value.length != 10) {
                            return "Phone number should be of 10 digits";
                          }
                          return null;
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: size.height / 10),
          Center(
            child: ButtonTheme(
              minWidth: size.width / 3.5,
              child: RaisedButton(
                onPressed: () async {
                  if (!_formKey.currentState.validate()) {
                    Fluttertoast.showToast(
                        msg: 'Please enter a valid phone number');
                    print("@@@@@@");
                    print(_controller?.text);
                    return;
                  } else {
                    _formKey.currentState.save();
                    String phoneNumber = _controller?.text;

                    final resp =
                        await Provider.of<UserData>(context, listen: false)
                            .sendOTP(_dialCode, phoneNumber);
                    if (resp) {
                      Fluttertoast.showToast(
                          msg: 'OTP is sent to ' + _dialCode + phoneNumber);
                      OTPBox.displayDialog(
                        context: context,
                        phoneNumber: phoneNumber,
                        dialCode: _dialCode,
                      );
                    }
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
          ),
        ],
      ),
    );
  }
}
