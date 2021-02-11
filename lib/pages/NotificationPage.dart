import 'package:flutter/material.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';
import 'package:provider/provider.dart';
import 'package:mootclub_app/providers/userData.dart';
import 'package:fluttertoast/fluttertoast.dart';
class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  BuiltNotificationList notificationList;

  Future getNotifications() async{
    final service = Provider.of<DatabaseApiService>(context,listen: false);
    final cuser = Provider.of<UserData>(context,listen:false).user;
    final authToken = Provider.of<UserData>(context,listen:false).authToken;
    String lastEvalustedKey;
    notificationList = (await service.getNotifications(cuser.userId, lastEvalustedKey, authorization: authToken)).body;
    setState(() {
    });
  }

  @override
  void initState(){
    getNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool hasAccepted = false;
    bool hasJoined = false;
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text(
            'Notifications',
          style: TextStyle(
            fontFamily: 'Lato',
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        backgroundColor: Colors.white,
      ),
      body: notificationList!=null?RefreshIndicator(
        onRefresh: getNotifications,
        child: Container(
          height: size.height,
          child: ListView.builder(
            itemCount: notificationList.notifications.length,
            itemBuilder: (context,index){
              return ListTile(
                leading: notificationList.notifications[index].secondaryAvatar!=null?Image.network(notificationList.notifications[index].secondaryAvatar):Image.asset("assets/Card1.jpg"),
                title: Text(
                  notificationList.notifications[index].title,
                  style: TextStyle(
                    fontFamily: "Lato",
                  ),
                ),
                trailing: notificationList.notifications[index].type=="FR#new"?
                ButtonTheme(
                  minWidth: size.width / 3.5,
                  child: RaisedButton(
                    onPressed: () async{
                      final service = Provider.of<DatabaseApiService>(context,listen: false);
                      final cuser = Provider.of<UserData>(context,listen:false).user;
                      final authToken = Provider.of<UserData>(context,listen:false).authToken;
                      final resp = (await service.acceptFriendRequest(cuser.userId, notificationList.notifications[index].targetResourceId, authorization: authToken));
                      if(resp.isSuccessful){
                      hasAccepted = !hasAccepted;
                      setState(() {
                      });
                      }
                      else{
                        Fluttertoast.showToast(msg: "Some error occured ${resp.body}");
                      }
                    },
                    color: hasAccepted==false?
                    Colors.red[600]:
                    Colors.grey,
                    child: Text(
                      hasAccepted==false?
                        'Accept':'Accepted',
                        style: TextStyle(
                          color: hasAccepted==false?
                          Colors.white:Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lato',
                        )),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      //side: BorderSide(color: Colors.red[600]),
                    ),
                  ),
                ):
                notificationList.notifications[index].type=="CLUB#INV#prt" || notificationList.notifications[index].type=="CLUB#INV#adc"?
                ButtonTheme(
                  minWidth: size.width / 3.5,
                  child: RaisedButton(
                    onPressed: () async{
                      hasJoined = !hasJoined;
                      setState(() {
                      });
                    },
                    color: hasJoined==false?Colors.red[600]:Colors.grey,
                    child: Text('Join',
                        style: TextStyle(
                          color: hasJoined==false?Colors.white:Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lato',
                        )),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      //side: BorderSide(color: Colors.red[600]),
                    ),
                  ),
                ):
                Container(),
              );
            },
          ),
        ),
      ):Container(
        child: Center(
            child: Text(
              "Loading..",
              style: TextStyle(
                  fontFamily: 'Lato',
                  color: Colors.grey
              ),
            )
        ),
      ),

    ));
  }
}
