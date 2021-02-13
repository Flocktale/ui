import 'package:flutter/cupertino.dart';
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
    return SafeArea(
      child: Scaffold(
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
      body: notificationList!=null?
      RefreshIndicator(
        onRefresh: getNotifications,
        child: Container(
          child: ListView.builder(
            itemCount: notificationList.notifications.length,
            itemBuilder: (context,index){
              return Container(
                margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                child: ListTile(
                  leading: notificationList.notifications[index].secondaryAvatar!=null?
                  CircleAvatar(backgroundImage: NetworkImage(notificationList.notifications[index].avatar)):
                  CircleAvatar(backgroundImage:AssetImage("assets/Card1.jpg")),
                  title: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            notificationList.notifications[index].title,
                            style: TextStyle(
                              fontFamily: "Lato",
                            ),
                          ),
                          Text(
                            DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(notificationList.notifications[index].timestamp)).inSeconds<60?
                            DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(notificationList.notifications[index].timestamp)).inSeconds==1?
                            DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(notificationList.notifications[index].timestamp)).inSeconds.toString()+" s":
                            DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(notificationList.notifications[index].timestamp)).inSeconds.toString() + " s":
                            DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(notificationList.notifications[index].timestamp)).inMinutes<60?
                            DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(notificationList.notifications[index].timestamp)).inMinutes==1?
                            DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(notificationList.notifications[index].timestamp)).inMinutes.toString() + " m":
                            DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(notificationList.notifications[index].timestamp)).inMinutes.toString() + " m":
                            DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(notificationList.notifications[index].timestamp)).inHours<24?
                            DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(notificationList.notifications[index].timestamp)).inHours==1?
                            DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(notificationList.notifications[index].timestamp)).inHours.toString() + " h":
                            DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(notificationList.notifications[index].timestamp)).inHours.toString() + " h":
                            DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(notificationList.notifications[index].timestamp)).inDays==1?
                            DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(notificationList.notifications[index].timestamp)).inDays.toString()+" d":
                            DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(notificationList.notifications[index].timestamp)).inDays.toString()+" d",
                            style: TextStyle(
                              fontFamily: "Lato",
                              color: Colors.grey
                            ),
                          )
                        ],
                      ),
                      notificationList.notifications[index].type=="FR#new"?
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
                    ],
                  ),
//                trailing: notificationList.notifications[index].type=="FR#new"?
//                ButtonTheme(
//                  minWidth: size.width / 3.5,
//                  child: RaisedButton(
//                    onPressed: () async{
//                      final service = Provider.of<DatabaseApiService>(context,listen: false);
//                      final cuser = Provider.of<UserData>(context,listen:false).user;
//                      final authToken = Provider.of<UserData>(context,listen:false).authToken;
//                      final resp = (await service.acceptFriendRequest(cuser.userId, notificationList.notifications[index].targetResourceId, authorization: authToken));
//                      if(resp.isSuccessful){
//                      hasAccepted = !hasAccepted;
//                      setState(() {
//                      });
//                      }
//                      else{
//                        Fluttertoast.showToast(msg: "Some error occured ${resp.body}");
//                      }
//                    },
//                    color: hasAccepted==false?
//                    Colors.red[600]:
//                    Colors.grey,
//                    child: Text(
//                      hasAccepted==false?
//                        'Accept':'Accepted',
//                        style: TextStyle(
//                          color: hasAccepted==false?
//                          Colors.white:Colors.black,
//                          fontWeight: FontWeight.bold,
//                          fontFamily: 'Lato',
//                        )),
//                    shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(5.0),
//                      //side: BorderSide(color: Colors.red[600]),
//                    ),
//                  ),
//                ):
//                notificationList.notifications[index].type=="CLUB#INV#prt" || notificationList.notifications[index].type=="CLUB#INV#adc"?
//                ButtonTheme(
//                  child: RaisedButton(
//                    onPressed: () async{
//                      hasJoined = !hasJoined;
//                      setState(() {
//                      });
//                    },
//                    color: hasJoined==false?Colors.red[600]:Colors.grey,
//                    child: Text('Join',
//                        style: TextStyle(
//                          color: hasJoined==false?Colors.white:Colors.black,
//                          fontWeight: FontWeight.bold,
//                          fontFamily: 'Lato',
//                        )),
//                    shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(5.0),
//                      //side: BorderSide(color: Colors.red[600]),
//                    ),
//                  ),
//                ):
//                Container(),
                ),
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
