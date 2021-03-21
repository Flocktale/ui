import 'package:flocktale/Widgets/customImage.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/services/LocalStorage/FollowingDatabase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/pages/ProfilePage.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  TextEditingController friendSearchController = new TextEditingController();
  TextEditingController followerSearchController = new TextEditingController();
  TextEditingController followingSearchController = new TextEditingController();

  TabController _tabController;

  List<SummaryUser> friends = [];
  List<SummaryUser> friendsFiltered = [];
  List<SummaryUser> followers = [];
  List<SummaryUser> followersFiltered = [];
  List<SummaryUser> following = [];
  List<SummaryUser> followingFiltered = [];

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

  _filterFriends() {
    List<SummaryUser> _friends = [];
    _friends.addAll((relationMap[relations[0]]['data'] as BuiltSearchUsers)
        ?.users
        ?.toList());
    friends = _friends;
    if (friendSearchController.text.isNotEmpty) {
      _friends.retainWhere((contact) {
        String searchTerm = friendSearchController.text.toLowerCase();
        String contactName = contact?.username?.toLowerCase();
        return contactName?.contains(searchTerm);
      });
      setState(() {
        friendsFiltered = _friends;
      });
    } else {
      setState(() {
        friends = friendsFiltered;
      });
    }
  }

  _filterFollowers() {
    List<SummaryUser> _followers = [];
    _followers.addAll((relationMap[relations[1]]['data'] as BuiltSearchUsers)
        ?.users
        ?.toList());
    followers = _followers;
    if (followerSearchController.text.isNotEmpty) {
      _followers.retainWhere((contact) {
        String searchTerm = followerSearchController.text.toLowerCase();
        String contactName = contact?.username?.toLowerCase();
        return contactName?.contains(searchTerm);
      });
      setState(() {
        followersFiltered = _followers;
      });
    } else {
      setState(() {
        followersFiltered = followers;
      });
    }
  }

  _filterFollowing() {
    List<SummaryUser> _following = [];
    _following.addAll((relationMap[relations[2]]['data'] as BuiltSearchUsers)
        ?.users
        ?.toList());
    following = _following;
    if (followingSearchController.text.isNotEmpty) {
      _following.retainWhere((contact) {
        String searchTerm = followingSearchController.text.toLowerCase();
        String contactName = contact?.username?.toLowerCase();
        return contactName?.contains(searchTerm);
      });
      setState(() {
        followingFiltered = _following;
      });
    } else {
      setState(() {
        followingFiltered = following;
      });
    }
  }

  Widget friendSearchBar() {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 20,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextField(
        controller: friendSearchController,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            fillColor: Colors.grey[200],
            hintText: 'Search friends',
            filled: true,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: Colors.black, width: 1.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0))),
      ),
    );
  }

  Widget followerSearchBar() {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 20,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextField(
        controller: followerSearchController,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            fillColor: Colors.grey[200],
            hintText: 'Search followers',
            filled: true,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: Colors.black, width: 1.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0))),
      ),
    );
  }

  Widget followingSearchBar() {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 20,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextField(
        controller: followingSearchController,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            fillColor: Colors.grey[200],
            hintText: 'Search followings',
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
    //var friends = (relationMap[relations[index]]['data'] as BuiltSearchUsers)?.users?.toList();
    List<SummaryUser> relationUsers;
    if (index == 0) {
      if (friendSearchController.text.length > 0) {
        relationUsers = friendsFiltered;
      } else {
        relationUsers =
            (relationMap[relations[index]]['data'] as BuiltSearchUsers)
                ?.users
                ?.toList();
      }
    } else if (index == 1) {
      if (followerSearchController.text.length > 0) {
        relationUsers = followersFiltered;
      } else {
        relationUsers =
            (relationMap[relations[index]]['data'] as BuiltSearchUsers)
                ?.users
                ?.toList();
      }
    } else {
      if (followingSearchController.text.length > 0) {
        relationUsers = followingFiltered;
      } else {
        relationUsers =
            (relationMap[relations[index]]['data'] as BuiltSearchUsers)
                ?.users
                ?.toList();
      }
    }
    final bool isLoading = relationMap[relations[index]]['isLoading'];
    final cuser = Provider.of<UserData>(context, listen: false).user;
    final isMe = cuser.userId == widget.user.userId;
    final listLength = (relationUsers?.length ?? 0) + 1;

    return Column(
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        index == 0
            ? friendSearchBar()
            : index == 1
                ? followerSearchBar()
                : followingSearchBar(),
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
                            child: CustomImage(
                              image: _user.avatar + "_thumb",
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
                          !isMe
                              ? _user.userId == cuser.userId
                                  ? Container()
                                  : InkWell(
                                      onTap: () async {
                                        // TODO: complete this functionality
                                        final service =
                                            Provider.of<DatabaseApiService>(
                                                context,
                                                listen: false);

                                        if (FollowingDatabase.isFollowing(
                                            _user.userId)) {
                                          final resp = (await service.unfollow(
                                            userId: cuser.userId,
                                            foreignUserId: _user.userId,
                                          ));
                                          if (resp.isSuccessful) {
                                            FollowingDatabase.deleteFollowing(
                                                _user.userId);
                                            //            _initRelationData(relations[index]);
                                            //             relationUsers.remove(_user);
                                            //             print("090909090909090909090909090909090909090999999999999999999999999999999999999999999999999999999");
                                            //             print(relationUsers);
                                            setState(() {});
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Some error occurred. Please try again.');
                                          }
                                        } else {
                                          final resp = (await service.follow(
                                            userId: cuser.userId,
                                            foreignUserId: _user.userId,
                                          ));
                                          if (resp.isSuccessful) {
                                            FollowingDatabase.addFollowing(
                                                _user.userId);
                                            setState(() {});
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Some error occurred. Please try again.');
                                          }
                                        }
                                      },
                                      child: FollowingDatabase.isFollowing(
                                              _user.userId)
                                          ? Container(
                                              width: 100,
                                              height: 35,
                                              child: Center(
                                                  child: Text(
                                                'Following',
                                                style: TextStyle(
                                                    fontFamily: "Lato",
                                                    color: Colors.redAccent),
                                              )),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.red[700]),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                            )
                                          : Container(
                                              width: 100,
                                              height: 35,
                                              child: Center(
                                                child: Text(
                                                  "Follow",
                                                  style: TextStyle(
                                                      fontFamily: "Lato",
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                            ),
                                    )
                              : index == 1
                                  ? Container()
                                  : InkWell(
                                      onTap: () async {
                                        // TODO: complete this functionality
                                        final service =
                                            Provider.of<DatabaseApiService>(
                                                context,
                                                listen: false);

                                        if (index == 0) {
                                          final resp = (await service.unfriend(
                                            userId: widget.user.userId,
                                            foreignUserId: _user.userId,
                                          ));
                                          if (resp.isSuccessful) {
                                            FollowingDatabase.deleteFollowing(
                                                _user.userId);
                                            relationUsers.removeAt(ind);
                                            _initRelationData(relations[index]);
                                            setState(() {});
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Some error occurred. Please try again.');
                                          }
                                        } else if (index == 1) {
                                        } else {
                                          final resp = (await service.unfollow(
                                            userId: widget.user.userId,
                                            foreignUserId: _user.userId,
                                          ));
                                          if (resp.isSuccessful) {
                                            FollowingDatabase.deleteFollowing(
                                                _user.userId);
                                            relationUsers.removeAt(ind);
                                            _initRelationData(relations[index]);
                                            setState(() {});
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Some error occurred. Please try again.');
                                          }
                                        }
                                      },
                                      child: Container(
                                        width: 100,
                                        height: 35,
                                        child: Center(
                                          child: Text(
                                            index == 0
                                                ? 'Remove Friend'
                                                : index == 2
                                                    ? 'Unfollow'
                                                    : '',
                                            style: TextStyle(
                                                fontFamily: "Lato",
                                                color: Colors.redAccent),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.red),
                                            borderRadius:
                                                BorderRadius.circular(12)),
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

    friendSearchController.addListener(() {
      _filterFriends();
    });

    followerSearchController.addListener(() {
      _filterFollowers();
    });

    followingSearchController.addListener(() {
      _filterFollowing();
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
