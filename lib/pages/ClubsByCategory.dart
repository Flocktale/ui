import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mootclub_app/providers/userData.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/pages/Club.dart';
import 'package:intl/intl.dart';

class ClubsByCategory extends StatefulWidget {
  final Color shadow = Color(0xFF191818);
  final String category;
  ClubsByCategory({this.category});
  @override
  _ClubsByCategoryState createState() => _ClubsByCategoryState();
}

class _ClubsByCategoryState extends State<ClubsByCategory> {
  Map<String, dynamic> clubMap = {
    'data': null,
    'isLoading': true,
  };

  Future<void> _fetchClubsByCategory() async {
    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    clubMap['data'] =
        (await Provider.of<DatabaseApiService>(context, listen: false)
                .getClubsOfCategory(
                    category: widget.category,
                    lastevaluatedkey:
                        (clubMap['data'] as BuiltSearchClubs)?.lastevaluatedkey,
                    authorization: authToken))
            .body;
    clubMap['isLoading'] = false;
    setState(() {});
  }

  Future<void> _fetchMoreClubsByCategory() async {
    if (clubMap['isLoading'] == true) return;
    setState(() {});

    final lastEvaluatedKey =
        (clubMap['data'] as BuiltSearchClubs)?.lastevaluatedkey;

    if (lastEvaluatedKey != null) {
      await _fetchClubsByCategory();
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

  Widget clubGrid() {
    final size = MediaQuery.of(context).size;
    final clubList = (clubMap['data'] as BuiltSearchClubs)?.clubs;
    final bool isLoading = clubMap['isLoading'];
    final listClubs = (clubList?.length ?? 0) + 1;
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          _fetchMoreClubsByCategory();
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => Club(club: clubList[index])));
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
                      clubList[index].isLive == true
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
                            clubList[index].isLive == false &&
                                    clubList[index].isConcluded == false
                                ? Container(
                                    padding: EdgeInsets.all(2),
                                    child: Icon(
                                      Icons.timer,
                                      size: size.width / 40,
                                    ),
                                  )
                                : Container(),
                            Container(
                              color: clubList[index].isLive
                                  ? Colors.red
                                  : clubList[index].isConcluded != null &&
                                          clubList[index].isConcluded
                                      ? Colors.grey
                                      : Colors.white,
                              padding: EdgeInsets.all(2),
                              child: Text(
                                clubList[index].isLive == true
                                    ? "LIVE"
                                    : clubList[index].isConcluded == true
                                        ? "ENDED"
                                        : _processTimestamp(
                                            clubList[index].scheduleTime),
                                style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold,
                                    color: clubList[index].isLive == true
                                        ? Colors.white
                                        : clubList[index].isConcluded == true
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
    _fetchClubsByCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Clubs in \"${widget.category}\"",
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