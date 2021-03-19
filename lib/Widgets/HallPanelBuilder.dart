import 'package:flocktale/customImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/pages/InviteScreen.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:provider/provider.dart';

import '../pages/ProfilePage.dart';

class HallPanelBuilder extends StatelessWidget {
  final ScrollController panelScrollController;

  final Size size;
  final bool hasSentJoinRequest;
  final List<AudienceData> participantList;
  final bool isOwner;
  final Map<String, int> currentlySpeakingUsers;

  final Function(String) muteParticipant;
  final Function(String) removeParticipant;

  final Function(String) inviteAudience;
  final Function(String) blockUser;

  final Function() sendJoinRequest;
  final Function() deleteJoinRequest;
  final BuiltClub club;

  final Map<String, dynamic> audienceMap;
  final Function fetchMoreAudience;

  const HallPanelBuilder(
    this.panelScrollController, {
    @required this.currentlySpeakingUsers,
    @required this.club,
    @required this.size,
    @required this.participantList,
    @required this.isOwner,
    @required this.hasSentJoinRequest,
    @required this.muteParticipant,
    @required this.removeParticipant,
    @required this.inviteAudience,
    @required this.blockUser,
    @required this.sendJoinRequest,
    @required this.deleteJoinRequest,
    @required this.audienceMap,
    @required this.fetchMoreAudience,
  });

  bool _isParticipant(String userId) {
    if (userId == club.creator.userId)
      return false;
    else {
      for (int i = 0; i < participantList.length; i++) {
        if (participantList[i].audience.userId == userId) return true;
      }
    }
    return false;
  }

  void _handleMenuButtons(String value, String userId) {
    switch (value) {
      case 'Mute':
        muteParticipant(userId);
        break;
      case 'Remove':
        removeParticipant(userId);
        break;
      case 'Invite':
        inviteAudience(userId);
        break;
      case 'Block':
        blockUser(userId);
        break;
    }
  }

  bool isOwnerMuted() {
    for (int i = 0; i < participantList.length; i++) {
      if (participantList[i].audience.userId == club.creator.userId) {
        return participantList[i].isMuted;
      }
    }
    return false;
  }

  bool _isSpeaking(String username) {
    return currentlySpeakingUsers != null &&
        currentlySpeakingUsers[username] != null &&
        currentlySpeakingUsers[username] > 0;
  }

  Widget _inviteOrRequestButtonForUser(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            isOwner
                ? Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => InviteScreen(club: club),
                    ),
                  )
                : !hasSentJoinRequest
                    ? sendJoinRequest()
                    : deleteJoinRequest();
          },
          child: Container(
            //        margin: EdgeInsets.fromLTRB(10,10,10,5),
            height: size.width / 5,
            width: size.width / 5,
            child: Icon(
              isOwner
                  ? Icons.person_add
                  : !hasSentJoinRequest
                      ? Icons.person_add
                      : Icons.person_add_disabled,
              color: Colors.redAccent,
              size: size.width / 10,
            ),
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.redAccent, width: 2)),
          ),
        ),
        Text(
          isOwner
              ? "Invite Panelists"
              : !hasSentJoinRequest
                  ? "Ask to join"
                  : "Cancel join request",
          style: TextStyle(fontFamily: "Lato", fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget popMenuForOwner(String userId, bool isParticipant) {
    Set<String> menu = {};
    if (isParticipant)
      menu = {'Mute', 'Remove', 'Block'};
    else
      menu = {'Invite', 'Block'};

    return Positioned(
      right: 10,
      child: PopupMenuButton<String>(
        onSelected: (val) => _handleMenuButtons(val, userId),
        itemBuilder: (BuildContext context) {
          return menu.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final myUserId = Provider.of<UserData>(context, listen: false).userId;

    // sorting show that owner comes first
    participantList.sort((first, second) {
      if (first.audience.userId == club.creator.userId) return -1;
      if (second.audience.userId == club.creator.userId)
        return -1;
      else
        return 0;
    });

    final List<AudienceData> audienceList = audienceMap['list'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            fetchMoreAudience();
          }
          return true;
        },
        child: ListView(
          controller: panelScrollController,
          children: [
            SizedBox(height: size.height / 30),
            Center(
              child: Text("Panelists",
                  style: TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                      fontSize: size.width / 20,
                      color: Colors.redAccent)),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: (participantList.length < 10
                    ? participantList.length + 1
                    : participantList.length),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 7 / 8,
                ),
                itemBuilder: (context, index) {
                  if (index == participantList.length) {
                    return !_isParticipant(myUserId) || isOwner
                        ? _inviteOrRequestButtonForUser(context)
                        : Container();
                  }

                  final participant = participantList[index].audience;
                  return Container(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ProfilePage(
                                      userId: participant.userId,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: size.width / 9,
                                    backgroundColor:
                                        _isSpeaking(participant.username)
                                            ? Colors.redAccent
                                            : Color(0xffFDCF09),
                                    child: CircleAvatar(
                                      radius: size.width / 10,
                                      child: CustomImage(
                                        image: participant.avatar,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    participant.username,
                                    style: TextStyle(
                                        fontFamily: "Lato",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            // display menu to owner only. (excluding owner himself)
                            if (isOwner && participant.userId != myUserId)
                              popMenuForOwner(
                                participant.userId,
                                true,
                              ),
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: Icon(
                                !participantList[index].isMuted
                                    ? _isSpeaking(participant.username)
                                        ? Icons.mic_rounded
                                        : Icons.mic_none_outlined
                                    : Icons.mic_off_outlined,
                                color: _isSpeaking(participant.username)
                                    ? Colors.redAccent
                                    : Colors.black,
                              ),
                            )
                          ],
                        ),
                        Text(participant.userId == club.creator.userId
                            ? '( Host )'
                            : ''),
                      ],
                    ),
                  );
                },
              ),
            ),
            Center(
              child: Text("Audience",
                  style: TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                      fontSize: size.width / 20,
                      color: Colors.redAccent)),
            ),
            if ((audienceList?.length ?? 0) == 0)
              Column(
                children: [
                  SizedBox(height: 80),
                  Center(
                    child: Text('.......'),
                  )
                ],
              )
            else
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 7 / 8,
                  ),
                  itemCount: (audienceList?.length ?? 0),
                  itemBuilder: (context, index) {
                    final audience = audienceList[index].audience;
                    return Container(
                      // color: Colors.red,
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ProfilePage(
                                    userId: audience.userId,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    CircleAvatar(
                                      radius: size.width / 11,
                                      child: CustomImage(
                                        image: audience.avatar,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      audience.username,
                                      style: TextStyle(
                                          fontFamily: "Lato",
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // display menu to owner only.
                          if (isOwner)
                            popMenuForOwner(
                              audience.userId,
                              false,
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: audienceMap['isLoading'] == true ? 2 : 1,
                itemBuilder: (ctx, index) {
                  if (index == 0)
                    return Container(
                      height: 100,
                      color: Colors.transparent,
                    );
                  else
                    return Container(
                      height: 100,
                      child: Center(child: CircularProgressIndicator()),
                    );
                }),
          ],
        ),
      ),
    );
  }
}
