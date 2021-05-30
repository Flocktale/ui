import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/Models/enums/communityUserType.dart';
import 'package:flocktale/Widgets/CommunityPageTopSection.dart';
import 'package:flocktale/Widgets/summaryClubCard.dart';
import 'package:flocktale/pages/NewClub.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommunityPage extends StatefulWidget {
  final BuiltCommunity community;
  CommunityPage({this.community});
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage>
    with TickerProviderStateMixin {
  BuiltCommunity _community;

  bool _isOwner = false;

  bool _isMember;

  BuiltSearchClubs _communityClubs;
  bool _isClubsLoading = true;

  void _navigateTo(Widget page) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => page))
        .then((value) {
      setState(() {});
    });
  }

  Widget clubGrid() {
    final clubList = _communityClubs?.clubs;
    final bool isLoading = _isClubsLoading;
    final listClubs = (clubList?.length ?? 0) + 1;
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          _fetchMoreCommunityClubs();
          _isClubsLoading = true;
        }
        return true;
      },
      child: RefreshIndicator(
        onRefresh: () async {
          await _fetchCommunityClubs(refresh: true);
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
    );
  }

  Widget _createClubButton() {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (_) => NewClub(community: _community)))
            .then(
              (value) => _fetchCommunityClubs(refresh: true),
            );
      },
      child: Card(
        elevation: 8,
        shadowColor: Colors.redAccent,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.black87,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Create Club",
                  style: TextStyle(
                    fontFamily: "Lato",
                    color: Colors.white,
                    fontSize: 16,
                  )),
              SizedBox(width: 8),
              Icon(
                Icons.add,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }

  _fetchCommunityClubs({bool refresh = false}) async {
    if (refresh) _communityClubs = null;
    _isClubsLoading = false;
    setState(() {});
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    _communityClubs = (await service.getCommunityActiveClubs(
            _community.communityId,
            lastevaluatedkey: _communityClubs?.lastevaluatedkey))
        .body;
    _isClubsLoading = false;
    setState(() {});
  }

  _fetchMoreCommunityClubs() async {
    final lastevaluatedkey = _communityClubs?.lastevaluatedkey;
    if (lastevaluatedkey != null) {
      await _fetchCommunityClubs();
    } else {
      await Future.delayed(Duration(milliseconds: 200));
      _isClubsLoading = false;
    }
  }

  Future<void> _toggleIsMember() async {
    if (_isMember == null) return;
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final cuserId = Provider.of<UserData>(context, listen: false).userId;
    int memberCounter = 0;

    if (_isMember) {
      await service.removeCommunityUser(
        _community.communityId,
        type: CommunityUserType.MEMBER,
        userId: cuserId,
      );
      memberCounter = -1;
    } else {
      await service.joinCommunityAsMember(
        _community.communityId,
        userId: cuserId,
      );
      memberCounter = 1;
    }

    _community = _community.rebuild(
        (b) => b..memberCount = _community.memberCount + memberCounter);

    setState(() {
      _isMember = !_isMember;
    });
  }

  void _checkMembershipStatus() async {
    if (_isOwner) {
      setState(() {});
      return;
    }

    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final username =
        Provider.of<UserData>(context, listen: false).user.username;
    final res = (await service.searchCommunityMember(
      _community.communityId,
      searchString: username,
    ))
        .body;

    _isMember = false; //initiating to ensure it is non-null

    res.users.forEach((user) {
      if (user.username == username) {
        _isMember = true;
      }
    });

    setState(() {});
  }

  @override
  void initState() {
    this._community = widget.community;
    final cuserId = Provider.of<UserData>(context, listen: false).userId;
    _isOwner = _community.creator.userId == cuserId;

    _checkMembershipStatus();
    _fetchCommunityClubs();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            CommunityPageTopSection(
              _community,
              isMember: _isMember,
              toggleIsMember: _toggleIsMember,
            ),
            if (_isOwner) _createClubButton(),
            Expanded(child: clubGrid())
          ],
        ),
      ),
    );
  }
}
