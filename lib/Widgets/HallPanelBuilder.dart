import 'package:flocktale/Models/enums/clubStatus.dart';
import 'package:flocktale/Widgets/ClubUserCards.dart';
import 'package:flocktale/Widgets/audienceActionDialog.dart';
import 'package:flocktale/Widgets/profileSummary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/pages/InviteScreen.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:provider/provider.dart';

class HallPanelBuilder extends StatelessWidget {
  final ScrollController scrollController;

  final Size size;
  final bool hasSentJoinRequest;
  final List<AudienceData> participantList;
  final bool isOwner;
  final ValueNotifier<Map<String, int>> currentlySpeakingUsers;

  final GestureDetector Function(AudienceData) participantCardStackGesture;

  final Future<bool> Function(String) inviteAudience;
  final Future<bool> Function(String) blockUser;

  final Function() sendJoinRequest;
  final Function() deleteJoinRequest;
  final BuiltClub club;

  final Map<String, dynamic> audienceMap;
  final Function fetchMoreAudience;

  const HallPanelBuilder(
    this.scrollController, {
    @required this.currentlySpeakingUsers,
    @required this.club,
    @required this.size,
    @required this.participantList,
    @required this.isOwner,
    @required this.hasSentJoinRequest,
    this.participantCardStackGesture,
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
      case 'Invite':
        inviteAudience(userId);
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

  Widget _inviteOrRequestButtonForUser(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            isOwner
                ? Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          InviteScreen(club: club, forPanelist: true),
                    ),
                  )
                : !hasSentJoinRequest
                    ? sendJoinRequest()
                    : deleteJoinRequest();
          },
          child: Container(
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Container(
              height: 68,
              width: 68,
              child: Icon(
                isOwner
                    ? Icons.person_add
                    : !hasSentJoinRequest
                        ? Icons.person_add
                        : Icons.person_add_disabled,
                color: Colors.white,
                size: 32,
              ),
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.87),
                border: Border.all(
                  color: Colors.redAccent,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 4),
        if (isOwner)
          Text(
            isOwner
                ? "Invite Panelists"
                : !hasSentJoinRequest
                    ? "Ask to join"
                    : "Cancel request",
            style: TextStyle(
              fontFamily: "Lato",
              color: Colors.white,
              fontSize: 12,
            ),
          )
        else if (club?.status == ClubStatus.Live && participantList.length < 9)
          Text(
            !hasSentJoinRequest ? "Ask to join" : "Cancel join request",
            style: TextStyle(
              fontFamily: "Lato",
              color: Colors.white,
              fontSize: 12,
            ),
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

    final List<AudienceData> audienceList = audienceMap['list'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            fetchMoreAudience();
          }
          return true;
        },
        child: ListView(
          controller: scrollController,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: GridView.builder(
                clipBehavior: Clip.none,
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

                  final participant = participantList[index];

                  return ValueListenableBuilder(
                      valueListenable: currentlySpeakingUsers,
                      child: participantCardStackGesture(participant),
                      builder: (_, speakers, stackGesture) {
                        return Stack(
                          fit: StackFit.passthrough,
                          children: [
                            ParticipantCard(
                              participant,
                              key: ObjectKey(
                                  participant.audience.userId + '$index'),
                              isHost: participant.audience.userId ==
                                  club.creator.userId,
                              volume: (speakers ?? const {})[
                                      participant.audience.username] ??
                                  0,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 72,
                                width: 72,
                                child: stackGesture,
                              ),
                            ),
                          ],
                        );
                      });
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
                    child: Text(
                      'Waiting for people to join...',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                ],
              )
            else
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: GridView.builder(
                  clipBehavior: Clip.none,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 7 / 8,
                  ),
                  itemCount: (audienceList?.length ?? 0),
                  itemBuilder: (context, index) {
                    final audience = audienceList[0].audience;

                    return AudienceCard(
                      audience,
                      onTap: () => ProfileShortView.display(context, audience),
                      onDoubleTap: isOwner
                          ? () {
                              AudienceActionDialog.display(
                                context,
                                audience,
                                inviteAudience: inviteAudience,
                                blockUser: blockUser,
                              );
                            }
                          : null,
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
