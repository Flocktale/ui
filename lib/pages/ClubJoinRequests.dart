import 'package:flutter/material.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:provider/provider.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';
import 'package:mootclub_app/providers/userData.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClubJoinRequests extends StatefulWidget {
  final BuiltClub club;
  const ClubJoinRequests({this.club});
  @override
  _ClubJoinRequestsState createState() => _ClubJoinRequestsState();
}

class _ClubJoinRequestsState extends State<ClubJoinRequests> {
  BuiltActiveJoinRequests joinRequests;
  bool isLoading = false;
  final searchInput = TextEditingController();
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

  _fetchMoreJRData(){

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
//          joinRequests = joinRequests.rebuild(
//                  (b) =>
//                  b..activeJoinRequestUsers = joinRequests.activeJoinRequestUsers.where((val) => val.audience.username==val));
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
                  child: joinRequests != null &&
                      joinRequests.activeJoinRequestUsers != null
                      ? ListView.builder(
                      itemCount: joinRequests.activeJoinRequestUsers.length,
                      itemBuilder: (context, index) {
                        return Container(
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
