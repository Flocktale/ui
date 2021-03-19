import 'package:flutter/material.dart';

Widget displayInvitationInClub(context,
    {Function onReject, Function onAccept}) {
  final size = MediaQuery.of(context).size;

  return Container(
    height: size.height / 10,
    width: size.width,
    color: Colors.redAccent,
    child: Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Text(
            "You have been invited to be a panelist",
            style: TextStyle(fontFamily: "Lato", color: Colors.white),
          ),
        ),
        FittedBox(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: RaisedButton(
                onPressed: () => onReject(),
                color: Colors.redAccent,
                child: Text(
                  "Reject",
                  style: TextStyle(
                      fontFamily: "Lato",
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            RaisedButton(
              onPressed: () => onAccept(),
              color: Colors.white,
              child: Text(
                "Accept",
                style: TextStyle(
                    fontFamily: "Lato",
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent),
              ),
            ),
          ],
        ))
      ],
    ),
  );
}
