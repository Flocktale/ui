import 'package:flocktale/customImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/pages/InviteScreen.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'ProfilePage.dart';

class ParticipantsPanel extends StatefulWidget {
  final Size size;
  final bool hasSentJoinRequest;
  final List<AudienceData> participantList;
  final bool isOwner;
  final Map<String, int> currentlySpeakingUsers;
  final Function(String) muteParticipant;
  final Function(String) removeParticipant;
  final Function(String) blockParticipant;
  final Function() sendJoinRequest;
  final Function() deleteJoinRequest;
  final BuiltClub club;
  const ParticipantsPanel({
    @required this.currentlySpeakingUsers,
    @required this.club,
    @required this.size,
    @required this.participantList,
    @required this.isOwner,
    @required this.hasSentJoinRequest,
    @required this.muteParticipant,
    @required this.removeParticipant,
    @required this.blockParticipant,
    @required this.sendJoinRequest,
    @required this.deleteJoinRequest,
  });

  @override
  _ParticipantsPanelState createState() => _ParticipantsPanelState();
}

class _ParticipantsPanelState extends State<ParticipantsPanel> {
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

  bool isOwnerMuted() {
    for (int i = 0; i < widget.participantList.length; i++) {
      if (widget.participantList[i].audience.userId ==
          widget.club.creator.userId) {
        return widget.participantList[i].isMuted;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
            width: size.width / 3.5,
            margin: EdgeInsets.fromLTRB(size.width / 15, 10, 0, 0),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: widget.size.width / 9,
                        backgroundColor:
                            widget.currentlySpeakingUsers != null &&
                                    widget.currentlySpeakingUsers[
                                            widget.club.creator.username] !=
                                        null &&
                                    widget.currentlySpeakingUsers[
                                            widget.club.creator.username] >
                                        0
                                ? Colors.redAccent
                                : Color(0xffFDCF09),
                        child: CircleAvatar(
                          radius: widget.size.width / 10,
                          child: CustomImage(
                            image: widget.club.creator.avatar,
                          ),
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
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(
                      isOwnerMuted() == false
                          ? widget.currentlySpeakingUsers != null &&
                                  widget.currentlySpeakingUsers[
                                          widget.club.creator.username] !=
                                      null &&
                                  widget.currentlySpeakingUsers[
                                          widget.club.creator.username] >
                                      0
                              ? Icons.mic_rounded
                              : Icons.mic_none_outlined
                          : Icons.mic_off_outlined,
                      color: widget.currentlySpeakingUsers != null &&
                              widget.currentlySpeakingUsers[
                                      widget.club.creator.username] !=
                                  null &&
                              widget.currentlySpeakingUsers[
                                      widget.club.creator.username] >
                                  0
                          ? Colors.redAccent
                          : Colors.black,
                    ),
                    color: Colors.black,
                  ),
                )
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
                  return index != widget.participantList.length
                      ? Container(
                          width: size.width / 3.5,
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: widget.size.width / 9,
                                      backgroundColor:
                                          widget.currentlySpeakingUsers !=
                                                      null &&
                                                  widget.currentlySpeakingUsers[
                                                          widget
                                                              .participantList[
                                                                  index]
                                                              .audience
                                                              .username] !=
                                                      null &&
                                                  widget.currentlySpeakingUsers[
                                                          widget
                                                              .participantList[
                                                                  index]
                                                              .audience
                                                              .username] >
                                                      0
                                              ? Colors.redAccent
                                              : Color(0xffFDCF09),
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
                              if (widget.isOwner &&
                                  widget.participantList[index].audience
                                          .userId !=
                                      userId)
                                Positioned(
                                  right: 10,
                                  child: PopupMenuButton<String>(
                                    onSelected: (val) => _handleMenuButtons(
                                        val,
                                        widget.participantList[index].audience
                                            .userId),
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
                                ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: IconButton(
                                  icon: Icon(
                                    !widget.participantList[index].isMuted
                                        ? widget.currentlySpeakingUsers !=
                                                    null &&
                                                widget.currentlySpeakingUsers[
                                                        widget
                                                            .participantList[
                                                                index]
                                                            .audience
                                                            .username] !=
                                                    null &&
                                                widget.currentlySpeakingUsers[
                                                        widget
                                                            .participantList[
                                                                index]
                                                            .audience
                                                            .username] >
                                                    0
                                            ? Icons.mic_rounded
                                            : Icons.mic_none_outlined
                                        : Icons.mic_off_outlined,
                                    color: widget.currentlySpeakingUsers !=
                                                null &&
                                            widget.currentlySpeakingUsers[widget
                                                    .participantList[index]
                                                    .audience
                                                    .username] !=
                                                null &&
                                            widget.currentlySpeakingUsers[widget
                                                    .participantList[index]
                                                    .audience
                                                    .username] >
                                                0
                                        ? Colors.redAccent
                                        : Colors.black,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : !isParticipant(cuser.userId) || widget.isOwner
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    widget.isOwner
                                        ? Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) => InviteScreen(
                                                    club: widget.club)))
                                        : !widget.hasSentJoinRequest
                                            ? widget.sendJoinRequest()
                                            : widget.deleteJoinRequest();
                                  },
                                  child: Container(
                                    //        margin: EdgeInsets.fromLTRB(10,10,10,5),
                                    height: widget.size.width / 5,
                                    width: widget.size.width / 5,
                                    child: Icon(
                                      widget.isOwner
                                          ? Icons.person_add
                                          : !widget.hasSentJoinRequest
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
                                ),
                                Text(
                                  widget.isOwner
                                      ? "Invite Panelists"
                                      : !widget.hasSentJoinRequest
                                          ? "Ask to join"
                                          : "Cancel join request",
                                  style: TextStyle(
                                      fontFamily: "Lato",
                                      fontWeight: FontWeight.bold),
                                )
                              ],
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
