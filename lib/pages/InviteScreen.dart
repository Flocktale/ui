import 'package:chopper/chopper.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flocktale/Widgets/customImage.dart';
import 'package:flocktale/Widgets/ProfileShortView.dart';
import 'package:flocktale/services/LocalStorage/InviteBox.dart';
import 'package:flocktale/services/shareApp.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:provider/provider.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:built_collection/built_collection.dart';

class InviteScreen extends StatefulWidget {
  final BuiltClub club;

  /// set [forPanelist] to true only when inviting panelist.
  final bool forPanelist;
  const InviteScreen({@required this.club, this.forPanelist = false});
  @override
  _InviteScreenState createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen>
    with TickerProviderStateMixin {
  List<Contact> contacts = [];
  String type;
  String _sponsorId;
  TabController _tabController;

  // it retains list of followers, even if user is searching
  // when user clear his/her searches, it will show already loaded data.
  Map<String, dynamic> relationMap = {
    'data': null,
    'isLoading': true,
  };

  // it would be null when user is not searching.
  Map<String, dynamic> searchResultMap = {
    'data': null,
    'isLoading': true,
  };

  bool _isSearching = false;

  bool _isInviting = false;

  Map<String, bool> _selectedUserIds = {};

  _fetchContacts() async {
    contacts = (await InviteBox.fetchContactsFromPhone());
    print("1212121212121212121212121212");
    print(contacts);
    setState(() {});
  }

  Future<void> _fetchRelationData() async {
    relationMap['data'] =
        (await Provider.of<DatabaseApiService>(context, listen: false)
                .getRelations(
      userId: _sponsorId,
      socialRelation: type,
      lastevaluatedkey:
          (relationMap['data'] as BuiltSearchUsers)?.lastevaluatedkey,
    ))
            .body;
    relationMap['isLoading'] = false;
    setState(() {});
  }

  void _fetchMoreRelationData() async {
    if (relationMap['isLoading'] == true) return;
    setState(() {});

    final lastevaulatedkey =
        (relationMap['data'] as BuiltSearchUsers)?.lastevaluatedkey;

    if (lastevaulatedkey != null) {
      await _fetchRelationData();
    } else {
      await Future.delayed(Duration(milliseconds: 200));
      relationMap['isLoading'] = false;
    }

    setState(() {});
  }

  Future<void> _inviteUsers({bool all = false}) async {
    if (all == false && _selectedUserIds.isEmpty) {
      Fluttertoast.showToast(msg: 'Select one atleast');
      return;
    }
    setState(() {
      _isInviting = true;
    });

    final service = Provider.of<DatabaseApiService>(context, listen: false);
    Response response;
    if (all) {
      response = await service.inviteAllFollowers(
        clubId: widget.club.clubId,
        sponsorId: _sponsorId,
      );
    } else {
      BuiltList<String> list = BuiltList<String>([]);
      var builder = list.toBuilder();
      builder.addAll(_selectedUserIds.keys);
      response = await service.inviteUsers(
        clubId: widget.club.clubId,
        sponsorId: _sponsorId,
        invite: BuiltInviteFormat((b) => b
          ..invitee = builder
          ..type = widget.forPanelist ? 'participant' : 'audience'),
      );
    }
    if (response.isSuccessful) {
      Fluttertoast.showToast(msg: 'Invitations sent successfully');
      Navigator.of(context).pop();
    } else {
      Fluttertoast.showToast(msg: 'Error in sending invitaions');

      setState(() {
        _isInviting = false;
      });
    }
  }

  // Widget inviteeSearchBar() {
  //   final size = MediaQuery.of(context).size;
  //   return Container(
  //     height: size.height / 20,
  //     margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
  //     child: TextField(
  //       controller: inviteeSearchController,
  //       decoration: InputDecoration(
  //           prefixIcon: Icon(
  //             Icons.search,
  //             color: Colors.black,
  //           ),
  //           fillColor: Colors.grey[200],
  //           hintText: 'Search friends',
  //           filled: true,
  //           enabledBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(12.0)),
  //               borderSide: BorderSide(color: Colors.black, width: 1.0)),
  //           focusedBorder: OutlineInputBorder(
  //               borderSide: BorderSide(color: Colors.black, width: 2.0))),
  //     ),
  //   );
  // }
  //
  // Widget contactSearchBar() {
  //   final size = MediaQuery.of(context).size;
  //   return Container(
  //     height: size.height / 20,
  //     margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
  //     child: TextField(
  //       controller: contactSearchController,
  //       decoration: InputDecoration(
  //           prefixIcon: Icon(
  //             Icons.search,
  //             color: Colors.black,
  //           ),
  //           fillColor: Colors.grey[200],
  //           hintText: 'Search friends',
  //           filled: true,
  //           enabledBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(12.0)),
  //               borderSide: BorderSide(color: Colors.black, width: 1.0)),
  //           focusedBorder: OutlineInputBorder(
  //               borderSide: BorderSide(color: Colors.black, width: 2.0))),
  //     ),
  //   );
  // }

  Widget _relationListWidget() {
    final relationUsers = (relationMap['data'] as BuiltSearchUsers)?.users;
    final bool isLoading = relationMap['isLoading'];

    final listLength = (relationUsers?.length ?? 0) + 1;

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          _fetchMoreRelationData();
          relationMap['isLoading'] = true;
        }
        return true;
      },
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: listLength,
        itemBuilder: (context, index) {
// last index of this list is being used for loading animation while more users are loaded.
          if (index == listLength - 1) {
            if (isLoading)
              return Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Center(child: CircularProgressIndicator()),
              );
            else
              return Container();
          }

          final _user = relationUsers[index];

          return Container(
            key: ValueKey(_user.username + ' $index'),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => ProfileShortView.display(context, _user),
                  child: Container(
                    width: 48,
                    height: 48,
                    child: CustomImage(
                      image: _user.avatar + "_thumb",
                      radius: 8,
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      _user.username,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Transform.scale(
                  scale: 1.25,
                  child: Switch(
                    activeColor: Colors.white,
                    activeTrackColor: Colors.redAccent,
                    inactiveThumbColor: Colors.white,
                    activeThumbImage: NetworkImage(_user.avatar + "_thumb"),
                    value: _selectedUserIds[_user.userId] ?? false,
                    onChanged: (val) async {
                      if (val) {
                        _selectedUserIds[_user.userId] = true;
                      } else {
                        _selectedUserIds.remove(_user.userId);
                      }
                      if (!this.mounted) return;
                      setState(() {});
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget contactListBuilder() {
    return ListView.builder(
      itemCount: contacts?.length,
      itemBuilder: (context, index) {
        Contact contact = contacts[index];

        bool hasAvatar = (contact.avatar?.length ?? 0) > 0;
        String name = contact.displayName ?? '';
        String phone = (contact?.phones?.length ?? 0) != 0
            ? contact.phones.elementAt(0).value.replaceAll(' ', '')
            : '';

        if (name.isEmpty && phone.isEmpty) return Container();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: hasAvatar
                      ? DecorationImage(image: MemoryImage(contact.avatar))
                      : null,
                  color: Colors.white,
                ),
                child: !hasAvatar
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.redAccent[200],
                        ),
                        child: Center(
                          child: Text(
                            contact.initials(),
                            style: TextStyle(
                              fontFamily: "Lato",
                              color: Colors.white,
                            ),
                          ),
                        ))
                    : null,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        phone,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => ShareApp(context).club(widget.club.clubName,
                    forPanelist: widget.forPanelist),
                child: Card(
                  color: Colors.white,
                  shadowColor: Colors.redAccent,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Invite',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _inviteButton(String text, VoidCallback onTap) {
    final size = MediaQuery.of(context).size;

    return ButtonTheme(
      minWidth: size.width / 3.2,
      child: RaisedButton(
        onPressed: onTap,
        color: Colors.red[600],
        child: Text(text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Lato',
            )),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          //side: BorderSide(color: Colors.red[600]),
        ),
      ),
    );
  }

  Widget tabPage(int index) {
    if (index == 0) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: _isInviting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _isSearching
                      ? Container()
                      : Expanded(child: _relationListWidget()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      /// Invite all is only for audience type of invitation
                      if (widget.forPanelist == false)
                        _inviteButton(
                            'Invite All', () => _inviteUsers(all: true)),

                      _inviteButton('Invite (${_selectedUserIds.length})',
                          () => _inviteUsers(all: false)),
                    ],
                  )
                ],
              ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: contactListBuilder(),
      );
    }
  }

  @override
  void initState() {
    this.type = widget.forPanelist ? 'friends' : 'followers';
    this._sponsorId = Provider.of<UserData>(context, listen: false).userId;
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
    _fetchContacts();
    _fetchRelationData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      color: Colors.white,
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.black87,
          body: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white70,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      'Invite ' +
                          (widget.forPanelist ? 'Panelist' : 'Audience'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Lato',
                        color: Colors.redAccent,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                ],
              ),
              SizedBox(height: 8),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                unselectedLabelColor: Colors.grey[700],
                labelColor: Colors.white,
                labelStyle: TextStyle(
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                ),
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Colors.redAccent),
                ),
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      type.toUpperCase(),
                      style: TextStyle(
                        fontFamily: "Lato",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "CONTACTS",
                      style: TextStyle(fontFamily: "Lato"),
                    ),
                  )
                ],
              ),
              Expanded(
                child: TabBarView(
                    controller: _tabController,
                    children: [tabPage(0), tabPage(1)]),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
