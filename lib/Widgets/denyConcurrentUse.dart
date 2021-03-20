import 'package:flutter/material.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

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
