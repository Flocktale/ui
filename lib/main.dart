import 'dart:async';
import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mootclub_app/pages/HomePage.dart';
import 'package:mootclub_app/providers/agoraController.dart';
import 'package:mootclub_app/providers/webSocket.dart';
import 'package:provider/provider.dart';
import 'Authentication/login.dart';
import 'notificationPilot.dart';
import 'providers/userData.dart';
import 'package:logging/logging.dart';
import 'route_generator.dart';
import 'services/chopper/database_api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _setupLogging();
  _configureFCM();
  runApp(NotificationTesting());
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}

_configureFCM() async {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print('hola');
      print("onMessage: $message");
    },
    onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
    },
    onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
    },
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => DatabaseApiService.create(),
          dispose: (context, DatabaseApiService service) =>
              service.client.dispose(),
        ),

        Provider<AgoraController>(
          create: (_) => AgoraController().create(),
          dispose: (context, AgoraController agoraController) =>
              agoraController.dispose(),
        ),

//since we are using DatabaseApiService in another provider, it should be defined after that.

        ChangeNotifierProvider<UserData>(
          create: (ctx) =>
              UserData(Provider.of<DatabaseApiService>(ctx, listen: false)),
        ),

        ChangeNotifierProvider<MySocket>(
          create: (ctx) => MySocket("aksdkkd"),
        ),
        // Provider(
        // create: (ctx)=> MySocket(Provider.of<UserData>(ctx, listen: false).user.userId),
        // ),
      ],
      child: Consumer<UserData>(
        builder: (ctx, userData, _) => MaterialApp(
            onGenerateRoute: RouteGenerator.generateRoute,
            title: 'Mootclub',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.purple,
              accentColor: Colors.teal,
            ),
            home: userData.loaded == false
                ? Scaffold(
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
                          boxHeight: 300.0,
                        ),
                      ),
                    ),
                  )
                : userData.isAuth == false
                    ? Login()
                    : Consumer<MySocket>(builder: (ctx, _, __) => HomePage()),
            routes: {}),
      ),
    );
  }
}
