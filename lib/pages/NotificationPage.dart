import 'package:flocktale/Models/enums/notificationType.dart';
import 'package:flocktale/Widgets/customImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/pages/ClubDetail.dart';
import 'package:flocktale/pages/ProfilePage.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

  Future _getNotifications() async {
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
          (a.type == NotificationType.CLUB_PARTICIPATION_INV ||
              a.type == NotificationType.CLUB_AUDIENCE_INV));
      var t2 = (b.timestamp >= curTime &&
          (b.type == NotificationType.CLUB_PARTICIPATION_INV ||
              b.type == NotificationType.CLUB_AUDIENCE_INV));
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
      final weekDiff = (daysDiff / 7).floor();
      str = '$weekDiff ' + (weekDiff == 1 ? 'w' : 'w');
    }

    return str;
  }

  _getClub(String clubId) async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final cuserId = Provider.of<UserData>(context, listen: false).userId;
    club = (await service.getClubByClubId(
      clubId: clubId,
      userId: cuserId,
    ))
        .body
        .club;
  }

  Future<void> _respondToFriendRequest(
      NotificationData notif, String response, int index) async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final cuser = Provider.of<UserData>(context, listen: false).user;

    final resp = (await service.responseToNotification(
        userId: cuser.userId,
        notificationId: notif.notificationId,
        action: response));

    if (resp.isSuccessful) {
      final allNotification = notificationList.notifications.toBuilder();

      if (response == 'accept') {
        allNotification[index] =
            allNotification[index].rebuild((b) => b..opened = true);

        _navigateToTargeResourceId(notif);
      } else if (response == 'cancel') {
        allNotification.removeAt(index);
      }
      notificationList =
          notificationList.rebuild((b) => b..notifications = allNotification);
    } else {
      Fluttertoast.showToast(msg: "Some error occured ");
    }
    setState(() {});
  }

  Widget _whenNotificationNotOpened(NotificationData notif, int index) {
    if (notif.type == NotificationType.CLUB_PARTICIPATION_INV) {
      return InkWell(
        onTap: () => _navigateToTargeResourceId(notif),
        child: _notificationButton(
          title: 'Go to Club',
          textColor: Colors.white,
          buttonColor: Colors.red[600],
        ),
      );
    } else if (notif.type == NotificationType.NEW_FRIEND_REQUEST) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () => _respondToFriendRequest(notif, 'accept', index),
            child: _notificationButton(
              title: 'Accept',
              textColor: Colors.white,
              buttonColor: Colors.red[600],
            ),
          ),
          InkWell(
            onTap: () => _respondToFriendRequest(notif, 'cancel', index),
            child: _notificationButton(
              title: 'Decline',
              textColor: Colors.redAccent,
              buttonColor: Colors.white,
            ),
          )
        ],
      );
    } else
      return Container();
  }

  Widget _notificationButton({
    String title,
    Color textColor = Colors.white,
    Color buttonColor = Colors.redAccent,
  }) {
    return Card(
      shadowColor: Colors.redAccent,
      elevation: 2,
      color: buttonColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _navigateToTargeResourceId(NotificationData notif) async {
    Widget page;
    if (notif.type == NotificationType.NEW_FRIEND_REQUEST ||
        notif.type == NotificationType.FRIEND_REQUEST_ACCEPTED ||
        notif.type == NotificationType.NEW_FOLLOWER) {
      // navigating to user profile

      page = ProfilePage(
        userId: notif.targetResourceId,
      );
    } else if (notif.type == NotificationType.CLUB_AUDIENCE_INV ||
        notif.type == NotificationType.CLUB_PARTICIPATION_INV) {
      // navigating to club

      page = ClubDetailPage(
        club: await _getClub(notif.targetResourceId),
      );
    }

    if (page != null) {
      await Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
      // resetting the notifications
      setState(() {
        notificationList = null;
      });

      _getNotifications();
    }
  }

  Widget _displayNotificationList() {
    return ListView.builder(
      itemCount: notificationList.notifications.length,
      itemBuilder: (context, index) {
        final notif = notificationList.notifications[index];

        return Container(
          key: ValueKey(notif.title),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: InkWell(
            onTap: () => _navigateToTargeResourceId(notif),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  child: CustomImage(
                    image: notif.avatar + '_thumb',
                    radius: 8,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: RichText(
                            text: TextSpan(
                              text: notif.title,
                              style: TextStyle(
                                fontFamily: "Lato",
                                color: Colors.white,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: '\t' +
                                        _processCommentTimestamp(
                                            notificationList
                                                .notifications[index]
                                                .timestamp),
                                    style: TextStyle(
                                      fontFamily: "Lato",
                                      color: Colors.white70,
                                    ))
                              ],
                            ),
                          ),
                        ),
                        notif.opened == false
                            ? _whenNotificationNotOpened(notif, index)
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    _getNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: Text(
              'Notifications',
              style: TextStyle(
                fontFamily: 'Lato',
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: notificationList != null
              ? RefreshIndicator(
                  onRefresh: _getNotifications,
                  child: Container(
                    child: _displayNotificationList(),
                  ),
                )
              : Container(
                  child: Center(
                    child: SpinKitChasingDots(
                      color: Colors.redAccent,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
