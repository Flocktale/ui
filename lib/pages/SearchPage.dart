import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/pages/ProfilePage.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';
import 'package:provider/provider.dart';

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
    List<BuiltUser> recentSearches = [widget.user, widget.user, widget.user];
    List<BuiltUser> allSearches = [widget.user];
    return SafeArea(
      child: Column(
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
                      borderSide: BorderSide(color: Colors.black, width: 1.0)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0))),
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
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  List<BuiltUser> recentSearches;
  BuiltSearchUsers allSearches;
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
    String username = query.toLowerCase();
    final service = Provider.of<DatabaseApiService>(context);
    allSearches = (await service.getUserbyUsername(username)).body;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show when someone searches for something
    return query.isEmpty
        ? ListView.builder(
            itemCount: recentSearches.length,
            itemBuilder: (builder, index) {
              return ListTile(
                leading: Image.network(recentSearches[index].avatar),
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
            })
        : FutureBuilder(
            future: getAllUsers(),
            builder: (context, snapshot) {
              if (allSearches == null ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                  itemCount: allSearches.users.length,
                  itemBuilder: (builder, index) {
                    return ListTile(
                      leading: allSearches.users[index].avatar != null
                          ? Image.network(allSearches.users[index].avatar)
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
                          allSearches.users[index].name != null
                              ? Text(allSearches.users[index].name)
                              : null,
                      subtitle: allSearches.users[index].username != null
                          ? Text(allSearches.users[index].username)
                          : null,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ProfilePage(
                                  userId: allSearches.users[index].userId,
                                )));
                      },
                    );
                  });
            },
          );
  }
}
