import 'package:flocktale/providers/userData.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'chopper/database_api_service.dart';

class SocialInteraction {
  final BuildContext context;
  final String foreignUserId;
  final Function updateProfileFromResponse;

  String userId;
  DatabaseApiService service;
  String authToken;

  SocialInteraction(this.context, this.foreignUserId,
      {@required this.updateProfileFromResponse}) {
    userId = Provider.of<UserData>(context, listen: false).userId;
    service = Provider.of<DatabaseApiService>(context, listen: false);
  }

  Future<void> sendFollow() async {
    final resp = await service.follow(
      userId: userId,
      foreignUserId: foreignUserId,
    );

    updateProfileFromResponse(resp.body);

    Fluttertoast.showToast(msg: 'Follow Request Sent');
  }

  Future<void> sendUnFollow() async {
    final resp = await service.unfollow(
      userId: userId,
      foreignUserId: foreignUserId,
    );

    updateProfileFromResponse(resp.body);

    Fluttertoast.showToast(msg: 'User Unfollowed');
  }

  Future<void> sendFriendRequest() async {
    final resp = await service.sendFriendRequest(
      userId: userId,
      foreignUserId: foreignUserId,
    );
    updateProfileFromResponse(resp.body);

    Fluttertoast.showToast(msg: 'Friend Request Sent');
  }

  Future<void> acceptFriendRequest() async {
    final resp = (await service.acceptFriendRequest(
      userId: userId,
      foreignUserId: foreignUserId,
    ));

    if (resp.isSuccessful) {
      updateProfileFromResponse(resp.body);
    } else {
      Fluttertoast.showToast(msg: "Some error occured ${resp.body}");
    }
  }

  Future<void> cancelFriendRequest() async {
    final resp = await service.deleteFriendRequest(
      userId: userId,
      foreignUserId: foreignUserId,
    );
    updateProfileFromResponse(resp.body);

    Fluttertoast.showToast(msg: 'Friend Request Cancelled');
  }

  Future<void> unFriend() async {
    final resp = await service.unfriend(
      userId: userId,
      foreignUserId: foreignUserId,
    );
    updateProfileFromResponse(resp.body);

    Fluttertoast.showToast(msg: 'Good Bye!');
  }
}
