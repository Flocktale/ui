import 'package:chopper/chopper.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/Widgets/ProfileShortView.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/services/LocalStorage/FollowingDatabase.dart';
import 'package:flocktale/services/LocalStorage/InviteBox.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart' as CONTACT;
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Models/contacts.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../Widgets/customImage.dart';

class ContactsPage extends StatefulWidget {
  final bool newRegistration;

  const ContactsPage({Key key, this.newRegistration = false}) : super(key: key);
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  // always used filtered Contacts for displaying purpose
  List<Contact> flocktaleContacts = [];
  List<Contact> flocktaleFilteredContacts = [];

  List<CONTACT.Contact> phoneContacts = [];
  List<CONTACT.Contact> phoneFilteredContacts = [];

  Map<String, bool> followStatus = new Map<String, bool>();

  String text = 'Hi! Join me on FlockTale.';
  String subject = 'Link to the app:';

  bool _initialFetching = true;

  TextEditingController _searchController = new TextEditingController();

  void _setFollowStatus() {
    for (int j = 0; j < flocktaleContacts.length; j++) {
      if (FollowingDatabase.isFollowing(flocktaleContacts[j].userId)) {
        followStatus[flocktaleContacts[j].userId] = true;
        //flockUsersContactsFollowingfollowStatus.add(true);
      } else {
        followStatus[flocktaleContacts[j].userId] = false;
        // flockUsersContactsFollowingfollowStatus.add(false);
      }
    }
  }

  void removeFlocktaleContactsFromPhoneContacts() {
    flocktaleContacts.forEach((flockContact) {
      for (int i = 0; i < phoneContacts.length; i++) {
        bool present = false;
        phoneContacts[i].phones.forEach((element) {
          String phoneNo = element.value;

          if (phoneNo[0] != '+') return;
          if (phoneNo == flockContact) {
            present = true;
          }
        });
        if (present) {
          phoneContacts.remove(phoneContacts[i]);
          break;
        }
      }
    });
  }

  Future<void> _initiateAndFetchContactsFromLocalDB() async {
    await InviteBox.getNonSavedPhoneNumbers(context);
    final userId = Provider.of<UserData>(context, listen: false).userId;
    await FollowingDatabase.fetchList(userId, context);
    _fetchContacts();
  }

  void _fetchContacts() async {
    flocktaleContacts = InviteBox.getData();
    phoneContacts = InviteBox.getContacts();

    _setFollowStatus();

    removeFlocktaleContactsFromPhoneContacts();
    // setFiltered values as original values
    flocktaleFilteredContacts = [...flocktaleContacts];
    phoneFilteredContacts = [...phoneContacts];
    setState(() {
      _initialFetching = false;
    });
  }

  filterContacts() {
    final now = DateTime.now();
    flocktaleFilteredContacts = [...flocktaleContacts];
    phoneFilteredContacts = [...phoneContacts];

    if (_searchController.text.isNotEmpty) {
      flocktaleFilteredContacts.retainWhere((contact) {
        String searchTerm = _searchController.text.toLowerCase();
        String contactName = contact?.name?.toLowerCase();
        return contactName?.contains(searchTerm);
      });

      phoneFilteredContacts.retainWhere((contact) {
        String searchTerm = _searchController.text.toLowerCase();
        String contactName = contact?.displayName?.toLowerCase();
        return contactName?.contains(searchTerm);
      });
    }

    print('milliseconds : ${DateTime.now().difference(now).inMilliseconds}');
    setState(() {});
  }

  share(BuildContext context) {
    Share.share(
      text,
      subject: subject,
    );
  }

  Widget _flocktaleContactListDisplay(isSearching) {
    return ListView(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      children: [
        if (isSearching && flocktaleFilteredContacts.length > 0)
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text(
              "Connect now",
              style: TextStyle(
                fontFamily: "Lato",
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        Container(
          child: ListView.builder(
            itemCount: flocktaleFilteredContacts.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              Contact contact = flocktaleFilteredContacts[index];

              if (contact.phoneNo.isEmpty) {
                return Container();
              }

              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => ProfileShortView.display(
                        context,
                        SummaryUser((b) => b
                          ..userId = contact.userId
                          ..avatar = contact.userAvatar),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 48,
                            width: 48,
                            child: CustomImage(
                              image: contact.userAvatar + "_thumb",
                              radius: 8,
                            ),
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                contact.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                contact.phoneNo.length > 0
                                    ? contact.phoneNo
                                    : '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                          SizedBox(width: 16),
                        ],
                      ),
                    ),
                    _socialActionButton(contact),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _socialActionButton(Contact contact) {
    final isFollowing = followStatus[contact.userId];

    final performSocialAction = () async {
      final userId = Provider.of<UserData>(context, listen: false).userId;
      Response<RelationActionResponse> resp;
      if (isFollowing) {
        resp = (await Provider.of<DatabaseApiService>(context, listen: false)
            .unfollow(
          userId: userId,
          foreignUserId: contact.userId,
        ));
      } else {
        resp = (await Provider.of<DatabaseApiService>(context, listen: false)
            .follow(
          userId: userId,
          foreignUserId: contact.userId,
        ));
      }

      if (resp.isSuccessful) {
        if (isFollowing) {
          FollowingDatabase.deleteFollowing(contact.userId);
        } else {
          FollowingDatabase.addFollowing(contact.userId);
        }
        followStatus[contact.userId] = !isFollowing;
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong. Please try again');
      }
      setState(() {});
    };

    return InkWell(
      onTap: () => performSocialAction(),
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: isFollowing ? 8 : 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.0),
          color: isFollowing ? Colors.transparent : Colors.redAccent,
        ),
        child: Text(
          isFollowing ? 'Following' : 'Follow',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isFollowing ? Colors.redAccent : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _phoneContactsListDisplay() {
    return ListView(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      children: [
        if (phoneFilteredContacts.isNotEmpty)
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text(
              "Invite your contacts",
              style: TextStyle(
                fontFamily: "Lato",
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        Container(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: phoneFilteredContacts.length,
            itemBuilder: (context, index) {
              CONTACT.Contact contact = phoneFilteredContacts[index];
              if (contact.phones.isEmpty) return Container();

              final hasMemoryImage =
                  (contact.avatar != null && contact.avatar.length > 0);

              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.blueGrey,
                              image: hasMemoryImage
                                  ? DecorationImage(
                                      image: MemoryImage(contact.avatar))
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: hasMemoryImage
                                ? null
                                : Text(
                                    contact.initials(),
                                    style: TextStyle(
                                      fontFamily: "Lato",
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                          SizedBox(width: 16),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  contact.displayName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  contact.phones.length > 0
                                      ? contact.phones
                                          .elementAt(0)
                                          .value
                                          .replaceAll(' ', '')
                                      : '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                        ],
                      ),
                    ),
                    RaisedButton(
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
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  AppBar get _appBar => AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          "Connect with contacts",
          style: TextStyle(
            fontFamily: "Lato",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          if (widget.newRegistration)
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
              ),
              onPressed: () {
                Provider.of<UserData>(context, listen: false).newRegistration =
                    false;
              },
              child: Text(
                ' Done ',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      );

  @override
  void initState() {
    super.initState();
    _initiateAndFetchContactsFromLocalDB();

    _searchController.addListener(() {
      filterContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isSearching = _searchController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar,
      body: Container(
        color: Colors.black87,
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: _initialFetching
            ? Center(
                child: SpinKitChasingDots(
                color: Colors.redAccent,
              ))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(color: Colors.redAccent),
                      decoration: InputDecoration(
                          labelText: "Search names",
                          labelStyle: TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white70,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white,
                          )),
                      onChanged: (val) {
                        if (val == "") setState(() {});
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        _flocktaleContactListDisplay(isSearching),
                        _phoneContactsListDisplay(),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
