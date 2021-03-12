import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class FollowingDatabase {
  static Box followingBox;
  static Future<void> init() async {
    if (followingBox == null) followingBox = await Hive.openBox('following');
  }

	static Future<void> fetchList(String userId, BuildContext context) async {
		await init();
    if (followingBox.isEmpty) {
      String lastevaluatedkey;
			
      do {
        BuiltSearchUsers u =
            (await Provider.of<DatabaseApiService>(context, listen: false)
                    .getRelations(
                        userId: userId,
                        socialRelation: 'followings',
                        lastevaluatedkey: lastevaluatedkey,
                        authorization: null))
                .body;
        u.users.forEach((e) {
          addFollowing(e.userId);
        });
        lastevaluatedkey = u.lastevaluatedkey;
      } while (lastevaluatedkey != null);
    }
  }
	

  static List<String> allFollowings()  {
		List res = [];
		followingBox.values.forEach((element) { 
				res.add(element);
		});
		return res;
  }

	static bool isFollowing(String userId)  {
		// init();
		return (followingBox.get(userId)!=null);		
	}

	static void addFollowing(String userId)  {
		// init();
		followingBox.put(userId, userId);
	}

	static void deleteAllData()  {
		// init();  
		followingBox.clear();
	}
}