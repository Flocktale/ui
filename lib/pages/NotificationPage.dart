import 'package:flocktale/Widgets/customImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/pages/ClubDetail.dart';
import 'package:flocktale/pages/ProfilePage.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:provider/provider.dart';
import 'package:flocktale/providers/userData.dart';
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
    String lastEvalustedKey;
    notificationList = (await service.getNotifications(
      userId: cuser.userId,
      lastevaluatedkey: lastEvalustedKey,
    ))
        .body;

    //  var z = notificationList.notifications[0];
    List<NotificationData> temp = [];
    int curTime = DateTime.now().millisecondsSinceEpoch -
        Duration.microsecondsPerMinute * 30;

    notificationList.notifications.forEach((e) {
      temp.add(e);
    });

    temp.sort((a, b) {
      var t1 = (a.timestamp >= curTime &&
          (a.type == "CLUB#INV#prt" || a.type == "CLUB#INV#adc"));
      var t2 = (b.timestamp >= curTime &&
          (b.type == "CLUB#INV#prt" || b.type == "CLUB#INV#adc"));
      print('${a.type} :: $t1 :: ${b.type} :: $t2');
      var res = (t1 != t2 ? t1 == true : a.timestamp > b.timestamp);
      if (res) {
        return -1;
      } else
        return 1;
    });

    String lastevaluatedkey = notificationList.lastevaluatedkey;
    notificationList = notificationList.rebuild((b) {
      b.notifications.clear();
      temp.forEach((element) {
        b.notifications.add(element);
      });
      b.lastevaluatedkey = lastevaluatedkey;
    });

    setState(() {});
  }

  respondNotifications(String notifId) async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final cuser = Provider.of<UserData>(context, listen: false).user;
    notificationList = (await service.responseToNotification(
            userId: cuser.userId, notificationId: notifId, action: 'accept'))
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
      str = '$secDiff ' + (secDiff == 1 ? 's' : 's');
    } else if (minDiff < 60) {
      str = '$minDiff ' + (minDiff == 1 ? 'm' : 'm');
    } else if (hourDiff < 24) {
      str = '$hourDiff ' + (hourDiff == 1 ? 'h' : 'h');
    } else if (daysDiff < 7) {
      str = '$daysDiff ' + (daysDiff == 1 ? 'd' : 'd');
    } else {
      final weekDiff = daysDiff / 7;
      str = '$weekDiff ' + (weekDiff == 1 ? 'w' : 'w');
    }

    return str;
  }

  getClub(String clubId) async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final cuserId = Provider.of<UserData>(context, listen: false).userId;
    club = (await service.getClubByClubId(
      clubId: clubId,
      userId: cuserId,
    ))
        .body
        .club;
    setState(() {});
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
                        onTap: notificationList.notifications[index].type ==
                                    "FR#new" ||
                                notificationList.notifications[index].type ==
                                    "FR#accepted" ||
                                notificationList.notifications[index].type ==
                                    "FLW#new"
                            ? () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => ProfilePage(
                                          userId: notificationList
                                              .notifications[index]
                                              .targetResourceId,
                                        )));
                              }
                            : () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => ClubDetailPage(
                                          club: getClub(notificationList
                                              .notifications[index]
                                              .targetResourceId),
                                        )));
                              },
                        leading:
                            notificationList.notifications[index].avatar != null
                                ? CircleAvatar(
                                    child: CustomImage(
                                      image: notificationList
                                              .notifications[index].avatar +
                                          "_thumb",
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.white,
                                  ),
                        title: Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: notificationList
                                      .notifications[index].title,
                                  style: TextStyle(
                                      fontFamily: "Lato", color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: _processCommentTimestamp(
                                            notificationList
                                                .notifications[index]
                                                .timestamp),
                                        style: TextStyle(
                                            fontFamily: "Lato",
                                            color: Colors.grey))
                                  ]),
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

                                                  final resp = (await service
                                                      .responseToNotification(
                                                          userId: cuser.userId,
                                                          notificationId:
                                                              notificationList
                                                                  .notifications[
                                                                      index]
                                                                  .notificationId,
                                                          action: "accept"));
                                                  if (resp.isSuccessful) {
                                                    hasAccepted = !hasAccepted;
                                                    setState(() {});
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                ProfilePage(
                                                                  userId: notificationList
                                                                      .notifications[
                                                                          index]
                                                                      .targetResourceId,
                                                                )));
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
                                                      Navigator.of(context).push(MaterialPageRoute(
                                                          builder: (_) => ClubDetailPage(
                                                              club: getClub(
                                                                  notificationList
                                                                      .notifications[
                                                                          index]
                                                                      .targetResourceId))));
                                                    },
                                                    color: hasJoined == false
                                                        ? Colors.red[600]
                                                        : Colors.grey,
                                                    child: Text('Go to Club',
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

                                                  final resp = (await service
                                                      .responseToNotification(
                                                          userId: cuser.userId,
                                                          notificationId:
                                                              notificationList
                                                                  .notifications[
                                                                      index]
                                                                  .notificationId,
                                                          action: "cancel"));
                                                  if (resp.isSuccessful) {
                                                    final allNotification =
                                                        notificationList
                                                            .notifications
                                                            .toBuilder();
                                                    allNotification
                                                        .removeAt(index);
                                                    notificationList =
                                                        notificationList
                                                            .rebuild((b) => b
                                                              ..notifications =
                                                                  allNotification);
                                                    setState(() {});
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Something went wrong");
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
                                                      BorderRadius.circular(
                                                          5.0),
                                                  //side: BorderSide(color: Colors.red[600]),
                                                ),
                                              ),
                                            )
                                          : Container()
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
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
