import 'package:flocktale/Models/basic_enums.dart';
import 'package:flocktale/Widgets/socialRelationActions.dart';
import 'package:flocktale/Widgets/customImage.dart';
import 'package:flocktale/pages/ClubSection.dart';
import 'package:flocktale/services/socialInteraction.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/pages/SocialRelationPage.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:provider/provider.dart';
import 'EditProfile.dart';
import '../Widgets/Carousel.dart';
import 'package:built_collection/built_collection.dart';

import '../Widgets/MinClub.dart';

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

    print('${cuser.userId}==${widget.userId}');

    if (widget.userId == null || cuser.userId == widget.userId) {
      _isMe = true;
      _user = cuser;
    } else {
      _isMe = false;
    }

    final fetchedUserData = (await service.getUserProfile(
      primaryUserId: cuser.userId,
      userId: widget.userId,
    ))
        .body;
    _user = fetchedUserData?.user;
    _userRelations = fetchedUserData?.relationIndexObj;

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

    _Clubs = (await service.getMyOrganizedClubs(
      userId: widget.userId,
      lastevaluatedkey: null,
    ))
        ?.body
        ?.clubs;
    setState(() {});
  }

  void _navigateTo(Widget page) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => page))
        .then((value) {
      _fetchUser();
    });
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
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              InkWell(
                onTap: () => _navigateTo(
                  ClubSection(
                    ClubSectionType.User,
                    category: 'Clubs of ${_user.username}',
                  ),
                ),
                child: Card(
                  shadowColor: Colors.white,
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 4),
                    child: Text(
                      'View All >',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: size.height / 50),
        _Clubs != null
            ? Carousel(Clubs: _Clubs, navigateTo: _navigateTo)
            //         ?CommunityCard()
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

  Widget _imageContainer() {
    return Container(
      height: 200,
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back_outlined),
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 96,
              width: 96,
              child: CustomImage(
                image: _user.avatar + '_large',
                radius: 16,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topRight,
              child: _isMe
                  ? InkWell(
                      onTap: () {
                        _navigateTo(EditProfile(user: _user));
                      },
                      splashColor: Colors.redAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'Edit',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                            Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 32,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ),
          ),
        ],
      ),
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

  Widget profileUI() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.black,
            Colors.black87,
            Colors.black,
            Colors.black,
          ],
          tileMode: TileMode.repeated, // repeats the gradient over the canvas
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 200 / 2, // half of image container
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(108, 36),
                  topRight: Radius.elliptical(108, 36),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(108, 36),
                    topRight: Radius.elliptical(108, 36),
                  ),
                ),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 48), // half of image size
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.elliptical(108, 36),
                      topRight: Radius.elliptical(108, 36),
                    ),
                  ),
                  child: profileDataColumn(),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _imageContainer(),
          ),
          Positioned(
            bottom: 0,
            child: MinClub((Widget page) async {
              await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => page));
              _fetchAllClubs();
            }),
          ),
        ],
      ),
    );
  }

  Widget _getSocialCountWidget({int count, String title, int initpos}) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () => _navigateTo(
        SocialRelationPage(
          initpos: initpos ?? 0,
          user: _user,
        ),
      ),
      child: Column(
        children: <Widget>[
          Text('${count ?? 0}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: size.width / 20,
              )),
          Text(
            title,
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: size.width / 26,
            ),
          )
        ],
      ),
    );
  }

  Widget profileDataColumn() {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[
        SizedBox(height: 12),
        Text(
          _user.name ?? '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.redAccent,
          ),
        ),
        SizedBox(height: size.height / 130),
        Text(
          '@${_user.username}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        SizedBox(height: size.height / 130),
        Center(
          child: Text(
            _user.tagline ?? '',
            style: TextStyle(
              fontFamily: "Lato",
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(height: size.height / 50),
        Container(
          margin:
              EdgeInsets.only(left: size.width / 20, right: size.width / 20),
          child: Text(
            _user.bio ?? '...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: size.width / 26,
              color: Colors.white70,
            ),
          ),
        ),
        SizedBox(height: size.height / 30),
        if (_isMe == false)
          SocialRelationActions(
              _socialInteraction, _userRelations, size, _user.username),
        SizedBox(height: size.height / 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _getSocialCountWidget(
                count: _user.friendsCount, title: 'Friends', initpos: 0),
            _getSocialCountWidget(
                count: _user.followerCount, title: 'Followers', initpos: 1),
            _getSocialCountWidget(
                count: _user.followingCount, title: 'Following', initpos: 2),
          ],
        ),
        SizedBox(height: 16),
        _showProfileClubs(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _user != null
            ? profileUI()
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
