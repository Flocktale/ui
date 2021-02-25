import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const String EMAIL = 'email';
  static const String PASSWORD = 'password';

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

  Future<String> getEmail()async{
    var email = await getAttribute(SecureStorage.EMAIL);
    return email;
  }
  Future setEmail(String val)async{
    var email = await writeSecureData(SecureStorage.EMAIL,val);
    return email;
  }

   Future<String> getPassword()async{
    var password = await getAttribute(SecureStorage.PASSWORD);
    return password;
  }

  Future setPassword(String val)async{
    var pass = await writeSecureData(SecureStorage.PASSWORD,val);
    return pass;
  }

  Future logout()async{
    await _storage.deleteAll();
  }

}
