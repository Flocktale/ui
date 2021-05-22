import 'package:flocktale/Models/appConstants.dart';
import 'package:flocktale/Widgets/denyConcurrentUse.dart';
import 'package:flocktale/Widgets/imageDialogLayout.dart';
import 'package:flocktale/pages/ContactsPage.dart';
import 'package:flocktale/providers/agoraController.dart';
import 'package:flutter/material.dart';
import 'package:flocktale/Authentication/signUp.dart';
import 'package:flocktale/pages/HomePage.dart';
import 'package:flocktale/pages/PhoneLogIn.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/providers/webSocket.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class RootPage extends StatelessWidget {
  Future<bool> onWillPop(context) async {
    final currentClub =
        Provider.of<AgoraController>(context, listen: false)?.club;
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else if (currentClub?.clubId != null) {
      final res = await showDialog(
          context: context,
          builder: (_) => ImageDialogLayout(
                imageUrl:
                    Provider.of<UserData>(context, listen: false)?.user?.avatar,
                content: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          'Do you really want to quit ${currentClub.clubName ?? ""}'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text(
                                  ' Yes ',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                              SizedBox(width: 32),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text(
                                  ' No ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ));
      if (res == true) {
        Provider.of<MySocket>(context).closeConnection();
        Provider.of<AgoraController>(context).dispose();
        return true;
      } else
        return false;
    } else
      return true;

    return false;
  }

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
              widget = WillPopScope(
                onWillPop: () async => await onWillPop(context),
                child: HomePage(),
              );
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
