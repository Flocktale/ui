import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/Widgets/imageDialogLayout.dart';
import 'package:flutter/material.dart';

class AudienceActionDialog extends StatelessWidget {
  static void display(
    BuildContext context,
    SummaryUser audience, {
    Future<bool> Function(String) inviteToSpeak,
    Future<bool> Function(String) blockUser,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (ctx) => AudienceActionDialog(
        audience,
        inviteToSpeak: inviteToSpeak,
        blockUser: blockUser,
      ),
    );
  }

  final Future<bool> Function(String) inviteToSpeak;
  final Future<bool> Function(String) blockUser;

  final SummaryUser audience;

  const AudienceActionDialog(
    this.audience, {
    this.inviteToSpeak,
    this.blockUser,
  });

  @override
  Widget build(BuildContext context) {
    return ImageDialogLayout(
      imageUrl: audience.avatar,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            audience.username,
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
                        onTap: () async {
                          final res = await inviteToSpeak(audience.userId);
                          if (res == true) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person_add,
                            size: 36,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Invite to speak",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onLongPress: () async {
                      final res = await blockUser(audience.userId);
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
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
