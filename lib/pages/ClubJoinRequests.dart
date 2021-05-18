import 'package:flocktale/Widgets/customImage.dart';
import 'package:flocktale/Widgets/profileSummary.dart';
import 'package:flutter/material.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClubJoinRequests extends StatefulWidget {
  final BuiltClub club;
  const ClubJoinRequests({this.club});
  @override
  _ClubJoinRequestsState createState() => _ClubJoinRequestsState();
}

class _ClubJoinRequestsState extends State<ClubJoinRequests> {
  BuiltActiveJoinRequests joinRequests;
  BuiltActiveJoinRequests filteredJoinRequests;

  bool isLoading = false;
  bool isSearching = false;

  final searchInput = new TextEditingController(text: '');

  DatabaseApiService _service;

  Future<void> loadingCycle(Function function) async {
    setState(() {
      isLoading = true;
    });

    if (function != null) await function();

    setState(() {
      isLoading = false;
    });
  }

  getJoinRequests() async {
    await loadingCycle(() async {
      joinRequests = (await _service.getActiveJoinRequests(
        clubId: widget.club.clubId,
      ))
          .body;
    });
  }

  acceptJoinRequest(String audienceId) async {
    await loadingCycle(() async {
      await _service.respondToJoinRequest(
        clubId: widget.club.clubId,
        action: "accept",
        audienceId: audienceId,
      );
      Fluttertoast.showToast(msg: "Join Request Accepted");
    });
  }

  fetchMoreJoinRequests() async {
    if (isLoading == true) return;

    final lastEvaluatedKey = joinRequests?.lastevaluatedkey;
    if (lastEvaluatedKey != null) {
      await getJoinRequests();
    } else {
      await Future.delayed(Duration(milliseconds: 200));
      isLoading = false;
    }
    setState(() {});
  }

  searchJoinRequests(String searchString) async {
    await loadingCycle(() async {
      filteredJoinRequests = (await _service.searchInActiveJoinRequests(
        clubId: widget.club.clubId,
        searchString: searchString,
        lastevaluatedkey: filteredJoinRequests?.lastevaluatedkey,
      ))
          .body;
    });
  }

  searchMoreJoinRequests(String searchString) async {
    if (isLoading == true) return;
    final lastEvaluatedKey = filteredJoinRequests?.lastevaluatedkey;
    if (lastEvaluatedKey != null) {
      await searchJoinRequests(searchString);
    } else {
      await Future.delayed(Duration(milliseconds: 200));
      isLoading = false;
    }
    setState(() {});
  }

  Widget searchBar() {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: TextField(
        controller: searchInput,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white54,
          ),
          fillColor: Colors.black.withOpacity(0.7),
          hintText: 'Search username',
          hintStyle: TextStyle(color: Colors.white38),
          filled: true,
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
        ),
        onChanged: (val) {
          print(val);
          if (val.isNotEmpty) {
            setState(() {
              isSearching = true;
            });
            searchJoinRequests(val);
          } else {
            setState(() {
              isSearching = false;
            });
          }
        },
      ),
    );
  }

  Card get acceptCard => Card(
        color: Colors.white,
        shadowColor: Colors.redAccent,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'Accept',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );

  Widget requesterList(BuiltActiveJoinRequests currentRequests) {
    final listLength = currentRequests?.activeJoinRequestUsers?.length ?? 0;
    if (listLength == 0)
      return Center(
        child: Text(
          'No Requests...',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 18,
          ),
        ),
      );

    return ListView.builder(
      shrinkWrap: true,
      itemCount: currentRequests?.activeJoinRequestUsers?.length ?? 0,
      itemBuilder: (context, index) {
        final requester =
            currentRequests.activeJoinRequestUsers[index].audience;

        return Container(
          key: ValueKey(requester.userId + ' $index'),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => ProfileShortView.display(context, requester),
                child: Container(
                  width: 36,
                  height: 36,
                  child: CustomImage(
                    image: requester.avatar,
                    radius: 8,
                  ),
                ),
              ),
              Text(
                requester.username,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              InkWell(
                onTap: () async {
                  await acceptJoinRequest(requester.userId);

                  final list = currentRequests.activeJoinRequestUsers
                      .toBuilder()
                        ..removeAt(index);

                  currentRequests = currentRequests
                      .rebuild((b) => b..activeJoinRequestUsers = list);

                  if (isSearching) {
                    {
                      filteredJoinRequests = currentRequests;

                      // this removed requester might also be present in non-filtered list so removing from that list too.

                      joinRequests = joinRequests.rebuild(
                        (b) => b
                          ..activeJoinRequestUsers =
                              (joinRequests.activeJoinRequestUsers.toBuilder()
                                ..removeWhere((r) =>
                                    r.audience.userId == requester.userId)),
                      );
                    }
                  } else
                    joinRequests = currentRequests;

                  setState(() {});
                },
                child: acceptCard,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    this._service = Provider.of<DatabaseApiService>(context, listen: false);
    getJoinRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BuiltActiveJoinRequests currentRequests;

    if (isSearching) {
      currentRequests = filteredJoinRequests;
    } else
      currentRequests = joinRequests;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
        child: Column(
          children: [
            Text(
              'Join Requests',
              style: TextStyle(color: Colors.redAccent, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            searchBar(),
            SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? Center(
                      child: SpinKitThreeBounce(color: Colors.redAccent),
                    )
                  : NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                          if (searchInput.text.isNotEmpty)
                            searchMoreJoinRequests(searchInput.text);
                          else
                            fetchMoreJoinRequests();
                          isLoading = true;
                        }
                        return true;
                      },
                      child: requesterList(currentRequests),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
