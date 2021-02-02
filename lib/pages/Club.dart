import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:mootclub_app/Carousel.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/Models/comment.dart';
import 'package:mootclub_app/providers/agoraController.dart';
import 'package:mootclub_app/providers/userData.dart';
import 'package:mootclub_app/providers/webSocket.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';
import 'package:provider/provider.dart';
import 'package:built_collection/built_collection.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'ClubJoinRequests.dart';

class Club extends StatefulWidget {
  final BuiltClub club;
  const Club({this.club});
  @override
  _ClubState createState() => _ClubState();
}

class _ClubState extends State<Club> {
  bool start = false;
  bool playing = false;
  bool isLive = true;
  BuiltList<BuiltClub> Clubs;
  var participantList = [];

  // int likes = -1;
  int likeCount = -1;
  int dislikes = -1;
  int flags = -1;
  int audienceCount = -1;
  List<Comment> comments = [];
  void getParticipantListForFirstTime(event) {
    // print(event);
    setState(() {});
  }

  void getAudienceForFirstTime(event) {
    audienceCount = (event['count']);
    print(event);

    setState(() {});
  }

  void getReactionForFirstTime(event) {
    int v = (event['count']);
    int ind = (event['indexValue']);
    if (ind == 0) {
      likeCount = v;
    } else if (ind == 1) {
      dislikes = v;
    } else
      flags = v;

    setState(() {});
  }

  void putNewComment(event) {
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

  void addOldComments(event) {
    event['oldComments'].forEach((e) => putNewComment(e));
    setState(() {});
  }

  void addComment(String message) {
    Provider.of<MySocket>(context, listen: false).addComment(
        message,
        widget.club.clubId,
        Provider.of<UserData>(context, listen: false).user.userId);
  }

  void toggleLikeClub() {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    service.postReaction(widget.club.clubId,
        Provider.of<UserData>(context, listen: false).user.userId, 0,
        authorization: null);
  }

  void toggleDislikeClub() {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    service.postReaction(widget.club.clubId,
        Provider.of<UserData>(context, listen: false).user.userId, 1,
        authorization: null);
  }

  void toggleReportClub() {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    service.postReaction(widget.club.clubId,
        Provider.of<UserData>(context, listen: false).user.userId, 2,
        authorization: null);
  }

  _fetchAllClubs() async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    Clubs = (await service.getMyHistoryClubs(widget.club.creator.userId,
            authorization: authToken))
        .body
        .clubs;
    //  print("============LENGTH= ${Clubs.length}");

    //THIS IS RETURNING NULL
    //   setState(() {});
  }

  void kickParticpant(String userId) {
    Provider.of<DatabaseApiService>(context, listen: false).kickAudienceId(
      widget.club.clubId,
      userId,
      authorization: null,
    );
  }

  void reportClub() {}

//! ------------------------------ for test purpose ------------------------------
  void _stopAgora() async {
    await Provider.of<AgoraController>(context, listen: false).dispose();
  }

  void _fetchClubDetailsAndJoinAsHost() async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    var _club = (await service.getClubByClubId(widget.club.clubId)).body;

    await Provider.of<AgoraController>(context, listen: false).create();

    if (_club.agoraToken == null) {
      final userId = Provider.of<UserData>(context, listen: false).user.userId;
      final data = (await service.generateAgoraTokenForClub(
        widget.club.clubId,
        userId,
      ));
      print(data.body['agoraToken']);
      _club = _club.rebuild((b) => b..agoraToken = data.body['agoraToken']);
    }

    Provider.of<AgoraController>(context, listen: false)
        .joinAsParticipant(clubId: _club.clubId, token: _club.agoraToken);
  }

  @override
  void initState() {
    Provider.of<DatabaseApiService>(context, listen: false).enterClub(
        widget.club.clubId,
        Provider.of<UserData>(context, listen: false).user.userId,
        authorization: null);

    // Provider.of<MySocket>(context,listen:false).currentStatus();
    Provider.of<MySocket>(context, listen: false).joinClub(
      widget.club.clubId,
      putNewComment,
      addOldComments,
      getReactionForFirstTime,
      getParticipantListForFirstTime,
      getAudienceForFirstTime,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: Container(
    //     padding: EdgeInsetsDirectional.fromSTEB(0, 100, 0, 0),
    //     child: Center(
    //       child: Column(
    //         children: [
    //           Center(
    //             child: RaisedButton(
    //               child: Text("Add Comment"),
    //               onPressed: () =>
    //                   addComment("Hi! I'm Adarsh, I'm testing this widget"),
    //             ),
    //           ),
    //           Center(
    //             child: RaisedButton(
    //               onPressed: () => Provider.of<MySocket>(context, listen: false)
    //                   .currentStatus(),
    //             ),
    //           ),
    //           Text('likes : $likeCount'),
    //           Text('audienceCount : $audienceCount'),
    //           Text('comments: $comments')
    //         ],
    //       ),
    //     ),
    //   ),
    // );
    BuiltUser user = Provider.of<UserData>(context, listen: false).user;
    bool isMe = widget.club.creator.userId == user.userId;
    final size = MediaQuery.of(context).size;
    final _commentController = TextEditingController();
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    int dislikeCount = 0;
    return WillPopScope(
      onWillPop: () async {
        for (int i = 0; i < 100; i++) print(i);
        Provider.of<MySocket>(context, listen: false)
            .leaveClub(widget.club.clubId);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            "Now Playing",
            style: TextStyle(
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: SlidingUpPanel(
            minHeight: size.height / 15,
            maxHeight: size.height / 1.5,
            backdropEnabled: true,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            panel: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height / 30,
                ),
                Center(
                  child: Text("Panelists",
                      style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                          fontSize: size.width / 20,
                          color: Colors.red[300])),
                ),
                SizedBox(
                  height: size.height / 50,
                ),
                Container(
                  height: 300,
                  child: ListView.builder(
                      itemCount: 3,
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      Colors.orange.withOpacity(0.3),
                                  radius: 32,
                                  child: Icon(
                                    Icons.person_outline,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                ),
                                CircleAvatar(
                                  backgroundColor:
                                      Colors.orange.withOpacity(0.3),
                                  radius: 32,
                                  child: Icon(
                                    Icons.person_outline,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                ),
                                CircleAvatar(
                                  backgroundColor:
                                      Colors.orange.withOpacity(0.3),
                                  radius: 32,
                                  child: Icon(
                                    Icons.person_outline,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: size.height / 50,
                            ),
                          ],
                        );
                      }),
                ),
                //SizedBox(height: size.height/50,),+
              ],
            )),
            collapsed: Container(
              decoration: BoxDecoration(
                  color: Colors.red[300],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24))),
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
            body: Container(
                margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
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
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 25.0, // soften the shadow
                                      spreadRadius: 1.0, //extend the shadow
                                      offset: Offset(
                                        0.0,
                                        15.0, // Move to bottom 10 Vertically
                                      ),
                                    )
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              child: Image.network(
                                widget.club.clubAvatar,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  widget.club.clubName != null
                                      ? SizedBox(
                                          width: size.width / 2,
                                          child: Text(
                                            widget.club.clubName,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontWeight: FontWeight.bold,
                                                fontSize: size.width / 25),
                                          ),
                                        )
                                      : SizedBox(
                                          width: size.width / 2,
                                          child: Text(
                                            "ANONYMOUS CLUB",
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                  widget.club.description != null
                                      ? SizedBox(
                                          width: size.width / 2,
                                          child: Text(
                                            widget.club.description,
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: size.width / 30,
                                                color: Colors.black54),
                                          ),
                                        )
                                      : SizedBox(
                                          width: size.width / 2,
                                          child: Text(
                                            "There is no description provided for this club",
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: size.width / 30,
                                                color: Colors.black54),
                                          ),
                                        ),
                                  isLive
                                      ? Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 5, 0, 0),
                                          padding:
                                              EdgeInsets.fromLTRB(2, 2, 2, 2),
                                          color: Colors.red,
                                          child: Text(
                                            "LIVE",
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                letterSpacing: 2.0),
                                          ),
                                        )
                                      : Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 5, 0, 0),
                                          child: Text(
                                            "23 mins",
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                color: Colors.black54),
                                          ),
                                        ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          child: LikeButton(
                                            likeBuilder: (bool isLiked) {
                                              return isLiked
                                                  ? Icon(
                                                      Icons.favorite,
                                                      color: Colors.redAccent,
                                                      size: size.height / 25,
                                                    )
                                                  : Icon(
                                                      Icons
                                                          .favorite_border_rounded,
                                                      color: Colors.black,
                                                      size: size.height / 25,
                                                    );
                                            },
                                            likeCount: likeCount,
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: LikeButton(
                                            likeCount: dislikeCount,
                                            likeBuilder: (bool isLiked) {
                                              return isLiked
                                                  ? Icon(
                                                      Icons.thumb_down,
                                                      color: Colors.amber,
                                                      size: size.height / 25,
                                                    )
                                                  : Icon(
                                                      Icons.thumb_down_outlined,
                                                      color: Colors.black,
                                                      size: size.height / 25,
                                                    );
                                            },
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: LikeButton(
                                            likeBuilder: (bool isLiked) {
                                              return isLiked
                                                  ? Icon(
                                                      Icons.flag,
                                                      color: Colors.black,
                                                      size: size.height / 25,
                                                    )
                                                  : Icon(
                                                      Icons.flag_outlined,
                                                      color: Colors.black,
                                                      size: size.height / 25,
                                                    );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ]),
                      Container(
                        margin:
                            EdgeInsets.fromLTRB(15, size.height / 30, 15, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(children: <Widget>[
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(widget.club.creator.avatar),
                                radius: size.width / 20,
                              ),
                              widget.club.creator.name != null
                                  ? Container(
                                      margin: EdgeInsets.fromLTRB(
                                          size.width / 30, 0, 0, 0),
                                      child: Text(
                                        widget.club.creator.name,
                                        style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : Container(
                                      margin: EdgeInsets.fromLTRB(
                                          size.width / 30, 0, 0, 0),
                                      child: Text(
                                        '@' + widget.club.creator.username,
                                        style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.bold,
                                            fontSize: size.width / 25),
                                      ),
                                    ),
                            ]),
                            Row(
                              children: [
                                Container(
                                  child: FloatingActionButton(
                                    heroTag: "btn1",
                                    onPressed: () {
                                      setState(() {
                                        playing = !playing;
                                        if (playing)
                                          _fetchClubDetailsAndJoinAsHost();
                                        else
                                          _stopAgora();
                                      });
                                    },
                                    child: !playing
                                        ? Icon(Icons.play_arrow)
                                        : Icon(Icons.stop),
                                    backgroundColor:
                                        !playing ? Colors.green : Colors.red,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: FloatingActionButton(
                                    heroTag: "btn2",
                                    onPressed: () {
                                      setState(() {});
                                      if (isMe && playing) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    ClubJoinRequests(
                                                      club: widget.club,
                                                    )));
                                      }
                                    },
                                    child: !isMe
                                        ? Icon(Icons.mic_none_rounded)
                                        : Icon(Icons.person_add),
                                    backgroundColor:
                                        !playing ? Colors.grey : Colors.amber,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: size.height / 30),
//                Text('Panelists',
//                    style: TextStyle(
//                        fontFamily: 'Lato',
//                        fontSize: size.width / 20,
//                        fontWeight: FontWeight.bold,
//                        color: Colors.black)),
//                SizedBox(height: size.height / 100),
//                Container(
//                  height: 64,
//                  width: size.width,
//                  child: ListView.builder(
//                    scrollDirection: Axis.horizontal,
//                    itemCount: 10,
//                    itemBuilder: (ctx, index) {
//                      return Padding(
//                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
//                        child: CircleAvatar(
//                          backgroundColor: Colors.orange.withOpacity(0.3),
//                          radius: 32,
//                          child: Icon(
//                            Icons.person_outline,
//                            size: 30,
//                            color: Colors.black,
//                          ),
//                        ),
//                      );
//                    },
//                  ),
//                ),

                      //SizedBox(height: size.height/20,),

                      Container(
                          height: size.height / 2,
                          width: size.width,
                          decoration: BoxDecoration(
                            color: Colors.black12,
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
                                top: 50,
                                left: 15,
                                child: Container(
                                  height: size.height / 2.5,
                                  width: size.width - 30,
                                  color: Colors.white,
                                  child: ListView.builder(
                                      itemCount: comments.length,
                                      reverse: true,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(comments[index].user.avatar),
                                          ),
                                          title: Text(
                                            comments[index].user.username,
                                            style: TextStyle(
                                              fontFamily: "Lato",
                                            ),
                                          ),
                                          subtitle: Text(
                                            comments[index].body,
                                            style:
                                                TextStyle(fontFamily: "Lato"),
                                          ),
                                        );
                                      }),
                                )),
                            Positioned(
                              left: 20,
                              bottom: 30,
                              child: Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: size.width / 1.25,
                                    child: TextField(
                                      decoration: InputDecoration(
                                          fillColor: Colors.grey[200],
                                          hintText: 'Comment',
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12.0)),
                                              borderSide: BorderSide(
                                                  color: Colors.black12,
                                                  width: 1.0)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 2.0))),
                                      controller: _commentController,
                                      onSubmitted: (val) => {addComment(val)},
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  IconButton(
                                    icon: Icon(Icons.send),
                                    onPressed: () {
                                      addComment(_commentController.text);
                                      _commentController.text = '';
                                      //            _sendComment(context);
                                    },
                                  ),
                                ],
                              ),
                            )
                          ])),

                      SizedBox(height: size.height / 30),
                      Container(
                        margin: EdgeInsets.only(
                            left: size.width / 50, right: size.width / 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'More from @${widget.club.creator.username}',
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
                      FutureBuilder(
                          future: _fetchAllClubs(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return Clubs != null
                                ? Carousel(Clubs: Clubs)
                                : Container();
                          }),
                      SizedBox(height: size.height / 5)
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
