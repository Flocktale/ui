import 'package:flutter/material.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/providers/userData.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
            height: MediaQuery.of(context).size.height / 2 + 40,
            child: GridView.builder(
              itemCount: participantList.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (context, index) {
                final participantId = participantList[index].userId;
                return Container(
                  child: Stack(
                    children: [
                      Column(
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
                );
              },
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
