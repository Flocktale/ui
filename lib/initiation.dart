import 'dart:async';

import 'package:flocktale/Models/appConstants.dart';
import 'package:flocktale/root.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:flocktale/services/connectivityCheck.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';

class Initiation extends StatefulWidget {
  @override
  _InitiationState createState() => _InitiationState();
}

class _InitiationState extends State<Initiation> {
  bool _isOnline = false;
  bool _tappable = false;

  _initServices() async {
    AppConstants.connectionStatus = ConnectionStatusSingleton.getInstance();
    AppConstants.connectionStatus.initialize();

    _checkConnection();
  }

  Future _checkConnection() async {
    setState(() {
      this._tappable = false;
    });

    this._isOnline = await AppConstants.connectionStatus.checkConnection();

    setState(() {});

    if (this._isOnline == true) {
      final isVersionQualified = await _checkAppConfigs();
      if (isVersionQualified == false) {
        await _showUpdateDialog();
      }

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => RootPage()));
    } else {
      this._tappable = true;
      setState(() {});
    }
  }

  int _compareVersionParts(String x, String y) {
    if (x == null) x = "0";
    if (y == null) y = "0";

    if (x.length > y.length)
      return 1;
    else if (x.length < y.length) return -1;
    return x.compareTo(y);
  }

  Future<bool> _checkAppConfigs() async {
    try {
      AppConstants.appConfigs =
          (await Provider.of<DatabaseApiService>(context, listen: false)
                  .getAppConfigs())
              .body;

      final minAppVersion = AppConstants.appConfigs.minAppVersion;

      if (minAppVersion != null) {
        final appVersion = (await PackageInfo.fromPlatform()).version;

        AppConstants.installedVersion = appVersion;

        final appVersionSplitted = appVersion.split('.');
        final minVersionSplitted = minAppVersion.split('.');
        final int major =
            _compareVersionParts(appVersionSplitted[0], minVersionSplitted[0]);
        final int minor =
            _compareVersionParts(appVersionSplitted[1], minVersionSplitted[1]);
        final int patch =
            _compareVersionParts(appVersionSplitted[2], minVersionSplitted[2]);

        if (major == 1)
          return true;
        else if (major == -1) return false;

        if (minor == 1)
          return true;
        else if (minor == -1) return false;

        if (patch == 1)
          return true;
        else if (patch == -1) return false;
      }
      return true;
    } catch (e) {
      print('error while comparing versions $e');
      return true;
    }
  }

  _showUpdateDialog() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: AlertDialog(
                title: Text('Update App'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Min Supported Version : ${AppConstants.appConfigs.minAppVersion}'),
                    SizedBox(height: 8),
                    Text(
                        'Installed Version : ${AppConstants.installedVersion}'),
                    SizedBox(height: 16),
                    Text(
                        '(Mandatory) Please update "Flocktale" app from Google Play Store'),
                  ],
                ),
                actions: [
                  RaisedButton(
                    onPressed: () {
                      try {
                        final appLink =
                            "https://play.google.com/store/apps/details?id=com.flocktale.android";
                        launch(appLink);
                      } catch (e) {
                        print(
                            'error in launching app link from update button: $e');
                      }
                    },
                    child: Text('Update'),
                  )
                ],
              ),
            ));
  }

  Widget get _loadingWidget => Container(
        color: Color(0xfff74040),
        child: Center(
          child: SpinKitThreeBounce(
            color: Colors.white,
            size: 50,
          ),
        ),
      );

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget widget = _loadingWidget;

    if (this._isOnline == false && this._tappable == true) {
      widget = Center(
        child: GestureDetector(
          onTap: () {
            _checkConnection();
          },
          child: connectionError,
        ),
      );
    }

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: widget,
      ),
    );
  }
}

Widget get connectionError {
  return Container(
    color: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text("Could not find active internet connection"),
        SizedBox(height: 20),
        Text(
          'Try again',
          style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 24),
        ),
        SizedBox(height: 20),
        Icon(
          Icons.restore_page,
          color: Colors.redAccent,
          size: 60,
        ),
      ],
    ),
  );
}
