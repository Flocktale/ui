import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/Widgets/imageDialogLayout.dart';
import 'package:flutter/material.dart';

class ParticipantActionDialog extends StatefulWidget {
  static void display(
    BuildContext context,
    AudienceData participant, {
    Future<bool> Function(String, bool) muteParticipant,
    Future<bool> Function(String) removeParticipant,
    Future<bool> Function(String) blockUser,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (ctx) => ParticipantActionDialog(
        participant,
        muteParticipant: muteParticipant,
        removeParticipant: removeParticipant,
        blockUser: blockUser,
      ),
    );
  }

  final Future<bool> Function(String, bool) muteParticipant;
  final Future<bool> Function(String) removeParticipant;
  final Future<bool> Function(String) blockUser;

  final AudienceData participant;
  const ParticipantActionDialog(
    this.participant, {
    this.muteParticipant,
    this.removeParticipant,
    this.blockUser,
  });
  @override
  _ParticipantActionDialogState createState() =>
      _ParticipantActionDialogState();
}

class _ParticipantActionDialogState extends State<ParticipantActionDialog> {
  AudienceData _participant;

  @override
  void initState() {
    this._participant = widget.participant;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ImageDialogLayout(
      imageUrl: _participant.audience.avatar,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _participant.audience.username,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      elevation: 4,
                      shadowColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: InkWell(
                        splashColor: Colors.redAccent,
                        onTap: _participant.isMuted
                            ? null
                            : () async {
                                final res = await widget.muteParticipant(
                                    widget.participant.audience.userId, true);
                                if (res == true) {
                                  setState(() {
                                    _participant = _participant
                                        .rebuild((b) => b..isMuted = true);
                                  });
                                }
                              },
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: _participant.isMuted
                              ? Colors.black87
                              : Colors.white,
                          child: Icon(
                            _participant.isMuted
                                ? Icons.mic_off_sharp
                                : Icons.mic_none_sharp,
                            size: 36,
                            color: _participant.isMuted
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Mute${_participant.isMuted ? 'd' : ''}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      decoration: _participant.isMuted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor: Colors.black,
                      decorationStyle: TextDecorationStyle.solid,
                      decorationThickness: 2,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  InkWell(
                    onLongPress: () async {
                      final res = await widget
                          .removeParticipant(_participant.audience.userId);
                      if (res == true) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Card(
                      elevation: 4,
                      shadowColor: Colors.redAccent,
                      color: Colors.black87,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 8),
                        child: Text(
                          'Demote',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '( long press )',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '( to listener only )',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 24),
                  InkWell(
                    onLongPress: () async {
                      final res =
                          await widget.blockUser(_participant.audience.userId);
                      if (res == true) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Card(
                      elevation: 4,
                      shadowColor: Colors.redAccent,
                      color: Colors.black87,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.block,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Block',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '( long press )',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '( block from this club )',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
