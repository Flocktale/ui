import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/pages/Club.dart';
import 'package:mootclub_app/pages/ProfilePage.dart';
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
  BuiltClub club;
  Future getNotifications() async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final cuser = Provider.of<UserData>(context, listen: false).user;
    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    String lastEvalustedKey;
    notificationList = (await service.getNotifications(
      userId: cuser.userId,
      lastevaluatedkey: lastEvalustedKey,
      authorization: authToken,
    ))
        .body;
    setState(() {});
  }

  respondNotifications(String notifId) async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final cuser = Provider.of<UserData>(context, listen: false).user;
    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    notificationList = (await service.responseToNotification(
            userId: cuser.userId,
            notificationId: notifId,
            authorization: authToken,
            action: 'accept'))
        .body;
    setState(() {});
  }
  String _processCommentTimestamp(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final diff = DateTime.now().difference(dateTime);

    final secDiff = diff.inSeconds;
    final minDiff = diff.inMinutes;
    final hourDiff = diff.inHours;
    final daysDiff = diff.inDays;

    String str = '';

    if (secDiff < 60) {
      str = '$secDiff ' + (secDiff == 1 ? 's' : 's') ;
    } else if (minDiff < 60) {
      str = '$minDiff ' + (minDiff == 1 ? 'm' : 'm');
    } else if (hourDiff < 24) {
      str = '$hourDiff ' + (hourDiff == 1 ? 'h' : 'h');
    } else if (daysDiff < 7) {
      str = '$daysDiff ' + (daysDiff == 1 ? 'd' : 'd') ;
    } else {
      final weekDiff = daysDiff / 7;
      str = '$weekDiff ' + (weekDiff == 1 ? 'w' : 'w') ;
    }

    return str;
  }

  getClub(String clubId) async{
    final service = Provider.of<DatabaseApiService>(context,listen: false);
    final authToken = Provider.of<UserData>(context,listen: false).authToken;
    final cuserId = Provider.of<UserData>(context,listen:false).userId;
    club = (await service.getClubByClubId(clubId: clubId, userId: cuserId, authorization: authToken)).body.club;
    setState(() {
    });
  }

  @override
  void initState() {
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
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: notificationList != null
          ? RefreshIndicator(
              onRefresh: getNotifications,
              child: Container(
                child: ListView.builder(
                  itemCount: notificationList.notifications.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                      child: ListTile(
                        onTap:
                        notificationList.notifications[index].type=="FR#new" || notificationList.notifications[index].type=="FR#accepted" || notificationList.notifications[index].type=="FLW#new"?
                        (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ProfilePage(userId: notificationList.notifications[index].targetResourceId,)));
                        }:
                        (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>Club(club: getClub(notificationList.notifications[index].targetResourceId),)));
                        },
                        leading: notificationList.notifications[index].avatar !=
                                null
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(notificationList
                                    .notifications[index].avatar))
                            : CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/Card1.jpg")),
                        title: Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                text: notificationList.notifications[index].title,
                                style: TextStyle(
                                  fontFamily: "Lato",
                                  color: Colors.black
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: _processCommentTimestamp(notificationList.notifications[index].timestamp),
                                    style: TextStyle(
                                      fontFamily: "Lato",
                                      color: Colors.grey
                                    )
                                  )
                                ]
                              ),
                            ),
                            notificationList.notifications[index].opened ==
                                    false
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      notificationList
                                                  .notifications[index].type ==
                                              "FR#new"
                                          ? ButtonTheme(
                                              minWidth: size.width / 3.5,
                                              child: RaisedButton(
                                                onPressed: () async {
                                                  final service = Provider.of<
                                                          DatabaseApiService>(
                                                      context,
                                                      listen: false);
                                                  final cuser =
                                                      Provider.of<UserData>(
                                                              context,
                                                              listen: false)
                                                          .user;
                                                  final authToken =
                                                      Provider.of<UserData>(
                                                              context,
                                                              listen: false)
                                                          .authToken;
                                                  final resp = (await service
                                                      .responseToNotification(
                                                          userId: cuser.userId,
                                                          notificationId:
                                                              notificationList
                                                                  .notifications[
                                                                      index]
                                                                  .notificationId,
                                                          authorization:
                                                              authToken,
                                                          action: "accept"));
                                                  if (resp.isSuccessful) {
                                                    hasAccepted = !hasAccepted;
                                                    setState(() {});
                                                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ProfilePage(userId: notificationList.notifications[index].targetResourceId,)));
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Some error occured ");
                                                  }
                                                },
                                                color: hasAccepted == false
                                                    ? Colors.red[600]
                                                    : Colors.grey,
                                                child: Text(
                                                    hasAccepted == false
                                                        ? 'Accept'
                                                        : 'Accepted',
                                                    style: TextStyle(
                                                      color:
                                                          hasAccepted == false
                                                              ? Colors.white
                                                              : Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Lato',
                                                    )),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  //side: BorderSide(color: Colors.red[600]),
                                                ),
                                              ),
                                            )
                                          : notificationList
                                                      .notifications[index]
                                                      .type ==
                                                  "CLUB#INV#prt"
                                              ? ButtonTheme(
                                                  minWidth: size.width / 3.5,
                                                  child: RaisedButton(
                                                    onPressed: () async {
                                                      final service = Provider
                                                          .of<DatabaseApiService>(
                                                              context,
                                                              listen: false);
                                                      final cuser =
                                                          Provider.of<UserData>(
                                                                  context,
                                                                  listen: false)
                                                              .user;
                                                      final authToken =
                                                          Provider.of<UserData>(
                                                                  context,
                                                                  listen: false)
                                                              .authToken;
                                                      final resp = (await service
                                                          .responseToNotification(
                                                              userId:
                                                                  cuser.userId,
                                                              notificationId:
                                                                  notificationList
                                                                      .notifications[
                                                                          index]
                                                                      .notificationId,
                                                              authorization:
                                                                  authToken,
                                                              action:
                                                                  "accept"));
                                                      if (resp.isSuccessful) {
                                                        hasJoined = !hasJoined;
                                                        setState(() {});
                                                        Navigator.of(context).push(MaterialPageRoute(builder: (_)=>Club(club: getClub(notificationList.notifications[index].targetResourceId),)));
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Something went wrong");
                                                      }
                                                    },
                                                    color: hasJoined == false
                                                        ? Colors.red[600]
                                                        : Colors.grey,
                                                    child: Text('Join',
                                                        style: TextStyle(
                                                          color: hasJoined ==
                                                                  false
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'Lato',
                                                        )),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                      //side: BorderSide(color: Colors.red[600]),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                      ButtonTheme(
                                        minWidth: size.width / 3.5,
                                        child: RaisedButton(
                                          onPressed: () async {
                                            final service =
                                                Provider.of<DatabaseApiService>(
                                                    context,
                                                    listen: false);
                                            final cuser = Provider.of<UserData>(
                                                    context,
                                                    listen: false)
                                                .user;
                                            final authToken =
                                                Provider.of<UserData>(context,
                                                        listen: false)
                                                    .authToken;
                                            final resp = (await service
                                                .responseToNotification(
                                                    userId: cuser.userId,
                                                    notificationId:
                                                        notificationList
                                                            .notifications[
                                                                index]
                                                            .notificationId,
                                                    authorization: authToken,
                                                    action: "cancel"));
                                            if (resp.isSuccessful) {
                                              final allNotification =
                                                  notificationList.notifications
                                                      .toBuilder();
                                              allNotification.removeAt(index);
                                              notificationList =
                                                  notificationList.rebuild(
                                                      (b) => b
                                                        ..notifications =
                                                            allNotification);
                                              setState(() {});
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: "Something went wrong");
                                            }
                                          },
                                          color: Colors.white,
                                          child: Text('Decline',
                                              style: TextStyle(
                                                color: Colors.redAccent,
                                                fontFamily: 'Lato',
                                              )),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            //side: BorderSide(color: Colors.red[600]),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : Container(),
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
            )
          : Container(
              child: Center(
                  child: Text(
                "Loading..",
                style: TextStyle(fontFamily: 'Lato', color: Colors.grey),
              )),
            ),
    ));
  }
}
