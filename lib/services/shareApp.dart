import 'package:flocktale/providers/userData.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ShareApp {
  final BuildContext context;
  ShareApp(this.context);

  final String appLink =
      'Link to the app: https://play.google.com/store/apps/details?id=com.flocktale.android';

  void _share(String text) {
    Share.share(
      text,
      subject: 'Flocktale - A revolutionising social audio app',
    );
  }

  void club(String clubName, {bool forPanelist = false}) {
    //  final RenderBox box = context.findRenderObject();
    String text = '$clubName is booming💥on FlockTale. ';

    if (forPanelist) {
//owner is sending participation ivnitation
      text = 'My club ' + text + 'Come and join us as a panelist.';
    } else {
      text +=
          'Hey, come and join us in Hall. The panelists are really interesting.';
    }

    text += ' $appLink';
    _share(text);
  }

  void app() {
    final cuser = Provider.of<UserData>(context, listen: false).user;
    String text =
        "Hi, I am \"${cuser.username}\" on Flocktale, come sign up and join me. "
        "This new platform is very interesting and engaging. "
        "$appLink";
    _share(text);
  }
}
