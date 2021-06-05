import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/Widgets/CommunityCard.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class LandingPageCommunities extends StatefulWidget {
  @override
  _LandingPageCommunitiesState createState() => _LandingPageCommunitiesState();
}

class _LandingPageCommunitiesState extends State<LandingPageCommunities>
    with AutomaticKeepAliveClientMixin {
  BuiltCommunityList _communities;
  bool _isLoading = true;

  bool _isFetchingMore = false;

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

    if (lastEvaluatedKey != null && _isFetchingMore == false) {
      setState(() {
        _isFetchingMore = true;
      });
      await _fetchCommunities();
    } else {
      await Future.delayed(Duration(milliseconds: 200));
      _isLoading = false;
    }
    _isFetchingMore = false;
    setState(() {});
  }

  @override
  void initState() {
    _fetchCommunities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_isLoading) {
      return Center(
        child: SpinKitChasingDots(
          color: Colors.redAccent,
        ),
      );
    }

    return Container(
      child: RefreshIndicator(
        backgroundColor: Colors.black87,
        color: Colors.redAccent,
        onRefresh: () async {
          await _fetchCommunities();
        },
        child: ListView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
                  _fetchMoreCommunities();
                }
                return true;
              },
              child: ListView(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: [
                  ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _communities?.communities?.length ?? 0,
                    itemBuilder: (context, index) {
                      final _community = _communities.communities[index];
                      return CommunityCard(community: _community);
                    },
                  ),
                  SizedBox(height: 80),
                  if (_isFetchingMore)
                    Center(
                      child: SpinKitChasingDots(
                        color: Colors.redAccent,
                      ),
                    ),
                ],
              ),
            ),

            // in order to work with refresh indicator, listview must have a scrollable length (when item consumes more height than height of screen)
            if ((_communities?.communities?.length ?? 0) < 4)
              SizedBox(
                height: (4 - (_communities?.communities?.length ?? 0)) * 250.0,
              ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
