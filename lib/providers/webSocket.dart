import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flocktale/providers/agoraController.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:web_socket_channel/io.dart';

class MySocket with ChangeNotifier {
  final AgoraController agoraController;

  final UserData userData;

  MySocket(this.agoraController, this.userData);

  IOWebSocketChannel channel;

  String userId;
  Map<String, Function> funcs = {"newComment": () => print("hi")};

  void update(String userId) {
    if (userId == null)
      closeConnection();
    else if (userId != this.userId) init(userId);
  }

  Future<void> closeConnection() async {
    await this.channel?.sink?.close();
  }

  void playClub(String clubId) async {
    channel.sink.add(jsonEncode({
      "action": "club-subscription",
      "toggleMethod": "play",
      "clubId": clubId,
    }));
  }

  void stopClub(String clubId) async {
    channel.sink.add(jsonEncode({
      "action": "club-subscription",
      "toggleMethod": "stop",
      "clubId": clubId,
    }));
  }

  void init(String userId) {
    this.userId = userId;
    this.channel = IOWebSocketChannel.connect(
      Uri.parse("wss://0pxxpxq71b.execute-api.ap-south-1.amazonaws.com/Dev"),
      headers: {"userid": userId},
    );

    this.channel.stream.listen(
        (event) {
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
        },
        cancelOnError: true, // closes stream as soon as any error occurs
        onError: (obj, stacktrace) {
          print('error in websocket stream: $obj, stacktrace: $stacktrace');
        },
        onDone: () {
          print('!!!websocket connection is closed!!!');
        });
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
      final agoraToken = agoraController.club.agoraToken;

      if (what == "muteAction#") {
        final bool isMuted = event['isMuted'];
        agoraController.hardMuteAction(isMuted);
        Fluttertoast.showToast(msg: " You are ${isMuted ? 'mute' : 'unmute'}d");
      } else if (what == "JR#Resp#accept") {
        agoraController.joinAsParticipant(clubId: clubId, token: agoraToken);

        Fluttertoast.showToast(msg: 'You are now a Panelist');
      } else if (what == "kickedOut") {
        agoraController.joinAsAudience(clubId: clubId, token: agoraToken);

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
    Function muteActionResponse,
    Function youAreBlocked,
    Function newJRArrived,
    Function yourJRAccepted,
    Function yourJRcancelledByOwner,
    Function youAreKickedOut,
    Function clubConcludedByOwner,
    Function youAreInvited,
  }) {
    channel.sink.add(jsonEncode({
      "action": "club-subscription",
      "toggleMethod": "enter",
      "clubId": clubId,
    }));

    funcs["newComment"] = putNewComment;
    funcs["oldComments"] = addOldComments;
    funcs["reactionCount"] = setReactionCounters;
    funcs["participantList"] = setParticipantList;
    funcs["audienceCount"] = setAudienceCount;
    funcs["clubStarted"] = clubStarted;

    funcs["muteParticipant"] = youAreMuted;

    funcs["muteAction#"] = muteActionResponse;

    funcs["blocked"] = youAreBlocked;

    funcs["JR#New"] = newJRArrived;
    funcs["JR#Resp#accept"] = yourJRAccepted;
    funcs["JR#Resp#cancel"] = yourJRcancelledByOwner;

    funcs["kickedOut"] = youAreKickedOut;

    funcs["clubConcluded"] = clubConcludedByOwner;

    funcs["INV#prt"] = youAreInvited;
  }

  void addComment(String message, String clubId, String userId) {
    channel.sink.add(jsonEncode({
      "action": "comment",
      "body": message,
      "clubId": clubId,
      "userId": userId,
    }));
  }

  void leaveClub(String clubId) {
    channel.sink.add(jsonEncode({
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

    funcs["muteAction#"] = null;

    funcs["blocked"] = null;

    funcs["JR#New"] = null;
    funcs["JR#Resp#accept"] = null;
    funcs["JR#Resp#cancel"] = null;

    funcs["kickedOut"] = null;

    funcs["clubConcluded"] = null;

    funcs["INV#prt"] = null;
  }
}
