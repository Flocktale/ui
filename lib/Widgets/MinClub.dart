import 'package:flocktale/Widgets/customImage.dart';
import 'package:flutter/material.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/pages/ClubDetailPages/ClubDetail.dart';
import 'package:flocktale/providers/agoraController.dart';
import 'package:flocktale/providers/webSocket.dart';
import 'package:provider/provider.dart';

class MinClub extends StatefulWidget {
  final Future Function(Widget) navigateTo;

  MinClub(this.navigateTo);

  @override
  _MinClubState createState() => _MinClubState();
}

class _MinClubState extends State<MinClub> {
  bool isPlaying = true;
  stopClub() async {
    BuiltClub club = Provider.of<AgoraController>(context, listen: false).club;
    //sending websocket message to indicate about club stopped event
    Provider.of<MySocket>(context, listen: false).stopClub(club.clubId);

    await Provider.of<AgoraController>(context, listen: false).stop();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    BuiltClub club = Provider.of<AgoraController>(context, listen: false).club;

    final size = MediaQuery.of(context).size;

    if (club == null) return Container(height: 0);

    return InkWell(
      onTap: () async {
        if (widget.navigateTo != null) {
          await widget.navigateTo(
            ClubDetailPage(club.clubId),
          );
        } else {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ClubDetailPage(club.clubId),
            ),
          );
        }
        if (this.mounted) {
          setState(() {});
        }
      },
      child: Container(
        color: Colors.white,
        child: Container(
          height: size.height / 12,
          width: size.width,
          color: Colors.black.withOpacity(0.7),
          child: Row(children: [
            Container(
              child: CustomImage(
                image: club.clubAvatar,
                radius: 0,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        club.clubName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: "Lato",
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Text(
                      club.creator.username,
                      style: TextStyle(
                        fontFamily: "Lato",
                        color: Colors.white70,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
