import 'package:flutter/material.dart';

AlertDialog clubConcludeAlert(context, Function() concludeClub) => AlertDialog(
      title: Text("Do you want to end the club?"),
      actions: [
        FlatButton(
          child: Text(
            "No",
            style: TextStyle(
                fontFamily: "Lato",
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(
            "Yes",
            style: TextStyle(
                fontFamily: "Lato",
                color: Colors.redAccent,
                fontWeight: FontWeight.bold),
          ),
          onPressed: () async {
            await concludeClub();

            Navigator.of(context).pop();
          },
        ),
      ],
    );
