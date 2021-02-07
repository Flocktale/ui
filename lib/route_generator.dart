import 'package:flutter/material.dart';
import 'package:mootclub_app/Authentication/signUp.dart';
import 'package:mootclub_app/pages/HomePage.dart';
import 'package:mootclub_app/Authentication/login.dart';
import 'package:mootclub_app/Authentication/register.dart';
import 'package:mootclub_app/pages/ImagePage.dart';
import 'package:mootclub_app/pages/NotificationPage.dart';
import 'package:mootclub_app/root.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => RootPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/register':
        return MaterialPageRoute(builder: (_) => Register());
      case '/notificationPage':
        return MaterialPageRoute(builder: (_) => NotificationPage());
      case '/imagePage':
        return MaterialPageRoute(builder: (_) => ImagePage());
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
