import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/services/SecureStorage.dart';
import 'package:mootclub_app/aws/cognito.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';

class UserData with ChangeNotifier {
  BuiltUser _builtUser;

  final AuthUser _authUser = AuthUser();

  final DatabaseApiService _postApiService;

  /// to store category data in current app instance
  Map<String, List<String>> categoryData;

// true when necessary actions are loaded (during startup of app)
  bool _loaded = false;

  bool _isAuth = false;

  UserData(this._postApiService) {
    print('-------------------initiating------------------------------------');
    initiate();
  }

  /// set newRegistration to true when new user has registered
  /// (in above case, user has login credentials, email and password, but no entry in database)
  initiate({bool newRegistration = false}) async {
    final _storage = SecureStorage();
    final email = await _storage.getEmail();
    final password = await _storage.getPassword();

    if (email != null && password != null) {}

    if (userId != null) {
      _isAuth = true;

      if (newRegistration == false) {
        final response = await _postApiService.getUserProfile(
          userId: userId,
          primaryUserId: userId,
          authorization: authToken,
        );

        if (response != null && response.body != null) {
          _builtUser = response.body.user;
        } else {
          // this case can arrive if user don't have internt connection.
          // then we can load some trivial info like name,username etc from sharedPreferences
        }

        if (_builtUser?.userId == null) {
          _builtUser = null;
        }
      } else {
        _builtUser = null;
      }
    } else {
      _isAuth = false;
    }

    _loaded = true;

    notifyListeners();
  }

  /// when user is logged in only then this method can be used
  Future<void> fetchUserFromBackend() async {
    if (userId == null || _authUser?.cognitoSession == null) return;

    _isAuth = true;

    final response = await _postApiService.getUserProfile(
        userId: userId, primaryUserId: userId, authorization: authToken);

    if (response != null && response.body != null) {
      _builtUser = response.body.user;

      if (_builtUser?.userId == null) {
        _builtUser = null;
      }
    }

    notifyListeners();
  }

  Future<bool> sendOTP(String dialCode, String phoneNumber) async {
    assert(dialCode != null);
    assert(phoneNumber != null);

    final phone = dialCode + phoneNumber;
    final response = await _authUser.sendOTP(phone);
    if (response == true) {
      return true;
    } else if (response == 'UserLambdaValidationException') {
      // user hasn't signed up yet. so sign up the user
      final signUpResponse = await _authUser.signUpWithCognito(phone);
      return signUpResponse;
    } else if (response == false) {
      Fluttertoast.showToast(msg: 'Unknown error, please contact the support');
      return false;
    } else {
      return false;
    }
  }

  Future<void> submitOTP(String code) async {
    assert(code != null);
    final resp = await _authUser.confirmOTP(code);
    if (resp == true) {
      _isAuth = true;
    }
    notifyListeners();
  }

  bool get loaded => _loaded;

  bool get isAuth => _isAuth;

  BuiltUser get user => _builtUser;
  String get userId {
    if (_authUser?.cognitoSession?.idToken?.payload != null)
      return _authUser?.cognitoSession?.idToken?.payload['cognito:username'];
    else
      return null;
  }
  // String get userId =>
  // _authUser?.cognitoSession?.idToken?.payload['cognito:username'];

  String get phoneNumber => _authUser?.cognitoUser?.username;

  set updateUser(BuiltUser user) {
    _isAuth = true;

    _builtUser = user;

    notifyListeners();
  }

  String get authToken => _authUser?.cognitoSession?.idToken?.jwtToken;

  // set cognitoSession(CognitoUserSession session) {
  //   _currentSession = session;
  // }
}
