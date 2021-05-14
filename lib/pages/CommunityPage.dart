import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/Widgets/customImage.dart';
import 'package:flocktale/Widgets/summaryClubCard.dart';
import 'package:flocktale/pages/NewClub.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CommunityPage extends StatefulWidget {
  BuiltCommunity community;
  CommunityPage({this.community});
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage>
    with TickerProviderStateMixin {
  TabController _tabController;
  bool _isOwner = true;
  bool isMember = false;
  bool isHost = true;
  Map<String, dynamic> communityClubsMap = {
    'data': null,
    'isLoading': true,
  };
  Widget clubGrid() {
    final clubList = (communityClubsMap['data'] as BuiltSearchClubs)?.clubs;
    final bool isLoading = communityClubsMap['isLoading'];
    final listClubs = (clubList?.length ?? 0) + 1;
    return RefreshIndicator(
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              _fetchMoreCommunityClubs();
              communityClubsMap['isLoading'] = true;
            }
            return true;
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            child: Align(
              alignment: Alignment.topCenter,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: listClubs,
                itemBuilder: (context, index) {
                  if (index == listClubs - 1) {
                    if (isLoading)
                      return Center(child: CircularProgressIndicator());
                    else
                      return Container();
                  }
                  return Container(
                      height: 180,
                      child: SummaryClubCard(clubList[index], _navigateTo));
                },
              ),
            ),
          ),
        ),
        onRefresh: () {});
  }

  Widget tabPage(int index) {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final userId = Provider.of<UserData>(context, listen: false).userId;
    final size = MediaQuery.of(context).size;
    if (index == 0) {
      return Column(
        children: [
          Container(
            height: size.height / 6,
            width: size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(widget.community.coverImage),
                    fit: BoxFit.cover)),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(size.width / 20, size.width / 20,
                size.width / 20, size.width / 20),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.community.avatar),
                      radius: size.width / 15,
                    ),
                    SizedBox(
                      width: size.width / 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.community.name,
                          style: TextStyle(
                              fontFamily: "Lato", fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.community.creator.username,
                          style:
                              TextStyle(fontFamily: "Lato", color: Colors.grey),
                        )
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      isMember ? "JOIN" : "Member",
                      style: TextStyle(fontFamily: "Lato"),
                    ),
                    IconButton(
                        icon: isMember
                            ? Icon(Icons.add)
                            : Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                        onPressed: () async {
                          isMember = !isMember;
                          setState(() {});
                          final resp = (await service.joinCommunityAsMember(
                              widget.community.communityId,
                              userId: userId));
                          if (!resp.isSuccessful) {
                            Fluttertoast.showToast(
                                msg: 'Sorry something went wrong.');
                            setState(() {
                              isMember = !isMember;
                            });
                          }
                        })
                  ],
                )
              ],
            ),
          ),
          Container(
              height: size.height / 8,
              color: Colors.grey[200],
              padding: EdgeInsets.fromLTRB(0, 0, 0, size.width / 20),
              child: ListView.builder(
                  itemCount: widget.community.hosts != null
                      ? widget.community.hosts.length
                      : 0,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(size.width / 20, 0, 0, 0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            child: CustomImage(
                              image: widget.community.creator.avatar,
                            ),
                            radius: size.width / 15,
                          ),
                          Container(
                            width: size.width / 10,
                            child: FittedBox(
                              child: Text(
                                "Name ${index + 1}",
                                style: TextStyle(
                                    fontFamily: "Lato",
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  })),
        ],
      );
    } else if (index == 1) {
      return SingleChildScrollView(
        child: Column(children: [
          isHost
              ? InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => NewClub()))
                        .then((value) => _fetchCommunityClubs());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Create CLub", style: TextStyle(fontFamily: "Lato")),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => NewClub(
                                    community: widget.community,
                                  )));
                        },
                        icon: Icon(Icons.add),
                      )
                    ],
                  ),
                )
              : Container(),
          clubGrid()
        ]),
      );
    } else {
      return Center(
          child: Text(
        "Coming soon...",
        style: TextStyle(fontFamily: "Lato", color: Colors.redAccent),
      ));
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
            ? {'Option 1', 'Option 2', 'Option 3'}.map((String choice) {
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

  _fetchCommunityClubs() async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    communityClubsMap['data'] = (await service.getCommunityActiveClubs(
            widget.community.communityId,
            lastevaluatedkey: (communityClubsMap['data'] as BuiltSearchClubs)
                ?.lastevaluatedkey))
        .body;
    communityClubsMap['isLoading'] = false;
    setState(() {});
  }

  _fetchMoreCommunityClubs() async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final lastevaluatedkey =
        (communityClubsMap['data'] as BuiltSearchClubs)?.lastevaluatedkey;
    if (lastevaluatedkey != null) {
      await _fetchCommunityClubs();
    } else {
      await Future.delayed(Duration(milliseconds: 200));
      communityClubsMap['isLoading'] = false;
    }
  }

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    _fetchCommunityClubs();
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
            style: TextStyle(fontFamily: "Lato", fontWeight: FontWeight.bold),
          ),
          actions: [_showMenuButtons()],
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
                style: TextStyle(fontFamily: "Lato", letterSpacing: 2.0),
              ),
              Text(
                "CLUBS",
                style: TextStyle(fontFamily: "Lato", letterSpacing: 2.0),
              ),
              Text(
                "MARKET",
                style: TextStyle(fontFamily: "Lato", letterSpacing: 2.0),
              ),
              Text(
                "DONATE",
                style: TextStyle(fontFamily: "Lato", letterSpacing: 2.0),
              )
            ],
          ),
        ),
        body: TabBarView(
            controller: _tabController,
            children: [tabPage(0), tabPage(1), tabPage(2), tabPage(3)]),
      ),
    );
  }
}
