import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/Models/sharedPrefKey.dart';
import 'package:mootclub_app/providers/userData.dart';
import 'package:mootclub_app/services/chopper/user_database_api_service.dart';
import 'package:provider/provider.dart';
import '../AppBarWidget.dart';
import '../Carousel.dart';
import 'package:http/http.dart' as http;
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
  int followersCount = 0;
  int followingCount = 0;
  BuiltList<BuiltClub> Clubs;
  checkIsFollowing() async {
    if (_isMe == false) {
      BuiltUser user = Provider
          .of<UserData>(context, listen: false)
          .user;
      isFollowing =
      (await Provider.of<UserDatabaseApiService>(context, listen: false)
          .checkFollow(user.userId, user.username, _user.username))
          .body['value'];
    }
  }

  fetchUser() async {
    BuiltUser cuser = Provider.of<UserData>(context, listen: false).user;
    print(cuser.userId+'=='+widget.userId);
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
    final service = Provider.of<UserDatabaseApiService>(context);
    _user = cuser;
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

  _fetchAllClubs()async{
    final service = Provider.of<UserDatabaseApiService>(context,listen: false);
    Clubs = (await service.getMyHistoryClubs(widget.userId)).body.clubs;
  //  print("============LENGTH= ${Clubs.length}");

    //THIS IS RETURNING NULL
    //   setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print('isme=${_isMe}');
    return Scaffold(
      backgroundColor: Colors.amber,
      body: FutureBuilder(
          future: fetchUser(),
          builder: (context, snapshot) {
            if (_user == null ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Center(child:CircularProgressIndicator());
            }
            return SafeArea(
              child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      color: Colors.amber,
                    ),
                    AppBarWidget(), //AppBar
                    Positioned(
                      top: ((size.height / 14) + (size.height / 9) -
                          (size.height / 25)),
                      height: size.height -
                          ((size.height / 14) + (size.height / 9) -
                              (size.height / 25)),
                      width: size.width,
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(45.0),
                                topRight: Radius.circular(45.0)),

                          ),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: size.height / 20),
                              Text(
                                //  'Caroline Steele',
                                _user.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.width / 20,
                                  color: Colors.red[300],
                                ),
                              ),
                              SizedBox(height: size.height / 130,),
                              Text(
                                //'Music Composer',
                               '@${ _user.username}',
                                style: TextStyle(
                                    fontSize: size.width / 26,
                                    color: Colors.grey[400]
                                ),
                              ),
                              SizedBox(height: size.height / 50,),
                              Container(
                                margin: EdgeInsets.only(left: size.width / 20,
                                    right: size.width / 20),
                                child: Text(
                                  //'Hi my name is Carol and I am a music composer. Music is the greatest passion of my life',
                                  _user.bio,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: size.width / 26,
                                      color: Colors.grey[500]
                                  ),
                                ),
                              ),
                              SizedBox(height: size.height / 30,),
                              !_isMe?
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: <Widget>[
                                  ButtonTheme(
                                    minWidth: size.width / 3.5,
                                    child: RaisedButton(
                                      onPressed: () {},
                                      color: Colors.red[600],
                                      child: Text(
                                          'FOLLOW',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          )
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            18.0),
                                        side: BorderSide(
                                            color: Colors.red[600]),
                                      ),
                                      elevation: 0.0,
                                    ),
                                  ),
                                  ButtonTheme(
                                    minWidth: size.width / 3.5,
                                    child: RaisedButton(
                                      onPressed: () {},
                                      color: Colors.white,
                                      child: Text(
                                          'ADD FRIEND',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red[600],
                                          )
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            18.0),
                                        side: BorderSide(
                                            color: Colors.red[600]),
                                      ),
                                      elevation: 0.0,
                                    ),
                                  ),
                                ],
                              ):
                              ButtonTheme(
                                minWidth: size.width / 1.5,
                                child: RaisedButton(
                                  onPressed: () {},
                                  color: Colors.white,
                                  child: Text(
                                      'EDIT PROFILE',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red[600],
                                      )
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        18.0),
                                    side: BorderSide(
                                        color: Colors.red[600]),
                                  ),
                                  elevation: 0.0,
                                ),
                              ),
                              SizedBox(height: size.height / 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                //crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text(
                                          _user.friendsCount.toString()!='null'?_user.friendsCount.toString():'0',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600],
                                            fontSize: size.width / 20,
                                          )
                                      ),
                                      Text(
                                        'Friends',
                                        style: TextStyle(
                                          color: Colors.red[300],
                                          fontSize: size.width / 26,
                                        ),
                                      )
                                    ],
                                  ),
                                  VerticalDivider(
                                    color: Colors.grey[400],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                          _user.followerCount.toString()!='null'?_user.followerCount.toString():'0',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600],
                                            fontSize: size.width / 20,
                                          )
                                      ),
                                      Text(
                                        'Followers',
                                        style: TextStyle(
                                          color: Colors.red[300],
                                          fontSize: size.width / 26,
                                        ),
                                      )
                                    ],
                                  ),
                                  VerticalDivider(
                                    color: Colors.grey[400],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                          _user.followingCount.toString()!='null'?_user.followingCount.toString():'0',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600],
                                            fontSize: size.width / 20,
                                          )
                                      ),
                                      Text(
                                        'Following',
                                        style: TextStyle(
                                          color: Colors.red[300],
                                          fontSize: size.width / 26,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height / 30),
                              Container(
                                margin: EdgeInsets.only(left: size.width / 50,
                                    right: size.width / 50),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'My Clubs',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red[300]
                                      ),
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
                              SizedBox(height: size.height / 50,),
                              FutureBuilder(
                                  future:_fetchAllClubs(),
                                  builder: (context,snapshot){
                                    if (Clubs == null || snapshot.connectionState == ConnectionState.waiting) {
                                      return Center(child:CircularProgressIndicator());
                                    }
                                    return Carousel(Clubs: Clubs);
                                  })

                            ],
                          )

                      ),
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
                  ]
              ),
            );
            }
      )
    );
  }
}