import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void sendAndRetrieveMessage() async {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final String serverToken =
      'AAAACgeiNUU:APA91bESRHYJLxb5jqE-_Sc-2hj4dt5uhz9raJeQhk838b3rdxsKVPn2WLOlGN12n3N9xsuj_pqRzkrLVNK9sZOfvcIXEO0ZZoGdbo4IrI2PrvGODD7x6_BPN8uhv8QylDJ2zkjIfhqJ';

  final fcmToken = await firebaseMessaging.getToken();
  print(fcmToken);
  // return null;

  await Future.delayed(Duration(seconds: 2));

  await http.post(
    'https://fcm.googleapis.com/fcm/send',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': 'this is a body',
          'title': 'this is a title'
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        },
        'to': await firebaseMessaging.getToken(),
      },
    ),
  );
}

class NotificationTesting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: RaisedButton(
            onPressed: () => sendAndRetrieveMessage(),
            child: Text('Click it!'),
          ),
        ),
      ),
    );
  }
}
