import 'package:flutter/cupertino.dart';
import 'package:share/share.dart';

class ShareApp {
  final BuildContext context;
  ShareApp(this.context);

  final String appLink = 'Link to the app: ';

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

    Share.share(
      text,
      subject: 'Flocktale - A revolutionising social audio app',
    );
  }
}
