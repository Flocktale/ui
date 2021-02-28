import 'package:flutter/material.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:provider/provider.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';
import 'package:mootclub_app/providers/userData.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:built_collection/built_collection.dart';
import 'ProfilePage.dart';

class ClubJoinRequests extends StatefulWidget {
  final BuiltClub club;
  const ClubJoinRequests({this.club});
  @override
  _ClubJoinRequestsState createState() => _ClubJoinRequestsState();
}

class _ClubJoinRequestsState extends State<ClubJoinRequests> {
  BuiltActiveJoinRequests joinRequests;
  BuiltList<JoinRequests> _searchResult;
  bool isLoading = false;
  final searchInput = new TextEditingController();
  getJoinRequests() async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    String lastevaluatedkey;
    joinRequests = (await service.getActiveJoinRequests(
      clubId: widget.club.clubId,
      lastevaluatedkey: lastevaluatedkey,
      authorization: authToken,
    ))
        .body;
    _searchResult = joinRequests.activeJoinRequestUsers;
    setState(() {});
  }

  acceptJoinRequest(String audienceId) async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    await service.respondToJoinRequest(
      clubId: widget.club.clubId,
      action: "accept",
      audienceId: audienceId,
      authorization: authToken,
    );
    Fluttertoast.showToast(msg: "Join Request Accepted");
    setState(() {});
  }

  _fetchMoreJRData(){

  }

  onSearchTextChanged(String text) async {
    _searchResult.toList().clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    final _userDetails = joinRequests.activeJoinRequestUsers;
    _userDetails.forEach((userDetail) {
      if (userDetail.audience.username.contains(text))
        _searchResult.toList().add(userDetail);
    });
    print("SEARCH RESULT");
    print(_searchResult);
    setState(() {});
  }


  Widget searchBar() {
    return Container(
      height: 40,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextField(
        controller: searchInput,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            fillColor: Colors.grey[200],
            hintText: 'Search username',
            filled: true,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: Colors.black, width: 1.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0))),
        onChanged: (val){
          onSearchTextChanged(val);
        },
      ),
    );
  }
  @override
  void initState() {
    getJoinRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Join Requests',
              style: TextStyle(
                fontFamily: 'Lato',
                color: Colors.black,
              ),
            ),
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
          ),
          body: Column(
            children: [
              SizedBox(height: size.height/30,),
              searchBar(),
              SizedBox(height: size.height/30,),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                      _fetchMoreJRData();
                      isLoading = true;
                    }
                    return true;
                  },
                  child:
                      _searchResult!=null
                      ? ListView.builder(
                          itemCount: _searchResult.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ProfilePage(userId: _searchResult[index].audience.userId,)));
                              },
                              child: Container(
                                key: ValueKey(_searchResult[index].audience.userId),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(_searchResult[index]?.audience?.avatar),
                                  ),
                                  title: Text(
                                    _searchResult[index]?.audience?.username !=
                                        null
                                        ? _searchResult[index]
                                        ?.audience?.username
                                        : "@Username$index",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Lato', fontWeight: FontWeight.bold),
                                  ),
                                  trailing: ButtonTheme(
                                    minWidth: size.width / 3.5,
                                    child: RaisedButton(
                                      onPressed: () async {
                                        final resp = await acceptJoinRequest(_searchResult[index]
                                            ?.audience
                                            ?.userId);
                                        Fluttertoast.showToast(
                                            msg: "Join Request Accepted");
                                        final allRequests =
                                        _searchResult.toBuilder();

                                        allRequests.removeAt(index);
                                        joinRequests = joinRequests.rebuild(
                                                (b) => b..activeJoinRequestUsers = allRequests);
                                        _searchResult = joinRequests.activeJoinRequestUsers;

                                        setState(() {});
                                      },
                                      color: Colors.red[600],
                                      child: Text('Accept',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Lato',
                                          )),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        //side: BorderSide(color: Colors.red[600]),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          })

                      : joinRequests != null &&
                      joinRequests.activeJoinRequestUsers != null && searchInput.text.isEmpty
                      ? ListView.builder(
                      itemCount: joinRequests.activeJoinRequestUsers.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ProfilePage(userId: joinRequests.activeJoinRequestUsers[index].audience.userId,)));
                          },
                          child: Container(
                            key: ValueKey(joinRequests
                                .activeJoinRequestUsers[index].audience.userId),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(joinRequests
                                    ?.activeJoinRequestUsers[index]?.audience?.avatar),
                              ),
                              title: Text(
                                joinRequests?.activeJoinRequestUsers[index]?.audience
                                    ?.username !=
                                    null
                                    ? joinRequests?.activeJoinRequestUsers[index]
                                    ?.audience?.username
                                    : "@Username$index",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Lato', fontWeight: FontWeight.bold),
                              ),
                              trailing: ButtonTheme(
                                minWidth: size.width / 3.5,
                                child: RaisedButton(
                                  onPressed: () async {
                                    final resp = await acceptJoinRequest(joinRequests
                                        ?.activeJoinRequestUsers[index]
                                        ?.audience
                                        ?.userId);
                                    Fluttertoast.showToast(
                                        msg: "Join Request Accepted");
                                    final allRequests =
                                    joinRequests.activeJoinRequestUsers.toBuilder();

                                    allRequests.removeAt(index);
                                    joinRequests = joinRequests.rebuild(
                                            (b) => b..activeJoinRequestUsers = allRequests);

                                    setState(() {});
                                  },
                                  color: Colors.red[600],
                                  child: Text('Accept',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Lato',
                                      )),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    //side: BorderSide(color: Colors.red[600]),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                      : Container(height: 0),
                ),
              ),
            ],
          ),
        ));
  }
}
