import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/providers/userData.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'ProfilePage.dart';

class ParticipantsPanel extends StatelessWidget {
  final Size size;
  final List<SummaryUser> participantList;
  final bool isOwner;
  final Function(String) muteParticipant;
  final Function(String) removeParticipant;
  final Function(String) blockParticipant;
  const ParticipantsPanel({
    @required this.size,
    @required this.participantList,
    @required this.isOwner,
    @required this.muteParticipant,
    @required this.removeParticipant,
    @required this.blockParticipant,
  });

  void _handleMenuButtons(String value, String panelistId) {
    switch (value) {
      case 'Mute':
        muteParticipant(panelistId);
        break;
      case 'Remove':
        removeParticipant(panelistId);
        break;
      case 'Block':
        blockParticipant(panelistId);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserData>(context, listen: false).userId;
    final cuser = Provider.of<UserData>(context,listen: false).user;
    return SlidingUpPanel(
      minHeight: size.height / 20,
      maxHeight: size.height / 1.5,
      backdropEnabled: true,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      panel: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: size.height / 30,
          ),
          Center(
            child: Text("Host",
                style: TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold,
                    fontSize: size.width / 20,
                    color: Colors.redAccent)),
          ),
          SizedBox(
            height: size.height / 50,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: Stack(
              children: [
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ProfilePage(userId: userId,)));
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: size.width / 9.4,
                        backgroundColor: Color(0xffFDCF09),
                        child: CircleAvatar(
                          radius: size.width / 10,
                          backgroundImage:
                          NetworkImage(cuser.avatar),
                        ),
                      ),
                      Text(
                        cuser.username,
                        style: TextStyle(
                            fontFamily: "Lato",
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.height / 30,
          ),
          Center(
            child: Text("Panelists",
                style: TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold,
                    fontSize: size.width / 20,
                    color: Colors.redAccent)),
          ),
          SizedBox(
            height: size.height / 50,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: GridView.builder(
                itemCount: participantList.where((element) => element.userId!=cuser.userId).length+1,
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemBuilder: (context, index) {
                  final participantId = participantList[index].userId;
                  return index!=participantList.where((element) => element.userId!=cuser.userId).length?
                  Container(
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ProfilePage(userId: participantList[index].userId,)));
                          },
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: size.width / 9.4,
                                backgroundColor: Color(0xffFDCF09),
                                child: CircleAvatar(
                                  radius: size.width / 10,
                                  backgroundImage:
                                      NetworkImage(participantList[index].avatar),
                                ),
                              ),
                              Text(
                                participantList[index].username,
                                style: TextStyle(
                                    fontFamily: "Lato",
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        // display menu to owner only.
                        if (isOwner && participantId != userId)
                          Positioned(
                            right: 10,
                            child: PopupMenuButton<String>(
                              onSelected: (val) =>
                                  _handleMenuButtons(val, participantId),
                              itemBuilder: (BuildContext context) {
                                return {
                                  'Mute',
                                  'Remove',
                                  'Block',
                                }.map((String choice) {
                                  return PopupMenuItem<String>(
                                    value: choice,
                                    child: Text(choice),
                                  );
                                }).toList();
                              },
                            ),
                          )
                      ],
                    ),
                  ):
                  InkWell(
                    onTap: (){
                    },
                    child: Container(
                      margin: EdgeInsets.all(size.width/20),
                      child: Icon(
                        Icons.person_add,
                        color: Colors.redAccent,
                        size: size.width/10,
                      ),
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.redAccent,width: 2)
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      )),
      collapsed: Container(
        decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        child: Center(
          child: Text(
            "PANELISTS",
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0),
          ),
        ),
      ),
    );
  }
}
