import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flocktale/pages/ClubDetailPages/ClubDetail.dart';
import 'package:provider/provider.dart';

class SearchAllClubs extends StatefulWidget {
  final BuiltList<BuiltClub> clubs;
  final String query;
  SearchAllClubs({this.clubs, this.query});
  @override
  _SearchAllClubsState createState() => _SearchAllClubsState();
}

class _SearchAllClubsState extends State<SearchAllClubs> {
  Map<String, dynamic> searchClubsMap = {
    'data': null,
    'isLoading': true,
  };
  String lastEvaluatedKey;
  getClubs() async {
    String username = widget.query;
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    //allSearches = (await service.getUserbyUsername(username)).body;

    searchClubsMap['data'] = (await service.unifiedQueryRoutes(
      searchString: username,
      type: "clubs",
      lastevaluatedkey: lastEvaluatedKey,
    ))
        .body;
    searchClubsMap['isLoading'] = false;
    lastEvaluatedKey = searchClubsMap['data'].clublastevaluatedkey;
    setState(() {});
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    print(searchClubsMap['data']);
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
  }

  getMoreClubs() async {
    if (searchClubsMap['isLoading'] == true) return;
    setState(() {});

    if (lastEvaluatedKey != null) {
      await getClubs();
    } else {
      await Future.delayed(Duration(milliseconds: 200));
      searchClubsMap['isLoading'] = false;
    }

    setState(() {});
  }

  Widget showClubs() {
    final searchClubs =
        (searchClubsMap['data'] as BuiltUnifiedSearchResults)?.clubs;

    final bool isLoading = searchClubsMap['isLoading'];

    final listLength = (searchClubs?.length ?? 0) + 1;

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          searchClubsMap['isLoading'] = true;
          getMoreClubs();
        }
        return true;
      },
      child: ListView.builder(
          itemCount: listLength,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (index == listLength - 1) {
              if (isLoading)
                return Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Center(child: CircularProgressIndicator()),
                );
              else
                return Container();
            }
            final _club = searchClubs[index];

            return Container(
                key: ValueKey(_club.clubId),
                margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(_club.clubAvatar),
                  ),
                  title: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ClubDetailPage(_club.clubId)));
                    },
                    child: Text(
                      _club.clubName,
                      style: TextStyle(
                          fontFamily: 'Lato', fontWeight: FontWeight.bold),
                    ),
                  ),
                  subtitle: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ClubDetailPage(_club.clubId),
                        ),
                      );
                    },
                    child: Text(
                      _club.category != null ? _club.category : "Club",
                      style: TextStyle(fontFamily: 'Lato'),
                    ),
                  ),
                ));
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getClubs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "\"${widget.query}\" in Clubs",
          style: TextStyle(
              fontFamily: "Lato",
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ),
      body: showClubs(),
    );
  }
}
