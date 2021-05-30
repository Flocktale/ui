import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/Widgets/CommunityCard.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPageCommunities extends StatefulWidget {
  @override
  _LandingPageCommunitiesState createState() => _LandingPageCommunitiesState();
}

class _LandingPageCommunitiesState extends State<LandingPageCommunities> {
  BuiltCommunityList _communities;
  bool _isLoading = false;

  Future<void> _fetchCommunities() async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);

    _communities = (await service.getAllCommunities(
            lastevaluatedkey: _communities?.lastevaluatedkey))
        .body;

    _isLoading = false;
    setState(() {});
  }

  void _fetchMoreCommunities() async {
    final lastEvaluatedKey = _communities?.lastevaluatedkey;
    if (lastEvaluatedKey != null) {
      await _fetchCommunities();
    } else {
      await Future.delayed(Duration(milliseconds: 200));
      _isLoading = false;
    }
    setState(() {});
  }

  @override
  void initState() {
    _fetchCommunities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final communities = _communities?.communities;

    final listLength = (communities?.length ?? 0) + 1;

    return Container(
      child: ListView(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: [
          RefreshIndicator(
            onRefresh: () {
              // resetting community list
              _communities = null;
              _fetchCommunities();
              return;
            },
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
                  _fetchMoreCommunities();
                  _isLoading = true;
                }
                return true;
              },
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: listLength,
                itemBuilder: (context, index) {
                  if (index == listLength - 1) {
                    if (_isLoading)
                      return Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    else
                      return Container();
                  }
                  final _community = communities[index];
                  return CommunityCard(community: _community);
                },
              ),
            ),
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
