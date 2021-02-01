import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/pages/FollowersPage.dart';
import 'package:mootclub_app/providers/userData.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';
import 'package:provider/provider.dart';
import '../AppBarWidget.dart';
import '../Carousel.dart';
import 'package:built_collection/built_collection.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  ProfilePage({this.userId});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static BuiltUser _user;
  bool _isMe;
  Image image;
  bool isFollowing = false;
  bool sentFollowRequest = false;
  bool sentFriendRequest = false;
  int followersCount = 0;
  int followingCount = 0;
  BuiltList<BuiltClub> Clubs;
  checkIsFollowing() async {
    if (_isMe == false) {
      BuiltUser user = Provider.of<UserData>(context, listen: false).user;
      final authToken = Provider.of<UserData>(context, listen: false).authToken;
      isFollowing =
          (await Provider.of<DatabaseApiService>(context, listen: false)
                  .checkFollow(user.userId, user.username, _user.username,
                      authorization: authToken))
              .body['value'];
    }
  }

  fetchUser() async {
    BuiltUser cuser = Provider.of<UserData>(context, listen: false).user;
    print(cuser.userId + '==' + widget.userId);
    if (widget.userId == null || cuser.userId == widget.userId) {
      setState(() {
        _isMe = true;
        _user = cuser;
      });
      await checkIsFollowing();
      if (_user.followerCount != null) followersCount = _user.followerCount;
      if (_user.followingCount != null) followingCount = _user.followingCount;
      return;
    } else
      _isMe = false;
    final service = Provider.of<DatabaseApiService>(context);
    // _user = cuser;

    final authToken = Provider.of<UserData>(context, listen: false).authToken;

    _user =
        (await service.getUserProfile(widget.userId, authorization: authToken))
            ?.body
            ?.user;
    if (_user.userId == null) {
      _user = null;
      Fluttertoast.showToast(
          msg: "Something went wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
    } else {
      await checkIsFollowing();
      if (_user.followerCount != null) followersCount = _user.followerCount;
      if (_user.followingCount != null) followingCount = _user.followingCount;
    }
    print(_user.followerCount);
  }

  String getImageUrl() {
    final requestUrl = (_user == null || _user.avatar == null)
        ? 'https://mootclub-public.s3.amazonaws.com/userAvatar/${widget.userId}'
        : _user.avatar;
    return requestUrl;
  }

  _fetchAllClubs() async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final authToken = Provider.of<UserData>(context, listen: false).authToken;

    Clubs = (await service.getMyHistoryClubs(widget.userId,
            authorization: authToken))
        ?.body
        ?.clubs;
    //  print("============LENGTH= ${Clubs.length}");

    //THIS IS RETURNING NULL
    //   setState(() {});
  }

  sendFollow() async {
    BuiltUser cuser = Provider.of<UserData>(context, listen: false).user;
    final service = Provider.of<DatabaseApiService>(context, listen: false);

    final authToken = Provider.of<UserData>(context, listen: false).authToken;

    await service.follow(cuser.userId, widget.userId, authorization: authToken);
    Fluttertoast.showToast(msg: 'Follow Request Sent');
  }

  sendFreindRequest() async {
    BuiltUser cuser = Provider.of<UserData>(context, listen: false).user;
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final authToken = Provider.of<UserData>(context, listen: false).authToken;

    await service.sendFriendRequest(cuser.userId, widget.userId,
        authorization: authToken);

    Fluttertoast.showToast(msg: 'Friend Request Sent');
  }

  checkingResponse(value) {
    print(value.statusCode);
    print(value.body);
    print(value.error);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print('isme=$_isMe');
//    const userId = '264bf27e-2752-4e49-aba0-ca03b101c104';
//    const clubId = 'MYg7GShERndmORpluy7GK';

    // var service = Provider.of<DatabaseApiService>(context,listen:false);
    // Provider.of<MySocket>(context,listen: false).currentStatus();
    // for(int i=0;i<100;i++){
    // print("${_user.userId}  $i");
    // }
    // Getting Reactions
    // Provider.of<DatabaseApiService>(context,listen: false).getReaction('MYg7GShERndmORpluy7GK').then((value){
    //   print(value.body);
    // });

    //Sending Reactions
    //  Provider.of<DatabaseApiService>(context,listen: false).postReaction('MYg7GShERndmORpluy7GK','9a6a6a6d-7b11-4d40-9ce9-c292b9f451b7',1).then((value){

    //   print(value.statusCode);
    //   print(value.body);
    //   print(value.error);
    // });

    //Reporting club
    // var a = ReportSummary((r)=>r
    // ..body = "AA");

    // Provider.of<DatabaseApiService>(context, listen: false).reportClub(
    //     '9a6a6a6d-7b11-4d40-9ce9-c292b9f451b7',
    //     a,
    //     'MYg7GShERndmORpluy7GK').then((value)  {
    //       print(value.statusCode);
    //       print(value.body);
    //       print(value.error);
    //     });

    //Entering a Club
    // Provider.of<DatabaseApiService>(context, listen: false)
    //     .enterClub(clubId, userId)
    //     .then((value) {
    //     print("Entering into a club");
    //   print(value.statusCode);
    //   print(value.body);
    //   print(value.error);
    // });

    //Getting Join Request
    // Provider.of<DatabaseApiService>(context, listen: false)
    //     .getActiveJoinRequests(clubId, null).then((value) {

    //         print(value.statusCode);
    //         print(value.body);
    //         print(value.error);
    //     });

    //sending join request
    // Provider.of<DatabaseApiService>(context, listen: false)
    //     .sendJoinRequest(userId, clubId)
    //     .then((value) {
    //   print(value.statusCode);
    //   print(value.body);
    //   print(value.error);
    // });

    // deleting join request
    // service.deleteJoinRequet(clubId, userId).then((value)=>checkingResposne(value));

    //accepting join request
    // service.respondToJoinRequest(clubId,"accept", userId).then((value) => checkingResponse(value));

    //rejecting join request
    //just replace accept by cancel

    // kicking an audience (currently some problem in backend)
    // service.kickAudienceId(clubId, userId).then((value) => checkingResponse(value));

    //searching for all
    // service.unifiedQueryRoutes("Ada", "unified",null).then((value) => checkingResponse(value));

    //searching for clubs
    // service.unifiedQueryRoutes("Ada", "clubs",null).then((value) => checkingResponse(value));

    //searching for users
    // service.unifiedQueryRoutes("hola", "users",null).then((value) => checkingResponse(value));

    return Scaffold(
        backgroundColor: Colors.amber,
        body: FutureBuilder(
            future: fetchUser(),
            builder: (context, snapshot) {
              if (_user == null ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return SafeArea(
                child: Scaffold(
                  body: Stack(fit: StackFit.expand, children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment(0.8,
                              0.5), // 10% of the width, so there are ten blinds.
                          colors: [
                            const Color(0xfffac043),
                            const Color(0xffd61a09)
                            //  const Color(0xffd90000)
                          ], // red to yellow
                          tileMode: TileMode
                              .repeated, // repeats the gradient over the canvas
                        ),
                      ),
                    ),
                    AppBarWidget(), //AppBar
                    Positioned(
                      top: ((size.height / 14) +
                          (size.height / 9) -
                          (size.height / 25)),
                      height: size.height -
                          ((size.height / 14) +
                              (size.height / 9) -
                              (size.height / 25)),
                      width: size.width,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
//                            borderRadius: BorderRadius.only(
//                                topLeft: Radius.circular(45.0),
//                                topRight: Radius.circular(45.0)),
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.elliptical(
                                      size.width / 2, size.height / 20))),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: size.height / 20),
                              Text(
                                //  'Caroline Steele',
                                _user.name != null
                                    ? _user.name
                                    : _user.username,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.width / 20,
                                  color: Colors.red[300],
                                ),
                              ),
                              SizedBox(
                                height: size.height / 130,
                              ),
                              Text(
                                //'Music Composer',
                                '@${_user.username}',
                                style: TextStyle(
                                    fontSize: size.width / 26,
                                    color: Colors.grey[400]),
                              ),
                              SizedBox(
                                height: size.height / 50,
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: size.width / 20,
                                    right: size.width / 20),
                                child: Text(
                                  //'Hi my name is Carol and I am a music composer. Music is the greatest passion of my life',
                                  _user.bio != null ? _user.bio : '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: size.width / 26,
                                      color: Colors.grey[500]),
                                ),
                              ),
                              SizedBox(
                                height: size.height / 30,
                              ),
                              !_isMe
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        ButtonTheme(
                                          minWidth: size.width / 3.5,
                                          child: RaisedButton(
                                            onPressed: () async {
                                              if (!sentFollowRequest) {
                                                await sendFollow();
                                                setState(() {
                                                  sentFollowRequest =
                                                      !sentFollowRequest;
                                                });
                                              }
                                            },
                                            color: !sentFollowRequest
                                                ? Colors.red[600]
                                                : Colors.white,
                                            child: Text(
                                                !sentFollowRequest
                                                    ? 'Follow'
                                                    : 'Sent follow request',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: !sentFollowRequest
                                                      ? Colors.white
                                                      : Colors.grey[700],
                                                )),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                              side: BorderSide(
                                                  color: Colors.red[600]),
                                            ),
                                            elevation: 0.0,
                                          ),
                                        ),
                                        ButtonTheme(
                                          minWidth: size.width / 3.5,
                                          child: RaisedButton(
                                            onPressed: () async {
                                              if (!sentFriendRequest) {
                                                await sendFreindRequest();
                                                setState(() {
                                                  sentFriendRequest =
                                                      !sentFriendRequest;
                                                });
                                              }
                                            },
                                            color: Colors.white,
                                            child: Text(
                                                !sentFriendRequest
                                                    ? 'Add friend'
                                                    : 'Sent Friend Request',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: !sentFriendRequest
                                                      ? Colors.red[600]
                                                      : Colors.grey[700],
                                                )),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                              side: BorderSide(
                                                  color: Colors.red[600]),
                                            ),
                                            elevation: 0.0,
                                          ),
                                        ),
                                      ],
                                    )
                                  : ButtonTheme(
                                      minWidth: size.width / 1.5,
                                      child: RaisedButton(
                                        onPressed: () {
                                          // Navigator.of(context).push(MaterialPageRoute(builder: (_)=>OtpScreen()));
                                        },
                                        color: Colors.white,
                                        child: Text('EDIT PROFILE',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red[600],
                                            )),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: BorderSide(
                                              color: Colors.red[600]),
                                        ),
                                        elevation: 0.0,
                                      ),
                                    ),
                              SizedBox(height: size.height / 30),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                //crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) => FollowersPage(
                                                  initpos: 0, user: _user)));
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                            _user.friendsCount.toString() !=
                                                    'null'
                                                ? _user.friendsCount.toString()
                                                : '0',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[600],
                                              fontSize: size.width / 20,
                                            )),
                                        Text(
                                          'Friends',
                                          style: TextStyle(
                                            color: Colors.red[300],
                                            fontSize: size.width / 26,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  VerticalDivider(
                                    color: Colors.grey[400],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) => FollowersPage(
                                                  initpos: 1, user: _user)));
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                            _user.followerCount.toString() !=
                                                    'null'
                                                ? _user.followerCount.toString()
                                                : '0',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[600],
                                              fontSize: size.width / 20,
                                            )),
                                        Text(
                                          'Followers',
                                          style: TextStyle(
                                            color: Colors.red[300],
                                            fontSize: size.width / 26,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  VerticalDivider(
                                    color: Colors.grey[400],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) => FollowersPage(
                                                  initpos: 2, user: _user)));
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                            _user.followingCount.toString() !=
                                                    'null'
                                                ? _user.followingCount
                                                    .toString()
                                                : '0',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[600],
                                              fontSize: size.width / 20,
                                            )),
                                        Text(
                                          'Following',
                                          style: TextStyle(
                                            color: Colors.red[300],
                                            fontSize: size.width / 26,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
                                      'My Clubs',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red[300]),
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
                              SizedBox(
                                height: size.height / 50,
                              ),
                              FutureBuilder(
                                  future: _fetchAllClubs(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                    return Clubs != null
                                        ? Carousel(Clubs: Clubs)
                                        : Container();
                                  })
                            ],
                          )),
                    ),

                    Positioned(
                      top: size.height / 14,
                      left: ((size.width / 2) - (size.width / 9)),
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(getImageUrl()),
                          //backgroundImage: AssetImage('assets/images/Default-female.png'),
                          radius: size.height / 18),
                    )
                  ]),
                ),
              );
            }));
  }
}
