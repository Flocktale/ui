import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flocktale/Models/appConstants.dart';
import 'package:flocktale/providers/notificationProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future onBackgroundMessageHandler(Map<String, dynamic> message) async {
  _setNotificationToHighlights(message);
  print('message in bgHandler: $message');
}

configureFCM() async {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final token = await _firebaseMessaging.getToken();
  debugPrint('token: ' + token);

  _firebaseMessaging.configure(
    onBackgroundMessage: onBackgroundMessageHandler,
    onMessage: (Map<String, dynamic> message) async {
      print('hola');
      print("onMessage: $message");

      _setNotificationToHighlights(message);
    },
    onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");

      _setNotificationToHighlights(message);
    },
    onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
      _setNotificationToHighlights(message);
    },
  );
}

void _setNotificationToHighlights(Map<String, dynamic> message) {
  if (message['data'] == null || !(message['data'] is Map)) return;

  final toSave = message['data']['toSave'];

  if (toSave == true ||
      toSave == 'true' ||
      toSave == 'True' ||
      toSave == 'TRUE') {
    Provider.of<NotificationProvider>(AppConstants.rootContext, listen: false)
        .changeHighlighted(true);
  }
}
