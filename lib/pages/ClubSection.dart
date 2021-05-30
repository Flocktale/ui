import 'package:chopper/chopper.dart';
import 'package:flocktale/Models/basic_enums.dart';
import 'package:flocktale/Widgets/summaryClubCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:flocktale/Models/built_post.dart';

class ClubSection extends StatefulWidget {
  final Color shadow = Color(0xFF191818);
  final ClubSectionType type;
  final String category;
  ClubSection(this.type, {this.category});
  @override
  _ClubSectionState createState() => _ClubSectionState();
}

class _ClubSectionState extends State<ClubSection> {
  BuiltSearchClubs _clubs;
  bool _isLoading = true;

  Future<void> _fetchClubs() async {
    final userId = Provider.of<UserData>(context, listen: false).userId;

    final lastevaluatedkey = _clubs?.lastevaluatedkey;

    final databaseService =
        Provider.of<DatabaseApiService>(context, listen: false);

    Response<BuiltSearchClubs> response;

    if (widget.type == ClubSectionType.Friend) {
      response = await databaseService.getClubsOfFriends(
        userId: userId,
        lastevaluatedkey: lastevaluatedkey,
      );
    }

    if (widget.type == ClubSectionType.Following) {
      response = await databaseService.getClubsOfFollowings(
        userId: userId,
        lastevaluatedkey: lastevaluatedkey,
      );
    }

    if (widget.type == ClubSectionType.Category) {
      response = await Provider.of<DatabaseApiService>(context, listen: false)
          .getClubsOfCategory(
        category: widget.category,
        lastevaluatedkey: lastevaluatedkey,
      );
    }

    if (widget.type == ClubSectionType.User) {
      response = await Provider.of<DatabaseApiService>(context, listen: false)
          .getMyOrganizedClubs(
        userId: userId,
        lastevaluatedkey: lastevaluatedkey,
      );
    }

    _clubs = response.body;

    _isLoading = false;
    setState(() {});
  }

  Future<void> _fetchMoreClubs() async {
    if (_isLoading == true) return;
    setState(() {});

    final lastEvaluatedKey = _clubs?.lastevaluatedkey;

    if (lastEvaluatedKey != null) {
      await _fetchClubs();
    } else {
      await Future.delayed(Duration(milliseconds: 200));
      _isLoading = false;
    }
    setState(() {});
  }

  Widget clubGrid() {
    final clubList = _clubs?.clubs;
    final listClubs = (clubList?.length ?? 0) + 1;

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          _fetchMoreClubs();
          _isLoading = true;
        }
        return true;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        child: Align(
          alignment: Alignment.topCenter,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: listClubs,
            itemBuilder: (context, index) {
              if (index == listClubs - 1) {
                if (_isLoading)
                  return Center(child: CircularProgressIndicator());
                else
                  return Container();
              }
              return Container(
                  height: 180,
                  child: SummaryClubCard(clubList[index], _navigateTo));
            },
          ),
        ),
      ),
    );
  }

  void _navigateTo(Widget page) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => page))
        .then((value) {
      setState(() {});
      _fetchClubs();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchClubs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.category,
          style: TextStyle(
            fontFamily: "Lato",
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: clubGrid(),
    );
  }
}
