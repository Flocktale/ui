import 'package:flutter/material.dart';
import 'package:mootclub_app/Models/sharedPrefKey.dart';
import 'package:mootclub_app/pages/LandingPage.dart';
import 'package:mootclub_app/pages/NewClub.dart';
import 'package:mootclub_app/pages/ProfilePage.dart';
import 'package:mootclub_app/pages/SearchPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController = PageController();
  List<Widget> _screens = [
    LandingPage(),NewClub(),SearchPage(),ProfilePage(userId:SharedPrefKeys.USERID)
  ];
  int selectedIndex = 0;
  void _onPageChanged(int index){
    setState(() {
      selectedIndex = index;
    });
  }
  void _onItemTapped(int selectedIndex){
    _pageController.jumpToPage(selectedIndex);
  }
  @override
  Widget build(BuildContext context) {
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
            icon: Icon(Icons.home,color: selectedIndex==0?Colors.amber:Colors.grey,),
            title: Text('Home',style: TextStyle(color: selectedIndex==0?Colors.amber:Colors.grey,)),
            //backgroundColor: Colors.amber,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add,color: selectedIndex==1?Colors.amber:Colors.grey,),
            title: Text('New Club',style: TextStyle(color: selectedIndex==1?Colors.amber:Colors.grey,)),
         //   backgroundColor: Colors.amber,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search,color: selectedIndex==2?Colors.amber:Colors.grey,),
            title: Text('Search',style: TextStyle(color: selectedIndex==2?Colors.amber:Colors.grey,)),
        //    backgroundColor: Colors.amber,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,color: selectedIndex==3?Colors.amber:Colors.grey,),
            title: Text('Profile',style: TextStyle(color: selectedIndex==3?Colors.amber:Colors.grey,)),
         //   backgroundColor: Colors.amber,
          ),
        ],
      ),
    );
  }
}
