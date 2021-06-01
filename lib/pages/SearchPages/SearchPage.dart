import 'package:flocktale/Models/enums/queryType.dart';
import 'package:flocktale/Widgets/CommunityCard.dart';
import 'package:flocktale/Widgets/customImage.dart';
import 'package:flocktale/Widgets/summaryClubCard.dart';
import 'package:flutter/material.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/pages/ProfilePage.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:built_collection/built_collection.dart';

import '../ClubDetailPages/ClubDetail.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  TextEditingController _searchController;
  String _searchedString = '';

  final _emptyResults = BuiltUnifiedSearchResults(
    (b) => b
      ..users = ListBuilder<SummaryUser>([])
      ..clubs = ListBuilder<BuiltClub>([])
      ..communities = ListBuilder<BuiltCommunity>([]),
  );

  BuiltUnifiedSearchResults _searchResults;

// to indicate about unified query
  bool _isLoading = false;

  bool _isFetchingMoreUsers = false;
  bool _isFetchingMoreClubs = false;
  bool _isFetchingMoreCommunities = false;

  Text _tabText(String title) => Text(
        title,
        style: TextStyle(fontFamily: "Lato", letterSpacing: 2.0),
      );

  Future<BuiltUnifiedSearchResults> _fetchSearchResults(
      String searchString, QueryType type, String lastevaluatedkey) async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final results = (await service.unifiedQueryRoutes(
      searchString: searchString,
      type: type,
      lastevaluatedkey: lastevaluatedkey,
    ))
        .body;

    return results;
  }

  void _fetchMoreUsers() async {
    if (_isFetchingMoreUsers || _searchResults.userlastevaluatedkey == null)
      return;

    setState(() {
      _isFetchingMoreUsers = true;
    });
    final res = await _fetchSearchResults(_searchController.text,
        QueryType.users, _searchResults.userlastevaluatedkey);

    final newUserList = (_searchResults?.users?.toList() ?? [])
      ..addAll(res?.users?.toList() ?? []);

    _searchResults = _searchResults.rebuild((b) => b
      ..users = newUserList.toBuiltList().toBuilder()
      ..userlastevaluatedkey = res?.userlastevaluatedkey);

    setState(() {
      _isFetchingMoreUsers = false;
    });
  }

  void _fetchMoreClubs() async {
    if (_isFetchingMoreClubs || _searchResults.clublastevaluatedkey == null)
      return;

    setState(() {
      _isFetchingMoreClubs = true;
    });
    final res = await _fetchSearchResults(_searchController.text,
        QueryType.clubs, _searchResults.clublastevaluatedkey);

    final newClubList = (_searchResults?.clubs?.toList() ?? [])
      ..addAll(res?.clubs?.toList() ?? []);

    _searchResults = _searchResults.rebuild((b) => b
      ..clubs = newClubList.toBuiltList().toBuilder()
      ..clublastevaluatedkey = res?.clublastevaluatedkey);

    setState(() {
      _isFetchingMoreClubs = false;
    });
  }

  void _fetchMoreCommunities() async {
    if (_isFetchingMoreCommunities ||
        _searchResults.communitylastevaluatedkey == null) return;

    setState(() {
      _isFetchingMoreCommunities = true;
    });
    final res = await _fetchSearchResults(_searchController.text,
        QueryType.communities, _searchResults.communitylastevaluatedkey);

    final newCommunityList = (_searchResults?.communities?.toList() ?? [])
      ..addAll(res?.communities?.toList() ?? []);

    _searchResults = _searchResults.rebuild((b) => b
      ..communities = newCommunityList.toBuiltList().toBuilder()
      ..communitylastevaluatedkey = res?.communitylastevaluatedkey);

    setState(() {
      _isFetchingMoreCommunities = false;
    });
  }

  Widget get _loadingWidget => Container(
        height: 80,
        child: Center(
          child: SpinKitChasingDots(
            color: Colors.redAccent,
          ),
        ),
      );

  Widget _searchCommunitiesTab() {
    if (_isLoading) return Center(child: _loadingWidget);

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          _fetchMoreCommunities();
        }
        return true;
      },
      child: ListView(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        children: [
          ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: _searchResults?.communities?.length ?? 0,
            itemBuilder: (context, index) {
              final community = _searchResults.communities[index];

              return CommunityCard(community: community);
            },
          ),
          SizedBox(height: 80),
          if (_isFetchingMoreClubs) _loadingWidget
        ],
      ),
    );
  }

  Widget _searchClubsTab() {
    if (_isLoading) return Center(child: _loadingWidget);

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          _fetchMoreClubs();
        }
        return true;
      },
      child: ListView(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        children: [
          ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: _searchResults?.clubs?.length ?? 0,
            itemBuilder: (context, index) {
              final club = _searchResults.clubs[index];

              return Container(
                height: 180,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                child: SummaryClubCard(
                  club,
                  (Widget page) async {
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ClubDetailPage(club.clubId)));
                  },
                ),
              );
            },
          ),
          SizedBox(height: 80),
          if (_isFetchingMoreClubs) _loadingWidget
        ],
      ),
    );
  }

  Widget _searchUsersTab() {
    if (_isLoading) return Center(child: _loadingWidget);

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          _fetchMoreUsers();
        }
        return true;
      },
      child: ListView(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        children: [
          ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: _searchResults.users?.length ?? 0,
            itemBuilder: (context, index) {
              final user = _searchResults.users[index];

              return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ProfilePage(
                          userId: user.userId,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 48,
                        width: 48,
                        color: Colors.transparent,
                        child: CustomImage(
                          image: user.avatar,
                          radius: 8,
                        ),
                      ),
                      SizedBox(width: 12),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                user.username,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(width: 4),
                              Text(
                                ' · ' + user.name,
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            user.tagline ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style:
                                TextStyle(color: Colors.white70, fontSize: 14),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 80),
          if (_isFetchingMoreUsers) _loadingWidget
        ],
      ),
    );
  }

  void _initiate() {
    this._searchController = TextEditingController(text: '');

    this._searchResults = _emptyResults;

    this._searchController.addListener(() async {
      final text = _searchController.text;

      // to prevent reload when user submits text field
      if (_searchedString == text) return;

      _searchedString = text;
      setState(() {
        this._isLoading = true;
      });

      if (text.isEmpty) {
        this._searchResults = _emptyResults;
      } else {
        // if the searched text changes then results reset to new
        this._searchResults =
            await _fetchSearchResults(text, QueryType.unified, null);
      }

      this._isLoading = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    _initiate();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: <Widget>[
              SizedBox(height: 12),
              Container(
                height: 50,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                            fillColor: Colors.grey[200],
                            hintText: 'Artists or Clubs',
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                borderSide: BorderSide(
                                    color: Colors.white, width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white, width: 2.0))),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              TabBar(
                isScrollable: true,
                unselectedLabelColor: Colors.white54,
                labelColor: Colors.redAccent,
                labelStyle:
                    TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold),
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Colors.white, width: 1),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  _tabText("USERS"),
                  _tabText("CLUBS"),
                  _tabText("COMMUNITIES"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _searchUsersTab(),
                    _searchClubsTab(),
                    _searchCommunitiesTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
