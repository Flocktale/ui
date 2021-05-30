import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/Widgets/customImage.dart';
import 'package:flocktale/services/shareApp.dart';
import 'package:flutter/material.dart';

class ClubFullDataSheet extends StatelessWidget {
  static void display(BuildContext context, BuiltClub club) async {
    FocusManager.instance.primaryFocus.unfocus();
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.8,
        minChildSize: 0.4,
        builder: (_, controller) => ClubFullDataSheet(
          controller: controller,
          club: club,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  final BuiltClub club;
  final ScrollController controller;

  const ClubFullDataSheet({Key key, this.club, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListView(
        controller: controller,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 6,
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 192,
            child: CustomImage(
              image: club.clubAvatar,
              pinwheelPlaceholder: true,
              radius: 0,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 12),
          Text(
            club.clubName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.multitrack_audio_sharp,
                color: Colors.white70,
                size: 20,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  club.description ?? "",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            child: Card(
              elevation: 2,
              shadowColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: InkWell(
                onTap: () => ShareApp(context).club(club.clubName),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.share,
                        size: 24,
                        color: Colors.redAccent,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Share with your friends',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
