import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/services/SecureStorage.dart';
import 'package:mootclub_app/aws/cognito.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';

class UserData with ChangeNotifier {
  BuiltUser _builtUser;
  CognitoUserSession _currentSession;
  String _userId;

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

    // final email = _prefs.containsKey(SharedPrefKeys.EMAIL)
    //     ? _prefs.getString(SharedPrefKeys.EMAIL)
    //     : null;

    // final password = _prefs.containsKey(SharedPrefKeys.PASSWORD)
    //     ? _prefs.getString(SharedPrefKeys.PASSWORD)
    //     : null;

    if (email != null && password != null) {
      await startSession(
          email: email,
          password: password,
          callback: (String id, CognitoUserSession session) {
            _userId = id;
            _currentSession = session;
          });
    }

    if (userId != null) {
      _isAuth = true;

      if (newRegistration == false) {
        final response = await _postApiService.getUserProfile(
          userId: _userId,
          primaryUserId: _userId,
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
    if (userId == null || _currentSession == null) return;

    _isAuth = true;

    final response = await _postApiService.getUserProfile(
        userId: _userId, primaryUserId: _userId, authorization: authToken);

    if (response != null && response.body != null) {
      _builtUser = response.body.user;

      if (_builtUser?.userId == null) {
        _builtUser = null;
      }
    }

    notifyListeners();
  }

  bool get loaded => _loaded;

  bool get isAuth => _isAuth;

  BuiltUser get user => _builtUser;

  String get userId => _userId;

  set userId(String id) => {_userId = id};

  set updateUser(BuiltUser user) {
    _isAuth = true;

    _builtUser = user;

    notifyListeners();
  }

  String get authToken => _currentSession?.idToken?.jwtToken;

  set cognitoSession(CognitoUserSession session) {
    _currentSession = session;
  }
}
