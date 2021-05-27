import 'package:chopper/chopper.dart';
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

  int currentTypeIndex;

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

  Widget socialActionButtonForRemoteUser(SummaryUser _user) {
    final cuser = Provider.of<UserData>(context, listen: false).user;

    final notIsMeOnTap = () async {
      final service = Provider.of<DatabaseApiService>(context, listen: false);

      if (FollowingDatabase.isFollowing(_user.userId)) {
        final resp = (await service.unfollow(
          userId: cuser.userId,
          foreignUserId: _user.userId,
        ));
        if (resp.isSuccessful) {
          FollowingDatabase.deleteFollowing(_user.userId);
          //            _initRelationData(relations[index]);
          //             relationUsers.remove(_user);
          //             print("090909090909090909090909090909090909090999999999999999999999999999999999999999999999999999999");
          //             print(relationUsers);
          setState(() {});
        } else {
          Fluttertoast.showToast(msg: 'Some error occurred. Please try again.');
        }
      } else {
        final resp = (await service.follow(
          userId: cuser.userId,
          foreignUserId: _user.userId,
        ));
        if (resp.isSuccessful) {
          FollowingDatabase.addFollowing(_user.userId);
          setState(() {});
        } else {
          Fluttertoast.showToast(msg: 'Some error occurred. Please try again.');
        }
      }
    };
    return _user.userId == cuser.userId
        ? Container()
        : InkWell(
            onTap: () => notIsMeOnTap(),
            child: FollowingDatabase.isFollowing(_user.userId)
                ? socialActionButtonContainer(text: 'Following')
                : socialActionButtonContainer(text: "Follow"),
          );
  }

  Widget socialActionButtonForLocalUser(int currentTypeIndex, int ind,
      List<SummaryUser> relationUsers, SummaryUser _user) {
    // this function is only for friends and following (ability to unfriend or unfollow)

    if (currentTypeIndex == 1) return Container();

    final isMeOnTap = () async {
      final service = Provider.of<DatabaseApiService>(context, listen: false);
      Response<RelationActionResponse> resp;
      if (currentTypeIndex == 0) {
        resp = (await service.unfriend(
          userId: widget.user.userId,
          foreignUserId: _user.userId,
        ));
      } else if (currentTypeIndex == 2) {
        resp = (await service.unfollow(
          userId: widget.user.userId,
          foreignUserId: _user.userId,
        ));
      }
      if (resp.isSuccessful) {
        FollowingDatabase.deleteFollowing(_user.userId);

        relationUsers.removeAt(ind);

        relationMap[relations[currentTypeIndex]]
            ['data'] = (relationMap[relations[currentTypeIndex]]['data']
                as BuiltSearchUsers)
            .rebuild((b) =>
                b..users = BuiltList<SummaryUser>(relationUsers).toBuilder());

        _initRelationData(relations[currentTypeIndex]);

        setState(() {});
      } else {
        Fluttertoast.showToast(msg: 'Some error occurred. Please try again.');
      }
    };
    return InkWell(
      onTap: () => isMeOnTap(),
      child: socialActionButtonContainer(
          text: currentTypeIndex == 0
              ? 'Remove Friend'
              : currentTypeIndex == 2
                  ? 'Unfollow'
                  : ''),
    );
  }

  Widget socialActionButtonContainer({String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(12),
        color: Colors.black87,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Lato",
          color: Colors.white70,
        ),
      ),
    );
  }

  List<SummaryUser> _populateRelationUserList(int index) {
    if (index == 0) {
      if (friendSearchController.text.length > 0) {
        return friendsFiltered;
      } else {
        return (relationMap[relations[index]]['data'] as BuiltSearchUsers)
            ?.users
            ?.toList();
      }
    } else if (index == 1) {
      if (followerSearchController.text.length > 0) {
        return followersFiltered;
      } else {
        return (relationMap[relations[index]]['data'] as BuiltSearchUsers)
            ?.users
            ?.toList();
      }
    } else {
      if (followingSearchController.text.length > 0) {
        return followingFiltered;
      } else {
        return (relationMap[relations[index]]['data'] as BuiltSearchUsers)
            ?.users
            ?.toList();
      }
    }
  }

  Widget tabPage(int currentTypeIndex) {
    List<SummaryUser> relationUsers =
        _populateRelationUserList(currentTypeIndex);

    final bool isLoading =
        relationMap[relations[currentTypeIndex]]['isLoading'];
    final cuser = Provider.of<UserData>(context, listen: false).user;
    final isMe = cuser.userId == widget.user.userId;

    final listLength = (relationUsers?.length ?? 0) + 1;

    return Column(
      children: <Widget>[
        // index == 0
        //     ? friendSearchBar()
        //     : index == 1
        //         ? followerSearchBar()
        //         : followingSearchBar(),
        // SizedBox(height: 40),
        // Text(
        //   'All ${tabs[index]}',
        //   style: TextStyle(
        //     fontWeight: FontWeight.bold,
        //     fontSize: 20,
        //   ),
        //   textAlign: TextAlign.left,
        // ),
        // SizedBox(height: 30),
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
                    key: UniqueKey(),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ProfilePage(
                            userId: _user.userId,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 48,
                                width: 48,
                                child: CustomImage(
                                  image: _user.avatar + "_thumb",
                                  radius: 8,
                                ),
                              ),
                              SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    _user.username,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    _user.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(width: 16),
                            ],
                          ),
                          if (isMe)
                            socialActionButtonForLocalUser(
                                currentTypeIndex, ind, relationUsers, _user)
                          else
                            socialActionButtonForRemoteUser(_user),
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

    currentTypeIndex = widget.initpos;

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
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: DefaultTabController(
          initialIndex: widget.initpos,
          length: tabs.length,
          child: Scaffold(
            backgroundColor: Colors.black87,
            body: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white70,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Text(
                        widget.user.username,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          color: Colors.redAccent,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
                SizedBox(height: 8),
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  unselectedLabelColor: Colors.grey[700],
                  labelColor: Colors.white,
                  labelStyle: TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold,
                  ),
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(color: Colors.redAccent),
                  ),
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: List<Widget>.generate(
                    tabs.length,
                    (index) => Tab(
                      text: tabs[index],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                      controller: _tabController,
                      children: [tabPage(0), tabPage(1), tabPage(2)]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
