import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';
import 'package:provider/provider.dart';

class DeviceStorage {
  static LocalStorage _storage = new LocalStorage('flocktale');
  // static Set _followings;
  static Map<String,bool> _followings;

  bool fetchFollowingsFromLocalStorage() {
    if (_followings == null) _followings = _storage.getItem('following');
    return (_followings != null  && _followings!={});
  }

  void fetchList(String userId, BuildContext context) async {
    // if (fetchFollowingsFromLocalStorage() == false) {
      String lastevaluatedkey;
      _followings = {};
      do {
        BuiltSearchUsers u =
            (await Provider.of<DatabaseApiService>(context, listen: false)
                    .getRelations(
                        userId: userId,
                        socialRelation: 'followings',
                        lastevaluatedkey: lastevaluatedkey,
                        authorization: null))
                .body;
        print(u);
        u.users.forEach((e) {
          _followings[e.userId] = true;
        });
        lastevaluatedkey = u.lastevaluatedkey;
      } while (lastevaluatedkey != null);
      _storage.setItem('following', _followings);
     
    // }
     for(int i=0;i<100;i++)
      print('$i$_followings');
  }

  void addFollowingList(List<String> followings) {
    _storage.deleteItem('following');
    _followings = {};
    followings.forEach((element) {
      // _followings.add(element);
    });
    _storage.setItem('following', _followings);
  }

  bool isListFetchedFromBackend() {
    return (_storage.getItem('following') != null);
  }

  void addFollowing(String userId) {
    // _followings.add(userId);
    _storage.setItem('following', _followings);
  }

  void removeFollowing(String userId) {
    _followings.remove(userId);
    _storage.setItem('following', _followings);
  }

  bool isFollowing(String userId) {
    return _followings.containsKey(userId);
  }
}
