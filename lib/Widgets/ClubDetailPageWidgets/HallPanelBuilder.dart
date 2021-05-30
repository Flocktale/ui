import 'package:flocktale/Models/enums/clubStatus.dart';
import 'package:flocktale/Widgets/ClubDetailPageWidgets/ClubUserCards.dart';
import 'package:flocktale/Widgets/ClubDetailPageWidgets/audienceActionDialog.dart';
import 'package:flocktale/Widgets/ProfileShortView.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/pages/ClubDetailPages/InviteScreen.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class HallPanelBuilder extends StatefulWidget {
  final ScrollController scrollController;

  final Size size;
  final bool hasSentJoinRequest;
  final List<AudienceData> participantList;
  final bool isOwner;
  final ValueNotifier<Map<String, int>> currentlySpeakingUsers;

  final GestureDetector Function(AudienceData) participantCardStackGesture;

  final Future<bool> Function(String) inviteToSpeak;
  final Future<bool> Function(String) blockUser;

  final Function() sendJoinRequest;
  final Function() deleteJoinRequest;
  final BuiltClub club;

  const HallPanelBuilder(
    this.scrollController, {
    @required this.currentlySpeakingUsers,
    @required this.club,
    @required this.size,
    @required this.participantList,
    @required this.isOwner,
    @required this.hasSentJoinRequest,
    this.participantCardStackGesture,
    @required this.inviteToSpeak,
    @required this.blockUser,
    @required this.sendJoinRequest,
    @required this.deleteJoinRequest,
  });

  @override
  _HallPanelBuilderState createState() => _HallPanelBuilderState();
}

class _HallPanelBuilderState extends State<HallPanelBuilder> {
  List<AudienceData> _audienceList = [];
  String _lastevaluatedkey;
  bool _isLoading = true;

  DatabaseApiService _service;

  void _fetchMoreAudience() async {
    if (_isLoading == true) return;
    setState(() {
      _isLoading = true;
    });

    if (_lastevaluatedkey != null) {
      _audienceList.addAll(await _fetchAudienceList(_lastevaluatedkey));
    } else {
      await Future.delayed(Duration(milliseconds: 200));
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<List<AudienceData>> _fetchAudienceList(String lastevaluatedkey) async {
    final resp = await _service.getAudienceList(
      clubId: widget.club.clubId,
      lastevaluatedkey: lastevaluatedkey,
    );

    _lastevaluatedkey = resp.body.lastevaluatedkey;

    setState(() {
      _isLoading = false;
    });
    return resp.body.audience.asList();
  }

  bool _isParticipant(String userId) {
    if (userId == widget.club.creator.userId)
      return false;
    else {
      for (int i = 0; i < widget.participantList.length; i++) {
        if (widget.participantList[i].audience.userId == userId) return true;
      }
    }
    return false;
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

  Widget _inviteOrRequestButtonForUser(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            widget.isOwner
                ? Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          InviteScreen(club: widget.club, forPanelist: true),
                    ),
                  )
                : !widget.hasSentJoinRequest
                    ? widget.sendJoinRequest()
                    : widget.deleteJoinRequest();
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
                widget.isOwner || !widget.hasSentJoinRequest
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
        if (widget.isOwner)
          Text(
            "Invite Panelists",
            style: TextStyle(
              fontFamily: "Lato",
              color: Colors.white,
              fontSize: 12,
            ),
          )
        else if (widget.club?.status == ClubStatus.Live &&
            widget.participantList.length < 9)
          Text(
            !widget.hasSentJoinRequest ? "Ask to join" : "Cancel join request",
            style: TextStyle(
              fontFamily: "Lato",
              color: Colors.white,
              fontSize: 12,
            ),
          )
      ],
    );
  }

  Widget participantGridBuilder(context) {
    final myUserId = Provider.of<UserData>(context, listen: false).userId;

    return GridView.builder(
      clipBehavior: Clip.none,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: (widget.participantList.length < 10
          ? widget.participantList.length + 1
          : widget.participantList.length),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 7 / 8,
      ),
      itemBuilder: (context, index) {
        if (index == widget.participantList.length) {
          return !_isParticipant(myUserId) || widget.isOwner
              ? _inviteOrRequestButtonForUser(context)
              : Container();
        }

        final participant = widget.participantList[index];

        return ValueListenableBuilder(
            valueListenable: widget.currentlySpeakingUsers,
            child: widget.participantCardStackGesture(participant),
            builder: (_, speakers, stackGesture) {
              return Stack(
                fit: StackFit.passthrough,
                children: [
                  ParticipantCard(
                    participant,
                    key: ObjectKey(participant.audience.userId + '$index'),
                    isHost: participant.audience.userId ==
                        widget.club.creator.userId,
                    volume:
                        (speakers ?? const {})[participant.audience.username] ??
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
    );
  }

  @override
  void initState() {
    this._service = Provider.of<DatabaseApiService>(context, listen: false);
    _fetchAudienceList(null).then((list) => _audienceList = list);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _fetchMoreAudience();
          }
          return true;
        },
        child: ListView(
          controller: widget.scrollController,
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
            SizedBox(height: 20),
            participantGridBuilder(context),
            Center(
              child: Text("Audience",
                  style: TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                      fontSize: size.width / 20,
                      color: Colors.redAccent)),
            ),
            if ((_audienceList?.length ?? 0) == 0)
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
                  itemCount: _audienceList?.length ?? 0,
                  itemBuilder: (context, index) {
                    final audience = _audienceList[index].audience;

                    return AudienceCard(
                      audience,
                      onTap: () => ProfileShortView.display(context, audience),
                      onDoubleTap: widget.isOwner
                          ? () {
                              AudienceActionDialog.display(context, audience,
                                  inviteToSpeak: widget.inviteToSpeak,
                                  blockUser: (String userId) async {
                                final res = await widget.blockUser(userId);
                                if (res == true) {
                                  _audienceList.removeWhere((element) =>
                                      element.audience.userId == userId);
                                }
                                return res;
                              });
                            }
                          : null,
                    );
                  },
                ),
              ),
            Container(
              height: 100,
              color: Colors.transparent,
            ),
            if (_isLoading == true)
              Container(
                height: 100,
                child: Center(
                    child: SpinKitChasingDots(
                  color: Colors.redAccent,
                )),
              ),
          ],
        ),
      ),
    );
  }
}
