import 'dart:math';

import 'package:chopper/chopper.dart';
import 'package:flocktale/Models/basic_enums.dart';
import 'package:flocktale/Widgets/CommunityCard.dart';
import 'package:flocktale/Widgets/introWidget.dart';
import 'package:flocktale/pages/ClubSection.dart';
import 'package:flocktale/pages/NotificationPage.dart';
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
                  fontWeight: FontWeight.w500,
                  fontSize: size.width / 18,
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
                          color: Colors.grey[600],
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

    while (true) {
      final diff = DateTime.now()
          .difference(_clubFetchedTime ?? DateTime.now())
          .inSeconds;
      if (diff < 30) {
        await Future.delayed(Duration(seconds: max(30 - diff, 10)));
      } else {
        await _fetchAllClubs();
      }
    }
  }

  Widget tabPage(int index){
    Size size = MediaQuery.of(context).size;
    if(index==0){
      return Stack(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: RefreshIndicator(
              onRefresh: () => _fetchAllClubs(),
              child: ListView(
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
          Positioned(bottom: 0, child: MinClub(_navigateTo)),
        ],
      );
    }
    return Stack(
      children: [
        Container(
          // margin: EdgeInsets.all(10),
          child: RefreshIndicator(
            onRefresh: (){
              return;
            },
            child: ListView.builder(
              itemCount: 20,
                itemBuilder: (context,index){
                  return CommunityCard();
            }),
          ),
        ),
        Positioned(bottom: 0, child: MinClub(_navigateTo)),
      ],
    );
  }

  @override
  void initState() {
    _infinteClubFetching();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          // appBar: PreferredSize(
          //   preferredSize: Size.fromHeight(50.0),
          //   child: Material(
          //     elevation: 1,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: <Widget>[
          //         IconButton(
          //           icon: Image.asset('assets/images/inverted_logo.png'),
          //           onPressed: null,
          //         ),
          //         Text(
          //           'Flocktale',
          //           style: TextStyle(
          //             fontWeight: FontWeight.bold,
          //             color: Colors.redAccent,
          //             fontSize: size.width / 20,
          //             letterSpacing: 0.0,
          //             fontFamily: 'Montserrat',
          //           ),
          //         ),
          //         IconButton(
          //           icon: hasNewNotifications == false
          //               ? Icon(Icons.notifications_none_outlined)
          //               : Icon(
          //                   Icons.notifications_active,
          //                   color: Colors.redAccent,
          //                 ),
          //           onPressed: () {
          //             hasNewNotifications = false;
          //             setState(() {});
          //             _navigateTo(NotificationPage());
          //           },
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          appBar: AppBar(
            leading: IconButton(
                    icon: Image.asset('assets/images/inverted_logo.png'),
                    onPressed: null,
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
                          ? Icon(Icons.notifications_none_outlined,color: Colors.black,)
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
              labelColor: Colors.black,
              labelStyle:
              TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold),
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Colors.black),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Text(
                  "CLUBS",
                  style: TextStyle(
                      fontFamily: "Lato",
                      letterSpacing: 2.0
                  ),
                ),
                Text(
                  "COMMUNITIES",
                  style: TextStyle(
                      fontFamily: "Lato",
                      letterSpacing: 2.0
                  ),
                )
              ],
            ),
            backgroundColor: Colors.white,
          ),
          body: TabBarView(
              controller: _tabController, children: [tabPage(0), tabPage(1)]),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
