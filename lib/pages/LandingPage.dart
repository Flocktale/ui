import 'dart:math';

import 'package:chopper/chopper.dart';
import 'package:flocktale/Models/basic_enums.dart';
import 'package:flocktale/Widgets/CommunityCard.dart';
import 'package:flocktale/Widgets/customImage.dart';
import 'package:flocktale/Widgets/introWidget.dart';
import 'package:flocktale/pages/ClubSection.dart';
import 'package:flocktale/pages/NewClub.dart';
import 'package:flocktale/pages/NewsTab.dart';
import 'package:flocktale/pages/NotificationPage.dart';
import 'package:flocktale/pages/ProfilePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flocktale/Widgets/Carousel.dart';
import 'package:flocktale/Widgets/MinClub.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:provider/provider.dart';
import 'package:built_collection/built_collection.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  BuiltList<CategoryClubsList> Clubs;
  BuiltSearchClubs friendsClubs;
  BuiltSearchClubs followingUsersClubs;
  BuiltSearchClubs myCurrentClubs;

  BuiltNotificationList notificationList;
  bool hasNewNotifications = false;

  DateTime _clubFetchedTime = DateTime.now();
  TabController _tabController;

  final Color shadow = Color(0xFF191818);

  Map<String, dynamic> communityMap = {
    'data': null,
    'isLoading': true,
  };

  Future<void> _fetchCommunities() async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    communityMap['data'] = (await service.getAllCommunities(
            lastevaluatedkey:
                (communityMap['data'] as BuiltCommunityList)?.lastevaluatedkey))
        .body;
    print(communityMap['data']);
    communityMap['isLoading'] = false;
    setState(() {});
  }

  void _fetchMoreCommunities() async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final lastEvaluatedKey =
        (communityMap['data'] as BuiltCommunityList)?.lastevaluatedkey;
    if (lastEvaluatedKey != null) {
      await _fetchCommunities();
    } else {
      await Future.delayed(Duration(milliseconds: 200));
      communityMap['isLoading'] = false;
    }
    setState(() {});
  }

  Widget dummyCard() {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.fromLTRB(0, 15, 15, 0),
      //width: 200.0,
      width: 150,
      child: Card(
        elevation: 10,
        shadowColor: shadow.withOpacity(0.2),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {},
          child: Stack(
            children: <Widget>[
              Container(
                height: 100,
                width: size.width,
                child: Image.asset(
                  "assets/images/logo.png",
                  //      height: 130,
                  //      width: 200,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                top: 100,
                left: 5,
                child: Text(
                  "Title",
                  style: TextStyle(
                      fontFamily: 'Lato', fontWeight: FontWeight.bold),
                ),
              ),
              Positioned(
                top: 120,
                left: 5,
                child: Row(children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/images/logo.png"),
                    radius: 10,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Creator name",
                    style: TextStyle(
                        fontFamily: "Lato",
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Colors.redAccent),
                  ),
                ]),
              ),
              Positioned(
                // margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                bottom: 5,
                left: 5,
                child: Text(
                  "10 Clubs",
                  style: TextStyle(
                      fontFamily: "Lato",
                      fontSize: size.width / 40,
                      color: Colors.grey[700]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getNotifications() async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final cuser = Provider.of<UserData>(context, listen: false).user;
    BuiltNotificationList tempNotificationList =
        (await service.getNotifications(
      userId: cuser.userId,
      lastevaluatedkey: null,
    ))
            .body;
    if (notificationList != null &&
        tempNotificationList.notifications.length >
            notificationList.notifications.length) hasNewNotifications = true;
    notificationList = tempNotificationList;

    if (this.mounted) setState(() {});
  }

  Future<void> _navigateTo(Widget page) async {
    // when user is on another page, then no need to keep fetching clubs
    _clubFetchedTime = null;

    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => page))
        .then((value) {
      setState(() {});
      _fetchAllClubs();
    });
  }

  Widget sectionHeading({
    String title,
    bool viewAll = false,
    ClubSectionType type,
    BuiltList<BuiltClub> clubs,
  }) {
    assert(type != null,
        'viewAllNavigationPage must not be null when viewAll is true and vice versa');

    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: size.height / 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Lato',
                 // fontWeight: FontWeight.w500,
                  fontSize: size.width / 18,
                  color: Colors.redAccent
                ),
              ),
            ),
            viewAll
                ? InkWell(
                    onTap: () =>
                        _navigateTo(ClubSection(type, category: title)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'View All >',
                        style: TextStyle(
                          fontSize: size.width / 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
        Carousel(
          Clubs: clubs,
          navigateTo: _navigateTo,
        ),
      ],
    );
  }

  Future _fetchAllClubs([bool initiating = false]) async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final cuser = Provider.of<UserData>(context, listen: false).user;

    if (initiating) {
      getNotifications();
    }
    _clubFetchedTime = DateTime.now();

    await Future.wait([
      service.getClubsOfFriends(userId: cuser.userId),
      service.getClubsOfFollowings(userId: cuser.userId),
      service.getAllClubs(),
    ]).then((values) {
      friendsClubs = values[0].body;
      followingUsersClubs = values[1].body;

      Clubs = (values[2] as Response<BuiltAllClubsList>).body.categoryClubs;

      if (this.mounted) {
        setState(() {});
      }
    });
  }

  _infinteClubFetching() async {
    await _fetchAllClubs(true);
//TODO: uncomment this
    // while (true) {
    //   final diff = DateTime.now()
    //       .difference(_clubFetchedTime ?? DateTime.now())
    //       .inSeconds;
    //   if (diff < 30) {
    //     await Future.delayed(Duration(seconds: max(30 - diff, 10)));
    //   } else {
    //     await _fetchAllClubs();
    //   }
    // }
  }

  Widget tabPage(int index) {
    Size size = MediaQuery.of(context).size;
    if (index == 0) {
      return Stack(
        children: [
          Container(
          //  color: Colors.black,
             margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: RefreshIndicator(
              backgroundColor: Colors.black87,
              color: Colors.redAccent,
              onRefresh: () => _fetchAllClubs(),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  SizedBox(height: 20),
                  FittedBox(child: IntroWidget()),
                  if ((myCurrentClubs?.clubs?.isNotEmpty ?? false))
                    sectionHeading(
                      title: "Your active Clubs",
                      viewAll: false,
                      clubs: myCurrentClubs.clubs,
                    ),
                  if ((friendsClubs?.clubs?.isNotEmpty ?? false))
                    sectionHeading(
                      title: "From your Friends",
                      viewAll: true,
                      type: ClubSectionType.Friend,
                      clubs: friendsClubs.clubs,
                    ),
                  if ((followingUsersClubs?.clubs?.isNotEmpty ?? false))
                    sectionHeading(
                      title: "From the people you follow",
                      viewAll: true,
                      type: ClubSectionType.Following,
                      clubs: followingUsersClubs.clubs,
                    ),
                  Clubs != null
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: Clubs?.length ?? 0,
                          itemBuilder: (context, index) {
                            return Clubs[index].clubs.isNotEmpty
                                ? sectionHeading(
                                    title: Clubs[index].category,
                                    viewAll: true,
                                    type: ClubSectionType.Category,
                                    clubs: Clubs[index].clubs,
                                  )
                                : Container();
                          },
                        )
                      : Container(
                          child: Center(
                            child: Text(
                              "Loading...",
                              style: TextStyle(
                                  fontFamily: "Lato", color: Colors.grey),
                            ),
                          ),
                        ),
                  SizedBox(height: size.height / 10)
                ],
              ),
            ),
          ),
          Positioned(
            right:size.width/20,
            bottom: size.height/8,
            child: InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (_)=>NewClub()));
              },
              child: FloatingActionButton(
                backgroundColor: Colors.redAccent,
                child: Icon(
                  Icons.add
                ),
              ),
            ),
          ),
          Positioned(bottom: 0, child: MinClub(_navigateTo)),
        ],
      );
    } else if (index == 1) {
      final communities =
          (communityMap['data'] as BuiltCommunityList)?.communities;
      final bool isLoading = communityMap['isLoading'];
      print(communities);
      final listLength = (communities?.length ?? 0) + 1;
      return Stack(
        children: [
          Container(
            // margin: EdgeInsets.all(10),
            child: RefreshIndicator(
              onRefresh: () {
                return;
              },
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                    _fetchMoreCommunities();
                    communityMap['isLoading'] = true;
                  }
                  return true;
                },
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: listLength,
                    itemBuilder: (context, index) {
                      if (index == listLength - 1) {
                        if (isLoading)
                          return Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        else
                          return Container();
                      }
                      final _community = communities[index];
                      return CommunityCard(
                        community: _community,
                      );
                    }),
              ),
            ),
          ),
          Positioned(bottom: 0, child: MinClub(_navigateTo)),
        ],
      );
    } else if (index == 2) {
      return NewsTab();
    } else {
      return Stack(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: RefreshIndicator(
              onRefresh: () => _fetchAllClubs(),
              child: ListView(
                children: [
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "FASHION",
                            style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w500,
                                fontSize: size.width / 18,
                                color: Color(0xfff74040)),
                          ),
                          Text(
                            "View All",
                            style: TextStyle(
                              fontSize: size.width / 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          )
                        ],
                      ),
                      Container(
                        height: 185,
                        child: ListView.builder(
                          itemCount: 15,
                          scrollDirection: Axis.horizontal,
                          // children: <Widget>[
                          itemBuilder: (context, index) {
                            return dummyCard();
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "ELECTRONICS",
                            style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w500,
                                fontSize: size.width / 18,
                                color: Color(0xfff74040)),
                          ),
                          Text(
                            "View All",
                            style: TextStyle(
                              fontSize: size.width / 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          )
                        ],
                      ),
                      Container(
                        height: 185,
                        child: ListView.builder(
                          itemCount: 15,
                          scrollDirection: Axis.horizontal,
                          // children: <Widget>[
                          itemBuilder: (context, index) {
                            return dummyCard();
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(height: size.height / 10)
                ],
              ),
            ),
          ),
          Positioned(bottom: 0, child: MinClub(_navigateTo)),
        ],
      );
    }
  }

  @override
  void initState() {
    _infinteClubFetching();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    super.initState();
    _fetchCommunities();
  }

  @override
  Widget build(BuildContext context) {
    final cuser = Provider.of<UserData>(context,listen:false).user;
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: DefaultTabController(
        initialIndex: 0,
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap:(){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        ProfilePage(
                          userId: cuser.userId,
                        )
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: CustomImage(
                    image: cuser.avatar,
                  radius: size.width/10,
                ),
              ),
            ),
            title: Text(
              'Flocktale',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
                fontSize: size.width / 20,
                letterSpacing: 0.0,
                fontFamily: 'Montserrat',
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: hasNewNotifications == false
                    ? Icon(
                        Icons.notifications_none_outlined,
                        color: Colors.redAccent,
                      )
                    : Icon(
                        Icons.notifications_active,
                        color: Colors.redAccent,
                      ),
                onPressed: () {
                  hasNewNotifications = false;
                  setState(() {});
                  _navigateTo(NotificationPage());
                },
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              unselectedLabelColor: Colors.grey[700],
              labelColor: Colors.redAccent,
              labelStyle:
                  TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold),
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Colors.black),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Text(
                  "CLUBS",
                  style: TextStyle(fontFamily: "Lato", letterSpacing: 2.0),
                ),
                Text(
                  "COMMUNITIES",
                  style: TextStyle(fontFamily: "Lato", letterSpacing: 2.0),
                ),
                Text(
                  "NEWS",
                  style: TextStyle(fontFamily: "Lato", letterSpacing: 2.0),
                ),
                Text(
                  "ECOMMERCE",
                  style: TextStyle(fontFamily: "Lato", letterSpacing: 2.0),
                )
              ],
            ),
          ),
          body: TabBarView(
              controller: _tabController,
              children: [tabPage(0), tabPage(1), tabPage(2), tabPage(3)]),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
