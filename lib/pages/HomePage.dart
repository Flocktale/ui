import 'package:flocktale/services/LocalStorage/FollowingDatabase.dart';
import 'package:flutter/material.dart';
import 'package:flocktale/pages/LandingPage.dart';
import 'package:flocktale/pages/NewClub.dart';
import 'package:flocktale/pages/ProfilePage.dart';
import 'package:flocktale/pages/SearchPage.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/providers/webSocket.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController = PageController();

  int selectedIndex = 0;
  void _onPageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  initState() {
    super.initState();
    MySocket a = Provider.of<MySocket>(context, listen: false);

    String userId = Provider.of<UserData>(context, listen: false).user.userId;

    // TODO: UNCOMMENT THIS
    // DBHelper.fetchList(userId, context);
    FollowingDatabase.fetchList(userId, context);
    if (a.userId != userId) a.update(userId);
  }

  @override
  Widget build(BuildContext context) {
    final cuser = Provider.of<UserData>(context, listen: false).user;
    List<Widget> _screens = [
      LandingPage(),
      NewClub(),
      SearchPage(
        user: cuser,
      ),
      ProfilePage(userId: cuser.userId)
    ];

    BottomNavigationBarItem navItem(
            String title, IconData iconData, int index) =>
        BottomNavigationBarItem(
          icon: Icon(
            iconData,
            color: selectedIndex == index ? Colors.redAccent : Colors.grey,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: selectedIndex == index ? Colors.redAccent : Colors.grey,
              fontFamily: 'Lato',
            ),
          ),
          //backgroundColor: Colors.redAccent,
        );

    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          navItem('Home', Icons.home, 0),
          navItem('Create', Icons.add, 1),
          navItem('Search', Icons.search, 2),
          navItem('Profile', Icons.person, 3),
        ],
      ),
    );
  }
}
