import 'package:flocktale/Models/appConstants.dart';
import 'package:flocktale/Widgets/denyConcurrentUse.dart';
import 'package:flocktale/pages/ContactsPage.dart';
import 'package:flutter/material.dart';
import 'package:flocktale/Authentication/signUp.dart';
import 'package:flocktale/pages/HomePage.dart';
import 'package:flocktale/pages/PhoneLogIn.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/providers/webSocket.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // using this context as rootContext
    AppConstants.rootContext = context;

    return Consumer<UserData>(
      builder: (context, userData, loadingWidget) {
        Widget widget = loadingWidget;

        if (userData.isOnlineSomewhereElse == true) {
          widget = DenyConcurrentUse();
        } else if (userData.loaded) {
          // connecting to websocket only when user is not using same account concurrently on another device.
          Provider.of<MySocket>(context, listen: false).update(userData.userId);

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
          color: Color(0xfff74040),
          child: Center(
              child: SpinKitThreeBounce(
            color: Colors.white,
            size: 50,
          )),
        ),
      ),
    );
  }
}
