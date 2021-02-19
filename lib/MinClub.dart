import 'package:flutter/material.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/pages/Club.dart';
import 'package:mootclub_app/providers/agoraController.dart';
import 'package:provider/provider.dart';
class MinClub extends StatefulWidget {
  @override
  _MinClubState createState() => _MinClubState();
}

class _MinClubState extends State<MinClub> {
  bool isPlaying = true;
  stopClub() async{
    await Provider.of<AgoraController>(context,listen: false).stop();
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    BuiltClub club = Provider.of<AgoraController>(context,listen: false).club;
    print("=================CLUB==================================");
    print(club);
    print("===================================================");
    final size = MediaQuery.of(context).size;
    return club!=null?
    InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (_)=>Club(club:club)));
      },
      child: Container(
        height: size.height/12,
        width: size.width,
        color: Colors.white,
        child: Row(
          children: [
            Container(
                margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Image.network(club.clubAvatar)),
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, size.width-250, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    club.clubName,
                    style: TextStyle(
                      fontFamily: "Lato",
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    club.creator.username,
                    style: TextStyle(
                      fontFamily: "Lato",
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
            Container(
                child: IconButton(
                  iconSize: size.width/10,
                    icon: Icon(Icons.stop),
                    onPressed: (){stopClub();}
                )
            )
          ]
        ),
      ),
    ):
    Container(
      height: 0,
      color: Colors.redAccent,
    );
  }
}
