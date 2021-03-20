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
    return Consumer<UserData>(
      builder: (ctx, userData, loadingWidget) {
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

class DenyConcurrentUse extends StatefulWidget {
  @override
  _DenyConcurrentUseState createState() => _DenyConcurrentUseState();
}

class _DenyConcurrentUseState extends State<DenyConcurrentUse> {
  bool _isLoading = false;

  void _refresh() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(seconds: 2));
    await Provider.of<UserData>(context, listen: false).initiate();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context, listen: false).user;

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage(
                'assets/images/logo.png',
              ),
            ),
            SizedBox(height: 32),
            Text(
              '${user.name ?? ""}',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
                color: Color(0xfff74040),
              ),
            ),
            Text(
              '@${user.username}',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
                color: Color(0xfff74040),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Looks like another device is currently using your account, please close/logout Flocktale from that device to use your account on this device.',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Lato',
                fontWeight: FontWeight.normal,
                color: Color(0xfff74040),
              ),
            ),
            SizedBox(height: 16),
            if (_isLoading)
              Container(
                height: 60,
                child: Center(
                  child: SpinKitThreeBounce(
                    color: Color(0xfff74040),
                    size: 50,
                  ),
                ),
              )
            else
              Container(
                height: 60,
                child: IconButton(
                  icon: Icon(
                    Icons.restore_rounded,
                    size: 50,
                  ),
                  onPressed: () => _refresh(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
