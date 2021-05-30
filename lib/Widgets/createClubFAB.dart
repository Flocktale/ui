import 'package:flocktale/Widgets/createClubButton.dart';
import 'package:flocktale/pages/NewClub.dart';
import 'package:flocktale/providers/agoraController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateClubHomeFAB extends StatefulWidget {
  final TabController tabController;

  const CreateClubHomeFAB(this.tabController);

  @override
  _CreateClubHomeFABState createState() => _CreateClubHomeFABState();
}

class _CreateClubHomeFABState extends State<CreateClubHomeFAB> {
  @override
  void initState() {
    widget.tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tabIndex = widget.tabController.index;

    // listen = true so that we can hear changes
    final club = Provider.of<AgoraController>(context, listen: true).club;

    // no FAB when either a club is already playing or current page in landingPageClubs.
    if (tabIndex != 0 || club != null) return Container();
    return CreateClubButton(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => NewClub()));
      },
    );
  }
}
