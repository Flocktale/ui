import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/io.dart';

class MySocket with ChangeNotifier {
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

  void init(String userId) {
    this.userId = userId;
    this.channel = IOWebSocketChannel.connect(
      Uri.parse("wss://jpkq996li6.execute-api.us-east-1.amazonaws.com/Dev"),
      headers: {"userid": userId},
    );

    this.channel.stream.listen((event) {
      print("Event is called");
      print(jsonDecode(event));
      // for (int i = 0; i < 100; i++) {
      //   print("$event$i");
      // }
      event = jsonDecode(event);

      funcs.forEach((key, value) {
        if (key == event["what"] && value != null) {
          value(event);
        }
      });
    });
    print("------------initializing websockets----------");
  }

  void currentStatus() {
    // for (int i = 0; i < 100; i++) print("$userId :100 $i");
    // print(channel);
  }

  void addFunction(String key, Function func) {
    funcs[key] = func;
  }

  void joinClub(
      String clubId,
      Function putNewComment,
      Function addOldComments,
      Function getReactionForFirstTime,
      Function getParticipantListForFirstTime,
      Function getAudienceForFirstTime,
      Function clubStarted,
      Function youAreMuted,
      Function youAreBlocked) {
    channel.sink.add(jsonEncode({
      "action": "club-subscription",
      "toggleMethod": "enter",
      "clubId": clubId,
    }));

    funcs["newComment"] = putNewComment;
    funcs["oldComments"] = addOldComments;
    funcs["reactionCount"] = getReactionForFirstTime;
    funcs["participantList"] = getParticipantListForFirstTime;
    funcs["audienceCount"] = getAudienceForFirstTime;
    funcs["clubStarted"] = clubStarted;
    funcs["muteParticipant"] = youAreMuted;
    funcs["blocked"] = youAreBlocked;

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
    funcs["blocked"] = null;
  }
}
