import 'package:flocktale/Models/enums/queryType.dart';
import 'package:flocktale/Widgets/customImage.dart';
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

  Widget get _loadingWidget => Container(
        height: 80,
        child: Center(
          child: SpinKitChasingDots(
            color: Colors.redAccent,
          ),
        ),
      );

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 64,
                      width: 64,
                      color: Colors.transparent,
                      child: CustomImage(
                        image: user.avatar,
                        radius: 8,
                      ),
                    ),
                    SizedBox(width: 12),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              user.username,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
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
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        )
                      ],
                    )
                  ],
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
                    Container(),
                    Container(),
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

class DataSearch extends SearchDelegate<String> {
  List<BuiltUser> recentSearches;
  BuiltUnifiedSearchResults allSearches;
  BuildContext context;
  DataSearch({this.recentSearches, this.context});

  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for App Bar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon on the left of the App Bar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show some result based on the selection
    return searchResultFutureBuilder();
  }

  getAllUsers() async {
    String username = query;
    final service = Provider.of<DatabaseApiService>(context);
    //allSearches = (await service.getUserbyUsername(username)).body;

    allSearches = (await service.unifiedQueryRoutes(
      searchString: username,
      // type: "unified",
      lastevaluatedkey: null,
    ))
        .body;
    print("===================");
    print(allSearches);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(color: Colors.blue, child: searchResultFutureBuilder());
  }

  Widget searchResultFutureBuilder() {
    final size = MediaQuery.of(context).size;
    // Show when someone searches for something
    return query.isEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height / 50),
              Text(
                "Recent Searches",
                style: TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold,
                    fontSize: size.width / 20),
              ),
              SizedBox(height: size.height / 50),
              Expanded(
                child: SizedBox(
                  height: 300.0,
                  child: ListView.builder(
                      itemCount: recentSearches.length,
                      itemBuilder: (builder, index) {
                        return ListTile(
                          leading: CustomImage(
                            image: recentSearches[index].avatar + "_thumb",
                          ),
                          title: Text(
                            recentSearches[index].name,
                          ),
                          subtitle: Text(recentSearches[index].username),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => ProfilePage(
                                      userId: recentSearches[index].userId,
                                    )));
                          },
                        );
                      }),
                ),
              ),
            ],
          )
        : FutureBuilder(
            future: getAllUsers(),
            builder: (context, snapshot) {
              if (allSearches == null ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height / 50),
                    Text(
                      "Search Results",
                      style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                          fontSize: size.width / 20),
                    ),
                    SizedBox(height: size.height / 50),
                    Text(
                      "Users",
                      style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w500,
                          fontSize: size.width / 20),
                    ),
                    //SizedBox(height: size.height/50),
                    allSearches.users.length == 0
                        ? Container(
                            child: Center(
                                child: Text(
                              "No users found",
                              style: TextStyle(
                                  fontFamily: "Lato",
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            )),
                          )
                        : Flexible(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  0, size.height / 50, 0, size.height / 50),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: allSearches.users != null
                                      ? allSearches.users.length < 3
                                          ? allSearches.users.length
                                          : 3
                                      : 0,
                                  itemBuilder: (builder, index) {
                                    return ListTile(
                                      leading: allSearches
                                                  .users[index].avatar !=
                                              null
                                          ? Image.network(
                                              allSearches.users[index].avatar)
                                          : null,
                                      title:
                                          /* RichText(text: TextSpan(
                                text: allSearches.users[index].name.substring(0,query.length),
                                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                children: [TextSpan(
                                  text: allSearches.users[index].name.substring(query.length),
                                  style: TextStyle(color: Colors.grey)
                                )]
                              ),),*/
                                          allSearches.users[index].username !=
                                                  null
                                              ? Text(allSearches
                                                  .users[index].username)
                                              : null,
                                      subtitle: allSearches
                                                  .users[index].tagline !=
                                              null
                                          ? Text(
                                              allSearches.users[index].tagline)
                                          : null,
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (_) => ProfilePage(
                                                      userId: allSearches
                                                          .users[index].userId,
                                                    )));
                                      },
                                    );
                                  }),
                            ),
                          ),
                    allSearches.users.length == 0
                        ? Container()
                        : InkWell(
                            onTap: () {
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (_) => SearchAllUsers(
                              //           users: allSearches.users,
                              //           query: query,
                              //         )));
                            },
                            child: Container(
                                width: size.width,
                                child: Text(
                                  "See all users",
                                  style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w500,
                                      fontSize: size.width / 25,
                                      color: Colors.redAccent),
                                ))),
                    SizedBox(
                      height: size.height / 30,
                    ),
                    // SizedBox(height: size.height/30),
                    Text(
                      "Clubs",
                      style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w500,
                          fontSize: size.width / 20),
                    ),
                    allSearches.clubs.length == 0
                        ? Container(
                            child: Center(
                                child: Text(
                              "No clubs found",
                              style: TextStyle(
                                  fontFamily: "Lato",
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            )),
                          )
                        : Flexible(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  0, size.height / 50, 0, size.height / 50),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: allSearches.clubs.length < 3
                                    ? allSearches.clubs.length
                                    : 3,
                                itemBuilder: (builder, index) {
                                  return ListTile(
                                    leading: allSearches
                                                .clubs[index].clubAvatar !=
                                            null
                                        ? Image.network(
                                            allSearches.clubs[index].clubAvatar)
                                        : null,
                                    title: allSearches
                                                .clubs[index].clubAvatar !=
                                            null
                                        ? Text(
                                            allSearches.clubs[index].clubName)
                                        : null,
                                    subtitle:
                                        allSearches.clubs[index].creator != null
                                            ? Text(allSearches
                                                .clubs[index].creator.username)
                                            : Text("Club"),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => ClubDetailPage(
                                            allSearches.clubs[index].clubId,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                    allSearches.clubs.length == 0
                        ? Container()
                        : InkWell(
                            onTap: () {
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (_) => SearchAllClubs(
                              //           clubs: allSearches.clubs,
                              //           query: query,
                              //         )));
                            },
                            child: Container(
                                child: Text(
                              "See all clubs",
                              style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w500,
                                  fontSize: size.width / 25,
                                  color: Colors.redAccent),
                            ))),
                  ],
                ),
              );
            },
          );
  }
}
