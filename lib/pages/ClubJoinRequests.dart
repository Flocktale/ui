import 'package:cached_network_image/cached_network_image.dart';
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
  BuiltActiveJoinRequests joinRequestsFiltered;
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

  fetchMoreJoinRequests()async{
    if(isLoading==true) return;
    setState(() {
    });
    final lastEvaluatedKey = joinRequests?.lastevaluatedkey;
    if(lastEvaluatedKey!=null){
      await getJoinRequests();
    }
    else{
      await Future.delayed(Duration(milliseconds: 200));
      isLoading = false;
    }
    setState(() {
    });
  }

  searchJoinRequests(String searchString)async{
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    joinRequestsFiltered = (await service.searchInActiveJoinRequests(clubId: widget.club.clubId, searchString: joinRequestsFiltered?.lastevaluatedkey, authorization: authToken)).body;
    setState(() {
    });
  }

  searchMoreJoinRequests(String searchString)async{
    if(isLoading==true) return;
    setState(() {
    });
    final lastEvaluatedKey = joinRequestsFiltered?.lastevaluatedkey;
    if(lastEvaluatedKey!=null){
      await searchJoinRequests(searchString);
    }
    else{
      await Future.delayed(Duration(milliseconds: 200));
      isLoading = false;
    }
    setState(() {
    });
  }

  Widget searchBar() {
    return Container(
      height: 40,
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
          searchJoinRequests(val);
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
          body: Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              children: [
                SizedBox(height: size.height/30,),
                searchBar(),
                SizedBox(height: size.height/30,),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                        if(searchInput.text.isNotEmpty)
                          searchMoreJoinRequests(searchInput.text);
                        else
                          fetchMoreJoinRequests();
                        isLoading = true;
                      }
                      return true;
                    },
                    child: ListView.builder(
                        itemCount: searchInput.text.isNotEmpty?
                        joinRequestsFiltered!=null?
                            joinRequestsFiltered.activeJoinRequestUsers.length
                            :0
                        :joinRequests!=null?
                            joinRequests.activeJoinRequestUsers.length
                            :0,
                        itemBuilder: (context, index) {
                          BuiltActiveJoinRequests _joinRequests = searchInput.text.isNotEmpty? joinRequestsFiltered:joinRequests;
                          return InkWell(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ProfilePage(userId: _joinRequests.activeJoinRequestUsers[index].audience.userId,)));
                            },
                            child: Container(
                              key: ValueKey(_joinRequests
                                  .activeJoinRequestUsers[index].audience.userId),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(_joinRequests
                                      ?.activeJoinRequestUsers[index]?.audience?.avatar),
                                ),
                                title: Text(
                                  _joinRequests?.activeJoinRequestUsers[index]?.audience
                                      ?.username !=
                                      null
                                      ? _joinRequests?.activeJoinRequestUsers[index]
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
                                      final resp = await acceptJoinRequest(_joinRequests
                                          ?.activeJoinRequestUsers[index]
                                          ?.audience
                                          ?.userId);
                                      Fluttertoast.showToast(
                                          msg: "Join Request Accepted");
                                      final allRequests =
                                      _joinRequests.activeJoinRequestUsers.toBuilder();

                                      allRequests.removeAt(index);
                                      _joinRequests = _joinRequests.rebuild(
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
                        }),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
