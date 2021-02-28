import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const String PHONE = 'phone';
  static const String USERID = 'userId';

  static const String IDTOKEN = 'idToken';
  static const String REFRESHTOKEN = 'refreshToken';
  static const String ACCESSTOKEN = 'accessToken';

  static const String NAME = 'name';
  static const String USERNAME = 'username';
  static const String BIO = 'bio';
  static final _storage = FlutterSecureStorage();

  Future writeSecureData(String key, String value) async {
    var writeData = await _storage.write(key: key, value: value);
    return writeData;
  }

  Future getAttribute(String key) async {
    var readData = await _storage.read(key: key);
    return readData;
  }

  Future<String> getPhoneNumber() async {
    var phone = await getAttribute(SecureStorage.PHONE);
    return phone;
  }

  Future setPhoneNumber(String val) async {
    var phone = await writeSecureData(SecureStorage.PHONE, val);
    return phone;
  }

  Future<String> getUserId() async {
    var userId = await getAttribute(SecureStorage.USERID);
    return userId;
  }

  Future setUserId(String val) async {
    var userId = await writeSecureData(SecureStorage.USERID, val);
    return userId;
  }

  Future<String> getIdToken() async {
    var idToken = await getAttribute(SecureStorage.IDTOKEN);
    return idToken;
  }

  Future setIdToken(String val) async {
    var idToken = await writeSecureData(SecureStorage.IDTOKEN, val);
    return idToken;
  }

  Future<String> getAccessToken() async {
    var accessToken = await getAttribute(SecureStorage.ACCESSTOKEN);
    return accessToken;
  }

  Future setAccessToken(String val) async {
    var accessToken = await writeSecureData(SecureStorage.ACCESSTOKEN, val);
    return accessToken;
  }

  Future<String> getRefreshToken() async {
    var refreshToken = await getAttribute(SecureStorage.REFRESHTOKEN);
    return refreshToken;
  }

  Future setRefreshToken(String val) async {
    var refreshToken = await writeSecureData(SecureStorage.REFRESHTOKEN, val);
    return refreshToken;
  }

  Future logout() async {
    await _storage.deleteAll();
  }
}
