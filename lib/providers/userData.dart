import 'package:flutter/material.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/Models/sharedPrefKey.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData with ChangeNotifier {
  BuiltUser _builtUser = BuiltUser();


  final DatabaseApiService _postApiService;

// true when necessary actions are loaded (during startup of app)
  bool _loaded = false;

  bool _isAuth = false;

  UserData(this._postApiService) {
    print('-------------------initiating------------------------------------');
    _initiate();
  }

  _initiate() async {
    final _prefs = await SharedPreferences.getInstance();
    final userId = _prefs.containsKey(SharedPrefKeys.USERID)
        ? _prefs.getString(SharedPrefKeys.USERID)
        : null;
    if (userId != null) {
      // if we have userId, it means user never logged out from current UserID.
      _isAuth = true;

      final response = await _postApiService.getUserProfile(userId);
      if (response != null && response.body != null) {
        _builtUser = response.body.user;

        print(
            '-------------------------builtuser loaded --------------------------------');
        print(_builtUser);
      } else {
        // this case can arrive if user don't have internt connection.
        // then we can load some trivial info like name,username etc from sharedPreferences
      }
    } else {
      _isAuth = false;
    }

    _loaded = true;
    notifyListeners();
  }

  bool get loaded => _loaded;

  bool get isAuth => _isAuth;

  BuiltUser get user => _builtUser;

  set updateUser(BuiltUser user) {
    _isAuth = true;

    _builtUser = user;

    notifyListeners();
  }
}
