import 'package:flocktale/services/LocalStorage/FollowingDatabase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/pages/ProfilePage.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:built_collection/built_collection.dart';
import 'package:provider/provider.dart';

class SocialRelationPage extends StatefulWidget {
  final int initpos;
  final BuiltUser user;
  SocialRelationPage({this.initpos, this.user});
  @override
  _SocialRelationPageState createState() => _SocialRelationPageState();
}

class _SocialRelationPageState extends State<SocialRelationPage>
    with SingleTickerProviderStateMixin {
  BuiltList<JoinRequests> _searchResult;
  List<String> tabs = ['Friends', 'Followers', 'Following'];
  List<String> relations = ['friends', 'followers', 'followings'];
  Map<String, Map<String, dynamic>> relationMap = {
    'friends': {'data': null, 'isLoading': true},
    'followers': {'data': null, 'isLoading': true},
    'followings': {'data': null, 'isLoading': true},
  };

  TabController _tabController;

  void _initRelationData(String type) async {
    //             ["followings","followers", "requests_sent", "requests_received","friends"]

    if (relationMap[type]['data'] != null) return;

    relationMap[type]['data'] =
        (await Provider.of<DatabaseApiService>(context, listen: false)
                .getRelations(
      userId: widget.user.userId,
      socialRelation: type,
      lastevaluatedkey:
          (relationMap[type]['data'] as BuiltSearchUsers)?.lastevaluatedkey,
    ))
            .body;

    relationMap[type]['isLoading'] = false;

    setState(() {});
  }

  void _fetchMoreRelationData(String type) async {
    //             ["followings","followers", "requests_sent", "requests_received","friends"]

    if (relationMap[type]['isLoading'] == true) return;
    setState(() {});

    final lastevaulatedkey =
        (relationMap[type]['data'] as BuiltSearchUsers)?.lastevaluatedkey;

    if (lastevaulatedkey != null) {
      relationMap[type]['data'] =
          (await Provider.of<DatabaseApiService>(context, listen: false)
                  .getRelations(
        userId: widget.user.userId,
        socialRelation: type,
        lastevaluatedkey:
            (relationMap[type]['data'] as BuiltSearchUsers)?.lastevaluatedkey,
      ))
              .body;
    } else {
      await Future.delayed(Duration(milliseconds: 200));
    }
    relationMap[type]['isLoading'] = false;

    setState(() {});
  }

  onSearchTextChanged(String text) async {
    _searchResult.toList().clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
//    final _userDetails = joinRequests.activeJoinRequestUsers;
//    _userDetails.forEach((userDetail) {
//      if (userDetail.audience.username.contains(text))
//        _searchResult.toList().add(userDetail);
//    });
    print("SEARCH RESULT");
    print(_searchResult);
    setState(() {});
  }

  Widget searchBar(String hint) {
    return Container(
      height: 40,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextField(
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            fillColor: Colors.grey[200],
            hintText: 'Search $hint',
            filled: true,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: Colors.black, width: 1.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0))),
      ),
    );
  }

  Widget tabPage(int index) {
    final relationUsers =
        (relationMap[relations[index]]['data'] as BuiltSearchUsers)?.users;
    final bool isLoading = relationMap[relations[index]]['isLoading'];
    final listLength = (relationUsers?.length ?? 0) + 1;

    return Column(
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        searchBar(tabs[index]),
        SizedBox(
          height: 40,
        ),
        Text(
          'All ${tabs[index]}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(
          height: 30,
        ),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                final type = relations[_tabController.index];
                _fetchMoreRelationData(type);
                relationMap[type]['isLoading'] = true;
              }
              return true;
            },
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: listLength,
                physics: ScrollPhysics(),
                itemBuilder: (context, ind) {
                  // last index of this list is being used for loading animation while more users are loaded.
                  if (ind == listLength - 1) {
                    if (isLoading)
                      return Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    else
                      return Container();
                  }

                  final _user = relationUsers[ind];

                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ProfilePage(
                                userId: _user.userId,
                              )));
                    },
                    child: Container(
                      key: ValueKey(_user.username),
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 30,
                            child: FadeInImage.assetNetwork(
                              image: _user.avatar + "_thumb",
                              placeholder: 'assets/gifs/fading_lines.gif',
                              imageErrorBuilder: (context, _, __) =>
                                  Image.asset('assets/images/logo.ico'),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                _user.username,
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                ),
                              ),
                              Text(
                                _user.name,
                                style: TextStyle(
                                    fontFamily: 'Lato',
                                    color: Colors.grey[700]),
                              )
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              // TODO: complete this functionality
                            },
                            child: Container(
                              width: 100,
                              height: 35,
                              child: Center(
                                child: Text(index == 0
                                    ? 'Remove Friend'
                                    : index == 1
                                        ? 'Remove'
                                        : 'Following'),
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[700]),
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ),

        //  ListView.builder(),//To be filled with get results.
      ],
    );
  }

  @override
  void initState() {
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: widget.initpos);
    _initRelationData(relations[widget.initpos]);

    _tabController.addListener(() {
      _initRelationData(relations[_tabController.index]);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.initpos,
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.grey[100],
          title: Text(
            widget.user.username,
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold),
          ),
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
            tabs: List<Widget>.generate(
                tabs.length,
                (index) => Tab(
                      text: tabs[index],
                    )),
          ),
        ),
        body: TabBarView(
            controller: _tabController,
            children: [tabPage(0), tabPage(1), tabPage(2)]),
      ),
    );
  }
}
