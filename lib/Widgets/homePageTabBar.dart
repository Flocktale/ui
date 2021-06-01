import 'package:flutter/material.dart';

class HomePageTabBar extends StatelessWidget {
  final TabController tabController;

  HomePageTabBar(this.tabController);

  Text _tabText(String title) => Text(
        title,
        style: TextStyle(fontFamily: "Lato", letterSpacing: 2.0),
      );

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      isScrollable: true,
      unselectedLabelColor: Colors.white54,
      labelColor: Colors.redAccent,
      labelStyle: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold),
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: Colors.white, width: 1),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      tabs: [
        _tabText("CLUBS"),
        _tabText("COMMUNITIES"),
        _tabText("NEWS"),
        // _tabText("ECOMMERCE"),
      ],
    );
  }
}
