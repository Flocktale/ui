import 'package:flocktale/initiation.dart';
import 'package:flocktale/providers/agoraController.dart';
import 'package:flocktale/providers/notificationProvider.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/providers/webSocket.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';
import 'services/chopper/database_api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  _setupHive();
  // _setupLogging();
  runApp(Phoenix(child: MyApp()));
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

        ChangeNotifierProvider<NotificationProvider>(
          create: (_) => NotificationProvider(),
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
        // theme: ThemeData(
        //   primaryColor: Colors.red,
        //   accentColor: Colors.redAccent,
        // ),
        theme: new ThemeData(
            scaffoldBackgroundColor: Colors.black87,
            appBarTheme: AppBarTheme(
              color: Colors.black87,
            )),
        home: Initiation(),
      ),
    );
  }
}
