import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/Models/enums/clubStatus.dart';
import 'package:flocktale/customImage.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class DetailClubCard extends StatelessWidget {
  final BuiltClubAndAudience clubAudience;
  final Size size;

  final int heartCount;
  final Function toggleClubHeart;

  final int dislikeCount;
  final Function toggleClubDislike;

  final Function(int) processScheduledTimestamp;

  const DetailClubCard({
    this.clubAudience,
    this.size,
    this.heartCount,
    this.toggleClubHeart,
    this.dislikeCount,
    this.toggleClubDislike,
    this.processScheduledTimestamp,
  });

  Widget _reactionWidgetRow() {
    final _reactionButton = (
            {Function toggler,
            int count,
            bool isLiked,
            IconData iconData,
            Color iconColor}) =>
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: LikeButton(
            onTap: (val) async {
              toggler();
              return Future.value(!val);
            },
            isLiked: isLiked,
            likeCount: count,
            likeBuilder: (bool isLiked) {
              return Icon(
                iconData,
                color: iconColor,
                size: size.height / 25,
              );
            },
          ),
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // heart reaction
        _reactionButton(
            toggler: toggleClubHeart,
            count: heartCount,
            isLiked: clubAudience.reactionIndexValue == 2,
            iconData: clubAudience.reactionIndexValue == 2
                ? Icons.favorite
                : Icons.favorite_border_rounded,
            iconColor: Colors.redAccent),

        // like reaction
//        _reactionButton(
//            toggler: toggleClubLike,
//            count: _likeCount,
//            isLiked: clubAudience.reactionIndexValue == 1,
//            iconData: clubAudience.reactionIndexValue == 1
//                ? Icons.thumb_up
//                : Icons.thumb_up_outlined,
//            iconColor: Colors.amber),

        // dislike reaction
        Container(
          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: _reactionButton(
              toggler: toggleClubDislike,
              count: dislikeCount,
              isLiked: clubAudience.reactionIndexValue == 0,
              iconData: clubAudience.reactionIndexValue == 0
                  ? Icons.thumb_down
                  : Icons.thumb_down_outlined,
              iconColor: Colors.black),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          height: size.height / 5,
          width: size.width / 2.5,
          margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 25.0, // soften the shadow
              spreadRadius: 1.0, //extend the shadow
              offset: Offset(
                0.0,
                15.0, // Move to bottom 10 Vertically
              ),
            )
          ], borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              child: CustomImage(
                radius: 0,
                image: clubAudience.club.clubAvatar + "_large",
                pinwheelPlaceholder: true,
              )),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: size.width / 2,
                child: Text(
                  clubAudience.club.clubName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                      fontSize: size.width / 25),
                ),
              ),
              SizedBox(
                width: size.width / 2,
                child: Text(
                  "${clubAudience.club.description ?? 'There is no description provided for this club'}",
                  style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: size.width / 30,
                      color: Colors.black54),
                ),
              ),
              clubAudience.club.status == (ClubStatus.Live)
                  ? Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                      color: Colors.red,
                      child: Text(
                        "LIVE",
                        style: TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2.0),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.fromLTRB(0, size.height / 50, 0, 0),
                      child: Text(
                        clubAudience.club.status == (ClubStatus.Concluded)
                            ? "Concluded"
                            : DateTime.now().compareTo(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            clubAudience.club.scheduleTime)) <
                                    0
                                ? "Scheduled: ${processScheduledTimestamp(clubAudience.club.scheduleTime)}"
                                : "Waiting for start",
                        style: TextStyle(
                            fontFamily: 'Lato', color: Colors.black54),
                      ),
                    ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: _reactionWidgetRow(),
              )
            ],
          ),
        ),
      ],
    );
  }
}
