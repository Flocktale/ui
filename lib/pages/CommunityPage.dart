import 'package:flocktale/Widgets/customImage.dart';
import 'package:flutter/material.dart';
class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> with TickerProviderStateMixin{
  TabController _tabController;
  bool _isOwner = true;

  Widget tabPage(int index){
    final size = MediaQuery.of(context).size;
    if(index==0){
      return Column(
        children: [
          Container(
            height: size.height/6,
            width: size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/logo.png"),
                    fit: BoxFit.cover
                )
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(size.width/20, size.width/20, size.width/20, size.width/20),
            color: Colors.grey[200],
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(
                    "assets/images/logo.png",
                  ),
                  radius: size.width/15,
                ),
                SizedBox(
                  width: size.width/20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "COMMUNITY NAME",
                      style: TextStyle(
                          fontFamily: "Lato",
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      "Creator name",
                      style: TextStyle(
                          fontFamily: "Lato",
                          color: Colors.grey
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
              height: size.height/8,
              color: Colors.grey[200],
              padding: EdgeInsets.fromLTRB(0, 0, 0, size.width/20),
              child: ListView.builder(
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context,index){
                    return Container(
                      margin:EdgeInsets.fromLTRB(size.width/20,0,0,0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage("assets/images/logo.png"),
                            radius: size.width/15,
                          ),
                          Container(
                            width: size.width/10,
                            child: FittedBox(
                              child: Text(
                                "Name ${index+1}",
                                style: TextStyle(
                                    fontFamily: "Lato",
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  })
          )
        ],
      );
    }
    else{
      return Container();
    }
  }

  void _justRefresh([Function refresh]) {
    if (this.mounted) {
      if (refresh != null) {
        refresh();
      }
      setState(() {});
    }
  }

  _navigateTo(Widget page) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
    _justRefresh();
  }

  Future<void> _handleMenuButtons(String value) async {
    switch (value) {
      case 'Join Requests':
        // await _navigateTo(ClubJoinRequests(club: widget.club));
        break;

      case 'Option 1':
        // await _navigateTo(InviteScreen(
        //   club: widget.club,
        //   forPanelist: true,
        // ));
        break;

      case 'Option 2':
        // await _navigateTo(InviteScreen(
        //   club: widget.club,
        //   forPanelist: false,
        // ));
        break;

      case 'Option 3':
        // await _navigateTo(BlockedUsersPage(club: widget.club));
        break;
    }
  }

  Widget _showMenuButtons() {
    return PopupMenuButton<String>(
      onSelected: _handleMenuButtons,
      itemBuilder: (BuildContext context) {
        return _isOwner
            ? {'Option 1', 'Option 2', 'Option 3'}
            .map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList()
            : {'Option 1'}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Community Name",
            style: TextStyle(
              fontFamily: "Lato",
              fontWeight: FontWeight.bold
            ),
          ),
          actions: [
            _showMenuButtons()
          ],
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            unselectedLabelColor: Colors.grey[700],
            labelColor: Colors.white,
            labelStyle:
            TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold),
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: Colors.white),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Text(
                "HOME",
                style: TextStyle(
                    fontFamily: "Lato",
                    letterSpacing: 2.0
                ),
              ),
              Text(
                "CLUBS",
                style: TextStyle(
                    fontFamily: "Lato",
                    letterSpacing: 2.0
                ),
              ),
              Text(
                "MARKET",
                style: TextStyle(
                    fontFamily: "Lato",
                    letterSpacing: 2.0
                ),
              ),
              Text(
                "DONATE",
                style: TextStyle(
                    fontFamily: "Lato",
                    letterSpacing: 2.0
                ),
              )
            ],
          ),
        ),
        body: TabBarView(
            controller: _tabController, children: [tabPage(0), tabPage(1), tabPage(2), tabPage(3)]),
      ),
    );
  }
}
