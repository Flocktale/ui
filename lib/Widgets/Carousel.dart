import 'package:flocktale/Widgets/summaryClubCard.dart';
import 'package:flutter/material.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:built_collection/built_collection.dart';

class Carousel extends StatelessWidget {
  final Color shadow = Color(0xFF191818);

  final BuiltList<BuiltClub> Clubs;
  final Function(Widget) navigateTo;

  Carousel({this.Clubs, @required this.navigateTo});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220 * 3 / 4,
      child: ListView.builder(
        itemCount: Clubs.length,
        scrollDirection: Axis.horizontal,
        // children: <Widget>[
        itemBuilder: (context, index) {
          return SummaryClubCard(Clubs[index], navigateTo);
        },
      ),
    );
  }
}
