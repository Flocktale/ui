import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/pages/InviteScreen.dart';
import 'package:mootclub_app/providers/userData.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'ProfilePage.dart';

class ParticipantsPanel extends StatefulWidget {
  final Size size;
  final List<AudienceData> participantList;
  final bool isOwner;
  final Function(String) muteParticipant;
  final Function(String) removeParticipant;
  final Function(String) blockParticipant;
  final BuiltClub club;
  const ParticipantsPanel({
    @required this.club,
    @required this.size,
    @required this.participantList,
    @required this.isOwner,
    @required this.muteParticipant,
    @required this.removeParticipant,
    @required this.blockParticipant,
  });

  @override
  _ParticipantsPanelState createState() => _ParticipantsPanelState();
}

class _ParticipantsPanelState extends State<ParticipantsPanel> {
  bool hasSentJoinRequest = false;
  bool isParticipant(String userId) {
    if (userId == widget.club.creator.userId)
      return false;
    else {
      for (int i = 0; i < widget.participantList.length; i++) {
        if (widget.participantList[i].audience.userId == userId) return true;
      }
    }
    return false;
  }

  _sendJoinRequest() async {
    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    BuiltUser cuser = Provider.of<UserData>(context, listen: false).user;
    final resp = await service.sendJoinRequest(
      clubId: widget.club.clubId,
      userId: cuser.userId,
      authorization: authToken,
    );
    if (resp.isSuccessful) {
      setState(() {
        hasSentJoinRequest = true;
      });
      Fluttertoast.showToast(msg: "Join Request Sent");
    } else {
      Fluttertoast.showToast(
          msg: "Some error occurred. Please try again later");
    }
  }

  _deleteJoinRequest() async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    BuiltUser cuser = Provider.of<UserData>(context, listen: false).user;
    final resp = await service.deleteJoinRequet(
      clubId: widget.club.clubId,
      userId: cuser.userId,
      authorization: authToken,
    );
    if (resp.isSuccessful) {
      setState(() {
        hasSentJoinRequest = true;
      });
      Fluttertoast.showToast(msg: "Join Request Cancelled");
    } else
      Fluttertoast.showToast(
          msg: "Some Error Occurred. Please try again later.");
  }

  void _handleMenuButtons(String value, String panelistId) {
    switch (value) {
      case 'Mute':
        widget.muteParticipant(panelistId);
        break;
      case 'Remove':
        widget.removeParticipant(panelistId);
        break;
      case 'Block':
        widget.blockParticipant(panelistId);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserData>(context, listen: false).userId;
    final cuser = Provider.of<UserData>(context, listen: false).user;
    return SlidingUpPanel(
      minHeight: widget.size.height / 20,
      maxHeight: widget.size.height / 1.5,
      backdropEnabled: true,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      panel: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: widget.size.height / 30,
          ),
          Center(
            child: Text("Host",
                style: TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold,
                    fontSize: widget.size.width / 20,
                    color: Colors.redAccent)),
          ),
          SizedBox(
            height: widget.size.height / 50,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: Stack(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ProfilePage(
                              userId: widget.club.creator.userId,
                            )));
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: widget.size.width / 9.4,
                        backgroundColor: Color(0xffFDCF09),
                        child: CircleAvatar(
                          radius: widget.size.width / 10,
                          backgroundImage:
                              NetworkImage(widget.club.creator.avatar),
                        ),
                      ),
                      Text(
                        widget.club.creator.username,
                        style: TextStyle(
                            fontFamily: "Lato", fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: widget.size.height / 30,
          ),
          Center(
            child: Text("Panelists",
                style: TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold,
                    fontSize: widget.size.width / 20,
                    color: Colors.redAccent)),
          ),
          SizedBox(
            height: widget.size.height / 50,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: GridView.builder(
                itemCount: widget.participantList
                            .where((element) =>
                                element.audience.userId != cuser.userId)
                            .length <
                        9
                    ? widget.participantList
                            .where((element) =>
                                element.audience.userId != cuser.userId)
                            .length +
                        1
                    : widget.participantList
                        .where((element) =>
                            element.audience.userId != cuser.userId)
                        .length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  final participantId =
                      widget.participantList[index].audience.userId;
                  return index !=
                          widget.participantList
                              .where((element) =>
                                  element.audience.userId != cuser.userId)
                              .length
                      ? Container(
                          child: Stack(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => ProfilePage(
                                            userId: widget
                                                .participantList[index]
                                                .audience
                                                .userId,
                                          )));
                                },
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: widget.size.width / 9.4,
                                      backgroundColor: Color(0xffFDCF09),
                                      child: CircleAvatar(
                                        radius: widget.size.width / 10,
                                        backgroundImage: NetworkImage(widget
                                            .participantList[index]
                                            .audience
                                            .avatar),
                                      ),
                                    ),
                                    Text(
                                      widget.participantList[index].audience
                                          .username,
                                      style: TextStyle(
                                          fontFamily: "Lato",
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              // display menu to owner only.
                              if (widget.isOwner && participantId != userId)
                                Positioned(
                                  right: 10,
                                  child: PopupMenuButton<String>(
                                    onSelected: (val) =>
                                        _handleMenuButtons(val, participantId),
                                    itemBuilder: (BuildContext context) {
                                      return {
                                        'Mute',
                                        'Remove',
                                        'Block',
                                      }.map((String choice) {
                                        return PopupMenuItem<String>(
                                          value: choice,
                                          child: Text(choice),
                                        );
                                      }).toList();
                                    },
                                  ),
                                )
                            ],
                          ),
                        )
                      : !isParticipant(cuser.userId)
                          ? InkWell(
                              onTap: () {
                                widget.isOwner
                                    ? Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => InviteScreen(
                                                club: widget.club)))
                                    : !hasSentJoinRequest
                                        ? _sendJoinRequest()
                                        : _deleteJoinRequest();
                              },
                              child: Container(
                                margin: EdgeInsets.all(widget.size.width / 20),
                                child: Icon(
                                  !hasSentJoinRequest
                                      ? Icons.person_add
                                      : Icons.person_add_disabled,
                                  color: Colors.redAccent,
                                  size: widget.size.width / 10,
                                ),
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.redAccent, width: 2)),
                              ),
                            )
                          : Container();
                },
              ),
            ),
          )
        ],
      )),
      collapsed: Container(
        decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        child: Center(
          child: Text(
            "PANELISTS",
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0),
          ),
        ),
      ),
    );
  }
}
