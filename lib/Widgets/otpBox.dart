import 'dart:math';

import 'package:flocktale/providers/userData.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OTPBox extends StatefulWidget {
  static displayDialog({
    BuildContext context,
    String phoneNumber,
    String dialCode,
  }) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.7),
        builder: (_) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: WillPopScope(
                onWillPop: () async {
                  return Future.value(false);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.black87,
                    ),
                    child: OTPBox(
                      phoneNumber: phoneNumber,
                      dialCode: dialCode,
                    ),
                  ),
                ),
              ),
            ));
  }

  final String phoneNumber;
  final String dialCode;
  const OTPBox({
    this.phoneNumber,
    this.dialCode,
  });
  @override
  _OTPBoxState createState() => _OTPBoxState();
}

class _OTPBoxState extends State<OTPBox> with CodeAutoFill {
  String _typedOTPCode = '';
  DateTime _resendingTime = DateTime.now();
  int _remainingTime = 30;

  String _autoFetchedOTP = '';

  bool _isSubmittingOtp = false;

  Widget _actionButton({Color buttonColor, String text, Function onTap}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2,
        color: Colors.white,
        shadowColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  _cycleSetState() async {
    while (_remainingTime > 0) {
      await Future.delayed(Duration(seconds: 1));
      if (this.mounted) {
        setState(() {
          _remainingTime =
              30 - DateTime.now().difference(_resendingTime).inSeconds;
        });
      } else
        break;
    }
  }

  _resendOTP() async {
    if (_remainingTime > 1) {
      await Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Please Wait for $_remainingTime seconds');
      return;
    }

    // re initiating otp listener
    await cancel();
    listenForCode();

    Fluttertoast.showToast(msg: 'Resending OTP');

    await Provider.of<UserData>(context, listen: false)
        .sendOTP(widget.dialCode, widget.phoneNumber);

    setState(() {
      _resendingTime = DateTime.now();
      _remainingTime = 30 - DateTime.now().difference(_resendingTime).inSeconds;
    });
    _cycleSetState();
  }

  _submitOTP(String code) async {
    if (_isSubmittingOtp) return;

    _isSubmittingOtp = true;
    setState(() {});
    final resp =
        await Provider.of<UserData>(context, listen: false).submitOTP(code);

    if (resp == true) {
      if (this.mounted) {
        Navigator.of(context).pop();
      }
    }

    if (resp == "EXPIRED") {
      Fluttertoast.showToast(msg: 'Expired, resending OTP');
      _typedOTPCode = '';
      await _resendOTP();
    } else if (resp == "WRONG_OTP") {
      Fluttertoast.showToast(msg: 'Wrong OTP');
      _typedOTPCode = '';
    }

    setState(() {
      _isSubmittingOtp = false;
    });
  }

  @override
  void codeUpdated() {
    // to prevent multiple callbacks at same time
    var random = new Random();
    Future.delayed(Duration(milliseconds: 200 + random.nextInt(5) * 50), () {
      if (_autoFetchedOTP == code) return;
      _autoFetchedOTP = code;
      setState(() {});
      print('_autoFetchedOTP: $_autoFetchedOTP');
      _submitOTP(_autoFetchedOTP);
    });
  }

  @override
  void initState() {
    super.initState();
    listenForCode();

    Future.delayed(Duration(milliseconds: 700), () {
      listenForCode();
    });

    _cycleSetState();
  }

  @override
  void dispose() {
    super.dispose();
    cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Phone: ${widget.dialCode} ${widget.phoneNumber}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 12),
          PinFieldAutoFill(
            codeLength: 6,
            decoration: UnderlineDecoration(
              textStyle: TextStyle(fontSize: 20, color: Colors.white),
              colorBuilder: FixedColorBuilder(Colors.white70),
            ),
            currentCode: _typedOTPCode,
            onCodeSubmitted: (code) {
              setState(() {
                _typedOTPCode = code;
              });
            },
            onCodeChanged: (code) {
              setState(() {
                _typedOTPCode = code;
              });
              print('code: $code');
              // if (code.length == 6) {
              //   FocusScope.of(context).requestFocus(FocusNode());
              // }
            },
          ),
          SizedBox(height: 24),
          InkWell(
            onTap: () => _resendOTP(),
            child: Text(
              _remainingTime > 1
                  ? 'Resend OTP   00:${_remainingTime > 9 ? _remainingTime.toString() : "0" + _remainingTime.toString()}'
                  : 'Resend OTP',
              style: TextStyle(
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
                color: _remainingTime > 1 ? Colors.white70 : Colors.redAccent,
                decoration: _remainingTime > 1
                    ? TextDecoration.none
                    : TextDecoration.underline,
              ),
            ),
          ),
          SizedBox(height: 60),
          if (_isSubmittingOtp)
            Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.redAccent,
              ),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _actionButton(
                    text: 'Cancel',
                    buttonColor: Colors.black87,
                    onTap: () {
                      Navigator.of(context).pop();
                    }),
                _actionButton(
                  text: 'Submit',
                  buttonColor: Colors.redAccent,
                  onTap: () => _submitOTP(_typedOTPCode),
                ),
              ],
            )
        ],
      ),
    );
  }
}
