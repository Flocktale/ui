import 'package:flocktale/Authentication/logOut.dart';
import 'package:flocktale/Models/basic_enums.dart';
import 'package:flocktale/Widgets/ProfileTopBackground.dart';
import 'package:flocktale/Widgets/socialRelationActions.dart';
import 'package:flocktale/customImage.dart';
import 'package:flocktale/pages/ClubSection.dart';
import 'package:flocktale/services/socialInteraction.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/pages/ContactsPage.dart';
import 'package:flocktale/pages/SocialRelationPage.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:provider/provider.dart';
import 'EditProfile.dart';
import '../Carousel.dart';
import 'package:built_collection/built_collection.dart';

import '../MinClub.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  ProfilePage({this.userId});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  BuiltUser _user;
  RelationIndexObject _userRelations;
  bool _isMe;

  BuiltList<BuiltClub> _Clubs;

  SocialInteraction _socialInteraction;

  void _updateProfileFromResponse(
      RelationActionResponse relationActionResponse) {
    if (relationActionResponse == null) return;
    _userRelations = relationActionResponse.relationIndexObj;

    _user = _user.rebuild((b) => b
      ..followerCount =
          relationActionResponse.followerCount ?? _user.followerCount
      ..followingCount =
          relationActionResponse.followingCount ?? _user.followingCount
      ..friendsCount =
          relationActionResponse.friendsCount ?? _user.friendsCount);

    setState(() {});
  }

  void _fetchUser() async {
    BuiltUser cuser = Provider.of<UserData>(context, listen: false).user;
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final authToken = Provider.of<UserData>(context, listen: false).authToken;

    print('${cuser.userId}==${widget.userId}');

    if (widget.userId == null || cuser.userId == widget.userId) {
      _isMe = true;
      _user = cuser;
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
    }

    setState(() {});
  }

  _fetchAllClubs() async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final authToken = Provider.of<UserData>(context, listen: false).authToken;

    _Clubs = (await service.getMyOrganizedClubs(
      userId: widget.userId,
      lastevaluatedkey: null,
      authorization: authToken,
    ))
        ?.body
        ?.clubs;
    setState(() {});
  }

  Future _inviteContacts() async => await Navigator.of(context)
      .push(MaterialPageRoute(builder: (_) => ContactsPage()));

  void _handleMenuButtons(String value) async {
    switch (value) {
      case 'Invite contacts':
        await _inviteContacts();
        break;

      case 'Settings':
        break;

      case 'Log Out':
        await logOutUser(context);
        break;
    }
  }

  void _navigateTo(Widget page) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
    _fetchUser();
    print(_user);
  }

  PopupMenuButton<String> _profileDropDownMenu() {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.menu_sharp,
        color: Colors.white,
      ),
      onSelected: _handleMenuButtons,
      itemBuilder: (BuildContext context) {
        return {'Invite contacts', 'Settings', 'Log Out'}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }

  Widget _editProfileButton() {
    Size size = MediaQuery.of(context).size;

    return ButtonTheme(
      minWidth: size.width / 1.5,
      child: RaisedButton(
        onPressed: () => _navigateTo(EditProfile(user: _user)),
        color: Colors.white,
        child: Text('EDIT PROFILE',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red[600],
            )),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.red[600]),
        ),
        elevation: 0.0,
      ),
    );
  }

  Widget _showProfileClubs() {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          margin:
              EdgeInsets.only(left: size.width / 50, right: size.width / 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Clubs',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent),
              ),
              InkWell(
                onTap: () => _navigateTo(
                  ClubSection(
                    ClubSectionType.User,
                    category: 'Clubs of ${_user.name ?? _user.username}',
                  ),
                ),
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: size.height / 50),
        _Clubs != null
            ? Carousel(Clubs: _Clubs)
            : Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Center(
                  child: Text(
                    "Loading..",
                    style: TextStyle(fontFamily: 'Lato', color: Colors.grey),
                  ),
                ),
              ),
      ],
    );
  }

  @override
  void initState() {
    this._socialInteraction = SocialInteraction(context, widget.userId,
        updateProfileFromResponse: _updateProfileFromResponse);
    _user = null;
    _fetchUser();
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
            ? Column(
                children: [
                  Expanded(
                    child: Stack(fit: StackFit.expand, children: <Widget>[
                      ProfileTopBackground(),
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
                          : Positioned(
                              right: 10,
                              top: 0,
                              child: _profileDropDownMenu(),
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
                            borderRadius: BorderRadius.vertical(
                              top: Radius.elliptical(
                                  size.width / 2, size.height / 20),
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: size.height / 20),
                              Text(
                                _user.name ?? _user.username,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.width / 20,
                                  color: Colors.redAccent,
                                ),
                              ),
                              SizedBox(height: size.height / 130),
                              Text(
                                '@${_user.username}',
                                style: TextStyle(
                                    fontSize: size.width / 26,
                                    color: Colors.grey[400]),
                              ),
                              SizedBox(height: size.height / 130),
                              Center(
                                child: Text(
                                  _user.tagline ?? '',
                                  style: TextStyle(
                                      fontFamily: "Lato",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                              ),
                              SizedBox(height: size.height / 50),
                              Container(
                                margin: EdgeInsets.only(
                                    left: size.width / 20,
                                    right: size.width / 20),
                                child: Text(
                                  _user.bio ?? '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: size.width / 26,
                                      color: Colors.grey[500]),
                                ),
                              ),
                              SizedBox(height: size.height / 30),
                              (_isMe == false)
                                  ? SocialRelationActions(_socialInteraction,
                                      _userRelations, size, _user.username)
                                  : _editProfileButton(),
                              SizedBox(height: size.height / 30),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                //crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () => _navigateTo(
                                      SocialRelationPage(
                                        initpos: 0,
                                        user: _user,
                                      ),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Text('${_user.friendsCount ?? 0}',
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
                                    onTap: () => _navigateTo(SocialRelationPage(
                                      initpos: 1,
                                      user: _user,
                                    )),
                                    child: Column(
                                      children: <Widget>[
                                        Text('${_user.followerCount ?? 0}',
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
                                    onTap: () => _navigateTo(
                                      SocialRelationPage(
                                        initpos: 2,
                                        user: _user,
                                      ),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Text('${_user.followingCount ?? 0}',
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
                              _showProfileClubs(),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: size.height / 14,
                        left: ((size.width / 2) - (size.width / 9)),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: size.height / 18,
                          child: CustomImage(
                            image: _user.avatar + '_large',
                          ),
                        ),
                      ),
                      Positioned(bottom: 0, child: MinClub())
                    ]),
                  ),
                ],
              )
            : Center(
                child: Container(
                    height: size.height / 10,
                    width: size.width / 5,
                    child: CircularProgressIndicator()),
              ),
      ),
    );
  }
}
