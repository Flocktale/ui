import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flocktale/Carousel.dart';
import 'package:flocktale/MinClub.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:provider/provider.dart';
import 'package:built_collection/built_collection.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'ClubsByCategory.dart';
import 'ClubsByRelation.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with AutomaticKeepAliveClientMixin {
  BuiltList<CategoryClubsList> Clubs;
  BuiltSearchClubs friendsClubs;
  BuiltSearchClubs followingUsersClubs;
  BuiltSearchClubs myCurrentClubs;
  List<String> Category = [
    'Entrepreneurship',
    'Education',
    'Comedy',
    'Travel',
    'Society',
    'Health',
    'Finance',
    'Sports',
    'Other'
  ];

  BuiltNotificationList notificationList;
  bool hasNewNotifications = false;
  Future getNotifications() async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final cuser = Provider.of<UserData>(context, listen: false).user;
    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    BuiltNotificationList tempNotificationList =
        (await service.getNotifications(
      userId: cuser.userId,
      lastevaluatedkey: null,
      authorization: authToken,
    ))
            .body;
    if (notificationList != null &&
        tempNotificationList.notifications.length >
            notificationList.notifications.length) hasNewNotifications = true;
    notificationList = tempNotificationList;
  }

  Future _fetchAllClubs() async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    final cuser = Provider.of<UserData>(context, listen: false).user;
    friendsClubs = (await service.getClubsOfFriends(
            userId: cuser.userId, authorization: authToken))
        .body;
    followingUsersClubs = (await service.getClubsOfFollowings(
            userId: cuser.userId, authorization: authToken))
        .body;
    myCurrentClubs = (await service.getMyCurrentAndUpcomingClubs(
            userId: cuser.userId, authorization: authToken))
        .body;
    Clubs = (await service.getAllClubs(authorization: authToken))
        .body
        .categoryClubs;
    await getNotifications();
    setState(() {});
  }

  @override
  void initState() {
    _fetchAllClubs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: Material(
              elevation: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.camera_alt_outlined), onPressed: null),
                  Text(
                    'Flocktale',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                  IconButton(
                    icon: hasNewNotifications == false
                        ? Icon(Icons.notifications_none_outlined)
                        : Icon(
                            Icons.notifications_active,
                            color: Colors.redAccent,
                          ),
                    onPressed: () {
                      hasNewNotifications = false;
                      setState(() {});
                      Navigator.of(context)
                          .pushNamed('/notificationPage')
                          .then((value) => setState(() {}));
                    },
                  ),
                ],
              ),
            ),
          ),
          body: Stack(children: [
            Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: RefreshIndicator(
                  onRefresh: _fetchAllClubs,
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 250.0,
                              height: 80,
                              child: TypewriterAnimatedTextKit(
                                isRepeatingAnimation: false,
                                speed: const Duration(milliseconds: 125),
                                onTap: () {
                                  print("Tap Event");
                                },
                                text: [
                                  'Join your \nfavourite clubs.',
                                ],
                                textStyle: TextStyle(
                                    fontSize: 30.0,
                                    fontFamily: "Lato",
                                    fontWeight: FontWeight.w300,
                                    color: Colors.red),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.redAccent, width: 10)),
                              child: Image.asset("assets/gifs/LandingPage.gif",
                                  width: 80, height: 80),
                            )
                          ],
                        ),
                      ),
                      myCurrentClubs != null && myCurrentClubs.clubs.length > 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: 1,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: size.height / 30),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Your active Clubs",
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.w400,
                                            fontSize: size.width / 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: size.height / 50),
                                    Carousel(Clubs: myCurrentClubs.clubs),
                                  ],
                                );
                              })
                          : Container(),
                      friendsClubs != null && friendsClubs.clubs.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: 1,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: size.height / 30),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (_) =>
                                                        ClubsByRelation(
                                                          userId: Provider.of<
                                                                      UserData>(
                                                                  context,
                                                                  listen: false)
                                                              .userId,
                                                          type: 0,
                                                        )))
                                                .then(
                                                    (value) => setState(() {}));
                                          },
                                          child: Text(
                                            "From your Friends",
                                            style: TextStyle(
                                              fontFamily: 'Lato',
                                              fontWeight: FontWeight.w400,
                                              fontSize: size.width / 15,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (_) =>
                                                        ClubsByRelation(
                                                          userId: Provider.of<
                                                                      UserData>(
                                                                  context,
                                                                  listen: false)
                                                              .userId,
                                                          type: 0,
                                                        )))
                                                .then(
                                                    (value) => setState(() {}));
                                          },
                                          child: Text(
                                            'View All',
                                            style: TextStyle(
                                              fontSize: size.width / 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: size.height / 50),
                                    Carousel(Clubs: friendsClubs.clubs),
                                  ],
                                );
                              })
                          : Container(),
                      followingUsersClubs != null &&
                              followingUsersClubs.clubs.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: 1,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: size.height / 30),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (_) =>
                                                        ClubsByRelation(
                                                          userId: Provider.of<
                                                                      UserData>(
                                                                  context,
                                                                  listen: false)
                                                              .userId,
                                                          type: 1,
                                                        )))
                                                .then(
                                                    (value) => setState(() {}));
                                          },
                                          child: Text(
                                            "From the people you follow",
                                            style: TextStyle(
                                              fontFamily: 'Lato',
                                              fontWeight: FontWeight.w400,
                                              fontSize: size.width / 15,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (_) =>
                                                        ClubsByRelation(
                                                          userId: Provider.of<
                                                                      UserData>(
                                                                  context,
                                                                  listen: false)
                                                              .userId,
                                                          type: 1,
                                                        )))
                                                .then(
                                                    (value) => setState(() {}));
                                          },
                                          child: Text(
                                            'View All',
                                            style: TextStyle(
                                              fontSize: size.width / 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: size.height / 50),
                                    Carousel(Clubs: followingUsersClubs.clubs),
                                  ],
                                );
                              })
                          : Container(),
                      Clubs != null
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: Category.length,
                              itemBuilder: (context, index) {
                                return Clubs[index].clubs.isNotEmpty
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(height: size.height / 30),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                          builder: (_) =>
                                                              ClubsByCategory(
                                                                category: Clubs[
                                                                        index]
                                                                    .category,
                                                              )))
                                                      .then((value) =>
                                                          setState(() {}));
                                                },
                                                child: Text(
                                                  Clubs[index].category,
                                                  style: TextStyle(
                                                    fontFamily: 'Lato',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: size.width / 15,
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                          builder: (_) =>
                                                              ClubsByCategory(
                                                                category: Clubs[
                                                                        index]
                                                                    .category,
                                                              )))
                                                      .then((value) =>
                                                          setState(() {}));
                                                },
                                                child: Text(
                                                  'View All',
                                                  style: TextStyle(
                                                    fontSize: size.width / 30,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: size.height / 50),
                                          Carousel(Clubs: Clubs[index].clubs),
                                        ],
                                      )
                                    : Container(
                                        // child: Center(
                                        //   child: Text(
                                        //     "No clubs available right now",
                                        //     style: TextStyle(
                                        //       fontFamily: "Lato",
                                        //       fontWeight: FontWeight.bold,
                                        //       color: Colors.grey
                                        //     ),
                                        //   ),
                                        // ),
                                        );
                              })
                          : Container(
                              child: Center(
                                  child: Text(
                                "Loading...",
                                style: TextStyle(
                                    fontFamily: "Lato", color: Colors.grey),
                              )),
                            ),
                      SizedBox(
                        height: size.height / 10,
                      )
                    ],
                  ),
                )),
            Positioned(bottom: 0, child: MinClub())
          ])),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
