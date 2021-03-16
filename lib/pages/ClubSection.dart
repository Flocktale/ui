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
  Map<String, dynamic> clubMap = {
    'data': null,
    'isLoading': true,
  };

  Future<void> _fetchClubs() async {
    final userId = Provider.of<UserData>(context, listen: false).userId;
    final authToken = Provider.of<UserData>(context, listen: false).authToken;

    final lastevaluatedkey =
        (clubMap['data'] as BuiltSearchClubs)?.lastevaluatedkey;

    final databaseService =
        Provider.of<DatabaseApiService>(context, listen: false);

    Response<BuiltSearchClubs> response;

    if (widget.type == ClubSectionType.Friend) {
      response = await databaseService.getClubsOfFriends(
        userId: userId,
        authorization: authToken,
        lastevaluatedkey: lastevaluatedkey,
      );
    }

    if (widget.type == ClubSectionType.Following) {
      response = await databaseService.getClubsOfFollowings(
        userId: userId,
        authorization: authToken,
        lastevaluatedkey: lastevaluatedkey,
      );
    }

    if (widget.type == ClubSectionType.Category) {
      response = await Provider.of<DatabaseApiService>(context, listen: false)
          .getClubsOfCategory(
        category: widget.category,
        lastevaluatedkey: lastevaluatedkey,
        authorization: authToken,
      );
    }

    if (widget.type == ClubSectionType.User) {
      response = await Provider.of<DatabaseApiService>(context, listen: false)
          .getMyOrganizedClubs(
              userId: userId,
              lastevaluatedkey: lastevaluatedkey,
              authorization: authToken);
    }

    clubMap['data'] = response.body;

    clubMap['isLoading'] = false;
    setState(() {});
  }

  Future<void> _fetchMoreClubs() async {
    if (clubMap['isLoading'] == true) return;
    setState(() {});

    final lastEvaluatedKey =
        (clubMap['data'] as BuiltSearchClubs)?.lastevaluatedkey;

    if (lastEvaluatedKey != null) {
      await _fetchClubs();
    } else {
      await Future.delayed(Duration(milliseconds: 200));
      clubMap['isLoading'] = false;
    }
    setState(() {});
  }

  Widget clubGrid() {
    final clubList = (clubMap['data'] as BuiltSearchClubs)?.clubs;
    final bool isLoading = clubMap['isLoading'];
    final listClubs = (clubList?.length ?? 0) + 1;

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          _fetchMoreClubs();
          clubMap['isLoading'] = true;
        }
        return true;
      },
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: listClubs,
        itemBuilder: (context, index) {
          if (index == listClubs - 1) {
            if (isLoading)
              return Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Center(child: CircularProgressIndicator()),
              );
            else
              return Container();
          }
          return SummaryClubCard(clubList[index]);
        },
      ),
    );
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
        backgroundColor: Colors.white,
        title: Text(
          widget.category,
          style: TextStyle(
            fontFamily: "Lato",
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: clubGrid(),
    );
  }
}
