import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:mootclub_app/pages/LandingPage.dart';
import 'package:mootclub_app/pages/NewClub.dart';
import 'package:mootclub_app/pages/ProfilePage.dart';
import 'package:mootclub_app/pages/SearchPage.dart';
import 'package:mootclub_app/providers/userData.dart';
import 'package:mootclub_app/providers/webSocket.dart';
import 'package:mootclub_app/services/DBHelper.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';
import 'package:mootclub_app/services/deviceStorage.dart';
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
    // DeviceStorage().fetchList(userId,context);
    DBHelper.fetchList(userId, context);

    // for(int i=0;i<100;i++){
    // print("$userId $i");
    // }
    if (a.userId != userId) a.update(userId);
  }

  @override
  Widget build(BuildContext context) {
    const userId = '334cca61-58df-47b5-b6a5-c50302qab9d46';

    DBHelper.addFollowing(userId);
    return Scaffold(
        body: Center(
            child: Container(
              padding: EdgeInsets.all(100),
      child: Column(children: [
        RaisedButton(
          child: Text('Restart App'),
          onPressed: () {
            Phoenix.rebirth(context);
          },
        ),
        RaisedButton(
          child: Text('Fetch List'),
          onPressed: () {
            String userId =
                Provider.of<UserData>(context, listen: false).user.userId;
            DBHelper.fetchList(userId, context);
            // Phoenix.rebirth(context);
          },
        ),
        RaisedButton(
          child: Text('Get Data'),
          onPressed: () {
            // String userId =
                // Provider.of<UserData>(context, listen: false).user.userId;
            DBHelper.getData();
            // Phoenix.rebirth(context);
          },
        ),
         RaisedButton(
          child: Text('Remove Following'),
          onPressed: () {
            DBHelper.deleteFollowing(userId);
          },
        ),
         RaisedButton(
          child: Text('Add Following'),
          onPressed: () {
            DBHelper.addFollowing(userId);
          },
        ),
         RaisedButton(
          child: Text('Check Following'),
          onPressed: () {
            if(DBHelper.isFollowing(userId)){
              print("YES");
            }
            else print("NO");
          },
        ),
        RaisedButton(
          child: Text('Print Following'),
          onPressed: () {
           DBHelper.printCurData();
          },
        ),
      ]),
    )));
    // return CircularProgressIndicator();
    // final cuser = Provider.of<UserData>(context, listen: false).user;
    // List<Widget> _screens = [
    //   LandingPage(),
    //   NewClub(
    //     userId: cuser.userId,
    //   ),
    //   SearchPage(
    //     user: cuser,
    //   ),
    //   ProfilePage(userId: cuser.userId)
    // ];

    // return Scaffold(
    //   body: PageView(
    //     controller: _pageController,
    //     children: _screens,
    //     onPageChanged: _onPageChanged,
    //     physics: NeverScrollableScrollPhysics(),
    //   ),
    //   bottomNavigationBar: BottomNavigationBar(
    //     onTap: _onItemTapped,
    //     type: BottomNavigationBarType.fixed,
    //     items: [
    //       BottomNavigationBarItem(
    //         icon: Icon(
    //           Icons.home,
    //           color: selectedIndex == 0 ? Colors.redAccent : Colors.grey,
    //         ),
    //         title: Text('Home',
    //             style: TextStyle(
    //                 color: selectedIndex == 0 ? Colors.redAccent : Colors.grey,
    //                 fontFamily: 'Lato')),
    //         //backgroundColor: Colors.redAccent,
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(
    //           Icons.add,
    //           color: selectedIndex == 1 ? Colors.redAccent : Colors.grey,
    //         ),
    //         title: Text('New Club',
    //             style: TextStyle(
    //                 color: selectedIndex == 1 ? Colors.redAccent : Colors.grey,
    //                 fontFamily: 'Lato')),
    //         //   backgroundColor: Colors.redAccent,
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(
    //           Icons.search,
    //           color: selectedIndex == 2 ? Colors.redAccent : Colors.grey,
    //         ),
    //         title: Text('Search',
    //             style: TextStyle(
    //                 color: selectedIndex == 2 ? Colors.redAccent : Colors.grey,
    //                 fontFamily: 'Lato')),
    //         //    backgroundColor: Colors.redAccent,
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(
    //           Icons.person,
    //           color: selectedIndex == 3 ? Colors.redAccent : Colors.grey,
    //         ),
    //         title: Text('Profile',
    //             style: TextStyle(
    //                 color: selectedIndex == 3 ? Colors.redAccent : Colors.grey,
    //                 fontFamily: 'Lato')),
    //         //   backgroundColor: Colors.redAccent,
    //       ),
    //     ],
    //   ),
    // );
  }
}
