import 'dart:convert';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flocktale/providers/agoraController.dart';
import 'package:flocktale/providers/userData.dart';

import 'dart:async';
import 'dart:io';

class MySocket with ChangeNotifier {
  final AgoraController agoraController;

  final UserData userData;

  MySocket(this.agoraController, this.userData);

  WebSocket channel;

  String userId;

  /// current club
  String _clubId;

  // previously playing club
  String _previousClubId;

  bool _inTheClub = false;
  bool _isPlaying = false;

  bool _isSocketClosedOnPurpose = false;

  Map<String, Function> funcs = {"newComment": () => print("hi")};

  void update(String userId) {
    if (userId == null)
      closeConnection();
    else if (userId != this.userId) init(userId);
  }

  Future<void> closeConnection() async {
    print('closing websocket directly');
    _isSocketClosedOnPurpose = true;

    await this.channel?.close(1000, 'App closed');
  }

  void playClub(String clubId) async {
    if (_isPlaying == true &&
        this._previousClubId != null &&
        clubId != this._previousClubId) {
      // it means, user has played another club while previous club was already in playing state

      stopClub(this._previousClubId);
    }

    _isPlaying = true;

    channel.add(jsonEncode({
      "action": "club-subscription",
      "toggleMethod": "play",
      "clubId": clubId,
    }));
  }

  void stopClub(String clubId) async {
    this._previousClubId = null;
    _isPlaying = false;

    channel.add(jsonEncode({
      "action": "club-subscription",
      "toggleMethod": "stop",
      "clubId": clubId,
    }));
  }

  void _wsEventListener(dynamic event) {
    print("Event is called");
    print(jsonDecode(event));
    // for (int i = 0; i < 100; i++) {
    //   print("$event$i");
    // }
    event = jsonDecode(event);
    final what = event["what"];

    /// when we get list of events in a single websocket message.
    if (what == 'ListOfWhat') {
      final List eventList = event['list'];
      for (var element in eventList) {
        final elementWhat = element['what'];
        executeWhatFunction(elementWhat, element);
      }
    } else
      executeWhatFunction(what, event);
  }

  connectWs({bool reconnect = false, int retries = 1}) async {
    final Map<String, dynamic> headers = {"userid": userId};

    if (reconnect || retries > 1) {
      headers.addAll({'reconnect': true});
    }

    try {
      final ch = await WebSocket.connect(
        "wss://0pxxpxq71b.execute-api.ap-south-1.amazonaws.com/Dev",
        headers: headers,
      );
      return ch;
    } catch (e) {
      print("Error! can not connect WS connectWs " + e.toString());

      Fluttertoast.showToast(msg: 'Please check your internet connection');

      await Future.delayed(Duration(
        seconds: min(2 * retries, 15),
      ));
      return await connectWs(retries: retries + 1, reconnect: true);
    }
  }

  void _reConnect() async {
    print('reconnecting-----------------------');
    print('reconnecting-----------------------');
    print('reconnecting-----------------------');
    print('reconnecting-----------------------');
    print('reconnecting-----------------------');
    if (this.channel != null) {
      // add in a reconnect delay
      await Future.delayed(Duration(seconds: 2));
    }

    await init(userId);

    if (_inTheClub) {
      joinClub(_clubId);
      await Future.delayed(Duration(milliseconds: 700));
      if (_isPlaying) {
        playClub(_clubId);
        await Future.delayed(Duration(milliseconds: 700));
      }
    } else {
      if (_isPlaying && _clubId != null) {
        leaveClub(_clubId);
        await Future.delayed(Duration(milliseconds: 700));

        playClub(_clubId);
        await Future.delayed(Duration(milliseconds: 700));
      }
    }
  }

  Future<void> init(String userId, {bool reconnect = false}) async {
    _isSocketClosedOnPurpose = false;

    this.userId = userId;

    this.channel = await connectWs(reconnect: reconnect);
    this.channel.pingInterval = Duration(seconds: 5);

    this.channel.listen(
      _wsEventListener,
      onError: (obj, stacktrace) {
        print('error in websocket stream: $obj, stacktrace: $stacktrace');
        if (_isSocketClosedOnPurpose) return;

        _reConnect();
      },
      onDone: () {
        print('!!!websocket connection is closed!!!');
        if (_isSocketClosedOnPurpose) return;

        _reConnect();
      },
      cancelOnError: true,
    );

    print("------------initializing websockets----------");
  }

  void executeWhatFunction(String what, Map event) {
    final clubId = event['clubId'];

    if (what == 'socialCounts') {
      final updatedUser = userData.user.rebuild((b) => b
        ..followerCount = event['followerCount'] ?? userData.user.followerCount
        ..followingCount =
            event['followingCount'] ?? userData.user.followingCount
        ..friendsCount = event['friendsCount'] ?? userData.user.friendsCount);

      userData.updateUser(updatedUser);
    } else if (funcs[what] != null) {
      funcs[what](event);
    } else if (agoraController.club?.clubId != null &&
        clubId == agoraController.club.clubId) {
      final agoraToken = agoraController.token;

      if (what == "muteParticipant") {
        final bool isMuted = event['isMuted'];
        agoraController.hardMuteAction(isMuted);
        Fluttertoast.showToast(msg: " You are ${isMuted ? 'mute' : 'unmute'}d");
      } else if (what == "JR#Resp#accept") {
        agoraController.joinAsParticipant(
          clubId: clubId,
          agoraToken: agoraToken,
          username: userData.user.username,
        );
        Fluttertoast.showToast(msg: 'You are now a Panelist');
      } else if (what == "kickedOut") {
        agoraController.joinAsAudience(
          clubId: clubId,
          agoraToken: agoraToken,
          username: userData.user.username,
        );

        Fluttertoast.showToast(msg: 'You are now a listener only');
      } else if (what == "blocked") {
        agoraController.stop();
        Fluttertoast.showToast(msg: "Sorry, You are blocked from this club");
      } else if (what == "JR#Resp#cancel") {
        Fluttertoast.showToast(msg: 'You request to speak has been cancelled.');
      } else if (what == "clubConcluded") {
        agoraController.stop();
        Fluttertoast.showToast(msg: "This Club is concluded now");
      }
    }
  }

  void addFunction(String key, Function func) {
    funcs[key] = func;
  }

  void joinClub(
    String clubId, {
    Function putNewComment,
    Function addOldComments,
    Function setReactionCounters,
    Function setParticipantList,
    Function setAudienceCount,
    Function clubStarted,
    Function youAreMuted,
    Function youAreBlocked,
    Function newJRArrived,
    Function yourJRAccepted,
    Function yourJRcancelledByOwner,
    Function youAreKickedOut,
    Function clubConcludedByOwner,
    Function youAreInvited,
    bool isReconnecting = false,
  }) {
    if (_isPlaying == true && clubId != this._clubId) {
      // it means a different club is already playing when user entered this club.
      _previousClubId = this._clubId;

      leaveClub(_previousClubId);

      /// since [this._clubId] will change now

    }

    // we are inside the club.
    _inTheClub = true;
    _clubId = clubId;

    channel.add(jsonEncode({
      "action": "club-subscription",
      "toggleMethod": "enter",
      "clubId": clubId,
    }));

    if (isReconnecting) return;
    // so that we don't need to pass the functions again.

    funcs["newComment"] = putNewComment;
    funcs["oldComments"] = addOldComments;
    funcs["reactionCount"] = setReactionCounters;
    funcs["participantList"] = setParticipantList;
    funcs["audienceCount"] = setAudienceCount;
    funcs["clubStarted"] = clubStarted;

    funcs["muteParticipant"] = youAreMuted;

    funcs["blocked"] = youAreBlocked;

    funcs["JR#New"] = newJRArrived;
    funcs["JR#Resp#accept"] = yourJRAccepted;
    funcs["JR#Resp#cancel"] = yourJRcancelledByOwner;

    funcs["kickedOut"] = youAreKickedOut;

    funcs["clubConcluded"] = clubConcludedByOwner;

    funcs["INV#prt"] = youAreInvited;
  }

  void addComment(String message, String clubId, String userId) {
    channel.add(jsonEncode({
      "action": "comment",
      "body": message,
      "clubId": clubId,
      "userId": userId,
    }));
  }

  void leaveClub(String clubId) {
    if (_isPlaying == true &&
        this._previousClubId != null &&
        this._previousClubId != clubId) {
      // it means user came out of different club than the one which is in playing state.
      this._clubId = this._previousClubId;
      // so restoring current clubId
    }

    // we are outhside the club
    _inTheClub = false;

    channel.add(jsonEncode({
      "action": "club-subscription",
      "toggleMethod": "exit",
      "clubId": clubId,
    }));

    // funcs["newComment"] = null;
    funcs["newComment"] = null;
    funcs["oldComments"] = null;
    funcs["reactionCount"] = null;
    funcs["participantList"] = null;
    funcs["audienceCount"] = null;
    funcs["clubStarted"] = null;

    funcs["muteParticipant"] = null;

    funcs["blocked"] = null;

    funcs["JR#New"] = null;
    funcs["JR#Resp#accept"] = null;
    funcs["JR#Resp#cancel"] = null;

    funcs["kickedOut"] = null;

    funcs["clubConcluded"] = null;

    funcs["INV#prt"] = null;
  }
}
