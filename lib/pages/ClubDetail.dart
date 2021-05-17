import 'dart:async';
import 'dart:math';

import 'package:agora_rtc_engine/rtc_engine.dart' as RTC;
import 'package:flocktale/Models/enums/audienceStatus.dart';
import 'package:flocktale/Models/enums/clubStatus.dart';
import 'package:flocktale/Widgets/ClubUserCards.dart';
import 'package:flocktale/Widgets/clubConcludeAlert.dart';
import 'package:flocktale/Widgets/commentBox.dart';
import 'package:flocktale/Widgets/displayInvitationInClub.dart';
import 'package:flocktale/Widgets/customImage.dart';
import 'package:flocktale/Widgets/participantActionDialog.dart';
import 'package:flocktale/Widgets/profileSummary.dart';
import 'package:flutter/material.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/Models/comment.dart';
import 'package:flocktale/pages/InviteScreen.dart';
import 'package:flocktale/Widgets/HallPanelBuilder.dart';
import 'package:flocktale/providers/agoraController.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/providers/webSocket.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
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
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

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

  bool _hasActiveJRs = false;

  BuiltList<BuiltClub> Clubs;
  List<AudienceData> participantList = [];

  final Map<String, dynamic> _audienceMap = {
    'list': <AudienceData>[],
    'lastevaluatedkey': null,
    'isLoading': false,
  };

  final PanelController _panelController = PanelController();

  // reaction counts
  int _dislikeCount;
  int _likeCount;
  int _heartCount;

  List<Comment> comments = [];
  final TextEditingController _newCommentController = TextEditingController();

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
      final username = integerUsernames[e.uid];
      speakingUsers[username] = e.volume;

      print("-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_");
      print(username);
      print(speakingUsers[username]);
    });

// sorted in ascending order of volume
// when iterating over this list from beginning, participantList is sorted every time with participant with greater volume at first position.
    speakingUsers.entries.toList()
      ..sort((a, b) => a.value - b.value)
      ..forEach((element) {
        participantList.sort((a, b) {
          if (b.audience.username == element.key)
            return 1;
          else
            return 0;
        });
      });

    _justRefresh(() {
      currentlySpeakingUsers = speakingUsers;
    });
  }

  void _getMostActiveSpeaker(int uid) {
    // String username = integerUsernames[uid];

    // print('$username is the dominating speaker');
  }

  void _onRemoteAudioStateChanged(
      int uid, _, RTC.AudioRemoteStateReason reason, __) {
    if (integerUsernames[uid] != null) {
      // for remote user: 5 when muted and 6 when unmuted
      if (reason.index == 5 || reason.index == 6) {
        bool isMuted;
        if (reason.index == 5)
          isMuted = true;
        else if (reason.index == 6) isMuted = false;

        for (int i = 0; i < participantList.length; i++) {
          var participant = participantList[i];
          if (participant.audience.username == integerUsernames[uid]) {
            participantList[i] = participantList[i]
                .rebuild((b) => b..isMuted = isMuted ?? false);

            _justRefresh();
            break;
          }
        }
      }
    }
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

// removing audience if he has become participant (since audience list is fetched by long polling for now)
      final audienceList = (_audienceMap['list'] as List<AudienceData>)
          .where((element) =>
              element.audience.userId != participant.audience.userId)
          .toList();

      _audienceMap['list'] = audienceList;

      // convertT
      // print(convertToInt(participant.audience.username));
      integerUsernames.putIfAbsent(convertToInt(participant.audience.username),
          () => participant.audience.username);
    });

    integerUsernames.putIfAbsent(
        0, () => Provider.of<UserData>(context, listen: false).user.username);

    print('list of it: $participantList');

    _justRefresh();
  }

  void _setAudienceCount(event) {
    if (event['clubId'] != widget.club.clubId) return;

    if (event['count'] != null)
      _clubAudience = _clubAudience
          .rebuild((b) => b..club.estimatedAudience = event['count']);

    _justRefresh();
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

    _justRefresh();
  }

  void _youAreBlocked(event) async {
    if (event['clubId'] != widget.club.clubId) return;

    // block if the current Club is blocked
    if (event['clubId'] == widget.club.clubId) {
      await _stopClub();

      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Sorry, You are blocked from this club");
    }
  }

// used when host mutes me
  void _youAreMuted(event) {
    if (event['clubId'] != _clubAudience.club.clubId) return;
    final bool isMuted = event['isMuted'];

    Provider.of<AgoraController>(context, listen: false)
        .hardMuteAction(isMuted);

    this._isMuted = isMuted;

    for (int i = 0; i < participantList.length; i++) {
      var participant = participantList[i];
      if (participant.audience.userId == _myUserId) {
        participantList[i] =
            participantList[i].rebuild((b) => b..isMuted = isMuted);
        break;
      }
    }

    Fluttertoast.showToast(msg: " You are ${isMuted ? 'mute' : 'unmute'}d");
    _justRefresh();
  }

  void _clubStartedByOwner(event) {
    if (event['clubId'] != _clubAudience.club.clubId) return;
    Fluttertoast.showToast(msg: "This Club is live now");

    _justRefresh(() {
      _clubAudience = _clubAudience.rebuild(
        (b) => b
          ..club.agoraToken = event['agoraToken']
          ..club.status = ClubStatus.Live,
      );
    });

    if (_isOwner == false) {
      _playButtonHandler();
    }
  }

  void _clubConcludedByOwner(event) async {
    if (event['clubId'] != _clubAudience.club.clubId) return;

    _clubAudience = _clubAudience.rebuild((b) => b
      ..club.agoraToken = null
      ..club.status = ClubStatus.Concluded);

    await _stopClub();

    Fluttertoast.showToast(msg: "This Club is concluded now");

    _justRefresh(() {
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
    _justRefresh();
  }

  void _addOldComments(event) {
    int length = (event['oldComments'] as List).length;

    for (int i = length - 1; i >= 0; i--) {
      _putNewComment(event['oldComments'][i]);
    }
    _justRefresh();

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
    _justRefresh();
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
    );
    _resetReactionValueInClubAudience(0);
  }

  _fetchAllOwnerClubs() async {
    Clubs = (await _service.getMyOrganizedClubs(
      userId: widget.club.creator.userId,
      lastevaluatedkey: null,
    ))
        .body
        .clubs;
  }

  /// set [overridenMute] to true if host is muting panelist
  Future<bool> _toggleMuteOfParticpant(String userId,
      [bool overridenMute = false]) async {
    // if user is unmuting himself. (_isMuted is true then till now)
    if (_isMuted && userId == _myUserId) {
      var status = await Permission.microphone.status;
      if (!status.isGranted) {
        status = await Permission.microphone.request();
        if (!status.isGranted) {
          Fluttertoast.showToast(
              msg: 'Please give microphone permissions from the settings');
          return false;
        }
      }
    }

    bool toMute = true;

    for (var participant in participantList) {
      if (participant.audience.userId == userId) {
        toMute = !participant.isMuted;
        break;
      }
    }

    String muteAction;
    if (overridenMute) {
      muteAction = 'mute';
    } else {
      muteAction = toMute ? 'mute' : 'unmute';
    }

    await _service.muteActionOnParticipant(
      clubId: widget.club.clubId,
      who: 'participant',
      participantId: userId,
      muteAction: muteAction,
    );

    if (userId == _myUserId) {
      Provider.of<AgoraController>(context, listen: false)
          .hardMuteAction(toMute);
      _isMuted = toMute;
    }

    Fluttertoast.showToast(msg: muteAction == 'mute' ? 'muted' : 'unmuted');

    _justRefresh();

    return true;
  }

  Future<bool> _kickParticpant(String userId) async {
    await Provider.of<DatabaseApiService>(context, listen: false)
        .kickOutParticipant(
      clubId: widget.club.clubId,
      audienceId: userId,
    );
    Fluttertoast.showToast(msg: 'Removed panelist');
    return true;
  }

  Future<bool> _blockUser(String userId) async {
    await _service.blockAudience(
      clubId: widget.club.clubId,
      audienceId: userId,
    );
    Fluttertoast.showToast(msg: 'Blocked user');
    return true;
  }

  _sendJoinRequest() async {
    if (participantList.length >= 10) {
      Fluttertoast.showToast(
          msg: 'All Panelist slots are filled. Max 9 allowed.');
      return;
    }

    final resp = await _service.sendJoinRequest(
      clubId: widget.club.clubId,
      userId: _myUserId,
    );
    if (resp.isSuccessful) {
      _clubAudience = _clubAudience.rebuild(
          (b) => b..audienceData.status = AudienceStatus.ActiveJoinRequest);

      Fluttertoast.showToast(msg: "Join Request Sent");
      _justRefresh();
    } else {
      Fluttertoast.showToast(msg: 'Some error occurred');
    }
  }

  _deleteJoinRequest() async {
    final resp = await _service.deleteJoinRequet(
      clubId: widget.club.clubId,
      userId: _myUserId,
    );
    if (resp.isSuccessful) {
      _clubAudience =
          _clubAudience.rebuild((b) => b..audienceData.status = null);
      Fluttertoast.showToast(msg: "Join Request Cancelled");
      _justRefresh();
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
    );
  }

  Future<void> _joinClubAsAudience() async {
    if (_clubAudience != null) {
      Provider.of<AgoraController>(context, listen: false).club =
          _clubAudience.club;
      String username =
          Provider.of<UserData>(context, listen: false).user.username;

      await Provider.of<AgoraController>(context, listen: false).joinAsAudience(
        clubId: _clubAudience.club.clubId,
        token: _clubAudience.club.agoraToken,
        integerUsername: convertToInt(username),
      );
    } else {
      Fluttertoast.showToast(msg: "Club is null error");
    }
  }

  void _initAgoraCallbacks() {
    final _agoraEventHandler =
        Provider.of<AgoraController>(context, listen: false).agoraEventHandler;

    _agoraEventHandler.audioVolumeIndication = getActiveSpeakers;

    _agoraEventHandler.remoteAudioStateChanged = _onRemoteAudioStateChanged;
  }

  void _disposeAgoraCallbacks() {
    final _agoraEventHandler =
        Provider.of<AgoraController>(context, listen: false).agoraEventHandler;

    _agoraEventHandler.audioVolumeIndication = null;
    _agoraEventHandler.remoteAudioStateChanged = null;
  }

  Future<void> _enterClub() async {
    _initAgoraCallbacks();

    this._isOwner = Provider.of<UserData>(context, listen: false).userId ==
        widget.club.creator.userId;

//if current club in agora controller is this very club, then this club is being currently played;
    this._isPlaying =
        Provider.of<AgoraController>(context, listen: false).club?.clubId ==
            widget.club.clubId;

    final resp = await _service.getClubByClubId(
      clubId: widget.club.clubId,
      userId: _myUserId,
    );

    if (resp.isSuccessful == false) {
      // 403 means user is blocked
      if (resp.statusCode == 403) {
        Fluttertoast.showToast(msg: 'You are not allowed in this club');
      }
      Navigator.of(context).pop();
      return;
    }

    // fetching audience list
    _infiniteAudienceListRefresh(init: true);

    _clubAudience = resp.body;

    // setting current mic status of user.
    this._isMuted = _clubAudience.audienceData.isMuted;

    Provider.of<AgoraController>(context, listen: false)
        .create(isMuted: this._isMuted);

    // now we can join club in websocket also.
    _joinClubInWebsocket();

    if (this._isPlaying == false &&
        (this._isOwner == false ||
            _clubAudience.club.status == ClubStatus.Live)) {
      // if club is not playing already then play it automatically for non-owner.
      await _playButtonHandler();
    }

    _justRefresh();
  }

  void _newJRArrived(event) {
    if (event['clubId'] != widget.club.clubId) return;

    final username = event['username'];
    if (username != null)
      Fluttertoast.showToast(msg: '$username wish to become Panelist');

    _justRefresh(() {
      _hasActiveJRs = true;
    });
  }

  void _yourJRAccepted(event) {
    if (event['clubId'] != widget.club.clubId) return;

    Fluttertoast.showToast(msg: 'You are now a Panelist');
    _clubAudience = _clubAudience
        .rebuild((b) => b..audienceData.status = AudienceStatus.Participant);

    _joinClubAsPanelist();

    _justRefresh();
  }

  void _yourJRcancelledByOwner(event) {
    if (event['clubId'] != widget.club.clubId) return;

    Fluttertoast.showToast(msg: 'You request to speak has been cancelled.');
    _clubAudience = _clubAudience.rebuild((b) => b..audienceData.status = null);

    _justRefresh();
  }

  void _youAreKickedOut(event) {
    if (event['clubId'] != widget.club.clubId) return;
    Fluttertoast.showToast(msg: 'You are now a listener only');
    _clubAudience = _clubAudience.rebuild((b) => b..audienceData.status = null);

    _joinClubAsAudience();
    _justRefresh();
  }

  void _youAreInvited(event) {
    if (event['clubId'] != widget.club.clubId) return;

    _clubAudience = _clubAudience
        .rebuild((b) => b..audienceData.invitationId = event['invitationId']);

    Fluttertoast.showToast(msg: event['message'] ?? '');

    _justRefresh();
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
    );
    print(data.body['agoraToken']);
    _clubAudience = _clubAudience.rebuild(
      (b) => b
        ..club.agoraToken = data.body['agoraToken']
        ..club.status = (ClubStatus.Live),
    );

    _justRefresh();
  }

  Future<void> _concludeClub() async {
    await _service.concludeClub(
      clubId: widget.club.clubId,
      creatorId: _myUserId,
    );
    _clubAudience = _clubAudience.rebuild(
      (b) => b
        ..club.agoraToken = null
        ..club.status = ClubStatus.Concluded,
    );

    await _stopClub();

    Fluttertoast.showToast(msg: 'This club is concluded now.');

    _justRefresh(() {
      _isPlaying = false;
    });
  }

  _navigateTo(Widget page) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
    _justRefresh();
  }

  Future<void> _handleMenuButtons(String value) async {
    switch (value) {
      case 'Join Requests':
        await _navigateTo(ClubJoinRequests(club: widget.club));
        break;

      case 'Invite Panelist':
        await _navigateTo(InviteScreen(
          club: widget.club,
          forPanelist: true,
        ));
        break;

      case 'Invite Audience':
        await _navigateTo(InviteScreen(
          club: widget.club,
          forPanelist: false,
        ));
        break;

      case 'Show Blocked Users':
        await _navigateTo(BlockedUsersPage(club: widget.club));
        break;
    }
  }

  _playButtonHandler() async {
    if (_clubAudience.club.status != (ClubStatus.Live) && _isOwner == false) {
      // non-owner is trying to play the club which is not yet started by owner.
      if (_clubAudience.club.status == ClubStatus.Concluded) {
        Fluttertoast.showToast(msg: "The Club is concluded");
      } else if (_clubAudience.club.status == ClubStatus.Waiting) {
        Fluttertoast.showToast(msg: "The Club has not started yet");
      }
      return;
    }

    if (_isPlaying) {
      if (_isOwner) {
        _showMaterialDialog();
      } else {
        await _stopClub();
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

    _justRefresh();
  }

  Future<void> _leavePanel() async {
    final resp = (await _service.kickOutParticipant(
      clubId: widget.club.clubId,
      audienceId: _myUserId,
      isSelf: 'true',
    ));
    if (resp.isSuccessful)
      Fluttertoast.showToast(msg: 'You are now an audience');
    else
      Fluttertoast.showToast(msg: 'Some Error occurred');
    _justRefresh();
  }

  void _participationButtonHandler() async {
    if (_clubAudience.audienceData.status == AudienceStatus.Participant) {
      // participant want to become only listener by themselves.
      await _leavePanel();
    } else {
      // user is interacting with join request button
      if (_clubAudience.audienceData.status !=
          AudienceStatus.ActiveJoinRequest) {
        await _sendJoinRequest();
      } else {
        await _deleteJoinRequest();
      }
    }

    _justRefresh();
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
      final weekDiff = (daysDiff / 7).floor();
      str = '$weekDiff ' + (weekDiff == 1 ? 'week' : 'weeks') + suff;
    }

    return str;
  }

  void _infiniteRefresh() async {
    while (true) {
      bool terminate = false;
      await Future.delayed(
        const Duration(seconds: 30),
        () => {if (this.mounted == true) _justRefresh() else terminate = true},
      );
      if (terminate) break;
    }
  }

  Future<List<AudienceData>> _fetchAudienceList(String lastevaluatedkey) async {
    final resp = await _service.getAudienceList(
      clubId: widget.club.clubId,
      lastevaluatedkey: lastevaluatedkey,
    );

    _audienceMap['lastevaluatedkey'] = resp.body.lastevaluatedkey;

    return resp.body.audience.asList();
  }

  void _infiniteAudienceListRefresh({bool init = false}) async {
    if (init) {
      final resp = await _service.getAudienceList(
        clubId: widget.club.clubId,
        lastevaluatedkey: null,
      );

      _audienceMap['list'] = resp.body.audience.asList();
      _justRefresh();
    }

    while (true) {
      bool terminate = false;
      int delay;
      if (_audienceMap['list'].length <= 20)
        delay = Random().nextInt(10) + 10;
      else if (_audienceMap['list'].length <= 30)
        delay = Random().nextInt(15) + 15;
      else if (_audienceMap['list'].length <= 50)
        delay = Random().nextInt(25) + 25;
      else if (_audienceMap['list'].length <= 100)
        delay = Random().nextInt(35) + 35;
      else
        delay = Random().nextInt(60) + 60;

      await Future.delayed(
        Duration(seconds: delay),
        () async {
          if (this.mounted == true &&
              _clubAudience?.club?.status == ClubStatus.Live) {
            if (this.mounted)
              _audienceMap['list'] = await _fetchAudienceList(null);

            if (this.mounted)
              _justRefresh();
            else
              terminate = true;
          } else
            terminate = true;
        },
      );
      if (terminate) break;
    }

    _audienceMap['list'] = <AudienceData>[];
    _audienceMap['lastevaluatedkey'] = null;
    if (this.mounted) _justRefresh();
  }

  _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return clubConcludeAlert(context, _concludeClub);
        });
  }

  respondToInvitation(String response) async {
    await _service.responseToNotification(
      userId: _myUserId,
      notificationId: _clubAudience.audienceData.invitationId,
      action: response,
    );

    _justRefresh(() {
      _clubAudience =
          _clubAudience.rebuild((b) => b..audienceData.invitationId = null);
    });
  }

  Widget _showMenuButtons() {
    return PopupMenuButton<String>(
      color: Colors.white,
      icon: Icon(
        Icons.adaptive.more,
        color: Colors.white,
        size: 32,
      ),
      onSelected: _handleMenuButtons,
      itemBuilder: (BuildContext context) {
        return _isOwner
            ? {'Invite Panelist', 'Invite Audience', 'Show Blocked Users'}
                .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList()
            : {'Invite Audience'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
      },
    );
  }

  Widget _displayInvitation() {
    return displayInvitationInClub(
      context,
      onReject: () async => await respondToInvitation('cancel'),
      onAccept: () async {
        if (_isPlaying) {
          if (participantList.length < 10) {
            await respondToInvitation('accept');
            _justRefresh(() {
              _clubAudience = _clubAudience.rebuild(
                  (b) => b..audienceData.status = AudienceStatus.Participant);
              _joinClubAsPanelist();
            });
          } else {
            Fluttertoast.showToast(
                msg: 'Panelist slots are full. Max 9 allowed.');
          }
        } else {
          if (_clubAudience.club.status == ClubStatus.Waiting) {
            Fluttertoast.showToast(msg: 'Please let the host start the club.');
          } else if (_clubAudience.club.status == ClubStatus.Live) {
            Fluttertoast.showToast(msg: 'Please play the club first.');
          } else {
            await respondToInvitation('cancel');
            Fluttertoast.showToast(msg: 'Can not accept, deleting request!');
          }
        }
      },
    );
  }

  Widget get _displayMicButton {
    final cuser = Provider.of<UserData>(context, listen: false).user;
    return InkWell(
      onTap: () => _toggleMuteOfParticpant(
          Provider.of<UserData>(context, listen: false).userId),
      child: Card(
        elevation: 4,
        shadowColor: Colors.redAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: CircleAvatar(
          radius: 24,
          backgroundColor: _isMuted ? Colors.black87 : Colors.white,
          child: !_isMuted
              ? Icon(
                  Icons.mic_none_sharp,
                  color: currentlySpeakingUsers != null &&
                          currentlySpeakingUsers[cuser.username] != null &&
                          currentlySpeakingUsers[cuser.username] > 0
                      ? Colors.redAccent
                      : Colors.black,
                  size: 28,
                )
              : Icon(
                  Icons.mic_off_outlined,
                  color: Colors.white,
                  size: 28,
                ),
        ),
      ),
    );
  }

  Widget get _displayParticipationButton {
    return InkWell(
      onTap: () => _participationButtonHandler(),
      child: Card(
        elevation: 4,
        shadowColor: Colors.redAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: CircleAvatar(
          radius: 24,
          backgroundColor:
              _clubAudience.audienceData.status == AudienceStatus.Participant
                  ? Colors.white
                  : Colors.black87,
          child: _clubAudience.audienceData.status == AudienceStatus.Participant
              ? Icon(
                  Icons.remove_from_queue,
                  color: Colors.black,
                  size: 24,
                )
              : _clubAudience.audienceData.status !=
                      AudienceStatus.ActiveJoinRequest
                  ? Icon(
                      Icons.person_add,
                      color: Colors.white,
                      size: 24,
                    )
                  : Icon(
                      Icons.person_add_disabled,
                      color: Colors.black,
                      size: 24,
                    ),
        ),
      ),
    );
  }

  Widget get _displayPlayButton {
    return InkWell(
      onTap: () {
        DateTime.now().compareTo(DateTime.fromMillisecondsSinceEpoch(
                    widget.club.scheduleTime)) >=
                0
            ? _playButtonHandler()
            : Fluttertoast.showToast(
                msg:
                    'The club can be started only when the scheduled time has been reached.');
      },
      child: Card(
        elevation: 4,
        shadowColor: Colors.redAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: CircleAvatar(
          radius: 24,
          backgroundColor: _clubAudience.club.status == (ClubStatus.Live)
              ? Colors.redAccent
              : Colors.black87,
          child: Icon(
            !_isPlaying ? Icons.play_arrow : Icons.stop,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }

  Future<void> _stopClub() async {
    // stop msg to websocket
    Provider.of<MySocket>(context, listen: false).stopClub(widget.club.clubId);

    // stopping from agora
    await Provider.of<AgoraController>(context, listen: false).stop();

    if (_isOwner == false) {
      //resetting user priveleges, if not owner
      _clubAudience = _clubAudience.rebuild(
        (b) => b
          ..audienceData.status = null
          ..audienceData.invitationId = null,
      );
    }

    this._isPlaying = false;

    _justRefresh();
  }

  void _justRefresh([Function refresh]) {
    if (this.mounted) {
      if (refresh != null) {
        refresh();
      }
      setState(() {});
    }
  }

  Widget clubDataDisplayWidget() {
    return Container(
      color: Colors.black87,
      child: Builder(
        builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    image: NetworkImage(widget.club.clubAvatar),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.62),
                        Colors.black.withOpacity(0.62),
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.7),
                        Colors.black87,
                        Colors.black87,
                        Colors.black87,
                        Colors.black87,
                      ],
                      stops: [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1],
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white70,
                                  ),
                                ),
                                if (_isOwner == false)
                                  InkWell(
                                    onTap: () => ProfileShortView.display(
                                        context, widget.club.creator),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.person_pin,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          '${widget.club.creator.username}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (_isOwner == true &&
                                        _clubAudience.club.status ==
                                            ClubStatus.Live)
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 16),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.black87,
                                          border: Border.all(
                                              color: _hasActiveJRs
                                                  ? Colors.redAccent
                                                  : Colors.black,
                                              width: _hasActiveJRs ? 0.5 : 0),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: _hasActiveJRs ? 1 : 0,
                                              spreadRadius:
                                                  _hasActiveJRs ? 0.5 : 0,
                                              color: Colors.redAccent,
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: InkWell(
                                          onTap: () async {
                                            await _handleMenuButtons(
                                                'Join Requests');
                                            _justRefresh(() {
                                              _hasActiveJRs = false;
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                'Join Requests',
                                                style: TextStyle(
                                                  color: _hasActiveJRs
                                                      ? Colors.white
                                                      : Colors.grey,
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              if (_hasActiveJRs)
                                                Icon(
                                                  Icons.circle,
                                                  color: Colors.redAccent,
                                                  size: 10,
                                                )
                                            ],
                                          ),
                                        ),
                                      ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black87,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 1,
                                            spreadRadius: 0.5,
                                            color: Colors.redAccent,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Icon(
                                          Icons.share,
                                          color: Colors.redAccent,
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                    _showMenuButtons(),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            InkWell(
                              onTap: () => displayFullClubData(context),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.club.clubName,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.multitrack_audio_sharp,
                                        color: Colors.white70,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${_clubAudience.club.description ?? ""}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        // if (_clubAudience.club.status != ClubStatus.Live)
                        //   Expanded(
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       crossAxisAlignment: CrossAxisAlignment.center,
                        //       children: [
                        //         Container(
                        //           padding: const EdgeInsets.symmetric(
                        //             horizontal: 24,
                        //             vertical: 16,
                        //           ),
                        //           decoration: BoxDecoration(
                        //             color: Colors.black54,
                        //             borderRadius: BorderRadius.circular(8),
                        //           ),
                        //           child: Row(
                        //             children: [
                        //               if (_clubAudience.club.status !=
                        //                   ClubStatus.Concluded)
                        //                 Icon(
                        //                   Icons.timer,
                        //                   color: Colors.white,
                        //                   size: 32,
                        //                 ),
                        //               SizedBox(width: 8),
                        //               Text(
                        //                 _clubAudience.club.status ==
                        //                         ClubStatus.Concluded
                        //                     ? "Concluded"
                        //                     : DateTime.now().compareTo(DateTime
                        //                                 .fromMillisecondsSinceEpoch(
                        //                                     _clubAudience.club
                        //                                         .scheduleTime)) <
                        //                             0
                        //                         ? "Scheduled: ${_processScheduledTimestamp(_clubAudience.club.scheduleTime)}"
                        //                         : "Waiting for start",
                        //                 style: TextStyle(
                        //                   fontFamily: 'Lato',
                        //                   color: Colors.white,
                        //                   fontSize: 16,
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   )
                        // else
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(),
                                Container(
                                  height: 100,
                                  child: Center(
                                    child: ListView.builder(
                                      clipBehavior: Clip.none,
                                      shrinkWrap: true,
                                      addSemanticIndexes: false,
                                      itemCount: participantList.length * 5,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (ctx, index) {
                                        //! if this is club owner
                                        //! different decoration for club owner

                                        final participant = participantList[0];
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 4.0),
                                          child: ParticipantCard(
                                            participant,
                                            key: ObjectKey(
                                                participant.audience.userId +
                                                    '2$index'),
                                            isHost:
                                                participant.audience.userId ==
                                                    widget.club.creator.userId,
                                            onTap: () =>
                                                ProfileShortView.display(
                                                    context,
                                                    participant.audience),
                                            onLongPress: () {
                                              // for non-owner participant, dialog box to show mute button

                                              // if (_isOwner && participant.audience
                                              //         .userId !=
                                              //     widget.club.creator
                                              //         .userId) {
                                              ParticipantActionDialog.display(
                                                context,
                                                participant,
                                                muteParticipant:
                                                    _toggleMuteOfParticpant,
                                                removeParticipant:
                                                    _kickParticpant,
                                                blockUser: _blockUser,
                                              );
                                              // }
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LikeButton(
                    onTap: (val) async {
                      _toggleClubHeart();
                      return Future.value(!val);
                    },
                    countPostion: CountPostion.bottom,
                    size: 32,
                    isLiked: _clubAudience.reactionIndexValue == 2,
                    likeCount: _heartCount,
                    countBuilder: (count, _, __) {
                      return Text(
                        '${count ?? ""}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      );
                    },
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        _clubAudience.reactionIndexValue == 2
                            ? Icons.favorite
                            : Icons.favorite_border_rounded,
                        color: isLiked ? Colors.redAccent : Colors.white,
                        size: 32,
                      );
                    },
                  ),
                  LikeButton(
                    onTap: (_) async {
                      Future.delayed(Duration(milliseconds: 1200), () {
                        setState(() {});
                      });

                      //TODO: uncomment this

                      // if (_clubAudience.club.status != ClubStatus.Live)
                      //   return Future.value(true);

                      if (FocusManager.instance.primaryFocus.hasFocus) {
                        FocusManager.instance.primaryFocus.unfocus();

                        // time delay to let unfocus action complete
                        Future.delayed(Duration(milliseconds: 200), () {
                          _displayHallPanel(context);
                        });
                      } else
                        _displayHallPanel(context);

                      return Future.value(true);
                    },
                    countDecoration: (_, count) {
                      String txt =
                          _clubAudience.club.estimatedAudience?.toString() ??
                              "";
                      if (txt.isNotEmpty) {
                        txt += ' listeners';
                      }
                      return Column(
                        children: [
                          Text(
                            txt,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                          if (_clubAudience.club.status == ClubStatus.Live)
                            Text(
                              '(click)',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                        ],
                      );
                    },
                    isLiked: false,
                    likeCount: _clubAudience.club.estimatedAudience,
                    countPostion: CountPostion.bottom,
                    size: 32,
                    likeBuilder: (_) {
                      return Icon(
                        Icons.headset,
                        color: Colors.green,
                        size: 32,
                      );
                    },
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: _displayPlayButton,
                      ),

                      // dedicated button for mic
                      if (_clubAudience.audienceData.status ==
                              AudienceStatus.Participant &&
                          _clubAudience.club.status == ClubStatus.Live)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: _displayMicButton,
                        ),

                      // dedicated button for sending join request or stepping down to become only listener
                      if (_isOwner == false && _isPlaying == true)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: _displayParticipationButton,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void displayFullClubData(BuildContext context) {
    FocusManager.instance.primaryFocus.unfocus();
    if (_clubAudience == null) return;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.8,
        minChildSize: 0.4,
        builder: (_, controller) => Container(
          color: Colors.black87,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: ListView(
            controller: controller,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 6,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 192,
                child: CustomImage(
                  image: widget.club.clubAvatar,
                  pinwheelPlaceholder: true,
                  radius: 0,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 12),
              Text(
                widget.club.clubName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.multitrack_audio_sharp,
                    color: Colors.white70,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${_clubAudience.club.description ?? ""}',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
                child: Card(
                  elevation: 2,
                  shadowColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.share,
                          size: 24,
                          color: Colors.redAccent,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Share with your friends',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  void _displayHallPanel(BuildContext context) {
    FocusManager.instance.primaryFocus.unfocus();
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (_, controller) => Container(
          child: HallPanelBuilder(
            controller,
            currentlySpeakingUsers: currentlySpeakingUsers,
            club: _clubAudience?.club ?? widget.club,
            size: MediaQuery.of(context).size,
            participantList: participantList,
            isOwner: _isOwner,
            hasSentJoinRequest: _clubAudience.audienceData.status ==
                AudienceStatus.ActiveJoinRequest,
            muteParticipant: _toggleMuteOfParticpant,
            removeParticipant: _kickParticpant,
            blockUser: _blockUser,
            sendJoinRequest: _sendJoinRequest,
            deleteJoinRequest: _deleteJoinRequest,
            audienceMap: _audienceMap,
            inviteAudience: (userId) async {
              final response = await _service.inviteUsers(
                clubId: widget.club.clubId,
                sponsorId: _myUserId,
                invite: BuiltInviteFormat(
                  (b) => b
                    ..invitee = BuiltList<String>([userId]).toBuilder()
                    ..type = 'participant',
                ),
              );
              if (response.isSuccessful) {
                Fluttertoast.showToast(msg: 'Invitation sent successfully');
              } else {
                Fluttertoast.showToast(msg: 'Error in sending invitaion');
              }
            },
            fetchMoreAudience: () async {
              if (_audienceMap['isLoading'] == true) return;

              _justRefresh(() {
                _audienceMap['isLoading'] = true;
              });

              if (_audienceMap['lastlastevaluatedkey'] != null) {
                (_audienceMap['list'] as List).addAll(
                    await _fetchAudienceList(_audienceMap['lastevaluatedkey']));
              } else {
                await Future.delayed(Duration(milliseconds: 200));
              }
              _justRefresh(() {
                _audienceMap['isLoading'] = false;
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    this._myUserId = Provider.of<UserData>(context, listen: false).userId;
    this._service = Provider.of<DatabaseApiService>(context, listen: false);

    _enterClub();
    _infiniteRefresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        Provider.of<MySocket>(context, listen: false)
            .leaveClub(widget.club.clubId);
        Provider.of<AgoraController>(context, listen: false)
            .agoraEventHandler
            .audioVolumeIndication = null;

        _disposeAgoraCallbacks();
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: _clubAudience != null
              ? Stack(
                  children: [
                    Container(
                      height: size.height,
                      child: Column(
                        children: <Widget>[
                          if (_clubAudience.audienceData.invitationId != null)
                            _displayInvitation(),
                          Expanded(
                            child: clubDataDisplayWidget(),
                          ),
                          Container(
                            height: size.height / 1.9 -
                                MediaQuery.of(context).viewInsets.bottom,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            color: Colors.black,
                            child: CommentBox(
                              size: size,
                              comments: comments,
                              listController: _listController,
                              navigateTo: _navigateTo,
                              processTimestamp: _processTimestamp,
                              addComment: addComment,
                              newCommentController: _newCommentController,
                            ),
                          ),
                        ],
                      ),
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
