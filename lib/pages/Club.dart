import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/Models/comment.dart';
import 'package:mootclub_app/pages/AudiencePage.dart';
import 'package:mootclub_app/pages/InviteScreen.dart';
import 'package:mootclub_app/pages/participantsPanel.dart';
import 'package:mootclub_app/providers/agoraController.dart';
import 'package:mootclub_app/providers/userData.dart';
import 'package:mootclub_app/providers/webSocket.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';
import 'package:provider/provider.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ProfilePage.dart';
import 'ClubJoinRequests.dart';

class Club extends StatefulWidget {
  final BuiltClub club;
  const Club({this.club});
  @override
  _ClubState createState() => _ClubState();
}

class _ClubState extends State<Club> {
  bool _isPlaying;

  bool _sentRequest = false;

  bool _isLive = false;
  bool _isConcluded = false;

  bool _isMuted;

  bool _isParticipant = false;
  bool _showInvitation = false;

  BuiltList<BuiltClub> Clubs;
  List<SummaryUser> participantList = [];
  List<SummaryUser> audienceList = [];
  // int likes = -1;

  // reaction counts
  int _dislikeCount;
  int _likeCount;
  int _heartCount;

  int _audienceCount;

  final _commentController = TextEditingController();
  List<Comment> comments = [];

  BuiltClubAndAudience _clubAudience;

  bool _isOwner;

  void _setParticipantList(event) {
    if (event['clubId'] != widget.club.clubId) return;

    participantList = [];
    event['participantList'].forEach((e) {
      SummaryUser participant = SummaryUser((r) => r
        ..userId = e['userId']
        ..username = e['username']
        ..avatar = e['avatar']);
      participantList.add(participant);
    });

    setState(() {});
  }

  void _setAudienceCount(event) {
    if (event['clubId'] != widget.club.clubId) return;

    _audienceCount = (event['count']);
    print("<<<<<<<<<<<<<<<<");
    print(event);
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
    Provider.of<AgoraController>(context, listen: false).hardMute();

    this._isMuted =
        Provider.of<AgoraController>(context, listen: false).isMicMuted;

    Fluttertoast.showToast(msg: " You are muted");
    setState(() {});
  }

  void _clubStartedByOwner(event) {
    if (event['clubId'] != _clubAudience.club.clubId) return;
    Fluttertoast.showToast(msg: "This Club is live now");

    setState(() {
      _clubAudience = _clubAudience.rebuild((b) => b
        ..club.agoraToken = event['agoraToken']
        ..club.isLive = true);
      _isLive = true;
    });

    //TODO
    // enable play button
  }

  void _clubConcludedByOwner(event) async {
    if (event['clubId'] != _clubAudience.club.clubId) return;

    _clubAudience = _clubAudience.rebuild((b) => b
      ..club.agoraToken = null
      ..club.isLive = false
      ..club.isConcluded = true);

    await Provider.of<AgoraController>(context, listen: false).stop();

    Fluttertoast.showToast(msg: "This Club is concluded now");

    setState(() {
      _isPlaying = false;
      _isLive = false;
      _isConcluded = true;
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
    setState(() {});
  }

  void _addOldComments(event) {
    int length = (event['oldComments'] as List).length;

    for (int i = length - 1; i >= 0; i--) {
      _putNewComment(event['oldComments'][i]);
    }
    setState(() {});
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

  void toggleClubHeart() async {
    if (_clubAudience.reactionIndexValue == 2)
      _heartCount -= 1;
    else {
      if (_clubAudience.reactionIndexValue == 1) _likeCount -= 1;
      if (_clubAudience.reactionIndexValue == 0) _dislikeCount -= 1;

      _heartCount += 1;
    }

    final service = Provider.of<DatabaseApiService>(context, listen: false);
    service.postReaction(
      clubId: widget.club.clubId,
      audienceId: Provider.of<UserData>(context, listen: false).user.userId,
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

    final service = Provider.of<DatabaseApiService>(context, listen: false);
    service.postReaction(
      clubId: widget.club.clubId,
      audienceId: Provider.of<UserData>(context, listen: false).user.userId,
      indexValue: 1,
      authorization: null,
    );
    _resetReactionValueInClubAudience(1);
  }

  void toggleClubDislike() async {
    if (_clubAudience.reactionIndexValue == 0)
      _dislikeCount -= 1;
    else {
      if (_clubAudience.reactionIndexValue == 2) _heartCount -= 1;
      if (_clubAudience.reactionIndexValue == 1) _likeCount -= 1;

      _dislikeCount += 1;
    }

    final service = Provider.of<DatabaseApiService>(context, listen: false);
    service.postReaction(
      clubId: widget.club.clubId,
      audienceId: Provider.of<UserData>(context, listen: false).user.userId,
      indexValue: 0,
      authorization: null,
    );
    _resetReactionValueInClubAudience(0);
  }

  _fetchAllOwnerClubs() async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    Clubs = (await service.getMyOrganizedClubs(
      userId: widget.club.creator.userId,
      lastevaluatedkey: null,
      authorization: authToken,
    ))
        .body
        .clubs;
  }

  void _muteParticpant(String userId) async {
    final authToken = Provider.of<UserData>(context, listen: false).authToken;

    await Provider.of<DatabaseApiService>(context, listen: false)
        .muteParticipant(
      clubId: widget.club.clubId,
      who: 'participant',
      participantId: userId,
      authorization: authToken,
    );
    Fluttertoast.showToast(msg: 'Panelist is muted');
  }

  void _kickParticpant(String userId) async {
    final authToken = Provider.of<UserData>(context, listen: false).authToken;

    await Provider.of<DatabaseApiService>(context, listen: false)
        .kickOutParticipant(
      clubId: widget.club.clubId,
      audienceId: userId,
      authorization: authToken,
    );
    Fluttertoast.showToast(msg: 'Removed panelist');
  }

  void _blockUser(String userId) async {
    final authToken = Provider.of<UserData>(context, listen: false).authToken;

    await Provider.of<DatabaseApiService>(context, listen: false).blockAudience(
      clubId: widget.club.clubId,
      audienceId: userId,
      authorization: authToken,
    );
    Fluttertoast.showToast(msg: 'Blocked user');
  }

  _sendJoinRequest() async {
    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    BuiltUser cuser = Provider.of<UserData>(context, listen: false).user;
    await service.sendJoinRequest(
      clubId: widget.club.clubId,
      userId: cuser.userId,
      authorization: authToken,
    );
    Fluttertoast.showToast(msg: "Join Request Sent");
  }

  _deleteJoinRequest() async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    BuiltUser cuser = Provider.of<UserData>(context, listen: false).user;
    await service.deleteJoinRequet(
      clubId: widget.club.clubId,
      userId: cuser.userId,
      authorization: authToken,
    );
    Fluttertoast.showToast(msg: "Join Request Cancelled");
  }

// TODO:
  void reportClub() {}

  Future<void> _joinClubAsPanelist() async {
    Provider.of<AgoraController>(context, listen: false).club =
        _clubAudience.club;

    await Provider.of<AgoraController>(context, listen: false)
        .joinAsParticipant(
            clubId: _clubAudience.club.clubId,
            token: _clubAudience.club.agoraToken);
  }

  Future<void> _joinClubAsAudience() async {
    if (_clubAudience != null) {
      Provider.of<AgoraController>(context, listen: false).club =
          _clubAudience.club;

      await Provider.of<AgoraController>(context, listen: false).joinAsAudience(
          clubId: _clubAudience.club.clubId,
          token: _clubAudience.club.agoraToken);
    } else {
      Fluttertoast.showToast(msg: "Club is null error");
    }
  }

  void _enterClub() async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final userId = Provider.of<UserData>(context, listen: false).userId;
    final authToken = Provider.of<UserData>(context, listen: false).authToken;

    final resp = await service.getClubByClubId(
      clubId: widget.club.clubId,
      userId: userId,
      authorization: authToken,
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

    // setting live status
    _isLive = _clubAudience.club.isLive;
    _isConcluded = _clubAudience.club.isConcluded ?? false;

    // now we can join club in websocket also.
    _joinClubInWebsocket();

    Provider.of<AgoraController>(context, listen: false).create();

    // if user is participant till the time of fetching this club data.
    this._isParticipant = _clubAudience.audienceData.isParticipant ?? false;
    // later it will be decided by participant list fetched by websocket.

    // if user has sent a join request already till the time of fetching this club.
    this._sentRequest = _clubAudience.audienceData.joinRequested ?? false;

    var invitation = _clubAudience.audienceData.invitationId;
    if (invitation != null) {
      _showInvitation = true;
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
    _clubAudience = _clubAudience.rebuild((b) => b
      ..audienceData.isParticipant = true
      ..audienceData.joinRequested = false);
    _isParticipant = true;
    _sentRequest = false;

    _joinClubAsPanelist();

    setState(() {});
  }

  void _yourJRcancelledByOwner(event) {
    if (event['clubId'] != widget.club.clubId) return;

    Fluttertoast.showToast(msg: 'You request to speak has been cancelled.');
    _clubAudience =
        _clubAudience.rebuild((b) => b..audienceData.joinRequested = false);
    _sentRequest = false;
    setState(() {});
  }

  void _youAreKickedOut(event) {
    if (event['clubId'] != widget.club.clubId) return;
    Fluttertoast.showToast(msg: 'You are now a listener only');
    _clubAudience =
        _clubAudience.rebuild((b) => b..audienceData.isParticipant = false);
    _isParticipant = false;

    _joinClubAsAudience();
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
      youAreBlocked: _youAreBlocked,
      newJRArrived: _newJRArrived,
      yourJRAccepted: _yourJRAccepted,
      yourJRcancelledByOwner: _yourJRcancelledByOwner,
      youAreKickedOut: _youAreKickedOut,
      clubConcludedByOwner: _clubConcludedByOwner,
    );
  }

  Future<void> _startClub() async {
    final userId = Provider.of<UserData>(context, listen: false).userId;
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    final data = await service.startClub(
      clubId: widget.club.clubId,
      userId: userId,
      authorization: authToken,
    );
    print(data.body['agoraToken']);
    _clubAudience = _clubAudience.rebuild(
      (b) => b
        ..club.agoraToken = data.body['agoraToken']
        ..club.isLive = true,
    );

    setState(() {
      _isLive = true;
    });
  }

  Future<void> _concludeClub() async {
    final userId = Provider.of<UserData>(context, listen: false).userId;
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    await service.concludeClub(
      clubId: widget.club.clubId,
      creatorId: userId,
      authorization: authToken,
    );
    _clubAudience = _clubAudience.rebuild((b) => b
      ..club.agoraToken = null
      ..club.isLive = false
      ..club.isConcluded = true);

    await Provider.of<AgoraController>(context, listen: false).stop();

    Fluttertoast.showToast(msg: 'This club is concluded now.');

    setState(() {
      _isPlaying = false;
      _isLive = false;
      _isConcluded = true;
    });
  }

  Future _navigateToInviteScreen({bool forPanelist = false}) async =>
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => InviteScreen(
                club: widget.club,
                forPanelist: forPanelist,
              )));

  Future _navigateToJoinRequests() async =>
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ClubJoinRequests(
                club: widget.club,
              )));

  Future _navigateToAudienceList() async =>
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => AudiencePage(
            club: widget.club,
          )));

  void _handleMenuButtons(String value) {
    switch (value) {
      case 'Show Join Requests':
        _navigateToJoinRequests();
        break;

      case 'Show Audience':
        _navigateToAudienceList();
        break;

      case 'Invite Panelist':
        _navigateToInviteScreen(forPanelist: true);
        break;
      case 'Invite Audience':
        _navigateToInviteScreen(forPanelist: false);
        break;
    }
  }

  void _playButtonHandler() async {
    if (_isLive == false && _isOwner == false) {
      // non-owner is trying to play the club which is not yet started by owner.
      Fluttertoast.showToast(msg: "The Club has not started yet");
      return;
    }

    if (_isPlaying) {
      if (_isOwner) {
        _isLive = false;
        _isConcluded = true;

        await _concludeClub();
      }

      // stop club
      await Provider.of<AgoraController>(context, listen: false).stop();
      _isPlaying = false;
    } else {
      //start club
      if (_isLive == false && _isOwner == true) {
        // club is being started by owner for first time.
        await _startClub();
      }

      if (_isParticipant) {
        await _joinClubAsPanelist();
      } else {
        await _joinClubAsAudience();
      }

      _isPlaying = true;
    }

    setState(() {});
  }

  void _micButtonHandler() async {
     _isMuted = Provider.of<AgoraController>(context, listen: false).isMicMuted;

    if(!_isMuted){
      var status = await Permission.microphone.status;
      if(!status.isGranted){
        status = await Permission.microphone.request();
        if(!status.isGranted){
          Fluttertoast.showToast(msg: 'Please give microphone permissions from the settings')  ;
          return;
        }
      } 
    }

    await Provider.of<AgoraController>(context, listen: false).toggleMicMute();
    _isMuted = Provider.of<AgoraController>(context, listen: false).isMicMuted;

    final msg = _isMuted ? 'Muted' : 'Unmuted';
    Fluttertoast.showToast(msg: msg);

    setState(() {});
  }

  void _participationButtonHandler() async {
    if (_isParticipant) {
      //TODO: complete this functionality
      // participant want to become only listener by themselves.

    } else {
      // user is interacting with join request button
      if (!_sentRequest) {
        await _sendJoinRequest();
      } else {
        await _deleteJoinRequest();
      }
      _sentRequest = !_sentRequest;
    }

    setState(() {});
  }

  String _processTimestamp(int timestamp, int type) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final diff = DateTime.now().difference(dateTime);

    final secDiff = diff.inSeconds;
    final minDiff = diff.inMinutes;
    final hourDiff = diff.inHours;
    final daysDiff = diff.inDays;

    String str = '';
    String suff = type==0?" to go":" ago";

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

  Widget _reactionWidgetRow() {
    final size = MediaQuery.of(context).size;

    final _reactionButton = (
            {Function toggler,
            int count,
            bool isLiked,
            IconData iconData,
            Color iconColor}) =>
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: LikeButton(
            onTap: (val) async {
              toggler();
              return Future.value(!val);
            },
            isLiked: isLiked,
            likeCount: count,
            likeBuilder: (bool isLiked) {
              return Icon(
                iconData,
                color: iconColor,
                size: size.height / 25,
              );
            },
          ),
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // heart reaction
        _reactionButton(
            toggler: toggleClubHeart,
            count: _heartCount,
            isLiked: _clubAudience.reactionIndexValue == 2,
            iconData: _clubAudience.reactionIndexValue == 2
                ? Icons.favorite
                : Icons.favorite_border_rounded,
            iconColor: Colors.redAccent),

        // like reaction
//        _reactionButton(
//            toggler: toggleClubLike,
//            count: _likeCount,
//            isLiked: _clubAudience.reactionIndexValue == 1,
//            iconData: _clubAudience.reactionIndexValue == 1
//                ? Icons.thumb_up
//                : Icons.thumb_up_outlined,
//            iconColor: Colors.amber),

        // dislike reaction
        Container(
          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: _reactionButton(
              toggler: toggleClubDislike,
              count: _dislikeCount,
              isLiked: _clubAudience.reactionIndexValue == 0,
              iconData: _clubAudience.reactionIndexValue == 0
                  ? Icons.thumb_down
                  : Icons.thumb_down_outlined,
              iconColor: Colors.black),
        ),
      ],
    );
  }

  AlertDialog get _invitationAlert => AlertDialog(
        title: Text("You have been invited as a panelist"),
        actions: [
          FlatButton(
            child: Text("Accept"),
            onPressed: () {
              setState(() {
                _showInvitation = true;
              });
            },
          ),
          FlatButton(
            child: Text("Decline"),
            onPressed: () {
              setState(() {
                _showInvitation = true;
              });
            },
          ),
        ],
      );

  @override
  void initState() {
    this._isOwner = Provider.of<UserData>(context, listen: false).userId ==
        widget.club.creator.userId;

//if current club in agora controller is this very club, then this club is being currently played;
    this._isPlaying =
        Provider.of<AgoraController>(context, listen: false).club?.clubId ==
            widget.club.clubId;

// setting current mic status of user.
    this._isMuted =
        Provider.of<AgoraController>(context, listen: false).isMicMuted;

    super.initState();

    _enterClub();

    Provider.of<DatabaseApiService>(context, listen: false)
        .getActiveJoinRequests(
      clubId: widget.club.clubId,
      lastevaluatedkey: null,
      authorization: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        Provider.of<MySocket>(context, listen: false)
            .leaveClub(widget.club.clubId);
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
            PopupMenuButton<String>(
              onSelected: _handleMenuButtons,
              itemBuilder: (BuildContext context) {
                return _isOwner
                    ? {
                        'Show Join Requests',
                        'Show Audience',
                        'Invite Panelist',
                        'Invite Audience'
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
            ),
          ],
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: _clubAudience != null
              ? _showInvitation == false
                  ? Stack(
                      children: [
                        Container(
                            //  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: size.height / 5,
                                    width: size.width / 2.5,
                                    margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            blurRadius:
                                                25.0, // soften the shadow
                                            spreadRadius:
                                                1.0, //extend the shadow
                                            offset: Offset(
                                              0.0,
                                              15.0, // Move to bottom 10 Vertically
                                            ),
                                          )
                                        ],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0))),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      child: Image.network(
                                        _clubAudience.club.clubAvatar,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          width: size.width / 2,
                                          child: Text(
                                            _clubAudience.club.clubName,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontWeight: FontWeight.bold,
                                                fontSize: size.width / 25),
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.width / 2,
                                          child: Text(
                                            "${_clubAudience.club.description ?? 'There is no description provided for this club'}",
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: size.width / 30,
                                                color: Colors.black54),
                                          ),
                                        ),
                                        _isLive
                                            ? Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 5, 0, 0),
                                                padding: EdgeInsets.fromLTRB(
                                                    2, 2, 2, 2),
                                                color: Colors.red,
                                                child: Text(
                                                  "LIVE",
                                                  style: TextStyle(
                                                      fontFamily: 'Lato',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      letterSpacing: 2.0),
                                                ),
                                              )
                                            : Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0, size.height/50, 0, 0),
                                                child: Text(
                                                  _isConcluded
                                                      ? "Concluded"
                                                      : "Scheduled: ${_processTimestamp(widget.club.scheduleTime,0)}",
                                                  style: TextStyle(
                                                      fontFamily: 'Lato',
                                                      color: Colors.black54),
                                                ),
                                              ),
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: _reactionWidgetRow(),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    15, size.height / 50, 15, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    FittedBox(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => ProfilePage(
                                                userId: _clubAudience
                                                    .club.creator.userId,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Row(children: <Widget>[
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                _clubAudience
                                                    .club.creator.avatar),
                                            radius: size.width / 20,
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
                                                  fontSize: size.width / 25),
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                                    // if club is concluded no need to show play, mic and participation button
                                    if (_isConcluded == false)
                                      FittedBox(
                                        child: Row(
                                          children: [
                                            Container(
                                              child: FloatingActionButton(
                                                heroTag: "play btn",
                                                onPressed: () =>
                                                    _playButtonHandler(),
                                                child: !_isPlaying
                                                    ? Icon(Icons.play_arrow)
                                                    : Icon(Icons.stop),
                                                backgroundColor: _isLive
                                                    ? !_isPlaying
                                                        ? Colors.redAccent
                                                        : Colors.redAccent
                                                    : Colors.grey,
                                              ),
                                            ),

                                            // dedicated button for mic
                                            if (_isParticipant == true)
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    10, 0, 0, 0),
                                                child: FloatingActionButton(
                                                  heroTag: "mic btn",
                                                  onPressed: () =>
                                                      _micButtonHandler(),
                                                  child: !_isMuted
                                                      ? Icon(
                                                          Icons.mic_none_rounded)
                                                      : Icon(
                                                          Icons.mic_off_rounded),
                                                  backgroundColor: !_isPlaying
                                                      ? Colors.grey
                                                      : !_sentRequest
                                                          ? Colors.redAccent
                                                          : Colors.grey,
                                                ),
                                              ),

                                            // dedicated button for sending join request or stepping down to become only listener
                                            if (_isOwner == false)
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    10, 0, 0, 0),
                                                child: FloatingActionButton(
                                                  heroTag: "participation btn",
                                                  onPressed: () =>
                                                      _participationButtonHandler(),
                                                  child: _isParticipant
                                                      ? Icon(
                                                          Icons.remove_from_queue)
                                                      : !_sentRequest?
                                                        Icon(Icons.person_add):
                                                        Icon(Icons.person_add_disabled,color: Colors.black,),
                                                  backgroundColor: _isParticipant
                                                      ? Colors.grey[200]
                                                      : !_sentRequest
                                                          ? Colors.redAccent
                                                          : Colors.grey[200],
                                                ),
                                              )
                                          ],
                                        ),
                                      )
                                  ],
                                ),
                              ),
                              SizedBox(height: size.height / 50),

                              Container(
                                  height: size.height / 2 + size.height / 30,
                                  width: size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: Stack(children: <Widget>[
                                    Positioned(
                                      top: 15,
                                      left: 10,
                                      child: Text(
                                        'COMMENTS',
                                        style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: size.width / 25,
                                            letterSpacing: 2.0),
                                      ),
                                    ),
                                    Positioned(
                                        top: 45,
                                        left: 10,
                                        child: Column(
                                          children: [
                                            Container(
                                              height: size.height / 2.5,
                                              width: size.width - 20,
                                              color: Colors.white,
                                              child: ListView.builder(
                                                  itemCount: comments.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return ListTile(
                                                      leading: CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(
                                                                comments[index]
                                                                    .user
                                                                    .avatar),
                                                      ),
                                                      title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          InkWell(
                                                            onTap: (){
                                                              Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ProfilePage(userId: comments[index].user.userId,)));
                                                            },
                                                            child: Text(
                                                              comments[index]
                                                                  .user
                                                                  .username,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Lato",
                                                                  color: Colors
                                                                      .redAccent),
                                                            ),
                                                          ),
                                                          Text(
                                                            _processTimestamp(
                                                                comments[index]
                                                                    .timestamp,1),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Lato',
                                                                fontSize:
                                                                    size.width /
                                                                        30),
                                                          )
                                                        ],
                                                      ),
                                                      subtitle: Text(
                                                        comments[index].body,
                                                        style: TextStyle(
                                                            fontFamily: "Lato"),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                            Container(
                                              height: 40,
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 10, 0, 10),
                                              width: size.width - 20,
                                              child: TextField(
                                                controller: _commentController,
                                                decoration: InputDecoration(
                                                    suffixIcon: IconButton(
                                                      icon: Icon(
                                                        Icons.send,
                                                        color: Colors.redAccent,
                                                      ),
                                                      onPressed: () {
                                                        print("=<<>>><<>>><<>>>=" +
                                                            _commentController
                                                                .text);
                                                        addComment(
                                                            _commentController
                                                                .text);
                                                        _commentController
                                                            .text = '';
                                                        //            _sendComment(context);
                                                      },
                                                    ),
                                                    fillColor: Colors.white,
                                                    hintText: 'Comment',
                                                    filled: true,
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius
                                                                    .circular(
                                                                        5.0)),
                                                        borderSide:
                                                            BorderSide(
                                                                color:
                                                                    Colors
                                                                        .black12,
                                                                width: 1.0)),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width:
                                                                        2.0))),
                                                //   onSubmitted: (val) => {addComment(val)},
                                              ),
                                            )
                                          ],
                                        )),
                                  ])),

                              SizedBox(height: size.height / 30),
                              Container(
                                margin: EdgeInsets.only(
                                    left: size.width / 50,
                                    right: size.width / 50),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'More from @${_clubAudience.club.creator.username}',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      'View All',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: size.height / 50),
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
                            size: size,
                            participantList: participantList,
                            isOwner: _isOwner,
                            muteParticipant: _muteParticpant,
                            removeParticipant: _kickParticpant,
                            blockParticipant: _blockUser,
                          ),
                      ],
                    )
                  : showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return _invitationAlert;
                      })
              : Container(
                  child: Center(child: Text("Loading...")),
                ),
          //        ),
        ),
      ),
    );
  }
}
