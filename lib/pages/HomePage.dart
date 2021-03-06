import 'package:flocktale/Widgets/HomePageTopSection.dart';
import 'package:flocktale/Widgets/MinClub.dart';
import 'package:flocktale/Widgets/HomeFAB.dart';
import 'package:flocktale/Widgets/homePageDrawer.dart';
import 'package:flocktale/Widgets/homePageTabBar.dart';
import 'package:flocktale/pages/LandingPages/LandingPageClubs.dart';
import 'package:flocktale/pages/LandingPages/LandingPageCommunities.dart';
import 'package:flocktale/pages/LandingPages/LandingPageNewsArticles.dart';
import 'package:flocktale/services/DBHelper.dart';
import 'package:flocktale/services/LocalStorage/FollowingDatabase.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController _tabController;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _navigateTo(Widget page) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => page))
        .then((value) {
      setState(() {});
    });
  }

  @override
  initState() {
    super.initState();

    String userId = Provider.of<UserData>(context, listen: false).user.userId;
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);

    DBHelper.fetchList(userId, context);
    FollowingDatabase.fetchList(userId, context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.black,
          floatingActionButton: HomeFAB(this._tabController),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          drawer: HomePageDrawer(),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    HomePageTopSection(
                      scaffoldKey: _scaffoldKey,
                      navigateTo: _navigateTo,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: HomePageTabBar(_tabController),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          LandingPageClubs(),
                          LandingPageCommunities(),
                          LandingPageNewsArticles(),
                          // LandingPageCommerceProducts(),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(bottom: 0, child: MinClub(_navigateTo)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
