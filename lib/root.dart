import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flocktale/pages/ContactsPage.dart';
import 'package:flutter/material.dart';
import 'package:flocktale/Authentication/signUp.dart';
import 'package:flocktale/pages/HomePage.dart';
import 'package:flocktale/pages/PhoneLogIn.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/providers/webSocket.dart';
import 'package:provider/provider.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserData>(
      builder: (ctx, userData, loadingWidget) {
        Provider.of<MySocket>(context, listen: false).update(userData.userId);

        Widget widget = loadingWidget;

        if (userData.loaded) {
          if (userData.isAuth == false)
            widget = PhoneLogin();
          // isAuth is true
          else if (userData.user == null) {
            widget = SignUpScreen();
          } else {
            // if isAuth is true and it is a new registration.
            if (userData.newRegistration) {
              widget = ContactsPage(newRegistration: userData.newRegistration);
            } else {
              widget = HomePage();
            }
          }
        }

        return widget;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Color(0xfff74040),
            // color: Color(0xff004040),
            image: DecorationImage(
              image: AssetImage('assets/images/splash.png'),
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    );
  }
}
