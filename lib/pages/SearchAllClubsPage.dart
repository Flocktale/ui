import 'package:flutter/material.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flocktale/pages/Club.dart';

class SearchAllClubs extends StatefulWidget {
  final BuiltList<BuiltClub> clubs;
  final String query;
  SearchAllClubs({this.clubs, this.query});
  @override
  _SearchAllClubsState createState() => _SearchAllClubsState();
}

class _SearchAllClubsState extends State<SearchAllClubs> {
//  Map<String, dynamic> searchClubsMap = {
//    'data': null,
//    'isLoading': true,
//  };

//  getClubs() async {
//    String username = widget.query;
//    final service = Provider.of<DatabaseApiService>(context);
//    //allSearches = (await service.getUserbyUsername(username)).body;
//
//    final authToken = Provider.of<UserData>(context, listen: false).authToken;
//
//    searchClubsMap['data'] = (await service.unifiedQueryRoutes(
//      searchString: username,
//      type: "clubs",
//      lastevaluatedkey: (searchClubsMap['data'] as BuiltSearchClubs)?.lastevaluatedkey,
//      authorization: authToken,
//    )).body.clubs;
//    searchClubsMap['isLoading'] = false;
//    setState(() {
//    });
//    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
//    print(searchClubsMap['data']);
//    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
//  }
//
//  getMoreClubs()async{
//    if (searchClubsMap['isLoading'] == true) return;
//    setState(() {});
//
//    final lastevaulatedkey =
//        (searchClubsMap['data'] as BuiltSearchUsers)?.lastevaluatedkey;
//
//    if (lastevaulatedkey != null) {
//      await getClubs();
//    } else {
//      await Future.delayed(Duration(milliseconds: 200));
//      searchClubsMap['isLoading'] = false;
//    }
//
//    setState(() {});
//  }
//
//  Widget showClubs(){
//
//    final relationUsers = (searchClubsMap['data'] as BuiltSearchUsers)?.users;
//
//    final bool isLoading = searchClubsMap['isLoading'];
//
//    final listLength = (relationUsers?.length ?? 0) + 1;
//
//    return NotificationListener<ScrollNotification>(
//      onNotification: (ScrollNotification scrollInfo) {
//        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
//          searchClubsMap['isLoading'] = true;
//          getMoreClubs();
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
//                    backgroundImage: NetworkImage(_user.avatar),
//                  ),
//                  title: InkWell(
//                    onTap: (){
//                      Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ProfilePage(userId: _user.userId,)));
//                    },
//                    child: Text(
//                      _user.username,
//                      style:
//                      TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold),
//                    ),
//                  ),
//                )
//            );
//
//          }),
//    );
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    getClubs();
//  }

  Widget showClubs() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.clubs.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => Club(
                        club: widget.clubs[index],
                      )));
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: ListTile(
                leading: CircleAvatar(
                  child: FadeInImage.assetNetwork(
                    image: widget.clubs[index].clubAvatar + "_thumb",
                    placeholder: 'assets/gifs/fading_lines.gif',
                    imageErrorBuilder: (context, _, __) =>
                        Image.asset('assets/images/logo.ico'),
                  ),
                ),
                title: Text(
                  widget.clubs[index].clubName,
                  style: TextStyle(fontFamily: "Lato"),
                ),
                subtitle: widget.clubs[index].creator != null
                    ? Text(
                        widget.clubs[index].creator.username,
                        style: TextStyle(fontFamily: "Lato"),
                      )
                    : Container(),
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
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "\"${widget.query}\" in Clubs",
          style: TextStyle(
              fontFamily: "Lato",
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ),
      body: showClubs(),
    );
  }
}
