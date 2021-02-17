import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/pages/SocialRelationPage.dart';
import 'package:mootclub_app/providers/userData.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';
import 'package:provider/provider.dart';

import '../Carousel.dart';
import 'package:built_collection/built_collection.dart';
import 'ProfileImagePage.dart';

import '../MinClub.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  ProfilePage({this.userId});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static BuiltUser _user;
  RelationIndexObject _userRelations;
  bool _isMe;
  Image image;
  bool isFollowing = false;
  bool sentFollowRequest = false;
  bool sentFriendRequest = false;
  int followersCount = 0;
  int followingCount = 0;
  BuiltList<BuiltClub> Clubs;
  fetchUserRelations() async {
    print("==================FetchUserRelations=========================");
    BuiltUser cuser = Provider.of<UserData>(context, listen: false).user;
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    _userRelations = (await service.getUserProfile(
      primaryUserId: cuser.userId,
      userId: widget.userId,
      authorization: authToken,
    ))
        .body
        .relationIndexObj;
    print("==================");
    print(_userRelations);
    print("==================");
    setState(() {});
  }

  fetchUser() async {
    BuiltUser cuser = Provider.of<UserData>(context, listen: false).user;
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    print('${cuser.userId}==${widget.userId}');
    if (widget.userId == null || cuser.userId == widget.userId) {
      setState(() {
        _isMe = true;
        _user = cuser;
      });
      if (_user.followerCount != null) followersCount = _user.followerCount;
      if (_user.followingCount != null) followingCount = _user.followingCount;
    } else {
      _isMe = false;
      final fetchedUserData = (await service.getUserProfile(
        primaryUserId: cuser.userId,
        userId: widget.userId,
        authorization: authToken,
      ))
          .body;
      _user = fetchedUserData?.user;
      _userRelations = fetchedUserData?.relationIndexObj;
    }

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
      if (_user.followerCount != null) followersCount = _user.followerCount;
      if (_user.followingCount != null) followingCount = _user.followingCount;
    }
    setState(() {});
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

    Clubs = (await service.getMyOrganizedClubs(
      userId: widget.userId,
      lastevaluatedkey: null,
      authorization: authToken,
    ))
        ?.body
        ?.clubs;
    setState(() {});
    //  print("============LENGTH= ${Clubs.length}");

    //THIS IS RETURNING NULL
    //   setState(() {});
  }

  sendFollow() async {
    BuiltUser cuser = Provider.of<UserData>(context, listen: false).user;
    final service = Provider.of<DatabaseApiService>(context, listen: false);

    final authToken = Provider.of<UserData>(context, listen: false).authToken;

    await service.follow(
      userId: cuser.userId,
      foreignUserId: widget.userId,
      authorization: authToken,
    );
    await fetchUserRelations();
    Fluttertoast.showToast(msg: 'Follow Request Sent');
  }

  sendUnFollow() async {
    BuiltUser cuser = Provider.of<UserData>(context, listen: false).user;
    final service = Provider.of<DatabaseApiService>(context, listen: false);

    final authToken = Provider.of<UserData>(context, listen: false).authToken;

    await service.unfollow(
      userId: cuser.userId,
      foreignUserId: widget.userId,
      authorization: authToken,
    );
    await fetchUserRelations();
    Fluttertoast.showToast(msg: 'User Unfollowed');
  }

  sendFreindRequest() async {
    BuiltUser cuser = Provider.of<UserData>(context, listen: false).user;
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final authToken = Provider.of<UserData>(context, listen: false).authToken;

    await service.sendFriendRequest(
      userId: cuser.userId,
      foreignUserId: widget.userId,
      authorization: authToken,
    );

    await fetchUserRelations();

    Fluttertoast.showToast(msg: 'Friend Request Sent');
  }

  cancelFriendRequest() async {
    BuiltUser cuser = Provider.of<UserData>(context, listen: false).user;
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final authToken = Provider.of<UserData>(context, listen: false).authToken;

    await service.deleteFriendRequest(
      userId: cuser.userId,
      foreignUserId: widget.userId,
      authorization: authToken,
    );

    await fetchUserRelations();

    Fluttertoast.showToast(msg: 'Friend Request Cancelled');
  }

  unFriend() async {
    BuiltUser cuser = Provider.of<UserData>(context, listen: false).user;
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final authToken = Provider.of<UserData>(context, listen: false).authToken;

    await service.unfriend(
      userId: cuser.userId,
      foreignUserId: widget.userId,
      authorization: authToken,
    );

    await fetchUserRelations();

    Fluttertoast.showToast(msg: 'Good Bye!');
  }

  checkingResponse(value) {
    print(value.statusCode);
    print(value.body);
    print(value.error);
  }

  @override
  void initState() {
    _user = null;
    fetchUser();
    _fetchAllClubs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print('isme=$_isMe');

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.redAccent,
          body: _user != null
              ? Stack(fit: StackFit.expand, children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment(0.5,
                            0.0), // 10% of the width, so there are ten blinds.
                        colors: [
                          const Color(0xfffa939e),
                          const Color(0xffad1323)
                          //  const Color(0xffd90000)
                        ], // red to yellow
                        tileMode: TileMode
                            .repeated, // repeats the gradient over the canvas
                      ),
                    ),
                  ),
                  _isMe == false
                      ? Positioned(
                          left: 0,
                          top: 0,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_outlined),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                      : Container(
                          height: 0,
                        ),
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
                              _user.name != null ? _user.name : _user.username,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: size.width / 20,
                                color: Colors.redAccent,
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
                            (!_isMe)
                                ? _userRelations == null
                                    ? Container(
                                        height: size.height / 20,
                                        child: Center(
                                            child: Text(
                                          "Loading...",
                                          style: TextStyle(
                                              fontFamily: "Lato",
                                              color: Colors.black38),
                                        )))
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          ButtonTheme(
                                            minWidth: size.width / 3.5,
                                            child: RaisedButton(
                                              onPressed: () async {
                                                if (_userRelations.B5 ==
                                                    false) {
                                                  await sendFollow();
                                                } else {
                                                  await sendUnFollow();
                                                }
                                                setState(() {});
                                              },
                                              color: _userRelations.B5 == false
                                                  ? Colors.red[600]
                                                  : Colors.white,
                                              child: Text(
                                                  _userRelations.B5 == false
                                                      ? 'Follow'
                                                      : 'Following',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: _userRelations.B5 ==
                                                            false
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
                                                if (_userRelations.B1 == true) {
                                                  await unFriend();
                                                } else if (_userRelations.B3 ==
                                                    false) {
                                                  await sendFreindRequest();
                                                } else {
                                                  await cancelFriendRequest();
                                                }
                                                setState(() {});
                                              },
                                              color: Colors.white,
                                              child: Text(
                                                  _userRelations.B1 == true
                                                      ? "FRIENDS"
                                                      : _userRelations.B3 ==
                                                              false
                                                          ? "Add Friend"
                                                          : "Request Sent",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: _userRelations.B1 ==
                                                            true
                                                        ? Colors.red
                                                        : _userRelations.B3 ==
                                                                false
                                                            ? Colors.black
                                                            : Colors.black38,
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
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    ProfileImagePage(
                                                      name: _user.name,
                                                      userName: _user.username,
                                                    )));
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
                                        side:
                                            BorderSide(color: Colors.red[600]),
                                      ),
                                      elevation: 0.0,
                                    ),
                                  ),
                            SizedBox(height: size.height / 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => SocialRelationPage(
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
                                          color: Colors.redAccent,
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
                                            builder: (_) => SocialRelationPage(
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
                                          color: Colors.redAccent,
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
                                            builder: (_) => SocialRelationPage(
                                                initpos: 2, user: _user)));
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                          _user.followingCount.toString() !=
                                                  'null'
                                              ? _user.followingCount.toString()
                                              : '0',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600],
                                            fontSize: size.width / 20,
                                          )),
                                      Text(
                                        'Following',
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: size.width / 26,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.height / 20),
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
                                        color: Colors.redAccent),
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
                            Clubs != null
                                ? Carousel(Clubs: Clubs)
                                : Container(
                                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                    child: Center(
                                        child: Text(
                                      "Loading..",
                                      style: TextStyle(
                                          fontFamily: 'Lato',
                                          color: Colors.grey),
                                    ))),
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
                  ),
                  Positioned(bottom: 0, child: MinClub())
                ])
              : Center(
                  child: Container(
                      height: size.height / 10,
                      width: size.width / 5,
                      child: CircularProgressIndicator()),
                )),
    );
  }
}
