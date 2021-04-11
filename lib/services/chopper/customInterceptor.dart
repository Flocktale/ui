import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:flocktale/Models/appConstants.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:provider/provider.dart';

class CustomInterceptor implements RequestInterceptor {
  Request removeNull(Request request) {
    final headers = {...request.headers};
    headers?.removeWhere((key, value) => value == null);

    final queryParams = {...request.parameters};
    queryParams?.removeWhere((key, value) => value == null);

    return request.copyWith(headers: headers, parameters: queryParams);
  }

  @override
  FutureOr<Request> onRequest(Request request) async {
    final connectivityResult =
        await AppConstants.connectionStatus.checkConnection();

    if (connectivityResult != true && AppConstants.rootContext != null) {
      AppConstants.internetErrorFlushBar.showFlushbar(AppConstants.rootContext);
      // throw InternetConnectionException();
    }

    request = removeNull(request);

    if (request.headers['noAuthRequired'] == 'true') {
      return request;
    }

    if (AppConstants.rootContext != null) {
      final user =
          Provider.of<UserData>(AppConstants.rootContext, listen: false);
      if (user.isAuthTokenValid == false) {
        await user.initCognitoSession();
      }

      if (user.isAuthTokenValid == false) {
        // TODO: if auth token is still not valid then ask user to login again
        // may be Phoenix.rebirth after all logout operations
      }
      return request.copyWith(
          headers: {...request.headers, 'authorization': user.authToken});
      // adding authorization token here
    }

    return request;
  }
}

class InternetConnectionException implements Exception {
  final message = 'Could not connect to internet, please check your connection';
  @override
  String toString() => message;
}
