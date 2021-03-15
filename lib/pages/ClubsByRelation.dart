import 'package:flocktale/Models/enums/clubStatus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/pages/Club.dart';
import 'package:flocktale/providers/agoraController.dart';
import 'package:intl/intl.dart';

class ClubsByRelation extends StatefulWidget {
  final Color shadow = Color(0xFF191818);
  final String userId;
  final int type;
  ClubsByRelation({this.userId, this.type});
  @override
  _ClubsByRelationState createState() => _ClubsByRelationState();
}

class _ClubsByRelationState extends State<ClubsByRelation> {
  Map<String, dynamic> clubMap = {
    'data': null,
    'isLoading': true,
  };

  Future<void> _fetchClubsByUser() async {
    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    clubMap['data'] = widget.type == 0
        ? (await Provider.of<DatabaseApiService>(context, listen: false)
                .getClubsOfFriends(
                    userId: widget.userId,
                    authorization: authToken,
                    lastevaluatedkey: (clubMap['data'] as BuiltSearchClubs)
                        ?.lastevaluatedkey))
            .body
        : (await Provider.of<DatabaseApiService>(context, listen: false)
                .getClubsOfFollowings(
                    userId: widget.userId,
                    authorization: authToken,
                    lastevaluatedkey: (clubMap['data'] as BuiltSearchClubs)
                        ?.lastevaluatedkey))
            .body;
    clubMap['isLoading'] = false;
    setState(() {});
  }

  Future<void> _fetchMoreClubsByUser() async {
    if (clubMap['isLoading'] == true) return;
    setState(() {});

    final lastEvaluatedKey =
        (clubMap['data'] as BuiltSearchClubs)?.lastevaluatedkey;

    if (lastEvaluatedKey != null) {
      await _fetchClubsByUser();
    } else {
      await Future.delayed(Duration(milliseconds: 200));
      clubMap['isLoading'] = false;
    }
    setState(() {});
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

  _showMaterialDialog() {
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

  Widget clubGrid() {
    final size = MediaQuery.of(context).size;
    final clubList = (clubMap['data'] as BuiltSearchClubs)?.clubs;
    final bool isLoading = clubMap['isLoading'];
    final listClubs = (clubList?.length ?? 0) + 1;
    BuiltClub club = Provider.of<AgoraController>(context, listen: false).club;
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          _fetchMoreClubsByUser();
          clubMap['isLoading'] = true;
        }
        return true;
      },
      child: GridView.builder(
          shrinkWrap: true,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: listClubs,
          itemBuilder: (context, index) {
            if (index == listClubs - 1) {
              if (isLoading)
                return Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Center(child: CircularProgressIndicator()),
                );
              else
                return Container();
            }
            return Container(
              margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
              //width: 200.0,
              width: 150,
              child: Card(
                elevation: 10,
                shadowColor: widget.shadow.withOpacity(0.2),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    if (club != null) {
                      final cuser =
                          Provider.of<UserData>(context, listen: false).user;
                      if (club.creator.userId == cuser.userId &&
                          club.clubId != clubList[index].clubId) {
                        _showMaterialDialog();
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => Club(club: clubList[index])));
                      }
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => Club(club: clubList[index])));
                    }
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 100,
                        width: size.width,
                        child: Image.network(
                          clubList[index].clubAvatar,
                          //      height: 130,
                          //      width: 200,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        top: 100,
                        left: 5,
                        child: Text(
                          clubList[index].clubName,
                          style: TextStyle(
                              fontFamily: 'Lato', fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                        top: 120,
                        left: 5,
                        child: Row(children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(clubList[index].creator.avatar),
                            radius: 10,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            clubList[index].creator.username,
                            style: TextStyle(
                                fontFamily: "Lato",
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                color: Colors.redAccent),
                          ),
                        ]),
                      ),
                      clubList[index].status == (ClubStatus.Live)
                          ? Positioned(
                              // margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                              bottom: 5,
                              left: 5,
                              child: Text(
                                "${clubList[index].estimatedAudience.toString()} LISTENERS",
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
                            clubList[index].status == (ClubStatus.Waiting)
                                ? Container(
                                    padding: EdgeInsets.all(2),
                                    child: Icon(
                                      Icons.timer,
                                      size: size.width / 40,
                                    ),
                                  )
                                : Container(),
                            Container(
                              color: clubList[index].status == (ClubStatus.Live)
                                  ? Colors.red
                                  : clubList[index].status ==
                                          (ClubStatus.Concluded)
                                      ? Colors.grey
                                      : Colors.white,
                              padding: EdgeInsets.all(2),
                              child: Text(
                                clubList[index].status == (ClubStatus.Live)
                                    ? "LIVE"
                                    : clubList[index].status ==
                                            (ClubStatus.Concluded)
                                        ? "ENDED"
                                        : _processTimestamp(
                                            clubList[index].scheduleTime),
                                style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold,
                                    color: clubList[index].status ==
                                            (ClubStatus.Live)
                                        ? Colors.white
                                        : clubList[index].status ==
                                                (ClubStatus.Concluded)
                                            ? Colors.white
                                            : Colors.black,
                                    //   letterSpacing: 2.0,
                                    fontSize: size.width / 40),
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
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchClubsByUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Clubs",
          style: TextStyle(
            fontFamily: "Lato",
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: clubGrid(),
    );
  }
}
