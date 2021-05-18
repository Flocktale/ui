import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/Widgets/customImage.dart';
import 'package:flutter/material.dart';

class ParticipantCard extends StatelessWidget {
  final AudienceData participant;
  final bool isHost;

  final int volume;

  const ParticipantCard(
    this.participant, {
    @required Key key,
    this.isHost = false,
    this.volume = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: volume < 20
                        ? null
                        : [
                            if (volume > 200)
                              BoxShadow(
                                color: Colors.redAccent,
                                spreadRadius: 3,
                                blurRadius: 6,
                              ),
                            BoxShadow(
                              color: Colors.green,
                              spreadRadius: volume > 200
                                  ? 2
                                  : (volume > 100 ? 3 : volume / 40),
                              blurRadius: volume > 200
                                  ? 3
                                  : (volume > 100 ? 3 : volume / 40),
                            ),
                            BoxShadow(
                              color: Colors.yellow,
                              spreadRadius: volume < 100 ? 1 : 0.5,
                            ),
                          ],
                  ),
                  child: CustomImage(
                    pinwheelPlaceholder: true,
                    radius: 8,
                    image: participant.audience.avatar,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: CircleAvatar(
                  backgroundColor: participant.isMuted
                      ? Colors.black.withOpacity(0.5)
                      : Colors.green.withOpacity(0.5),
                  radius: 10,
                  child: Icon(
                    participant.isMuted
                        ? Icons.mic_off_outlined
                        : Icons.mic_none_sharp,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 84,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                child: Text(
                  participant.audience.username,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
              ),
              SizedBox(width: 4),
            ],
          ),
        ),
      ],
    );
  }
}

class AudienceCard extends StatelessWidget {
  final SummaryUser audience;
  final Function onTap;
  final Function onLongPress;

  const AudienceCard(
    this.audience, {
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomImage(
              pinwheelPlaceholder: true,
              radius: 8,
              image: audience.avatar,
            ),
          ),
          Container(
            width: 80,
            child: Text(
              audience.username,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
