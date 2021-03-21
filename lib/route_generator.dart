import 'package:flocktale/initiation.dart';
import 'package:flutter/material.dart';
import 'package:flocktale/pages/HomePage.dart';
import 'package:flocktale/pages/NotificationPage.dart';
import 'package:flocktale/root.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case '/init':
        return MaterialPageRoute(builder: (_) => Initiation());
      case '/root':
        return MaterialPageRoute(builder: (_) => RootPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/notificationPage':
        return MaterialPageRoute(builder: (_) => NotificationPage());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
