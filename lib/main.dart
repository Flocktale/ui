import 'package:flutter/material.dart';
import 'package:mootclub_app/pages/HomePage.dart';
import 'package:provider/provider.dart';
import 'Authentication/login.dart';
import 'providers/userData.dart';
import 'package:logging/logging.dart';
import 'route_generator.dart';
import 'services/chopper/club_database_api_service.dart';
import 'services/chopper/user_database_api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _setupLogging();
  runApp(MyApp());
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
          create: (_) => UserDatabaseApiService.create(),
          dispose: (context, UserDatabaseApiService service) =>
              service.client.dispose(),
        ),

        Provider(
          create: (_) => ClubDatabaseApiService.create(),
          dispose: (context, ClubDatabaseApiService service) =>
              service.client.dispose(),
        ),

//since we are using UserDatabaseApiService in another provider, it should be defined after that.

        ChangeNotifierProvider<UserData>(
          create: (ctx) =>
              UserData(Provider.of<UserDatabaseApiService>(ctx, listen: false)),
        ),
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
                      child: Text('Loading ...'),
                    ),
                  )
                : userData.isAuth == false ? Login() : HomePage(),
            routes: {}),
      ),
    );
  }
}
