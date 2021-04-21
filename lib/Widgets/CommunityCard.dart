import 'dart:ui';

import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/Widgets/customImage.dart';
import 'package:flocktale/pages/CommunityPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:flocktale/providers/userData.dart';

class CommunityCard extends StatefulWidget {
  final BuiltCommunity community;
  CommunityCard({this.community});
  @override
  _CommunityCardState createState() => _CommunityCardState();
}

class _CommunityCardState extends State<CommunityCard> {
  bool isMember = false;
  @override
  Widget build(BuildContext context) {
    final _communityCoverImage = widget.community.coverImage;
    final _communityAvatar = widget.community.avatar;
    final _userAvatar =
        Provider.of<UserData>(context, listen: false).user.avatar;
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => CommunityPage(
                  community: widget.community,
                )));
      },
      child: ClipRRect(
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Stack(children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              height: size.height / 4,
              width: double.infinity,
              child: CustomImage(
                radius: 10,
                image: _communityCoverImage,
              ),
            ),
            Container(
              height: size.height / 4,
              width: size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
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
              bottom: size.height / 15,
              left: 10,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: size.width / 20,
                    child: CircleAvatar(
                      child: CustomImage(image: _communityAvatar),
                    ),
                  ),
                  SizedBox(
                    width: size.width / 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.community.name,
                        style: TextStyle(
                            fontFamily: "Lato",
                            color: Colors.white,
                            letterSpacing: 2.0),
                      ),
                      Text(
                        widget.community.creator.username,
                        style: TextStyle(
                            fontFamily: "Lato",
                            color: Colors.grey[400],
                            fontSize: size.width / 30),
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
                height: size.height / 22.5,
                width: size.width,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.community.hosts!=null?widget.community.hosts.length>4?5:widget.community.hosts.length:0,
                    itemBuilder: (context, index) {
                      return widget.community.hosts.length>4?
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        height: size.height / 22.5,
                        width: size.height / 22.5,
                        child: CustomImage(
                          image: _userAvatar,
                          radius: 2,
                        ),
                      ):
                      index == 4
                          ? Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                              height: size.height / 22.5,
                              width: size.height / 22.5,
                              decoration: BoxDecoration(
                                  //color: Color(0xfff74040)
                                  color: Colors.black45),
                              child: Center(
                                child: Text(
                                  (widget.community.hosts.length-4).toString(),
                                  style: TextStyle(
                                      fontFamily: "Lato", color: Colors.white),
                                ),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                              height: size.height / 22.5,
                              width: size.height / 22.5,
                              child: CustomImage(
                                image: _userAvatar,
                                radius: 2,
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
                          widget.community.liveClubCount.toString(),
                          style: TextStyle(
                              fontFamily: "Lato", color: Colors.white),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Container(
                          height: size.height / 50,
                          width: size.width / 15,
                          decoration: BoxDecoration(color: Color(0xfff74040)),
                          child: Center(
                            child: Text(
                              "LIVE",
                              style: TextStyle(
                                  fontFamily: "Lato",
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2.0,
                                  color: Colors.white,
                                  fontSize: size.width / 50),
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
                          widget.community.scheduledClubCount.toString(),
                          style: TextStyle(
                              fontFamily: "Lato", color: Colors.white),
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
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10))),
                  child: Row(
                    children: [
                      Text(
                        widget.community.memberCount.toString(),
                        style: TextStyle(
                            fontFamily: "Lato",
                            color: Colors.white,
                            fontSize: size.width / 30),
                      ),
                      Icon(
                        Icons.person,
                        color: Colors.white,
                        size: size.width / 25,
                      ),
                    ],
                  ),
                ))
          ]),
        ),
      ),
    );
  }
}
