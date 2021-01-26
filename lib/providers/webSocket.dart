import 'package:flutter/widgets.dart';
import 'package:mootclub_app/providers/userData.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

 class MySocket with ChangeNotifier{
  IOWebSocketChannel channel;

  Map<String, Function> funcs;
  MySocket(String userId) {

    for(int i=0;i<100;i++)
      print("i$userId");
    // if (userId != null) init(userId);
    // funcs["newComment"] = null;
    // funcs["oldComment"] = null;
    // funcs["reactionCount"] = null;
    // funcs["audienceCount"] = null;
  }

  void update(String userId) {
    if (userId != null) init(userId);
  }

  void init(String userId) {
    this.channel = IOWebSocketChannel.connect(
      Uri.parse("wss://jpkq996li6.execute-api.us-east-1.amazonaws.com/Dev"),
      headers: {"userid": userId},
    );
    this.channel.stream.listen((event) {
      print("Event is called");
      print(event);

      funcs.forEach((key, value) {
        if (key == event.what && value != null) {
          value();
        }
      });
    });
    print("------------initializing websockets----------");
  }

  void currentStatus() {
    // for (int i = 0; i < 100; i++) print(i);
    // print(funcs);
  }
}
