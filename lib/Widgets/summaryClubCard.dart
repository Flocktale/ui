import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/Models/enums/clubStatus.dart';
import 'package:flocktale/pages/Club.dart';
import 'package:flocktale/providers/agoraController.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SummaryClubCard extends StatelessWidget {
  final Color shadow = Color(0xFF191818);
  final BuiltClub club;

  SummaryClubCard(this.club);

  _showMaterialDialog(BuildContext context) {
    BuiltClub activeClub =
        Provider.of<AgoraController>(context, listen: false).club;
    showDialog(
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
                  Navigator.of(context).pop();
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
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (_) => Club(
                            club: activeClub,
                          )));
                },
              ),
            ],
          );
        });
  }

  String _processTimestamp(int timestamp) {
    if (DateTime.now()
            .compareTo(DateTime.fromMillisecondsSinceEpoch(timestamp)) >
        0) return "Waiting for start";
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    String formattedDate2 =
        DateFormat.MMMd().add_Hm().format(dateTime) + " Hrs";
    return formattedDate2;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    BuiltClub cuurentClub =
        Provider.of<AgoraController>(context, listen: false).club;

    return Container(
      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
      //width: 200.0,
      width: 150,
      child: Card(
        elevation: 10,
        shadowColor: shadow.withOpacity(0.2),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            if (cuurentClub != null) {
              final cuser = Provider.of<UserData>(context, listen: false).user;
              if (cuurentClub.creator.userId == cuser.userId &&
                  cuurentClub.clubId != club.clubId) {
                _showMaterialDialog(context);
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => Club(club: club),
                  ),
                );
              }
            } else {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => Club(
                  club: club,
                ),
              ));
            }
          },
          child: Stack(
            children: <Widget>[
              Container(
                height: 100,
                width: size.width,
                child: Image.network(
                  club.clubAvatar,
                  //      height: 130,
                  //      width: 200,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                top: 100,
                left: 5,
                child: Text(
                  club.clubName,
                  style: TextStyle(
                      fontFamily: 'Lato', fontWeight: FontWeight.bold),
                ),
              ),
              Positioned(
                top: 120,
                left: 5,
                child: Row(children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(club.creator.avatar),
                    radius: 10,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    club.creator.username,
                    style: TextStyle(
                        fontFamily: "Lato",
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Colors.redAccent),
                  ),
                ]),
              ),
              club.status == ClubStatus.Live
                  ? Positioned(
                      // margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      bottom: 5,
                      left: 5,
                      child: Text(
                        "${club.estimatedAudience.toString()} LISTENERS",
                        style: TextStyle(
                            fontFamily: "Lato",
                            fontSize: size.width / 40,
                            color: Colors.grey[700]),
                      ),
                    )
                  : Container(),
              Positioned(
                bottom: 5,
                right: 5,
                child: Row(
                  children: [
                    club.status == (ClubStatus.Waiting)
                        ? Container(
                            padding: EdgeInsets.all(2),
                            child: Icon(
                              Icons.timer,
                              size: size.width / 40,
                            ),
                          )
                        : Container(),
                    Container(
                      color: club.status == (ClubStatus.Live)
                          ? Colors.red
                          : club.status == (ClubStatus.Concluded)
                              ? Colors.grey
                              : Colors.white,
                      padding: EdgeInsets.all(2),
                      child: Text(
                        club.status == (ClubStatus.Live)
                            ? "LIVE"
                            : club.status == (ClubStatus.Concluded)
                                ? "ENDED"
                                : _processTimestamp(club.scheduleTime),
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                          color: club.status == (ClubStatus.Live)
                              ? Colors.white
                              : club.status == (ClubStatus.Concluded)
                                  ? Colors.white
                                  : Colors.black,
                          //   letterSpacing: 2.0,
                          fontSize: size.width / 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
