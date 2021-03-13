import 'package:flocktale/services/LocalStorage/FollowingDatabase.dart';
import 'package:flocktale/services/LocalStorage/InviteBox.dart';
import 'package:flutter/material.dart';
import 'package:flocktale/pages/LandingPage.dart';
import 'package:flocktale/pages/NewClub.dart';
import 'package:flocktale/pages/ProfilePage.dart';
import 'package:flocktale/pages/SearchPage.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/providers/webSocket.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
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
  //   const userId = '334cca61-58df-47b5-b6a5-c50302qab9d46';
  //   return Scaffold(
  //       body: Center(
  //           child: Container(
  //     padding: EdgeInsets.all(100),
  //     child: Column(children: [
  //       RaisedButton(
  //         child: Text('Restart App'),
  //         onPressed: () {
  //           Phoenix.rebirth(context);
  //         },
  //       ),
  //       RaisedButton(
  //         child: Text('Fetch List'),
  //         onPressed: () {
  //           String userId =
  //               Provider.of<UserData>(context, listen: false).user.userId;
  //               InviteBox.getNonSavedPhoneNumbers(context);
  //           // DBHelper.fetchList(userId, context);
  //           // Phoenix.rebirth(context);
  //         },
  //       ),
  //       RaisedButton(
  //         child: Text('Get Data'),
  //         onPressed: () {
  //           InviteBox.getData();

  //           // String userId =
  //           // Provider.of<UserData>(context, listen: false).user.userId;
  //           // DBHelper.getData();
  //           // Phoenix.rebirth(context);
  //         },
  //       ),
  //       RaisedButton(
  //         child: Text('Remove Following'),
  //         onPressed: () {
  //           // DBHelper.deleteFollowing(userId);
  //         },
  //       ),
  //       RaisedButton(
  //         child: Text('Add Following'),
  //         onPressed: () {
  //           // DBHelper.addFollowing(userId);
  //         },
  //       ),
  //       RaisedButton(
  //         child: Text('Check Following'),
  //         onPressed: () {
  //           // if(DBHelper.isFollowing(userId)){
  //           // print("YES");
  //           // }
  //           // else print("NO");
  //         },
  //       ),
  //       RaisedButton(
  //         child: Text('Delete Following'),
  //         onPressed: () {
  //           InviteBox.clearContactDatabase();

  //           //  DBHelper.printCurData();
  //         },
  //       ),
  //     ]),
  //   )));
      final cuser = Provider.of<UserData>(context, listen: false).user;
      List<Widget> _screens = [
        LandingPage(),
        NewClub(
          userId: cuser.userId,
        ),
        SearchPage(
          user: cuser,
        ),
        ProfilePage(userId: cuser.userId)
      ];

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
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: selectedIndex == 0 ? Colors.redAccent : Colors.grey,
              ),
              title: Text('Home',
                  style: TextStyle(
                      color: selectedIndex == 0 ? Colors.redAccent : Colors.grey,
                      fontFamily: 'Lato')),
              //backgroundColor: Colors.redAccent,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add,
                color: selectedIndex == 1 ? Colors.redAccent : Colors.grey,
              ),
              title: Text('New Club',
                  style: TextStyle(
                      color: selectedIndex == 1 ? Colors.redAccent : Colors.grey,
                      fontFamily: 'Lato')),
              //   backgroundColor: Colors.redAccent,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: selectedIndex == 2 ? Colors.redAccent : Colors.grey,
              ),
              title: Text('Search',
                  style: TextStyle(
                      color: selectedIndex == 2 ? Colors.redAccent : Colors.grey,
                      fontFamily: 'Lato')),
              //    backgroundColor: Colors.redAccent,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: selectedIndex == 3 ? Colors.redAccent : Colors.grey,
              ),
              title: Text('Profile',
                  style: TextStyle(
                      color: selectedIndex == 3 ? Colors.redAccent : Colors.grey,
                      fontFamily: 'Lato')),
              //   backgroundColor: Colors.redAccent,
            ),
          ],
        ),
      );
  }
}
