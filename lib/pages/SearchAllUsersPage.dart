import 'package:flocktale/Widgets/customImage.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:built_collection/built_collection.dart';
import 'package:provider/provider.dart';

import 'ProfilePage.dart';

class SearchAllUsers extends StatefulWidget {
  BuiltList<SummaryUser> users;
  final String query;
  SearchAllUsers({this.users, this.query});
  @override
  _SearchAllUsersState createState() => _SearchAllUsersState();
}

class _SearchAllUsersState extends State<SearchAllUsers> {
  Map<String, dynamic> searchUsersMap = {
    'data': null,
    'isLoading': true,
  };
  String lastEvaluatedKey;
  Future<void> getUsers() async {
    String username = widget.query;
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    searchUsersMap['data'] = (await service.unifiedQueryRoutes(
      searchString: username,
      type: "users",
      lastevaluatedkey: lastEvaluatedKey,
      authorization: authToken,
    ))
        .body;
    lastEvaluatedKey = searchUsersMap['data'].userlastevaluatedkey;
    searchUsersMap['isLoading'] = false;
    print("*****************************************************************");
    setState(() {});
    print(searchUsersMap);
  }

//
  Future<void> getMoreUsers() async {
    if (searchUsersMap['isLoading'] == true) return;
    setState(() {});

    if (lastEvaluatedKey != null) {
      await getUsers();
    } else {
      await Future.delayed(Duration(milliseconds: 200));
      searchUsersMap['isLoading'] = false;
    }

    setState(() {});
  }

  Widget showUsers() {
    final relationUsers =
        (searchUsersMap['data'] as BuiltUnifiedSearchResults)?.users;

    final bool isLoading = searchUsersMap['isLoading'];

    final listLength = (relationUsers?.length ?? 0) + 1;

    print(listLength);
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            getMoreUsers();
            searchUsersMap['isLoading'] = true;
          }
          return true;
        },
        child: ListView.builder(
            itemCount: listLength,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (index == listLength - 1) {
                if (isLoading)
                  return Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Center(child: CircularProgressIndicator()),
                  );
                else
                  return Container();
              }
              final _user = relationUsers[index];

              return _user != null
                  ? Container(
                      key: ValueKey(_user.username),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(_user.avatar),
                        ),
                        title: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => ProfilePage(
                                      userId: _user.userId,
                                    )));
                          },
                          child: Text(
                            _user.username,
                            style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        subtitle: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => ProfilePage(
                                      userId: _user.userId,
                                    )));
                          },
                          child: Text(
                            _user.tagline != null ? _user.tagline : "User",
                            style: TextStyle(
                              fontFamily: 'Lato',
                            ),
                          ),
                        ),
                      ))
                  : Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }

//  @override
//  void initState() {
//    super.initState();
//  }
//
//  @override
//  void didChangeDependencies(){
//    getUsers();
//    super.didChangeDependencies();
//  }

  // Widget showUsers() {
  //   return ListView.builder(
  //       shrinkWrap: true,
  //       itemCount: widget.users.length,
  //       itemBuilder: (context, index) {
  //         return InkWell(
  //           onTap: () {
  //             Navigator.of(context).push(MaterialPageRoute(
  //                 builder: (_) => ProfilePage(
  //                       userId: widget.users[index].userId,
  //                     )));
  //           },
  //           child: Container(
  //             margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
  //             child: ListTile(
  //               leading: CircleAvatar(
  //                 child: CustomImage(
  //                   image: widget.users[index].avatar + "_thumb",
  //                 ),
  //               ),
  //               title: Text(
  //                 widget.users[index].username,
  //                 style: TextStyle(fontFamily: "Lato"),
  //               ),
  //               subtitle: widget.users[index].name != null
  //                   ? Text(
  //                       widget.users[index].name,
  //                       style: TextStyle(fontFamily: "Lato"),
  //                     )
  //                   : Container(),
  //             ),
  //           ),
  //         );
  //       });
  // }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "\"${widget.query}\" in Users",
          style: TextStyle(
              fontFamily: "Lato",
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ),
      body: searchUsersMap['data'] != null
          ? showUsers()
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
