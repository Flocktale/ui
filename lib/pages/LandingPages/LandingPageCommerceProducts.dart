import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/Widgets/clubContentCard.dart';
import 'package:flocktale/pages/NewsPage.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPageCommerceProducts extends StatefulWidget {
  @override
  _LandingPageCommerceProductsState createState() =>
      _LandingPageCommerceProductsState();
}

class _LandingPageCommerceProductsState
    extends State<LandingPageCommerceProducts> {
  List<ClubContentModel> contentList;

  DatabaseApiService service;

  Future<void> _fetchContentList() async {
    // TODO: fetch commerce products instead of news
    contentList = (await service.getContentData(type: 'news'))?.body?.toList();
    setState(() {});
  }

  @override
  void initState() {
    service = Provider.of<DatabaseApiService>(context, listen: false);
    _fetchContentList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (contentList == null) return Center(child: CircularProgressIndicator());
    return ListView(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: contentList.length,
          itemBuilder: (context, index) {
            final data = contentList[index];

            return InkWell(
              onTap: () {
                //TODO: push commerce page.
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => NewsPage(
                      news: data,
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ClubContentCard(data),
              ),
            );
          },
        ),
        SizedBox(height: 100),
      ],
    );
  }
}
