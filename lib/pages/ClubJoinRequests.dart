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
  getJoinRequests() async{
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    String lastevaluatedkey;
    joinRequests = (await service.getActiveJoinRequests(widget.club.clubId, lastevaluatedkey, authorization: authToken)).body;
    setState(() {
    });
  }

  acceptJoinRequest(String audienceId) async{
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    await service.respondToJoinRequest(widget.club.clubId, "accept", audienceId, authorization: authToken);
    Fluttertoast.showToast(msg:"Join Request Accepted");
    setState(() {});
  }

  @override
  void initState(){
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
        child: joinRequests!=null && joinRequests.activeJoinRequestUsers!=null?
        ListView.builder(
          itemCount: joinRequests.activeJoinRequestUsers.length,
            itemBuilder: (context, index) {
          return Container(
            child:
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(joinRequests?.activeJoinRequestUsers[index]?.audience?.avatar),
              ),
              title: Text(
                joinRequests?.activeJoinRequestUsers[index]?.audience?.name!=null?
                joinRequests?.activeJoinRequestUsers[index]?.audience?.name:"Name $index",
                style:
                    TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                joinRequests?.activeJoinRequestUsers[index]?.audience?.username!=null?
                joinRequests?.activeJoinRequestUsers[index]?.audience?.username:"@Username$index",
                style: TextStyle(fontFamily: 'Lato'),
              ),
              trailing: ButtonTheme(
                minWidth: size.width / 3.5,
                child: RaisedButton(
                  onPressed: () async{
                    final resp = await acceptJoinRequest(joinRequests?.activeJoinRequestUsers[index]?.audience?.userId);
                    Fluttertoast.showToast(msg: "Join Request Accepted");
                    setState(() {
                    });
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
        }):Container(height: 0),
      ),
    ));
  }
}
