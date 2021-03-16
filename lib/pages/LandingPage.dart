import 'package:chopper/chopper.dart';
import 'package:flocktale/Models/basic_enums.dart';
import 'package:flocktale/Widgets/introWidget.dart';
import 'package:flocktale/pages/ClubSection.dart';
import 'package:flocktale/pages/NotificationPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flocktale/Carousel.dart';
import 'package:flocktale/MinClub.dart';
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
    with AutomaticKeepAliveClientMixin {
  BuiltList<CategoryClubsList> Clubs;
  BuiltSearchClubs friendsClubs;
  BuiltSearchClubs followingUsersClubs;
  BuiltSearchClubs myCurrentClubs;

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

    if (this.mounted) setState(() {});
  }

  void _navigateTo(Widget page) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
    await _fetchAllClubs();
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
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Lato',
                fontWeight: FontWeight.w400,
                fontSize: size.width / 15,
              ),
            ),
            viewAll
                ? InkWell(
                    onTap: () =>
                        _navigateTo(ClubSection(type, category: title)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'View All',
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
        SizedBox(height: size.height / 50),
        Carousel(Clubs: clubs),
      ],
    );
  }

  Future _fetchAllClubs() async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    final cuser = Provider.of<UserData>(context, listen: false).user;

    getNotifications();

    await Future.wait([
      service.getClubsOfFriends(userId: cuser.userId, authorization: authToken),
      service.getClubsOfFollowings(
          userId: cuser.userId, authorization: authToken),
      service.getAllClubs(authorization: authToken),
    ]).then((values) {
      friendsClubs = values[0].body;
      followingUsersClubs = values[1].body;

      Clubs = (values[2] as Response<BuiltAllClubsList>).body.categoryClubs;

      if (this.mounted) {
        setState(() {});
      }
    });
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
                    _navigateTo(NotificationPage());
                  },
                ),
              ],
            ),
          ),
        ),
        body: Stack(
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
            Positioned(bottom: 0, child: MinClub()),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
