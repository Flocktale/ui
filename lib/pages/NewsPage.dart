import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/Widgets/summaryClubCard.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'NewClub.dart';

class NewsPage extends StatefulWidget {
  ClubContentModel news;
  NewsPage({this.news});
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Map<String, dynamic> newsClubsMap = {
      'data': null,
      'isLoading': true,
    };
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

    _fetchNewsClubs() async {
      final service = Provider.of<DatabaseApiService>(context, listen: false);
      newsClubsMap['data'] = (await service.getContentData(type: "news"))
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
              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: listClubs,
                itemBuilder: (context, index) {
                  if (index == listClubs - 1) {
                    if (isLoading)
                      return Center(child: CircularProgressIndicator());
                    else
                      return Container();
                  }
                  return SummaryClubCard(clubList[index], _navigateTo);
                },
              ),
            ),
          ),
          onRefresh: () {});
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
                            fontFamily: "Lato", fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                       // widget.community.creator.username,
                          widget.news.source,
                          style:
                          TextStyle(fontFamily: "Lato", color: Colors.grey),
                        )
                      ],
                    )
                  ],
                ),
                // Row(
                // children: [
                // Text(
                // isMember ? "JOIN" : "Member",
                // style: TextStyle(fontFamily: "Lato"),
                // ),
                // IconButton(
                // icon: isMember
                // ? Icon(Icons.add)
                //     : Icon(
                // Icons.check,
                // color: Colors.green,
                // ),
                // onPressed: () async {
                // isMember = !isMember;
                // setState(() {});
                // final resp = (await service.joinCommunityAsMember(
                // widget.community.communityId,
                // userId: userId));
                // if (!resp.isSuccessful) {
                // Fluttertoast.showToast(
                // msg: 'Sorry something went wrong.');
                // setState(() {
                // isMember = !isMember;
                // });
                // }
                // })
                // ],
                // )
                ],
              ),
            ),
            // Container(
            // height: size.height / 8,
            // color: Colors.grey[200],
            // padding: EdgeInsets.fromLTRB(0, 0, 0, size.width / 20),
            // child: ListView.builder(
            // itemCount: widget.community.hosts!=null?widget.community.hosts.length:0,
            // scrollDirection: Axis.horizontal,
            // itemBuilder: (context, index) {
            // return Container(
            // margin: EdgeInsets.fromLTRB(size.width / 20, 0, 0, 0),
            // child: Column(
            // children: [
            // CircleAvatar(
            // child:
            // CustomImage(image: widget.community.creator.avatar,),
            // radius: size.width / 15,
            // ),
            // Container(
            // width: size.width / 10,
            // child: FittedBox(
            // child: Text(
            // "Name ${index + 1}",
            // style: TextStyle(
            // fontFamily: "Lato",
            // fontWeight: FontWeight.bold),
            // ),
            // ),
            // )
            // ],
            // ),
            // );
            // })),
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => NewClub()))
                  .then((value) => _fetchNewsClubs());
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Create CLub", style: TextStyle(fontFamily: "Lato")),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>NewClub()));
                  },
                  icon: Icon(Icons.add),
                )
              ],
            ),
          ),
          clubGrid()
            ],
            )
        ),
      ),
    );
  }
}
