import 'package:flutter/material.dart';
class MinClub extends StatefulWidget {
  @override
  _MinClubState createState() => _MinClubState();
}

class _MinClubState extends State<MinClub> {
  bool isPlaying = true;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return isPlaying?
    Container(
      height: size.height/12,
      width: size.width,
      color: Colors.white,
      child: Row(
        children: [
          Container(
              margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: Image.asset("assets/Card1.jpg")),
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, size.width-250, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Club Name",
                  style: TextStyle(
                    fontFamily: "Lato",
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  "Artist",
                  style: TextStyle(
                    fontFamily: "Lato",
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
          Container(
              child: IconButton(
                iconSize: size.width/10,
                  icon: Icon(Icons.stop),
                  onPressed: null
              )
          )
        ]
      ),
    ):Container(height: 0,);
  }
}
