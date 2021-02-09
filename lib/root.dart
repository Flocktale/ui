import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:mootclub_app/Authentication/signUp.dart';
import 'package:mootclub_app/pages/HomePage.dart';
import 'package:mootclub_app/providers/userData.dart';
import 'package:mootclub_app/providers/webSocket.dart';
import 'package:provider/provider.dart';

import 'Authentication/login.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<UserData>(
      builder: (ctx, userData, loadingWidget) {
        Provider.of<MySocket>(context, listen: false).update(userData.userId);

        Widget widget = loadingWidget;

        if (userData.loaded) {
          if (userData.isAuth == false)
            widget = Login();
          else if (userData.user == null) {
            widget = SignUpScreen();
          } else {
            widget = HomePage();
          }
        }

        return widget;
      },
      child: Scaffold(
        body: Center(
          child: SizedBox(
            // width: 250.0,
            child: TextLiquidFill(
              text: 'MOOTCLUB',
              waveColor: Colors.blueAccent,
              boxBackgroundColor: Colors.redAccent,
              textStyle: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
              boxHeight: size.height,
            ),
          ),
        ),
      ),
    );
  }
}
