import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flocktale/services/SecureStorage.dart';

class AuthUser {
  static const _userPoolId = "ap-south-1_VS8RwdWHw";
  static const _clientId = "584k9d814gf8nftt9svngschf7";
// static const _region = 'ap-south-1';

  static final _userPool =
      CognitoUserPool(_userPoolId, _clientId, storage: CognitoMemoryStorage());

  CognitoUser _cognitoUser;

  CognitoUserSession cognitoSession;

  Future<void> initCachedSession(
      {@required String idToken,
      @required String accessToken,
      @required String refreshToken}) async {
    if (idToken == null || accessToken == null || refreshToken == null) {
      _cognitoUser = null;
      cognitoSession = null;
      return false;
    }

    cognitoSession = CognitoUserSession(
        CognitoIdToken(idToken), CognitoAccessToken(accessToken),
        refreshToken: CognitoRefreshToken(refreshToken), clockDrift: 0);

    _cognitoUser = CognitoUser(
        cognitoSession.idToken.payload['phone_number'], _userPool,
        storage: CognitoMemoryStorage());

    if (cognitoSession.isValid() == false) {
      await refreshSession();
    }
  }

  Future<void> refreshSession() async {
    if (cognitoSession == null || cognitoSession?.isValid() == true) return;

    cognitoSession =
        await _cognitoUser.refreshSession(cognitoSession.refreshToken);

    final _storage = SecureStorage();
    await _storage.setIdToken(cognitoSession.idToken.jwtToken);
    await _storage.setAccessToken(cognitoSession.accessToken.jwtToken);
    await _storage.setRefreshToken(cognitoSession.refreshToken.token);

    if (cognitoSession?.isValid() != true) {
      // user has to login again.
      cognitoSession = null;
      _cognitoUser = null;
    }
  }

  Future<bool> signUpWithCognito(String phone) async {
    final password = DateTime.now().toString();
    try {
      final data = await _userPool.signUp(phone, password);

      print('successfull: ${data.toString()}');
      Fluttertoast.showToast(msg: 'Succesfully registered');

      return true;
    } on CognitoClientException catch (e) {
      Fluttertoast.showToast(msg: e.message, gravity: ToastGravity.CENTER);
      print('catched error : ${e.toString()}');
      return false;
    }
  }

  Future<dynamic> confirmOTP(String code) async {
    try {
      cognitoSession = await _cognitoUser.sendCustomChallengeAnswer(code);
      return true;
    } on CognitoUserCustomChallengeException catch (e) {
      return "WRONG_OTP";
    } on CognitoClientException catch (e) {
      print(e);

      if (e.code == "NotAuthorizedException") {
        return "EXPIRED";
      }

      return false;
    }
  }

  Future sendOTP(String phone) async {
    _cognitoUser =
        CognitoUser(phone, _userPool, storage: CognitoMemoryStorage());

    try {
      await _cognitoUser
          .initiateAuth(AuthenticationDetails(authParameters: []));

      return false;
    } on CognitoUserCustomChallengeException catch (e) {
      // the package (amazon_cognito_identity_dart_2) generates this error for custom_challenge
      // but there is no problem in that because we need to send custom challenge answer.
      // and then we get the CognitoUserSession.
      return true;
    } on CognitoClientException catch (e) {
      print('error');
      print(e);
      return e.code;
    } catch (e) {
      print('--------------------');
      print(e);
      print('--------------------');
      return e.code;
    }
  }
}
