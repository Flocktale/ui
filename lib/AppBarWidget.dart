import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(icon: Icon(Icons.camera_alt_outlined), onPressed: null),
        Text(
          'MOOTCLUB',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        IconButton(
          icon: Icon(Icons.notifications_none_outlined),
          onPressed: () {
            Navigator.of(context).pushNamed('/notificationPage');
          },
        ),
      ],
    );
  }
}
