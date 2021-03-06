import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:built_collection/built_collection.dart';
import 'package:mootclub_app/providers/userData.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';
import 'package:provider/provider.dart';

import 'ProfilePage.dart';
class SearchAllUsers extends StatefulWidget {
  BuiltList<SummaryUser> users;
  final String query;
  SearchAllUsers({this.users,this.query});
  @override
  _SearchAllUsersState createState() => _SearchAllUsersState();
}

class _SearchAllUsersState extends State<SearchAllUsers> {
  Map<String, dynamic> searchUsersMap = {
    'data': null,
    'isLoading': true,
  };

//  getUsers() async {
//    String username = widget.query;
//    final service = Provider.of<DatabaseApiService>(context);
//    //allSearches = (await service.getUserbyUsername(username)).body;
//
//    final authToken = Provider.of<UserData>(context, listen: false).authToken;
//
//    searchUsersMap['data'] = (await service.unifiedQueryRoutes(
//      searchString: username,
//      type: "users",
//      lastevaluatedkey: (searchUsersMap['data'] as BuiltSearchUsers)?.lastevaluatedkey,
//      authorization: authToken,
//    )).body;
//    searchUsersMap['isLoading'] = false;
//    setState(() {
//    });
//    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
//    print(searchUsersMap['data']);
//    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
//    setState(() {
//    });
//  }
//
//  getMoreUsers()async{
//    if (searchUsersMap['isLoading'] == true) return;
//    setState(() {});
//
//    final lastevaulatedkey =
//        (searchUsersMap['data'] as BuiltSearchUsers)?.lastevaluatedkey;
//
//    if (lastevaulatedkey != null) {
//      await getUsers();
//    } else {
//      await Future.delayed(Duration(milliseconds: 200));
//      searchUsersMap['isLoading'] = false;
//    }
//
//    setState(() {});
//  }

//  Widget showUsers(){
//
//    final relationUsers = (searchUsersMap['data'] as BuiltSearchUsers)?.users;
//
//    final bool isLoading = searchUsersMap['isLoading'];
//
//    final listLength = (relationUsers?.length ?? 0) + 1;
//
//    return NotificationListener<ScrollNotification>(
//      onNotification: (ScrollNotification scrollInfo) {
//        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
//          searchUsersMap['isLoading'] = true;
//          getMoreUsers();
//        }
//        return true;
//      },
//      child: ListView.builder(
//          itemBuilder: (context,index){
//            if (index == listLength - 1) {
//              if (isLoading)
//                return Container(
//                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
//                  child: Center(child: CircularProgressIndicator()),
//                );
//              else
//                return Container();
//            }
//            final _user = relationUsers[index];
//
//            return Container(
//                key: ValueKey(_user.username),
//                margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
//                child: ListTile(
//                  leading: CircleAvatar(
//                  backgroundImage: NetworkImage(_user.avatar),
//                  ),
//                  title: InkWell(
//                    onTap: (){
//                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ProfilePage(userId: _user.userId,)));
//                    },
//                    child: Text(
//                    _user.username,
//                    style:
//                    TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold),
//                    ),
//                  ),
//                )
//              );
//
//          }),
//    );
//  }

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

  Widget showUsers(){
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.users.length,
      itemBuilder: (context,index){
        return InkWell(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ProfilePage(userId: widget.users[index].userId,)));
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: ListTile(
              leading: CachedNetworkImage(
                imageUrl: widget.users[index].avatar+"_thumb",
                imageBuilder: (context,imageProvider)=>CircleAvatar(
                  backgroundImage: imageProvider,
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              title: Text(
                widget.users[index].username,
                style: TextStyle(
                    fontFamily: "Lato"
                ),
              ),
              subtitle: widget.users[index].name!=null?
              Text(
                widget.users[index].name,
                style: TextStyle(
                  fontFamily: "Lato"
                ),
              ):
              Container(),
            ),
          ),
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        title: Text(
          "\"${widget.query}\" in Users",
          style: TextStyle(
            fontFamily: "Lato",
            fontWeight: FontWeight.bold,
            color: Colors.black
          ),
        ),
      ),
      body: showUsers(),
    );
  }
}
