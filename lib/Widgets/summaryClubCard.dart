import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/Models/enums/clubStatus.dart';
import 'package:flocktale/Widgets/customImage.dart';
import 'package:flocktale/pages/ClubDetail.dart';
import 'package:flocktale/providers/agoraController.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SummaryClubCard extends StatelessWidget {
  final Color shadow = Color(0xFF191818);
  final BuiltClub club;
  final Function(Widget) navigateTo;

  SummaryClubCard(this.club, this.navigateTo);

  _showMaterialDialog(BuildContext context) async {
    BuiltClub activeClub =
        Provider.of<AgoraController>(context, listen: false).club;
    final res = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                "Please end the club \"${activeClub.clubName}\" before entering another club."),
            actions: [
              FlatButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      fontFamily: "Lato",
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text(
                  "Ok",
                  style: TextStyle(
                      fontFamily: "Lato",
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });

    if (res == true) {
      navigateTo(ClubDetailPage(club: activeClub));
    }
  }

  String _processTimestamp(int timestamp) {
    if (DateTime.now()
            .compareTo(DateTime.fromMillisecondsSinceEpoch(timestamp)) >
        0) return "Waiting";

    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, 23, 59, 59);
    if (today.compareTo(dateTime) >= 0) {
      String formattedDate2 = DateFormat.Hm().format(dateTime) + " Hrs";
      return formattedDate2;
    }

    String formattedDate2 =
        DateFormat.MMMd().add_Hm().format(dateTime) + " Hrs";
    return formattedDate2;
  }

  Widget clubStatusWidget(ClubStatus status, int scheduleTime) {
    final statusContainer =
        ({Color color, String text, Color textColor}) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              color: color,
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            );

    if (status == ClubStatus.Live)
      return statusContainer(
          color: Colors.red, text: ' LIVE ', textColor: Colors.white);
    else if (status == ClubStatus.Concluded)
      return statusContainer(
          color: Colors.black54, text: 'Ended', textColor: Colors.white);
    else
      return Container(
        color: Colors.black54,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.timer, color: Colors.white, size: 20),
            statusContainer(
                text: _processTimestamp(scheduleTime), textColor: Colors.white),
          ],
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    BuiltClub cuurentClub =
        Provider.of<AgoraController>(context, listen: false).club;

    return InkWell(
      onTap: () {
        if (cuurentClub != null) {
          final cuser = Provider.of<UserData>(context, listen: false).user;
          if (cuurentClub.creator.userId == cuser.userId &&
              cuurentClub.clubId != club.clubId) {
            _showMaterialDialog(context);
          } else {
            navigateTo(ClubDetailPage(club: club));
          }
        } else {
          navigateTo(ClubDetailPage(club: club));
        }
      },
      child: Container(
        margin: EdgeInsets.all(8),
        width: 220,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            image: DecorationImage(
              image: NetworkImage(club.clubAvatar),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black26,
                  Colors.black38,
                  Colors.black54,
                  Colors.black.withOpacity(0.7),
                  Colors.black87,
                  Colors.black87,
                ],
                stops: [0.2, 0.4, 0.5, 0.6, 0.7, 1],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: clubStatusWidget(club.status, club.scheduleTime),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        club.clubName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        club.creator.username,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        height: 32,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 36 * 4.0,
                              child: ListView.builder(
                                // itemCount: club.participants.length > 3
                                //     ? 4
                                //     : club.participants.length,
                                itemCount: 4,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (ctx, index) {
                                  final avatarCard = (child) => Padding(
                                        padding:
                                            const EdgeInsets.only(right: 4),
                                        child: Container(
                                          height: 32,
                                          width: 32,
                                          child: child,
                                        ),
                                      );
                                  if (index == 3) {
                                    return avatarCard(Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '+${club.participants.length - 3}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ));
                                  }
                                  // final imageUrl = club.participants.toList()[index];
                                  final imageUrl =
                                      club.participants.toList()[0];
                                  return avatarCard(CustomImage(
                                    image: imageUrl,
                                    radius: 4,
                                  ));
                                },
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.headset_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 2),
                                Text(
                                  '${club.estimatedAudience ?? 0}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
