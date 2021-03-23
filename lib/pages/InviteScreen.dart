import 'package:chopper/chopper.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flocktale/Widgets/customImage.dart';
import 'package:flocktale/services/LocalStorage/InviteBox.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:provider/provider.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:built_collection/built_collection.dart';
import 'package:share/share.dart';

import 'ProfilePage.dart';

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

  share(BuildContext context) {
    //  final RenderBox box = context.findRenderObject();
    String text;

    if (widget.forPanelist) {
//owner is sending participation ivnitation
      text =
          'Hi! Be a panelist for my club "${widget.club.clubName}" on FlockTale.';
    } else {
      if (widget.club.creator.userId ==
          Provider.of<UserData>(context, listen: false).userId) {
        text =
            'Hey, come and join us in Hall of "${widget.club.clubName}" on Flocktale.';
      } else {
        text =
            'Hi, let\'s listen to "${widget.club.clubName}" together on Flocktale. The panelists are really interesting.';
      }
    }
    String subject = 'Link to the app:';
    Share.share(
      text,
      subject: subject,
      // sharePositionOrigin: box.localToGlobal(Offset.zero)&box.size
    );
  }

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
    final size = MediaQuery.of(context).size;

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
            key: ValueKey(_user.username),
            margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: ListTile(
              leading: CircleAvatar(
                child: CustomImage(
                  image: _user.avatar + "_thumb",
                ),
              ),
              title: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ProfilePage(
                            userId: _user.userId,
                          )));
                },
                child: Text(
                  _user.username,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Lato', fontWeight: FontWeight.bold),
                ),
              ),
              trailing: Transform.scale(
                scale: 1.25,
                child: Switch(
                  activeColor: Colors.red[600],
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
              ),
            ),
          );
        },
      ),
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
        child: ListView.builder(
            itemCount: contacts?.length,
            itemBuilder: (context, index) {
              Contact contact = contacts[index];
              return ListTile(
                leading: (contact.avatar != null && contact.avatar.length > 0)
                    ? CircleAvatar(backgroundImage: MemoryImage(contact.avatar))
                    : CircleAvatar(
                        backgroundColor: Colors.redAccent,
                        child: Text(
                          contact.initials(),
                          style: TextStyle(
                              fontFamily: "Lato", color: Colors.white),
                        )),
                title: Text(
                  contact.displayName ?? '',
                  style: TextStyle(
                      fontFamily: "Lato", fontWeight: FontWeight.bold),
                ),
                subtitle: contact != null &&
                        contact.phones != null &&
                        contact.phones.length != 0
                    ? Text(
                        contact.phones.elementAt(0).value.replaceAll(' ', ''),
                        style: TextStyle(fontFamily: "Lato"),
                      )
                    : Text(
                        "Contact",
                        style: TextStyle(fontFamily: "Lato"),
                      ),
                trailing: ButtonTheme(
                  child: RaisedButton(
                    onPressed: () {
                      share(context);
                    },
                    color: Colors.white,
                    child: Text('Invite',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red[600],
                        )),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red[600]),
                    ),
                    elevation: 0.0,
                  ),
                ),
              );
            }),
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
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Invite ' + (widget.forPanelist ? 'Panelist' : 'Audience'),
            style: TextStyle(
              fontFamily: 'Lato',
              color: Colors.black,
            ),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            unselectedLabelColor: Colors.grey[700],
            labelColor: Colors.black,
            labelStyle:
                TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold),
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: Colors.black),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Text(
                type.toUpperCase(),
                style: TextStyle(
                  fontFamily: "Lato",
                ),
              ),
              Text(
                "CONTACTS",
                style: TextStyle(fontFamily: "Lato"),
              )
            ],
          ),
        ),
        body: TabBarView(
            controller: _tabController, children: [tabPage(0), tabPage(1)]),
      ),
    ));
  }
}
