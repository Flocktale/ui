import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:flocktale/Models/appConstants.dart';

class CustomInterceptor implements RequestInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) async {
    final connectivityResult =
        await AppConstants.connectionStatus.checkConnection();

    if (connectivityResult != true && AppConstants.rootContext != null) {
      AppConstants.internetErrorFlushBar.showFlushbar(AppConstants.rootContext);
      // throw InternetConnectionException();
    }

    return request;
  }
}

class InternetConnectionException implements Exception {
  final message = 'Could not connect to internet, please check your connection';
  @override
  String toString() => message;
}
