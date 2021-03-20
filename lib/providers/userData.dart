import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/services/SecureStorage.dart';
import 'package:flocktale/aws/cognito.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';

class UserData with ChangeNotifier {
  BuiltUser _builtUser;

  final _storage = SecureStorage();

  final AuthUser _authUser = AuthUser();

  final DatabaseApiService _postApiService;

  /// to store category data in current app instance
  Map<String, List<String>> categoryData;

// true when necessary actions are loaded (during startup of app)
  bool _loaded = false;

  bool _isAuth = false;

  bool _newRegistration = false;

  bool _isOnlineisOnlineSomewhereElse = false;

  UserData(this._postApiService) {
    print('-------------------initiating------------------------------------');
    initiate();
  }

  /// set newRegistration to true when new user has registered
  initiate({bool isNew = false}) async {
    _newRegistration = isNew;

    final idToken = await _storage.getIdToken();
    final accessToken = await _storage.getAccessToken();
    final refreshToken = await _storage.getRefreshToken();

    await _authUser.initCachedSession(
        idToken: idToken, accessToken: accessToken, refreshToken: refreshToken);

    if (userId != null) {
      _isAuth = true;

      final response = await _postApiService.getUserProfile(
        userId: userId,
        primaryUserId: userId,
        authorization: authToken,
      );

      if (response != null && response.body != null) {
        _builtUser = response.body.user;

        // this function only runs during app initiation/login/signup,
        // so the user fetched here is prior to connecting websocket,
        // therefore if user is still online then he is using this app with same account concurrently on aonther device too.
        _isOnlineisOnlineSomewhereElse = _builtUser.online == 0;
      } else {
        // this case can arrive if user don't have internt connection.
        // then we can load some trivial info like name,username etc from sharedPreferences
      }

      if (_builtUser?.userId == null) {
        _builtUser = null;
      }
    } else {
      _isAuth = false;
    }

    _loaded = true;

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

  Future<dynamic> submitOTP(String code) async {
    assert(code != null);
    final resp = await _authUser.confirmOTP(code);

    if (resp == "EXPIRED") {
      Fluttertoast.showToast(msg: 'OTP expired, please try again');
      return resp;
    } else if (resp == "WRONG_OTP") {
      Fluttertoast.showToast(msg: 'Wrong otp, please try again');
      return resp;
    } else if (resp == true) {
      _isAuth = true;

      await _storage.setIdToken(_authUser.cognitoSession.idToken.jwtToken);
      await _storage
          .setAccessToken(_authUser.cognitoSession.accessToken.jwtToken);
      await _storage
          .setRefreshToken(_authUser.cognitoSession.refreshToken.token);

      final fcmToken = await FirebaseMessaging().getToken();

      await _postApiService.registerFCMToken(
        userId: userId,
        body: BuiltFCMToken((b) => b..deviceToken = fcmToken),
        authorization: authToken,
      );

      await initiate();
    }
    notifyListeners();
    return true;
  }

  bool get loaded => _loaded;

  bool get isAuth => _isAuth;

  BuiltUser get user => _builtUser;

  String get userId {
    if (_authUser?.cognitoSession?.idToken?.payload != null)
      return _authUser?.cognitoSession?.idToken?.payload['sub'];
    else
      return null;
  }

  String get phoneNumber {
    if (_authUser?.cognitoSession?.idToken?.payload == null) return null;

    return _authUser?.cognitoSession?.idToken?.payload['phone_number'];
  }

  void updateUser(BuiltUser user) async {
    _builtUser = user;

    notifyListeners();
  }

  String get authToken => _authUser?.cognitoSession?.idToken?.jwtToken;

  bool get newRegistration => _newRegistration;

  set newRegistration(bool isNew) {
    _newRegistration = isNew;
    notifyListeners();
  }

  bool get isOnlineSomewhereElse => _isOnlineisOnlineSomewhereElse;

  // set cognitoSession(CognitoUserSession session) {
  //   _currentSession = session;
  // }
}
