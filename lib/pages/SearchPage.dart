import 'package:flocktale/customImage.dart';
import 'package:flutter/material.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/pages/ProfilePage.dart';
import 'package:flocktale/pages/SearchAllUsersPage.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:provider/provider.dart';

import '../MinClub.dart';
import 'ClubDetail.dart';
import 'SearchAllClubsPage.dart';

class SearchPage extends StatefulWidget {
  BuiltUser user;
  SearchPage({this.user});
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // BuiltList<BuiltUser> allSearches;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<BuiltUser> recentSearches = [];
    // List<BuiltUser> allSearches = [widget.user];
    return SafeArea(
      child: Stack(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: size.height / 50,
            ),
            Text(
              'Search',
              style: TextStyle(
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                  fontSize: size.width / 10),
            ),
            SizedBox(
              height: size.height / 50,
            ),
            Container(
              height: 50,
              margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    fillColor: Colors.grey[200],
                    hintText: 'Artists or Clubs',
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide:
                            BorderSide(color: Colors.black, width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 2.0))),
                onTap: () {
                  showSearch(
                      context: context,
                      delegate: DataSearch(
                          recentSearches: recentSearches, context: context));
                },
              ),
            ),
            SizedBox(
              height: size.height / 50,
            )
          ],
        ),
        Positioned(bottom: 0, child: MinClub())
      ]),
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
    throw UnimplementedError();
  }

  getAllUsers() async {
    String username = query;
    final service = Provider.of<DatabaseApiService>(context);
    //allSearches = (await service.getUserbyUsername(username)).body;

    final authToken = Provider.of<UserData>(context, listen: false).authToken;

    allSearches = (await service.unifiedQueryRoutes(
      searchString: username,
      type: "unified",
      lastevaluatedkey: null,
      authorization: authToken,
    ))
        .body;
    print("===================");
    print(allSearches);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
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
                    Flexible(
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
                                leading: allSearches.users[index].avatar != null
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
                                    allSearches.users[index].username != null
                                        ? Text(
                                            allSearches.users[index].username)
                                        : null,
                                subtitle:
                                    allSearches.users[index].tagline != null
                                        ? Text(allSearches.users[index].tagline)
                                        : null,
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => ProfilePage(
                                            userId:
                                                allSearches.users[index].userId,
                                          )));
                                },
                              );
                            }),
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => SearchAllUsers(
                                    users: allSearches.users,
                                    query: query,
                                  )));
                        },
                        child: Container(
                            width: size.width,
                            child: Text(
                              "See all users",
                              style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w500,
                                  fontSize: size.width / 25),
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
                    Flexible(
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
                              leading:
                                  allSearches.clubs[index].clubAvatar != null
                                      ? Image.network(
                                          allSearches.clubs[index].clubAvatar)
                                      : null,
                              title: allSearches.clubs[index].clubAvatar != null
                                  ? Text(allSearches.clubs[index].clubName)
                                  : null,
                              subtitle: allSearches.clubs[index].creator != null
                                  ? Text(
                                      allSearches.clubs[index].creator.username)
                                  : Text("Club"),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => ClubDetailPage(
                                          club: allSearches.clubs[index],
                                        )));
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => SearchAllClubs(
                                    clubs: allSearches.clubs,
                                    query: query,
                                  )));
                        },
                        child: Container(
                            child: Text(
                          "See all clubs",
                          style: TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w500,
                              fontSize: size.width / 25),
                        ))),
                  ],
                ),
              );
            },
          );
  }
}
