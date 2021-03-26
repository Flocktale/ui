import 'dart:ui';

import 'package:flocktale/Widgets/customImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:flocktale/providers/userData.dart';

class CommunityCard extends StatefulWidget {
  @override
  _CommunityCardState createState() => _CommunityCardState();
}

class _CommunityCardState extends State<CommunityCard> {
  bool isMember = false;
  @override
  Widget build(BuildContext context) {
    final _userAvatar = Provider.of<UserData>(context,listen:false).user.avatar;
    final size = MediaQuery.of(context).size;
    return ClipRRect(
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Stack(children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  'assets/images/logo.png',
                ),
              ),
            ),
            height: size.height/4,
          ),
          Container(
            height: size.height/4,
            width: size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      Colors.grey.withOpacity(0.2),
                      Colors.black,
                    ],
                    stops: [
                      0.0,
                      1.0
                    ])),
          ),
          Positioned(
            bottom: size.height/15,
            left: 10,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: size.width/20,
                  child: CircleAvatar(
                backgroundImage: NetworkImage(_userAvatar),
                    radius: size.width/23,
            ),
                ),
                SizedBox(
                  width: size.width/30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "COMMUNITY NAME",
                      style: TextStyle(
                          fontFamily: "Lato",
                          color: Colors.white,
                          letterSpacing: 2.0
                      ),
                    ),
                    Text(
                      "Creator name",
                      style: TextStyle(
                        fontFamily: "Lato",
                        color: Colors.grey[400],
                        fontSize: size.width/30
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Container(
              height: size.height/22.5,
              width: size.width,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context,index){
                    return index==4?
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                          height: size.height/22.5,
                          width: size.height/22.5,
                          decoration: BoxDecoration(
                            //color: Color(0xfff74040)
                            color: Colors.black45
                          ),
                          child: Center(
                            child: Text(
                              "+6",
                              style: TextStyle(
                                fontFamily: "Lato",
                                color: Colors.white
                              ),
                            ),
                          ),
                        ):
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                      height: size.height/22.5,
                      width: size.height/22.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                          image: DecorationImage(
                              image: NetworkImage(
                                  _userAvatar
                              )
                          )
                      ),
                    );
                  }),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Column(
              children: [
                FittedBox(
                  child: Row(
                    children: [
                      Text(
                        "15",
                        style: TextStyle(
                            fontFamily: "Lato",
                            color: Colors.white
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Container(
                        height: size.height/50,
                        width: size.width/15,
                        decoration: BoxDecoration(
                            color: Color(0xfff74040)
                        ),
                        child: Center(
                          child: Text(
                            "LIVE",
                            style: TextStyle(
                                fontFamily: "Lato",
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                                color: Colors.white,
                                fontSize: size.width/50
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                FittedBox(
                  child: Row(
                    children: [
                      Text(
                          "35",
                        style: TextStyle(
                          fontFamily: "Lato",
                          color: Colors.white
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Icon(
                          Icons.schedule,
                        color: Colors.white,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(10))
              ),
              child: Row(
                children: [
                  Text(
                  "15K",
                    style: TextStyle(
                      fontFamily: "Lato",
                      color: Colors.white,
                      fontSize: size.width/30
                    ),
                  ),
                  Icon(
                    Icons.person,
                    color: Colors.white,
                    size: size.width/25,
                  ),
                  IconButton(icon: isMember?Icon(Icons.check,color: Colors.green,):Icon(Icons.add,color: Colors.white,), onPressed: (){
                    setState(() {
                      isMember = !isMember;
                    });
                  })
                ],
              ),
            )
          )
        ]),
      ),
    );
  }
}
