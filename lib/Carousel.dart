import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/pages/Club.dart';
import 'package:built_collection/built_collection.dart';
import 'package:intl/intl.dart';
import 'package:flocktale/providers/agoraController.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:provider/provider.dart';

class Carousel extends StatefulWidget {
  final Color shadow = Color(0xFF191818);
  final BuiltList<BuiltClub> Clubs;
  Carousel({this.Clubs});
  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  // List<String> myClubs = ['Card1.jpg', 'Card2.jpg', 'Card3.jpg', 'Card4.jpg'];
  String _processTimestamp(int timestamp) {
    if (DateTime.now()
            .compareTo(DateTime.fromMillisecondsSinceEpoch(timestamp)) >
        0) return "Waiting for start";
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = DateTime.now().difference(dateTime).abs();
    String formattedDate2 =
        DateFormat.MMMd().add_Hm().format(dateTime) + " Hrs";
    return formattedDate2;
  }

  _showMaterialDialog(BuiltClub club) {
    BuiltClub activeClub = Provider.of<AgoraController>(context, listen: false).club;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Please end the club \"${activeClub.clubName}\" before entering another club."),
            actions: [
              FlatButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      fontFamily: "Lato",
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),
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
                      fontWeight: FontWeight.bold
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>Club(club: activeClub,)));
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    BuiltClub club = Provider.of<AgoraController>(context, listen: false).club;
    return Container(
      margin: EdgeInsets.only(left: size.width / 50, right: size.width / 50),
      //  height: 250,
      height: 185,
      child: ListView.builder(
        itemCount: widget.Clubs.length,
        scrollDirection: Axis.horizontal,
        // children: <Widget>[
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(right: 10),
            //width: 200.0,
            width: 150,
            child: Card(
              elevation: 10,
              shadowColor: widget.shadow.withOpacity(0.2),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  if(club!=null){
                    final cuser = Provider.of<UserData>(context,listen: false).user;
                    if(club.creator.userId==cuser.userId && club.clubId!=widget.Clubs[index].clubId){
                      _showMaterialDialog(club);
                    }
                    else{
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => Club(club: widget.Clubs[index])));
                    }
                  }
                  else{
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => Club(club: widget.Clubs[index])));
                  }

                },
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: size.width,
                      //       child: Image.network(
                      //         widget.Clubs[index].clubAvatar,
                      // //      height: 130,
                      // //      width: 200,
                      //         fit: BoxFit.fill,
                      //       ),
                      child: CachedNetworkImage(
                        imageUrl: widget.Clubs[index].clubAvatar,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Container(
                            padding: EdgeInsets.all(40),
                            child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),

                    Positioned(
                      top: 100,
                      left: 5,
                      child: Text(
                        widget.Clubs[index].clubName,
                        style: TextStyle(
                            fontFamily: 'Lato', fontWeight: FontWeight.bold),
                      ),
                    ),

                    Positioned(
                      top: 120,
                      left: 5,
                      child: Row(children: [
                        CachedNetworkImage(
                          imageUrl:
                              widget.Clubs[index].creator.avatar + "_thumb",
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                            backgroundImage: imageProvider,
                            radius: 10,
                          ),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.Clubs[index].creator.username,
                          style: TextStyle(
                              fontFamily: "Lato",
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Colors.redAccent),
                        ),
                      ]),
                    ),
                    widget.Clubs[index].isLive == true
                        ? Positioned(
                            // margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                            bottom: 5,
                            left: 5,
                            child: Text(
                              "${widget.Clubs[index].estimatedAudience.toString()} LISTENERS",
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
                          widget.Clubs[index].isLive == false &&
                                  widget.Clubs[index].isConcluded == false
                              ? Container(
                                  padding: EdgeInsets.all(2),
                                  child: Icon(
                                    Icons.timer,
                                    size: size.width / 40,
                                  ),
                                )
                              : Container(),
                          Container(
                            color: widget.Clubs[index].isLive
                                ? Colors.red
                                : widget.Clubs[index].isConcluded != null &&
                                        widget.Clubs[index].isConcluded
                                    ? Colors.grey
                                    : Colors.white,
                            padding: EdgeInsets.all(2),
                            child: Text(
                              widget.Clubs[index].isLive == true
                                  ? "LIVE"
                                  : widget.Clubs[index].isConcluded == true
                                      ? "ENDED"
                                      : _processTimestamp(
                                          widget.Clubs[index].scheduleTime),
                              style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.bold,
                                  color: widget.Clubs[index].isLive == true
                                      ? Colors.white
                                      : widget.Clubs[index].isConcluded == true
                                          ? Colors.white
                                          : Colors.black,
                                  //   letterSpacing: 2.0,
                                  fontSize: size.width / 40),
                            ),
                          ),
                        ],
                      ),
                    ),

//                      trailing:  Container(
//                        color: Colors.red,
//                        child: Text(
//                          "LIVE",
//                          style: TextStyle(
//                              fontFamily: 'Lato',
//                              fontWeight: FontWeight.bold,
//                              color: Colors.white,
//                              letterSpacing: 2.0,
//                            fontSize: 10
//                          ),
//                        ),
//                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
