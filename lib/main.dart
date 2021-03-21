import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flocktale/initiation.dart';
import 'package:flocktale/providers/agoraController.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/providers/webSocket.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';
import 'route_generator.dart';
import 'services/chopper/database_api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _setupHive();
  _setupLogging();
  _configureFCM();
  runApp(Phoenix(child: MyApp()));
  // runApp(NotificationTesting());
}

void _setupHive() async {
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}

Future onBackgroundMessageHandler(Map<String, dynamic> message) async {
  print('message in bgHandler: $message');
}

_configureFCM() async {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  _firebaseMessaging.configure(
    onBackgroundMessage: onBackgroundMessageHandler,
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
          create: (ctx) => MySocket(
              Provider.of<AgoraController>(ctx, listen: false),
              Provider.of<UserData>(ctx, listen: false)),
        ),
      ],
      child: MaterialApp(
        title: 'Flocktale',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.red,
          accentColor: Colors.redAccent,
        ),
        home: Initiation(),
      ),
    );
  }
}
