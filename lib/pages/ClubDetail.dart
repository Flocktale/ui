import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart' as RTC;
import 'package:flocktale/Models/enums/audienceStatus.dart';
import 'package:flocktale/Models/enums/clubStatus.dart';
import 'package:flocktale/Widgets/commentBox.dart';
import 'package:flocktale/Widgets/detailClubCard.dart';
import 'package:flocktale/customImage.dart';
import 'package:flutter/material.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/Models/comment.dart';
import 'package:flocktale/pages/AudiencePage.dart';
import 'package:flocktale/pages/InviteScreen.dart';
import 'package:flocktale/pages/participantsPanel.dart';
import 'package:flocktale/providers/agoraController.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/providers/webSocket.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:provider/provider.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ProfilePage.dart';
import 'ClubJoinRequests.dart';
import 'package:intl/intl.dart';
import 'BlockedUsersPage.dart';

class ClubDetailPage extends StatefulWidget {
  final BuiltClub club;
  const ClubDetailPage({this.club});
  @override
  _ClubDetailPageState createState() => _ClubDetailPageState();
}

class _ClubDetailPageState extends State<ClubDetailPage> {
  String _myUserId;
  DatabaseApiService _service;
  String _authToken;

  BuiltClubAndAudience _clubAudience;
  bool _isOwner;

  ScrollController _listController = ScrollController();
  bool _isPlaying;

  bool newMessage = false;

  Map<int, String> integerUsernames = {};
  Map<String, int> currentlySpeakingUsers;

  bool _isMuted;

  bool once = false;
  BuiltList<BuiltClub> Clubs;
  List<AudienceData> participantList = [];

  // List<AudienceData> audienceList = [];
  // int likes = -1;

  // reaction counts
  int _dislikeCount;
  int _likeCount;
  int _heartCount;

  List<Comment> comments = [];

  int convertToInt(String username) {
    int hash = 0;
    const int p = 53;
    const int m = 1000000009;
    int pPow = 1;
    username.runes.forEach((c) {
      hash = (hash + (c - 94 + 1) * pPow) % m;
      pPow = (pPow * p) % m;
    });
    return hash;
  }

  void getActiveSpeakers(List<RTC.AudioVolumeInfo> speakers, _) {
    var speakingUsers = new Map<String, int>();
    speakers.forEach((e) {
      //speakingUsers.putIfAbsent(integerUsernames[e.uid], () => e.volume);
      speakingUsers[integerUsernames[e.uid]] = e.volume;
      print("-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_");
      print(integerUsernames[e.uid]);
      print(speakingUsers[integerUsernames[e.uid]]);
    });

    setState(() {
      currentlySpeakingUsers = speakingUsers;
    });
    // print('All Speaking users with their volume  $speakingUsers');
    // TODO
    // Bhaiya, Is list of speakingUsers me aapko jo bhi bol raha hai unke baare me sab mil jaaega.
  }

  void _getMostActiveSpeaker(int uid) {
    // String username = integerUsernames[uid];

    // print('$username is the dominating speaker');
  }

  void scrollToBottom() {
    _listController.jumpTo(_listController.position.maxScrollExtent);
  }

  void _setParticipantList(event) {
    if (event['clubId'] != widget.club.clubId) return;

    participantList = [];
    event['participantList'].forEach((e) {
      AudienceData participant = AudienceData(
        (r) => r
          ..isMuted = e['isMuted']
          ..audience = SummaryUser((b) => b
            ..userId = e['audience']['userId']
            ..username = e['audience']['username']
            ..avatar = e['audience']['avatar']).toBuilder(),
      );
      participantList.add(participant);
      // convertT
      // print(convertToInt(participant.audience.username));
      integerUsernames.putIfAbsent(0, () => participant.audience.username);
      integerUsernames.putIfAbsent(convertToInt(participant.audience.username),
          () => participant.audience.username);
    });

    print('list of it: $participantList');

    setState(() {});
  }

  void _setAudienceCount(event) {
    if (event['clubId'] != widget.club.clubId) return;

    if (event['count'] != null)
      _clubAudience = _clubAudience
          .rebuild((b) => b..club.estimatedAudience = event['count']);

    setState(() {});
  }

  void _setReactionCounters(event) {
    if (event['clubId'] != widget.club.clubId) return;

    int count = (event['count']);
    int ind = (event['indexValue']);
    if (ind == 0) {
      _dislikeCount = count;
    } else if (ind == 1) {
      _likeCount = count;
    } else if (ind == 2) {
      _heartCount = count;
    }

    setState(() {});
  }

  void _youAreBlocked(event) {
    if (event['clubId'] != widget.club.clubId) return;

    // block if the current Club is blocked
    if (event['clubId'] == widget.club.clubId) {
      Provider.of<MySocket>(context, listen: false)
          .leaveClub(widget.club.clubId);
      Provider.of<AgoraController>(context, listen: false).stop();
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Sorry, You are blocked from this club");
    }
  }

  void _youAreMuted(event) {
    if (event['clubId'] != _clubAudience.club.clubId) return;
    final bool isMuted = event['isMuted'];

    Provider.of<AgoraController>(context, listen: false)
        .hardMuteAction(isMuted);

    this._isMuted = isMuted;

    Fluttertoast.showToast(msg: " You are ${isMuted ? 'mute' : 'unmute'}d");
    setState(() {});
  }

  void _muteActionResponse(event) {
    if (event['clubId'] != _clubAudience.club.clubId) return;

    final participantIdList = ((event['participantIdList'] ?? []) as List)
        .map((e) => e as String)
        .toList();

    final myUserId = Provider.of<UserData>(context, listen: false).userId;

    final bool isMuted = event['isMuted'];

    for (var id in participantIdList) {
      // if i am affected user
      if (id == myUserId) {
        _isMuted = isMuted;

        Provider.of<AgoraController>(context, listen: false)
            .hardMuteAction(isMuted);

        Fluttertoast.showToast(msg: " You are ${isMuted ? 'mute' : 'unmute'}d");
      }

      // changing mute status of this participant inside participantList.
      for (int i = 0; i < participantList.length; i++) {
        if (participantList[i].audience.userId == id) {
          participantList[i] =
              participantList[i].rebuild((b) => b..isMuted = isMuted);
          break;
        }
      }
    }

    setState(() {});
  }

  void _clubStartedByOwner(event) {
    if (event['clubId'] != _clubAudience.club.clubId) return;
    Fluttertoast.showToast(msg: "This Club is live now");

    setState(() {
      _clubAudience = _clubAudience.rebuild(
        (b) => b
          ..club.agoraToken = event['agoraToken']
          ..club.status = ClubStatus.Live,
      );
    });

    //TODO
    // enable play button
  }

  void _clubConcludedByOwner(event) async {
    if (event['clubId'] != _clubAudience.club.clubId) return;

    _clubAudience = _clubAudience.rebuild((b) => b
      ..club.agoraToken = null
      ..club.status = (ClubStatus.Concluded));

    await Provider.of<AgoraController>(context, listen: false).stop();

    Fluttertoast.showToast(msg: "This Club is concluded now");

//sending websocket message to indicate about club stopped event
    Provider.of<MySocket>(context, listen: false).stopClub(widget.club.clubId);

    setState(() {
      _isPlaying = false;
    });
  }

  void _putNewComment(event) {
    print(event);
    Comment cur = new Comment();
    SummaryUser u = SummaryUser((r) => r
      ..avatar = event['user']['avatar']
      ..userId = event['user']['userId']
      ..username = event['user']['username']);
    cur.user = u;
    cur.timestamp = event['timestamp'];
    cur.body = event['body'];
    comments.add(cur);

    print(
        '${_listController.position.maxScrollExtent}::::${_listController.offset}');
    print(
        '${_listController.position.maxScrollExtent - 60 < _listController.offset}');

    if (_listController.position.maxScrollExtent - 60 <=
        _listController.offset) {
      Future.delayed(
          const Duration(seconds: 1),
          () =>
              _listController.jumpTo(_listController.position.maxScrollExtent));
      newMessage = false;
    } else {
      newMessage = true;
    }
    setState(() {});
  }

  void _addOldComments(event) {
    int length = (event['oldComments'] as List).length;

    for (int i = length - 1; i >= 0; i--) {
      _putNewComment(event['oldComments'][i]);
    }
    setState(() {});

    Future.delayed(const Duration(seconds: 1),
        () => _listController.jumpTo(_listController.position.maxScrollExtent));
  }

  void addComment(String message) {
    Provider.of<MySocket>(context, listen: false).addComment(
        message,
        widget.club.clubId,
        Provider.of<UserData>(context, listen: false).user.userId);
  }

  void _resetReactionValueInClubAudience(int value) {
    _clubAudience = _clubAudience.rebuild((b) => b
      ..reactionIndexValue =
          _clubAudience.reactionIndexValue == value ? null : value);
    setState(() {});
  }

  void _toggleClubHeart() async {
    if (_clubAudience.reactionIndexValue == 2)
      _heartCount -= 1;
    else {
      if (_clubAudience.reactionIndexValue == 1) _likeCount -= 1;
      if (_clubAudience.reactionIndexValue == 0) _dislikeCount -= 1;

      _heartCount += 1;
    }

    _service.postReaction(
      clubId: widget.club.clubId,
      audienceId: _myUserId,
      indexValue: 2,
      authorization: null,
    );
    _resetReactionValueInClubAudience(2);
  }

  void toggleClubLike() async {
    if (_clubAudience.reactionIndexValue == 1)
      _likeCount -= 1;
    else {
      if (_clubAudience.reactionIndexValue == 2) _heartCount -= 1;
      if (_clubAudience.reactionIndexValue == 0) _dislikeCount -= 1;

      _likeCount += 1;
    }

    _service.postReaction(
      clubId: widget.club.clubId,
      audienceId: _myUserId,
      indexValue: 1,
      authorization: null,
    );
    _resetReactionValueInClubAudience(1);
  }

  void _toggleClubDislike() async {
    if (_clubAudience.reactionIndexValue == 0)
      _dislikeCount -= 1;
    else {
      if (_clubAudience.reactionIndexValue == 2) _heartCount -= 1;
      if (_clubAudience.reactionIndexValue == 1) _likeCount -= 1;

      _dislikeCount += 1;
    }

    _service.postReaction(
      clubId: widget.club.clubId,
      audienceId: _myUserId,
      indexValue: 0,
      authorization: null,
    );
    _resetReactionValueInClubAudience(0);
  }

  _fetchAllOwnerClubs() async {
    Clubs = (await _service.getMyOrganizedClubs(
      userId: widget.club.creator.userId,
      lastevaluatedkey: null,
      authorization: _authToken,
    ))
        .body
        .clubs;
  }

  void _toggleMuteOfParticpant(String userId) async {
    // if user is unmuting himself. (_isMuted is true then till now)
    if (_isMuted && userId == _myUserId) {
      var status = await Permission.microphone.status;
      if (!status.isGranted) {
        status = await Permission.microphone.request();
        if (!status.isGranted) {
          Fluttertoast.showToast(
              msg: 'Please give microphone permissions from the settings');
          return;
        }
      }
    }

    bool toMute = true;

    for (var participant in participantList) {
      print(participant);
      if (participant.audience.userId == userId) {
        toMute = !participant.isMuted;
        break;
      }
    }

    await _service.muteActionOnParticipant(
      clubId: widget.club.clubId,
      who: 'participant',
      participantId: userId,
      muteAction: toMute ? 'mute' : 'unmute',
      authorization: _authToken,
    );

    if (userId == _myUserId) {
      Provider.of<AgoraController>(context, listen: false)
          .hardMuteAction(toMute);
      _isMuted = toMute;
    }

    Fluttertoast.showToast(msg: toMute ? 'muted' : 'unmuted');

    setState(() {});
  }

  void _kickParticpant(String userId) async {
    await Provider.of<DatabaseApiService>(context, listen: false)
        .kickOutParticipant(
      clubId: widget.club.clubId,
      audienceId: userId,
      authorization: _authToken,
    );
    Fluttertoast.showToast(msg: 'Removed panelist');
  }

  void _blockUser(String userId) async {
    await _service.blockAudience(
      clubId: widget.club.clubId,
      audienceId: userId,
      authorization: _authToken,
    );
    Fluttertoast.showToast(msg: 'Blocked user');
  }

  _sendJoinRequest() async {
    final resp = await _service.sendJoinRequest(
      clubId: widget.club.clubId,
      userId: _myUserId,
      authorization: _authToken,
    );
    if (resp.isSuccessful) {
      _clubAudience = _clubAudience.rebuild(
          (b) => b..audienceData.status = AudienceStatus.ActiveJoinRequest);

      Fluttertoast.showToast(msg: "Join Request Sent");
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: 'Some error occurred');
    }
  }

  _deleteJoinRequest() async {
    final resp = await _service.deleteJoinRequet(
      clubId: widget.club.clubId,
      userId: _myUserId,
      authorization: _authToken,
    );
    if (resp.isSuccessful) {
      _clubAudience =
          _clubAudience.rebuild((b) => b..audienceData.status = null);
      Fluttertoast.showToast(msg: "Join Request Cancelled");
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: 'Some Error occurred');
    }
  }

// TODO:
  void reportClub() {}

  Future<void> _joinClubAsPanelist() async {
    String username =
        Provider.of<UserData>(context, listen: false).user.username;

    Provider.of<AgoraController>(context, listen: false).club =
        _clubAudience.club;

    await Provider.of<AgoraController>(context, listen: false)
        .joinAsParticipant(
      clubId: _clubAudience.club.clubId,
      token: _clubAudience.club.agoraToken,
      integerUsername: convertToInt(username),
      audioVolumeIndication: getActiveSpeakers,
    );
  }

  Future<void> _joinClubAsAudience() async {
    if (_clubAudience != null) {
      Provider.of<AgoraController>(context, listen: false).club =
          _clubAudience.club;

      await Provider.of<AgoraController>(context, listen: false).joinAsAudience(
        clubId: _clubAudience.club.clubId,
        token: _clubAudience.club.agoraToken,
        audioVolumeIndication: getActiveSpeakers,
      );
    } else {
      Fluttertoast.showToast(msg: "Club is null error");
    }
  }

  void _enterClub() async {
    this._isOwner = Provider.of<UserData>(context, listen: false).userId ==
        widget.club.creator.userId;

//if current club in agora controller is this very club, then this club is being currently played;
    this._isPlaying =
        Provider.of<AgoraController>(context, listen: false).club?.clubId ==
            widget.club.clubId;

    Provider.of<AgoraController>(context, listen: false)
        .agoraEventHandler
        .audioVolumeIndication = getActiveSpeakers;

    final resp = await _service.getClubByClubId(
      clubId: widget.club.clubId,
      userId: _myUserId,
      authorization: _authToken,
    );

    if (resp.isSuccessful == false) {
      // 403 means user is blocked
      if (resp.statusCode == 403) {
        Fluttertoast.showToast(msg: 'You are not allowed in this club');
      }
      Navigator.of(context).pop();
      return;
    }

    _clubAudience = resp.body;

    // setting current mic status of user.
    this._isMuted = _clubAudience.audienceData.isMuted;

    // now we can join club in websocket also.
    _joinClubInWebsocket();

    Provider.of<AgoraController>(context, listen: false)
        .create(isMuted: this._isMuted);

    if (this._isPlaying == false && this._isOwner == false) {
      // if club is not playing already then play it automatically for non-owner.
      await _playButtonHandler();
    }

    setState(() {});
  }

  void _newJRArrived(event) {
    if (event['clubId'] != widget.club.clubId) return;

    final username = event['username'];
    if (username != null)
      Fluttertoast.showToast(msg: '$username wish to become Panelist');
  }

  void _yourJRAccepted(event) {
    if (event['clubId'] != widget.club.clubId) return;

    Fluttertoast.showToast(msg: 'You are now a Panelist');
    _clubAudience = _clubAudience
        .rebuild((b) => b..audienceData.status = AudienceStatus.Participant);

    _joinClubAsPanelist();

    setState(() {});
  }

  void _yourJRcancelledByOwner(event) {
    if (event['clubId'] != widget.club.clubId) return;

    Fluttertoast.showToast(msg: 'You request to speak has been cancelled.');
    _clubAudience = _clubAudience.rebuild((b) => b..audienceData.status = null);

    setState(() {});
  }

  void _youAreKickedOut(event) {
    if (event['clubId'] != widget.club.clubId) return;
    Fluttertoast.showToast(msg: 'You are now a listener only');
    _clubAudience = _clubAudience.rebuild((b) => b..audienceData.status = null);

    _joinClubAsAudience();
    setState(() {});
  }

  void _youAreInvited(event) {
    if (event['clubId'] != widget.club.clubId) return;

    _clubAudience = _clubAudience
        .rebuild((b) => b..audienceData.invitationId = event['invitationId']);

    Fluttertoast.showToast(msg: event['message'] ?? '');

    setState(() {});
  }

  void _joinClubInWebsocket() {
    Provider.of<MySocket>(context, listen: false).joinClub(
      widget.club.clubId,
      putNewComment: _putNewComment,
      addOldComments: _addOldComments,
      setReactionCounters: _setReactionCounters,
      setParticipantList: _setParticipantList,
      setAudienceCount: _setAudienceCount,
      clubStarted: _clubStartedByOwner,
      youAreMuted: _youAreMuted,
      muteActionResponse: _muteActionResponse,
      youAreBlocked: _youAreBlocked,
      newJRArrived: _newJRArrived,
      yourJRAccepted: _yourJRAccepted,
      yourJRcancelledByOwner: _yourJRcancelledByOwner,
      youAreKickedOut: _youAreKickedOut,
      clubConcludedByOwner: _clubConcludedByOwner,
      youAreInvited: _youAreInvited,
    );
  }

  Future<void> _startClub() async {
    final data = await _service.startClub(
      clubId: widget.club.clubId,
      userId: _myUserId,
      authorization: _authToken,
    );
    print(data.body['agoraToken']);
    _clubAudience = _clubAudience.rebuild(
      (b) => b
        ..club.agoraToken = data.body['agoraToken']
        ..club.status = (ClubStatus.Live),
    );

    setState(() {});
  }

  Future<void> _concludeClub() async {
    await _service.concludeClub(
      clubId: widget.club.clubId,
      creatorId: _myUserId,
      authorization: _authToken,
    );
    _clubAudience = _clubAudience.rebuild(
      (b) => b
        ..club.agoraToken = null
        ..club.status = (ClubStatus.Concluded),
    );

    await Provider.of<AgoraController>(context, listen: false).stop();

    Fluttertoast.showToast(msg: 'This club is concluded now.');

//sending websocket message to indicate about club stopped event
    Provider.of<MySocket>(context, listen: false).stopClub(widget.club.clubId);

    setState(() {
      _isPlaying = false;
    });
  }

  _navigateTo(Widget page) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
    setState(() {});
  }

  void _handleMenuButtons(String value) {
    switch (value) {
      case 'Show Join Requests':
        _navigateTo(ClubJoinRequests(club: widget.club));
        break;

      case 'Show Audience':
        _navigateTo(AudiencePage(club: widget.club));
        break;

      case 'Invite Panelist':
        _navigateTo(InviteScreen(
          club: widget.club,
          forPanelist: true,
        ));
        break;
      case 'Invite Audience':
        _navigateTo(InviteScreen(
          club: widget.club,
          forPanelist: false,
        ));
        break;

      case 'Show Blocked Users':
        _navigateTo(BlockedUsersPage(club: widget.club));
        break;
    }
  }

  _playButtonHandler() async {
    if (_clubAudience.club.status != (ClubStatus.Live) && _isOwner == false) {
      // non-owner is trying to play the club which is not yet started by owner.
      Fluttertoast.showToast(msg: "The Club has not started yet");
      return;
    }

    if (_isPlaying) {
      if (_isOwner) {
        _showMaterialDialog();
      } else {
        //sending websocket message to indicate about club stopped event
        Provider.of<MySocket>(context, listen: false)
            .stopClub(widget.club.clubId);

        // stop club
        await Provider.of<AgoraController>(context, listen: false).stop();
        _isPlaying = false;
      }
    } else {
      //start club
      if (_clubAudience.club.status != (ClubStatus.Live) && _isOwner == true) {
        // club is being started by owner for first time.
        await _startClub();
      }

      if (_clubAudience.audienceData.status == AudienceStatus.Participant) {
        await _joinClubAsPanelist();
      } else {
        await _joinClubAsAudience();
      }

      //sending websocket message to indicate about club being played event
      Provider.of<MySocket>(context, listen: false)
          .playClub(widget.club.clubId);
      _isPlaying = true;
    }

    setState(() {});
  }

  Future<void> _leavePanel() async {
    final resp = (await _service.kickOutParticipant(
      clubId: widget.club.clubId,
      audienceId: _myUserId,
      isSelf: 'true',
      authorization: _authToken,
    ));
    if (resp.isSuccessful)
      Fluttertoast.showToast(msg: 'You are now an audience');
    else
      Fluttertoast.showToast(msg: 'Some Error occurred');
    setState(() {});
  }

  void _participationButtonHandler() async {
    if (_clubAudience.audienceData.status == AudienceStatus.Participant) {
      // participant want to become only listener by themselves.
      await _leavePanel();
    } else {
      // user is interacting with join request button
      if (_clubAudience.audienceData.status !=
          AudienceStatus.ActiveJoinRequest) {
        if (participantList.length < 10) {
          await _sendJoinRequest();
        } else
          Fluttertoast.showToast(
              msg: 'All Panelist slots are filled. Max 9 allowed.');
      } else {
        await _deleteJoinRequest();
      }
    }

    setState(() {});
  }

  String _processScheduledTimestamp(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String formattedDate2 =
        DateFormat.MMMd().add_Hm().format(dateTime) + " Hrs";
    return formattedDate2;
  }

  String _processTimestamp(int timestamp, int type) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final diff = DateTime.now().difference(dateTime);

    final secDiff = diff.inSeconds;
    final minDiff = diff.inMinutes;
    final hourDiff = diff.inHours;
    final daysDiff = diff.inDays;

    String str = '';
    String suff = type == 0 ? " to go" : " ago";
    if (secDiff < 60) {
      str = '$secDiff ' + (secDiff == 1 ? 'second' : 'seconds') + suff;
    } else if (minDiff < 60) {
      str = '$minDiff ' + (minDiff == 1 ? 'minute' : 'minutes') + suff;
    } else if (hourDiff < 24) {
      str = '$hourDiff ' + (hourDiff == 1 ? 'hour' : 'hours') + suff;
    } else if (daysDiff < 7) {
      str = '$daysDiff ' + (daysDiff == 1 ? 'day' : 'days') + suff;
    } else {
      final weekDiff = daysDiff / 7;
      str = '$weekDiff ' + (weekDiff == 1 ? 'week' : 'weeks') + suff;
    }

    return str;
  }

  AlertDialog get _clubConcludeAlert => AlertDialog(
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
              await _concludeClub();

              Navigator.of(context).pop();
            },
          ),
        ],
      );

  void _infiniteRefresh() async {
    while (true) {
      bool terminate = false;
      await Future.delayed(
        const Duration(seconds: 30),
        () => {if (this.mounted == true) setState(() {}) else terminate = true},
      );
      if (terminate) break;
    }
  }

  _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return _clubConcludeAlert;
        });
  }

  respondToInvitation(String response) async {
    await _service.responseToNotification(
      userId: _myUserId,
      notificationId: _clubAudience.audienceData.invitationId,
      authorization: _authToken,
      action: response,
    );
    setState(() {
      _clubAudience =
          _clubAudience.rebuild((b) => b..audienceData.invitationId = null);
    });
  }

  Widget _showMenuButtons() {
    return PopupMenuButton<String>(
      onSelected: _handleMenuButtons,
      itemBuilder: (BuildContext context) {
        return _isOwner
            ? {
                'Show Join Requests',
                'Show Audience',
                'Invite Panelist',
                'Invite Audience',
                'Show Blocked Users'
              }.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList()
            : {'Show Audience', 'Invite Audience'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
      },
    );
  }

  Widget _displayInvitation() {
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
                  onPressed: () => respondToInvitation('cancel'),
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
                onPressed: () async {
                  await _playButtonHandler();
                  if (_isPlaying) {
                    if (participantList.length < 10) {
                      await respondToInvitation('accept');
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Panelist slots are full. Max 9 allowed.');
                    }
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Please let the host start the club.');
                  }
                },
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

  Widget get _displayMicButton {
    final cuser = Provider.of<UserData>(context, listen: false).user;

    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: FloatingActionButton(
          heroTag: "mic btn",
          onPressed: () => _toggleMuteOfParticpant(
              Provider.of<UserData>(context, listen: false).userId),
          child: !_isMuted
              ? currentlySpeakingUsers != null &&
                      currentlySpeakingUsers[cuser.username] != null &&
                      currentlySpeakingUsers[cuser.username] > 0
                  ? Icon(
                      Icons.mic_rounded,
                      color: Colors.redAccent,
                    )
                  : Icon(
                      Icons.mic_none_rounded,
                      color: Colors.black,
                    )
              : Icon(
                  Icons.mic_off_rounded,
                  color: Colors.black,
                ),
          backgroundColor: Colors.white),
    );
  }

  Widget get _displayParticipationButton {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: FloatingActionButton(
        heroTag: "participation btn",
        onPressed: () => _participationButtonHandler(),
        child: _clubAudience.audienceData.status == AudienceStatus.Participant
            ? Icon(
                Icons.remove_from_queue,
                color: Colors.redAccent,
              )
            : _clubAudience.audienceData.status !=
                    AudienceStatus.ActiveJoinRequest
                ? Icon(Icons.person_add)
                : Icon(
                    Icons.person_add_disabled,
                    color: Colors.black,
                  ),
        backgroundColor:
            _clubAudience.audienceData.status == AudienceStatus.Participant
                ? Colors.white
                : _clubAudience.audienceData.status !=
                        AudienceStatus.ActiveJoinRequest
                    ? participantList.length < 10
                        ? Colors.redAccent
                        : Colors.grey
                    : Colors.white,
      ),
    );
  }

  Widget get _displayPlayButton {
    return Container(
      child: FloatingActionButton(
        heroTag: "play btn",
        onPressed: () {
          DateTime.now().compareTo(DateTime.fromMillisecondsSinceEpoch(
                      widget.club.scheduleTime)) >=
                  0
              ? _playButtonHandler()
              : Fluttertoast.showToast(
                  msg:
                      'The club can be started only when the scheduled time has been reached.');
        },
        child: !_isPlaying ? Icon(Icons.play_arrow) : Icon(Icons.stop),
        backgroundColor: _clubAudience.club.status == (ClubStatus.Live)
            ? !_isPlaying
                ? Colors.redAccent
                : Colors.redAccent
            : Colors.grey,
      ),
    );
  }

  @override
  void initState() {
    this._myUserId = Provider.of<UserData>(context, listen: false).userId;
    this._service = Provider.of<DatabaseApiService>(context, listen: false);
    this._authToken = Provider.of<UserData>(context, listen: false).authToken;

    _enterClub();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (!once) {
      once = true;
      _infiniteRefresh();
    }

    final _detailClubCard = DetailClubCard(
      clubAudience: _clubAudience,
      size: size,
      heartCount: _heartCount,
      toggleClubHeart: _toggleClubHeart,
      dislikeCount: _dislikeCount,
      toggleClubDislike: _toggleClubDislike,
      processScheduledTimestamp: _processScheduledTimestamp,
    );

    return WillPopScope(
      onWillPop: () async {
        Provider.of<MySocket>(context, listen: false)
            .leaveClub(widget.club.clubId);
        Provider.of<AgoraController>(context, listen: false)
            .agoraEventHandler
            .audioVolumeIndication = null;
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
//          title: Text(
//            "Now Playing",
//            style: TextStyle(
//                fontFamily: 'Lato',
//                fontWeight: FontWeight.bold,
//                color: Colors.black),
//          ),
          actions: <Widget>[
            _showMenuButtons(),
          ],
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: _clubAudience != null
              ? Stack(
                  children: [
                    Container(
                        //  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          if (_clubAudience.audienceData.invitationId != null)
                            _displayInvitation(),

                          _detailClubCard,

                          Container(
                            margin: EdgeInsets.fromLTRB(
                                15, size.height / 50, 15, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                FittedBox(
                                  child: InkWell(
                                    onTap: () => _navigateTo(
                                      ProfilePage(
                                        userId:
                                            _clubAudience.club.creator.userId,
                                      ),
                                    ),
                                    child: Row(children: <Widget>[
                                      CircleAvatar(
                                        radius: size.width / 17,
                                        backgroundColor:
                                            currentlySpeakingUsers != null &&
                                                    currentlySpeakingUsers[
                                                            widget.club.creator
                                                                .username] !=
                                                        null &&
                                                    currentlySpeakingUsers[
                                                            widget.club.creator
                                                                .username] >
                                                        0
                                                ? Colors.redAccent
                                                : Color(0xffFDCF09),
                                        child: CircleAvatar(
                                          radius: size.width / 20,
                                          child: CustomImage(
                                            image: _clubAudience
                                                    .club.creator.avatar +
                                                "_thumb",
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(
                                            size.width / 30, 0, 0, 0),
                                        child: Text(
                                          '@' +
                                              _clubAudience
                                                  .club.creator.username,
                                          style: TextStyle(
                                              fontFamily: 'Lato',
                                              fontWeight: FontWeight.bold,
                                              fontSize: size.width / 25,
                                              color:  currentlySpeakingUsers != null &&
                                                  currentlySpeakingUsers[
                                                  widget.club.creator
                                                      .username] !=
                                                      null &&
                                                  currentlySpeakingUsers[
                                                  widget.club.creator
                                                      .username] >
                                                      0
                                                  ? Colors.redAccent
                                                  : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                                // if club is concluded no need to show play, mic and participation button
                                if (_clubAudience.club.status !=
                                    ClubStatus.Concluded)
                                  FittedBox(
                                    child: Row(
                                      children: [
                                        _displayPlayButton,

                                        // dedicated button for mic
                                        if (_clubAudience.audienceData.status ==
                                                AudienceStatus.Participant &&
                                            _clubAudience.club.status ==
                                                ClubStatus.Live)
                                          _displayMicButton,

                                        // dedicated button for sending join request or stepping down to become only listener
                                        if (_isOwner == false &&
                                            _isPlaying == true)
                                          _displayParticipationButton,
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.height / 50),

                          CommentBox(
                            size: size,
                            comments: comments,
                            listController: _listController,
                            navigateTo: _navigateTo,
                            processTimestamp: _processTimestamp,
                            addComment: addComment,
                          ),

                          SizedBox(height: size.height / 30),

                          // Container(
                          //   margin: EdgeInsets.only(
                          //       left: size.width / 50, right: size.width / 50),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: <Widget>[
                          //       Text(
                          //         'More from @${_clubAudience.club.creator.username}',
                          //         style: TextStyle(
                          //             fontSize: 15.0,
                          //             fontWeight: FontWeight.bold,
                          //             color: Colors.black),
                          //       ),
                          //       Text(
                          //         'View All',
                          //         style: TextStyle(
                          //           fontSize: 15.0,
                          //           fontWeight: FontWeight.bold,
                          //           color: Colors.grey[600],
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),

                          // SizedBox(height: size.height / 50),
                          // FutureBuilder(
                          //     future: _fetchAllOwnerClubs(),
                          //     builder: (context, snapshot) {
                          //       if (snapshot.connectionState ==
                          //           ConnectionState.waiting) {
                          //         return Center(
                          //             child: CircularProgressIndicator());
                          //       }
                          //       return Clubs != null
                          //           ? Carousel(
                          //               Clubs: Clubs.where((club) =>
                          //                       club.clubId !=
                          //                       _clubAudience.club.clubId)
                          //                   .toBuiltList())
                          //           : Container();
                          //     }),
                          SizedBox(height: size.height / 20)
                        ],
                      ),
                    )),
                    if (MediaQuery.of(context).viewInsets.bottom == 0)
                      ParticipantsPanel(
                        currentlySpeakingUsers: currentlySpeakingUsers,
                        club: widget.club,
                        size: size,
                        participantList: participantList
                            .where((element) =>
                                element.audience.userId !=
                                widget.club.creator.userId)
                            .toList(),
                        isOwner: _isOwner,
                        hasSentJoinRequest: _clubAudience.audienceData.status ==
                            AudienceStatus.ActiveJoinRequest,
                        muteParticipant: _toggleMuteOfParticpant,
                        removeParticipant: _kickParticpant,
                        blockParticipant: _blockUser,
                        sendJoinRequest: _sendJoinRequest,
                        deleteJoinRequest: _deleteJoinRequest,
                      ),
                  ],
                )
              : Container(
                  child: Center(child: Text("Loading...")),
                ),
          //        ),
        ),
      ),
    );
  }
}
