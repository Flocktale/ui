import 'package:flocktale/pages/NewClub.dart';
import 'package:flocktale/providers/agoraController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateClubFAB extends StatefulWidget {
  final TabController tabController;

  const CreateClubFAB(this.tabController);

  @override
  _CreateClubFABState createState() => _CreateClubFABState();
}

class _CreateClubFABState extends State<CreateClubFAB> {
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

    return FloatingActionButton(
      backgroundColor: Colors.redAccent,
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => NewClub()));
      },
      child: Icon(Icons.add),
    );
  }
}
