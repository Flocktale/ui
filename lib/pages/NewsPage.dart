import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/Widgets/CreateFABButton.dart';
import 'package:flocktale/Widgets/summaryClubCard.dart';
import 'package:flocktale/pages/ClubDetailPages/ClubDetail.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class NewsPage extends StatefulWidget {
  final ClubContentModel news;
  NewsPage({this.news});
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  BuiltSearchClubs _newsClubs;
  bool _isLoading = true;

  _fetchNewsClubs() async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    _newsClubs = (await service.getClubsOfContent(
            contentUrl: widget.news.url,
            lastevaluatedkey: _newsClubs?.lastevaluatedkey))
        .body;
    _isLoading = false;
    setState(() {});
  }

  _fetchMoreNewsClubs() async {
    final lastevaluatedkey = _newsClubs?.lastevaluatedkey;
    if (lastevaluatedkey != null) {
      await _fetchNewsClubs();
    } else {
      await Future.delayed(Duration(milliseconds: 200));
      _isLoading = false;
    }
  }

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

  Widget _clubGrid() {
    final clubList = _newsClubs?.clubs;
    final bool isLoading = _isLoading;
    final listClubs = (clubList?.length ?? 0) + 1;
    return RefreshIndicator(
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              _fetchMoreNewsClubs();
              _isLoading = true;
            }
            return true;
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            child: Align(
              alignment: Alignment.topCenter,
              child: ListView(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                children: [
                  ListView.builder(
                    physics: ScrollPhysics(),
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
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
        onRefresh: () {
          return _fetchNewsClubs();
        });
  }

  void _createClub() async {
    String userId = Provider.of<UserData>(context, listen: false).userId;

    final resp = (await Provider.of<DatabaseApiService>(context, listen: false)
        .createNewContentClub(
            creatorId: userId,
            contentUrl: widget.news.url,
            contentType: "news"));
    if (!resp.isSuccessful) {
      Fluttertoast.showToast(msg: "Something went wrong...");
    } else {
      Fluttertoast.showToast(msg: "Club created");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ClubDetailPage(resp.body['clubId']),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchNewsClubs();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: CreateFABButton(
          onTap: () => _createClub(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Container(
            child: ListView(
          children: [
            Container(
              height: size.width * 9 / 16,
              width: size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.news.avatar),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.news.title,
                    style: TextStyle(
                      fontFamily: "Lato",
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '~ ' + widget.news.source,
                    style: TextStyle(
                      fontFamily: "Lato",
                      color: Colors.white70,
                    ),
                  )
                ],
              ),
            ),
            _clubGrid()
          ],
        )),
      ),
    );
  }
}
