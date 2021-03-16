import 'package:flocktale/Widgets/summaryClubCard.dart';
import 'package:flutter/material.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/pages/Club.dart';
import 'package:built_collection/built_collection.dart';
import 'package:intl/intl.dart';
import 'package:flocktale/providers/agoraController.dart';
import 'package:provider/provider.dart';

class Carousel extends StatefulWidget {
  final Color shadow = Color(0xFF191818);
  final BuiltList<BuiltClub> Clubs;
  Carousel({this.Clubs});
  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
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
          return SummaryClubCard(widget.Clubs[index]);
        },
      ),
    );
  }
}
