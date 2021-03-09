import 'package:flutter/material.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

const followingTable = 'followings';

class DBHelper {
  static Database db;
  static Set _followings;
  static Future<Database> database() async {
    if (db != null) return db;
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'flocktale.db'),
        onCreate: (db, version) async {
      return db.execute('CREATE TABLE followings(userId TEXT PRIMARY KEY)');
    }, version: 1);
  }

  static Future<bool> fetchFollowingsFromLocalStorage() async {
    if (_followings == null) await getData();
    return (_followings != null && _followings.length != 0);
  }

  static void fetchList(String userId, BuildContext context) async {
    final db = await DBHelper.database();
    print(_followings);
    if ((await fetchFollowingsFromLocalStorage()) == false) {
      String lastevaluatedkey;
      _followings = {};
      await db.delete(followingTable);
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
          _followings.add(e.userId);
          addFollowing(e.userId);
        });
        lastevaluatedkey = u.lastevaluatedkey;
      } while (lastevaluatedkey != null);
    }
  }

  static Future<void> addFollowing(String userId) async {
    _followings.add(userId);
    final db = await DBHelper.database();
    Map<String, String> data = {'userId': userId};
    db.insert(
      followingTable,
      data,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  static Future<int> deleteFollowing(String userId) async {
    _followings.remove(userId);
    final db = await DBHelper.database();
    return await db
        .delete(followingTable, where: 'userId = ?', whereArgs: [userId]);
  }

  static bool isFollowing(String userId) {
    return _followings.contains(userId);
  }

  static Future getData({String table = followingTable}) async {
    final db = await DBHelper.database();
    final res = await db.query(table);
    _followings = {};
    res.forEach((element) {
      _followings.add(element['userId']);
    });
  }
}
