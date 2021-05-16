import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/Widgets/summaryClubCard.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'NewClub.dart';

class NewsPage extends StatefulWidget {
  ClubContentModel news;
  NewsPage({this.news});
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  Map<String, dynamic> newsClubsMap = {
    'data': null,
    'isLoading': true,
  };
  _fetchNewsClubs() async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    newsClubsMap['data'] = (await service.getClubsOfContent(
            contentUrl: widget.news.url,
            lastevaluatedkey:
                (newsClubsMap['data'] as BuiltSearchClubs)?.lastevaluatedkey))
        .body;
    newsClubsMap['isLoading'] = false;
    setState(() {});
  }

  _fetchMoreNewsClubs() async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final lastevaluatedkey =
        (newsClubsMap['data'] as BuiltSearchClubs)?.lastevaluatedkey;
    if (lastevaluatedkey != null) {
      await _fetchNewsClubs();
    } else {
      await Future.delayed(Duration(milliseconds: 200));
      newsClubsMap['isLoading'] = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchNewsClubs();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String userId = Provider.of<UserData>(context, listen: false).userId;
    void _justRefresh([Function refresh]) {
      if (this.mounted) {
        if (refresh != null) {
          refresh();
        }
        setState(() {});
      }
    }

    _navigateTo(Widget page) async {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => page,
        ),
      );
      _justRefresh();
    }

    Widget clubGrid() {
      final clubList = (newsClubsMap['data'] as BuiltSearchClubs)?.clubs;
      final bool isLoading = newsClubsMap['isLoading'];
      final listClubs = (clubList?.length ?? 0) + 1;
      return RefreshIndicator(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                _fetchMoreNewsClubs();
                newsClubsMap['isLoading'] = true;
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
                      if (isLoading)
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
          ),
          onRefresh: () {
            return _fetchNewsClubs();
          });
    }

    return SafeArea(
      child: Scaffold(
        body: Container(
            child: Column(
          children: [
            Container(
              height: size.height / 6,
              width: size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(widget.news.avatar),
                      fit: BoxFit.cover)),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(size.width / 20, size.width / 20,
                  size.width / 20, size.width / 20),
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.news.avatar),
                        radius: size.width / 15,
                      ),
                      SizedBox(
                        width: size.width / 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 250,
                            child: Text(
                              //  widget.community.name,
                              widget.news.title,
                              maxLines: 3,
                              style: TextStyle(
                                  fontFamily: "Lato",
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            // widget.community.creator.username,
                            widget.news.source,
                            style: TextStyle(
                                fontFamily: "Lato", color: Colors.grey),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Create CLub", style: TextStyle(fontFamily: "Lato")),
                IconButton(
                  onPressed: () async {
                    final resp = (await Provider.of<DatabaseApiService>(context,
                            listen: false)
                        .createNewContentClub(
                            creatorId: userId,
                            contentUrl: widget.news.url,
                            contentType: "news"));
                    if (!resp.isSuccessful) {
                      Fluttertoast.showToast(msg: "Something went wrong...");
                    } else {
                      Fluttertoast.showToast(msg: "Club created");
                    }
                  },
                  icon: Icon(Icons.add),
                )
              ],
            ),
            clubGrid()
          ],
        )),
      ),
    );
  }
}
