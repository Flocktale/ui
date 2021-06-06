import 'package:flocktale/Models/appConstants.dart';
import 'package:flocktale/Widgets/CreateFABButton.dart';
import 'package:flocktale/pages/NewClub.dart';
import 'package:flocktale/providers/agoraController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeFAB extends StatefulWidget {
  final TabController tabController;

  const HomeFAB(this.tabController);

  @override
  _HomeFABState createState() => _HomeFABState();
}

class _HomeFABState extends State<HomeFAB> {
  @override
  void initState() {
    widget.tabController.addListener(() {
      if (this.mounted) setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tabController.indexIsChanging) return Container();

    final tabIndex = widget.tabController.index;

    // listen = true so that we can hear changes
    final club = Provider.of<AgoraController>(context, listen: true).club;

    // no FAB when either a club is already playing or current page is not landingPageClubs/Communitites.
    if (tabIndex > 1 || club != null) return Container();

    if (tabIndex == 0) {
      return CreateFABButton(
        title: "Create Club",
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => NewClub()));
        },
      );
    } else {
      return CreateFABButton(
        title: "Create Community",
        onTap: () {
          AppConstants.launchCreateCommunityForm();
        },
      );
    }
  }
}
