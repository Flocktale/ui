import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/io.dart';

class MySocket with ChangeNotifier {
  IOWebSocketChannel channel;

  String userId;
  Map<String, Function> funcs = {"newComment": () => print("hi")};

  MySocket(String userId) {
    if (userId != null) init(userId);
    // funcs["newComment"] = null;
    // funcs["oldComments"] = null;
    // funcs["reactionCount"] = null;
    // funcs["audienceCount"] = null;
  }

  void update(String userId) {
    if (userId != this.userId) init(userId);
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
    for (int i = 0; i < 100; i++) print("$userId :100 $i");
    print(channel);
  }

  void addFunction(String key, Function func) {
    funcs[key] = func;
  }

  void joinClub(String clubId, Function func) {
    channel.sink.add(jsonEncode({
      "action": "club-subscription",
      "toggleMethod": "enter",
      "clubId": clubId,
    }));

    funcs["newComment"] = func;
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

    funcs["newComment"] = null;
  }
}
