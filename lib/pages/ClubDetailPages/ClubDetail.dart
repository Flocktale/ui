import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart' as RTC;
import 'package:flocktale/Models/enums/audienceStatus.dart';
import 'package:flocktale/Models/enums/clubStatus.dart';
import 'package:flocktale/Widgets/ClubDetailPageWidgets/ClubFulllDataSheet.dart';
import 'package:flocktale/Widgets/ClubDetailPageWidgets/ClubUserCards.dart';
import 'package:flocktale/Widgets/ClubDetailPageWidgets/clubConcludeAlert.dart';
import 'package:flocktale/Widgets/ClubDetailPageWidgets/commentBox.dart';
import 'package:flocktale/Widgets/displayInvitationInClub.dart';
import 'package:flocktale/Widgets/ClubDetailPageWidgets/participantActionDialog.dart';
import 'package:flocktale/Widgets/ProfileShortView.dart';
import 'package:flocktale/Widgets/rightSideSheet.dart';
import 'package:flocktale/services/shareApp.dart';
import 'package:flutter/material.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/Models/comment.dart';
import 'package:flocktale/pages/ClubDetailPages/InviteScreen.dart';
import 'package:flocktale/Widgets/ClubDetailPageWidgets/HallPanelBuilder.dart';
import 'package:flocktale/providers/agoraController.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/providers/webSocket.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ClubJoinRequests.dart';
import 'package:intl/intl.dart';
import 'BlockedUsersPage.dart';

class ClubDetailPage extends StatefulWidget {
  final String clubId;
  const ClubDetailPage(this.clubId)
      : assert(clubId != null, 'ClubId must not be null');
  @override
  _ClubDetailPageState createState() => _ClubDetailPageState();
}

class _ClubDetailPageState extends State<ClubDetailPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  String _myUserId;
  DatabaseApiService _service;

  BuiltClubAndAudience _clubAudience;
  AgoraToken agoraToken;

  bool _isOwner;

  ScrollController _listController = ScrollController();
  bool _isPlaying;

  bool newMessage = false;

  bool emptySpeakerList = false;
  ValueNotifier<Map<String, int>> currentlySpeakingUsers = ValueNotifier({});

  bool _isMuted;

  bool _hasActiveJRs = false;

  List<AudienceData> participantList = [];

  // reaction counts
  int _heartCount;

  List<Comment> comments = [];
  final TextEditingController _newCommentController = TextEditingController();

  void getActiveSpeakers(List<RTC.AudioVolumeInfo> speakers, _) {
    if (speakers.isEmpty && emptySpeakerList == false) {
      emptySpeakerList = true;
      return;
    } else
      emptySpeakerList = false;

    final integerUsernames =
        Provider.of<AgoraController>(context, listen: false).integerUsernames;

    var speakingUsers = new Map<String, int>();
    speakers.forEach((e) {
      final username = integerUsernames[e.uid];
      speakingUsers[username] = e.volume;
    });

// sorted in ascending order of volume
// when iterating over this list from beginning, participantList is sorted every time with participant with greater volume at first position.
    speakingUsers.entries.toList()
      ..sort((a, b) => a.value - b.value)
      ..forEach((element) {
        if (element.value < 50) return;
        participantList.sort((a, b) {
          if (b.audience.username == element.key)
            return 1;
          else
            return 0;
        });
      });

    // print(speakingUsers);

    currentlySpeakingUsers.value = speakingUsers;
  }

  void _onRemoteAudioStateChanged(
      int uid, _, RTC.AudioRemoteStateReason reason, __) {
    // for remote user: 5 when muted and 6 when unmuted
    if (reason.index != 5 && reason.index != 6) return;

    bool isMuted;
    if (reason.index == 5)
      isMuted = true;
    else if (reason.index == 6) isMuted = false;

    final remoteAudioMuteStatesWithUid =
        Provider.of<AgoraController>(context, listen: false)
            .remoteAudioMuteStatesWithUid;
    final integerUsernames =
        Provider.of<AgoraController>(context, listen: false).integerUsernames;

    remoteAudioMuteStatesWithUid[uid] = isMuted;

    if (integerUsernames[uid] != null) {
      for (int i = 0; i < participantList.length; i++) {
        var participant = participantList[i];
        if (participant.audience.username == integerUsernames[uid]) {
          participantList[i] =
              participantList[i].rebuild((b) => b..isMuted = isMuted ?? false);
          _justRefresh();
          break;
        }
      }
    }
  }

  void scrollToBottom() {
    _listController.jumpTo(_listController.position.maxScrollExtent);
  }

  void _setParticipantList(event) {
    if (event['clubId'] != widget.clubId) return;

    final integerUsernames =
        Provider.of<AgoraController>(context, listen: false).integerUsernames;

    final remoteAudioMuteStatesWithUid =
        Provider.of<AgoraController>(context, listen: false)
            .remoteAudioMuteStatesWithUid;

    final prtUser = (Map user) {
      final username = user['username'];

      final integerUsername =
          Provider.of<AgoraController>(context, listen: false)
              .convertToInt(username);

      integerUsernames.putIfAbsent(integerUsername, () => username);

      final participant = AudienceData(
        (r) => r
          ..isMuted = remoteAudioMuteStatesWithUid[integerUsername] ?? false
          ..audience = SummaryUser((b) => b
            ..userId = user['userId']
            ..username = user['username']
            ..avatar = user['avatar']).toBuilder(),
      );

      return participant;
    };

    final subAction = event['subAction'];

    if (subAction == 'All') {
      participantList = [];
      event['participantList'].forEach((e) {
        AudienceData participant = prtUser(e);

        participantList.add(participant);
        // convert
      });
    } else if (subAction == 'Add') {
      final userId = event['user']['userId'];

      AudienceData participant = prtUser(event['user']);
      final searchedResult = participantList.firstWhere(
          (element) => element.audience.userId == userId,
          orElse: () => null);
      if (searchedResult == null) {
        participantList.add(participant);
      }
    } else if (subAction == 'Remove') {
      final userId = event['user']['userId'];
      participantList
          .removeWhere((element) => element.audience.userId == userId);
    }

    integerUsernames.putIfAbsent(
        0, () => Provider.of<UserData>(context, listen: false).user.username);

    print('list of it: $participantList');

    _justRefresh();
  }

  void _setAudienceCount(event) {
    if (event['clubId'] != widget.clubId) return;

    if (event['count'] != null)
      _clubAudience = _clubAudience
          .rebuild((b) => b..club.estimatedAudience = event['count']);

    _justRefresh();
  }

  void _setReactionCounters(event) {
    if (event['clubId'] != widget.clubId) return;

    int count = (event['count']);
    int ind = (event['indexValue']);

    if (ind == 2) {
      _heartCount = count;
    }

    _justRefresh();
  }

  void _youAreBlocked(event) async {
    if (event['clubId'] != widget.clubId) return;

    // block if the current Club is blocked
    if (event['clubId'] == widget.clubId) {
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

  void _clubStartedByOwner(event) async {
    if (event['clubId'] != _clubAudience.club.clubId) return;
    Fluttertoast.showToast(msg: "This Club is live now");

    _clubAudience = _clubAudience.rebuild(
      (b) => b..club.status = ClubStatus.Live,
    );

    await _getAgoraToken();

    if (_isOwner == false) {
      _playButtonHandler();
    }

    _justRefresh();
  }

  void _clubConcludedByOwner(event) async {
    if (event['clubId'] != _clubAudience.club.clubId) return;

    _clubAudience =
        _clubAudience.rebuild((b) => b..club.status = ClubStatus.Concluded);

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
        widget.clubId,
        Provider.of<UserData>(context, listen: false).user.userId);
  }

  void _toggleClubHeart() async {
    if (_clubAudience.reactionIndexValue == 2)
      _heartCount -= 1;
    else {
      _heartCount += 1;
    }

    _service.postReaction(
      clubId: widget.clubId,
      audienceId: _myUserId,
      indexValue: 2,
    );
    _clubAudience = _clubAudience.rebuild((b) => b
      ..reactionIndexValue = _clubAudience.reactionIndexValue == 2 ? null : 2);

    _justRefresh();
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
      clubId: widget.clubId,
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
      clubId: widget.clubId,
      audienceId: userId,
    );

    participantList.removeWhere((element) => element.audience.userId == userId);
    _justRefresh();

    Fluttertoast.showToast(msg: 'Removed panelist');
    return true;
  }

  Future<bool> _blockUser(String userId) async {
    await _service.blockAudience(
      clubId: widget.clubId,
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
      clubId: widget.clubId,
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
      clubId: widget.clubId,
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
      agoraToken: this.agoraToken,
      username: username,
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
        agoraToken: agoraToken,
        username: username,
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

  Future<void> _fetchClub() async {
    final resp = await _service.getClubByClubId(
      clubId: widget.clubId,
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
    _clubAudience = resp.body;
  }

  Future<void> _enterClub() async {
    await _fetchClub();

    _initAgoraCallbacks();

    this._isOwner = Provider.of<UserData>(context, listen: false).userId ==
        _clubAudience.club.creator.userId;

//if current club in agora controller is this very club, then this club is being currently played;
    this._isPlaying =
        Provider.of<AgoraController>(context, listen: false).club?.clubId ==
            widget.clubId;

    if (_clubAudience.audienceData.audience.userId ==
            _clubAudience.club.creator.userId &&
        _clubAudience.audienceData.status != AudienceStatus.Participant) {
      _clubAudience = _clubAudience
          .rebuild((b) => b..audienceData.status = AudienceStatus.Participant);
    }

    // setting current mic status of user.
    this._isMuted = _clubAudience.audienceData.isMuted;

    Provider.of<AgoraController>(context, listen: false)
        .create(isMuted: this._isMuted);

    // now we can join club in websocket also.
    _joinClubInWebsocket();

    if (this._isPlaying == false &&
        _clubAudience.club.status == ClubStatus.Live) {
      // if club is Live and not playing already then play it automatically.
      await _playButtonHandler();
    }

    _justRefresh();
  }

  void _newJRArrived(event) {
    if (event['clubId'] != widget.clubId) return;

    final username = event['username'];
    if (username != null)
      Fluttertoast.showToast(msg: '$username wish to become Panelist');

    _justRefresh(() {
      _hasActiveJRs = true;
    });
  }

  void _yourJRAccepted(event) {
    if (event['clubId'] != widget.clubId) return;

    Fluttertoast.showToast(msg: 'You are now a Panelist');
    _clubAudience = _clubAudience
        .rebuild((b) => b..audienceData.status = AudienceStatus.Participant);

    _joinClubAsPanelist();

    _justRefresh();
  }

  void _yourJRcancelledByOwner(event) {
    if (event['clubId'] != widget.clubId) return;

    Fluttertoast.showToast(msg: 'You request to speak has been cancelled.');
    _clubAudience = _clubAudience.rebuild((b) => b..audienceData.status = null);

    _justRefresh();
  }

  void _youAreKickedOut(event) {
    if (event['clubId'] != widget.clubId) return;
    Fluttertoast.showToast(msg: 'You are now a listener only');
    _clubAudience = _clubAudience.rebuild((b) => b..audienceData.status = null);

    _joinClubAsAudience();
    _justRefresh();
  }

  void _youAreInvited(event) {
    if (event['clubId'] != widget.clubId) return;

    _clubAudience = _clubAudience
        .rebuild((b) => b..audienceData.invitationId = event['invitationId']);

    Fluttertoast.showToast(msg: event['message'] ?? '');

    _justRefresh();
  }

  void _joinClubInWebsocket() {
    Provider.of<MySocket>(context, listen: false).joinClub(
      widget.clubId,
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

  Future<void> _getAgoraToken() async {
    final username =
        Provider.of<UserData>(context, listen: false).user.username;
    final integerUsername = Provider.of<AgoraController>(context, listen: false)
        .convertToInt(username);
    agoraToken = (await _service.getAgoraToken(
      clubId: widget.clubId,
      uid: integerUsername,
    ))
        .body;
  }

  Future<void> _startClub() async {
    final data = await _service.startClub(
      clubId: widget.clubId,
      userId: _myUserId,
    );
    print(data.body['agoraToken']);
    _clubAudience = _clubAudience.rebuild(
      (b) => b..club.status = (ClubStatus.Live),
    );
    await _getAgoraToken();

    _justRefresh();
  }

  Future<void> _concludeClub() async {
    await _service.concludeClub(
      clubId: widget.clubId,
      creatorId: _myUserId,
    );
    _clubAudience = _clubAudience.rebuild(
      (b) => b..club.status = ClubStatus.Concluded,
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
        RightSideSheet.display(context,
            child: ClubJoinRequests(club: _clubAudience.club));
        break;

      case 'Invite Panelist':
        await _navigateTo(InviteScreen(
          club: _clubAudience.club,
          forPanelist: true,
        ));
        break;

      case 'Invite Audience':
        await _navigateTo(InviteScreen(
          club: _clubAudience.club,
          forPanelist: false,
        ));
        break;

      case 'Show Blocked Users':
        await RightSideSheet.display(context,
            child: BlockedUsersPage(club: _clubAudience.club));
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
      } else if (this.agoraToken?.agoraToken == null) {
        // getting agora token
        await _getAgoraToken();
      }

      if (_clubAudience.audienceData.status == AudienceStatus.Participant ||
          _isOwner == true) {
        await _joinClubAsPanelist();
      } else {
        await _joinClubAsAudience();
      }

      //sending websocket message to indicate about club being played event
      Provider.of<MySocket>(context, listen: false).playClub(widget.clubId);
      _isPlaying = true;
    }

    _justRefresh();
  }

  Future<void> _leavePanel() async {
    final resp = (await _service.kickOutParticipant(
      clubId: widget.clubId,
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
    return ValueListenableBuilder(
      valueListenable: currentlySpeakingUsers,
      builder: (_, speakers, __) {
        return InkWell(
          onTap: () => _toggleMuteOfParticpant(
              Provider.of<UserData>(context, listen: false).userId),
          child: Card(
            elevation: 4,
            shadowColor: Colors.redAccent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: _isMuted ? Colors.black87 : Colors.white,
              child: !_isMuted
                  ? Icon(
                      Icons.mic_none_sharp,
                      color: ((speakers ?? const {})[cuser.username] ?? 0) > 30
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
      },
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
              : Icon(
                  _clubAudience.audienceData.status !=
                          AudienceStatus.ActiveJoinRequest
                      ? Icons.person_add
                      : Icons.person_add_disabled,
                  color: Colors.white,
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
                    _clubAudience.club.scheduleTime)) >=
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
    Provider.of<MySocket>(context, listen: false).stopClub(widget.clubId);

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

  /// due to quick updation of widgets (because of our need here), long press can't be used within listenable builder
  /// widget is re-rendered many times amidst a single timespan of long press
  /// above reasoning also satisfies doubleTap (not if double tap is done quicker than updation, which is very cumbersome here)
  /// so using a gesture detector to be stacked over main widget
  /// main widget => keeps updating, stacked gesture => remains constant so works well

  GestureDetector _participantCardStackGesture(AudienceData participant) =>
      GestureDetector(
        onDoubleTap: _isOwner &&
                participant.audience.userId != _clubAudience.club.creator.userId
            ? () {
                // for non-owner participant, dialog box to show mute button
                ParticipantActionDialog.display(
                  context,
                  participant,
                  muteParticipant: _toggleMuteOfParticpant,
                  removeParticipant: _kickParticpant,
                  blockUser: _blockUser,
                );
              }
            : null,
        onTap: () => ProfileShortView.display(context, participant.audience),
      );

  Widget clubDataDisplayWidget() {
    return Container(
      color: Colors.black87,
      child: Builder(
        builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    image: NetworkImage(_clubAudience.club.clubAvatar),
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
                                        context, _clubAudience.club.creator),
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
                                          '${_clubAudience.club.creator.username}',
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
                                    InkWell(
                                      onTap: () => ShareApp(context)
                                          .club(_clubAudience.club.clubName),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black87,
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                    ),
                                    _showMenuButtons(),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            InkWell(
                              onTap: _clubAudience == null
                                  ? null
                                  : () => ClubFullDataSheet.display(
                                      context, _clubAudience.club),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _clubAudience.club.clubName,
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
                        if (_clubAudience.club.status != ClubStatus.Live)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    if (_clubAudience.club.status !=
                                        ClubStatus.Concluded)
                                      Icon(
                                        Icons.timer,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    SizedBox(width: 8),
                                    Text(
                                      _clubAudience.club.status ==
                                              ClubStatus.Concluded
                                          ? "Concluded"
                                          : DateTime.now().compareTo(DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          _clubAudience.club
                                                              .scheduleTime)) <
                                                  0
                                              ? "Scheduled: ${_processScheduledTimestamp(_clubAudience.club.scheduleTime)}"
                                              : "Waiting for start",
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        else if (_clubAudience.audienceData.invitationId ==
                            null)
                          Container(
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
                                      itemCount: participantList.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (ctx, index) {
                                        //! if this is club owner
                                        //! different decoration for club owner

                                        final participant =
                                            participantList[index];
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 4.0),
                                          child: ValueListenableBuilder(
                                              valueListenable:
                                                  currentlySpeakingUsers,
                                              child:
                                                  _participantCardStackGesture(
                                                      participant),
                                              builder: (context, speakers,
                                                  stackGesture) {
                                                return Stack(
                                                  fit: StackFit.passthrough,
                                                  children: [
                                                    ParticipantCard(
                                                      participant,
                                                      key: ObjectKey(participant
                                                              .audience.userId +
                                                          ' 2 $index'),
                                                      isHost: participant
                                                              .audience
                                                              .userId ==
                                                          _clubAudience.club
                                                              .creator.userId,
                                                      volume: (speakers ??
                                                                  const {})[
                                                              participant
                                                                  .audience
                                                                  .username] ??
                                                          0,
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Container(
                                                        height: 72,
                                                        width: 72,
                                                        child: stackGesture,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
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

                      if (_clubAudience.club.status != ClubStatus.Live)
                        return Future.value(true);

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
                      if (_clubAudience.club.status != ClubStatus.Concluded)
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
        initialChildSize: 0.95,
        maxChildSize: 0.95,
        minChildSize: 0.95,
        builder: (_, controller) => Container(
          key: UniqueKey(),
          child: HallPanelBuilder(
            controller,
            currentlySpeakingUsers: currentlySpeakingUsers,
            club: _clubAudience.club,
            size: MediaQuery.of(context).size,
            participantList: participantList,
            isOwner: _isOwner,
            hasSentJoinRequest: _clubAudience.audienceData.status ==
                AudienceStatus.ActiveJoinRequest,
            participantCardStackGesture: _participantCardStackGesture,
            sendJoinRequest: _sendJoinRequest,
            deleteJoinRequest: _deleteJoinRequest,
            inviteToSpeak: (userId) async {
              final response = await _service.inviteUsers(
                clubId: widget.clubId,
                sponsorId: _myUserId,
                invite: BuiltInviteFormat(
                  (b) => b
                    ..invitee = BuiltList<String>([userId]).toBuilder()
                    ..type = 'participant',
                ),
              );
              if (response.isSuccessful) {
                Fluttertoast.showToast(msg: 'Invitation sent successfully');
                return true;
              } else {
                Fluttertoast.showToast(msg: 'Error in sending invitaion');
                return false;
              }
            },
            blockUser: _blockUser,
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
        Provider.of<MySocket>(context, listen: false).leaveClub(widget.clubId);
        Provider.of<AgoraController>(context, listen: false)
            .agoraEventHandler
            .audioVolumeIndication = null;

        _disposeAgoraCallbacks();
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        body: SafeArea(
          child: _clubAudience != null
              ? Container(
                  height: size.height,
                  child: Column(
                    children: <Widget>[
                      if (_clubAudience.audienceData.invitationId != null)
                        _displayInvitation(),
                      clubDataDisplayWidget(),
                      Expanded(
                        child: LayoutBuilder(builder: (context, constraints) {
                          return Container(
                            height: constraints.maxHeight -
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
                          );
                        }),
                      ),
                    ],
                  ),
                )
              : Container(
                  child: Center(
                      child: SpinKitChasingDots(
                    color: Colors.redAccent,
                  )),
                ),
          //        ),
        ),
      ),
    );
  }
}
