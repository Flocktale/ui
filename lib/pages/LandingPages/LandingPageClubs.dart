import 'dart:math';

import 'package:flocktale/Models/basic_enums.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/Widgets/Carousel.dart';
import 'package:flocktale/Widgets/introWidget.dart';
import 'package:flocktale/pages/ClubSection.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:built_collection/built_collection.dart';

class LandingPageClubs extends StatefulWidget {
  @override
  _LandingPageClubsState createState() => _LandingPageClubsState();
}

class _LandingPageClubsState extends State<LandingPageClubs>
    with AutomaticKeepAliveClientMixin {
  List<CategoryClubsList> _clubs;
  DateTime _clubFetchedTime = DateTime.now();

  Future<void> _navigateTo(Widget page) async {
    // when user is on another page, then no need to keep fetching clubs
    _clubFetchedTime = null;

    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => page))
        .then((value) {
      setState(() {});
      _fetchAllClubs();
    });
  }

  void _infinteClubFetching() async {
    await _fetchAllClubs(true);
    while (true) {
      final diff = DateTime.now()
          .difference(_clubFetchedTime ?? DateTime.now())
          .inSeconds;
      if (diff < 30) {
        await Future.delayed(Duration(seconds: max(30 - diff, 10)));
      } else {
        if (this.mounted) {
          await _fetchAllClubs();
        } else {
          await Future.delayed(Duration(seconds: 10));
        }
      }
    }
  }

  Future _fetchAllClubs([bool initiating = false]) async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);

    _clubFetchedTime = DateTime.now();

    _clubs = (await service.getAllClubs())?.body?.categoryClubs?.toList();

    _clubs = _clubs?.where((cat) => (cat?.clubs?.length ?? 0) > 0)?.toList();

    if (this.mounted) {
      setState(() {});
    }
  }

  Widget sectionHeading({
    String title,
    bool viewAll = false,
    ClubSectionType type,
    BuiltList<BuiltClub> clubs,
  }) {
    assert(type != null,
        'viewAllNavigationPage must not be null when viewAll is true and vice versa');

    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: size.height / 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 24,
                  color: Colors.redAccent,
                ),
              ),
            ),
            viewAll
                ? InkWell(
                    onTap: () =>
                        _navigateTo(ClubSection(type, category: title)),
                    child: Card(
                      //   shadowColor: Colors.white,
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 4),
                        child: Text(
                          'View All >',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
        Carousel(
          Clubs: clubs,
          navigateTo: _navigateTo,
        ),
      ],
    );
  }

  Widget get _displayClubList => ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: _clubs?.length ?? 0,
        itemBuilder: (context, index) {
          return _clubs[index].clubs.isNotEmpty
              ? sectionHeading(
                  title: _clubs[index].category,
                  viewAll: true,
                  type: ClubSectionType.Category,
                  clubs: _clubs[index].clubs,
                )
              : Container();
        },
      );

  Widget get _loadingWidget => Container(
        child: Center(
          child: Text(
            "Loading...",
            style: TextStyle(fontFamily: "Lato", color: Colors.grey),
          ),
        ),
      );

  @override
  void initState() {
    _infinteClubFetching();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: RefreshIndicator(
        backgroundColor: Colors.black87,
        color: Colors.redAccent,
        onRefresh: () async {
          await _fetchAllClubs();
        },
        child: ListView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: [
            FittedBox(child: IntroWidget()),
            _displayClubList,
            if (_clubs == null) _loadingWidget,
            SizedBox(height: 100),

            // in order to work with refresh indicator, listview must have a scrollable length (when item consumes more height than height of screen)
            if ((_clubs?.length ?? 0) < 4)
              SizedBox(
                height: (4 - (_clubs?.length ?? 0)) * 250.0,
              ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
