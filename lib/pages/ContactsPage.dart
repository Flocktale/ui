import 'package:flocktale/pages/ProfilePage.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/services/LocalStorage/FollowingDatabase.dart';
import 'package:flocktale/services/LocalStorage/InviteBox.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Models/contacts.dart' as CONTACT;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../customImage.dart';

class ContactsPage extends StatefulWidget {
  final bool newRegistration;

  const ContactsPage({Key key, this.newRegistration = false}) : super(key: key);
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  List<CONTACT.Contact> flockContacts = [];
  Map<String, bool> buttonPressed = new Map<String, bool>();
  List<CONTACT.Contact> flockContactsFiltered = [];
  // List<bool> flockUsersContactsFollowingButtonPressed = [];
  // List<bool> flockUsersContactsFollowingButtonPressedfiltered = [];
  String text = 'Hi! Join me on FlockTale.';
  String subject = 'Link to the app:';
  TextEditingController searchController = new TextEditingController();

  _fetchContacts() async {
    setState(() {
      contacts = InviteBox.getContacts();
      flockContacts = InviteBox.getData();
    });
    for (int j = 0; j < flockContacts.length; j++) {
      if (FollowingDatabase.isFollowing(flockContacts[j].userId)) {
        buttonPressed[flockContacts[j].userId] = true;
        //flockUsersContactsFollowingButtonPressed.add(true);
      } else {
        buttonPressed[flockContacts[j].userId] = false;
        // flockUsersContactsFollowingButtonPressed.add(false);
      }
    }
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);
    for (int i = 0; i < contacts.length; i++) {
      if (contacts[i] == null ||
          contacts[i].phones == null ||
          contacts[i].phones.length == 0) {
        continue;
      }
      for (int j = 0; j < flockContacts.length; j++) {
        if (contacts[i] != null &&
            contacts[i].phones != null &&
            contacts[i].phones.length != 0 &&
            flockContacts[j].phoneNo ==
                contacts[i].phones.elementAt(0).value.replaceAll(' ', '')) {
          _contacts.remove(contacts[i]);
        }
      }
    }
    setState(() {
      contacts = _contacts;
    });
  }

  Future<void> getPermissions() async {
//    await InviteBox.clearContactDatabase();
    await InviteBox.getNonSavedPhoneNumbers(context);
    final userId = Provider.of<UserData>(context, listen: false).userId;
    await FollowingDatabase.fetchList(userId, context);
    _fetchContacts();
  }

  filterContacts() {
    final now = DateTime.now();

    List<Contact> _contacts = [];
    _contacts.addAll(contacts);

    List<CONTACT.Contact> _flockUsersContacts = [];
    _flockUsersContacts.addAll(flockContacts);

    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String contactName = contact?.displayName?.toLowerCase();
        return contactName?.contains(searchTerm);
      });

      _flockUsersContacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String contactName = contact?.name?.toLowerCase();
        return contactName?.contains(searchTerm);
      });
      setState(() {
        contactsFiltered = _contacts;
        flockContactsFiltered = _flockUsersContacts;
      });
    }
    print('milliseconds : ${DateTime.now().difference(now).inMilliseconds}');
  }

  share(BuildContext context) {
    //  final RenderBox box = context.findRenderObject();
    Share.share(
      text,
      subject: subject,
      // sharePositionOrigin: box.localToGlobal(Offset.zero)&box.size
    );
  }

  @override
  void initState() {
    super.initState();
    getPermissions();
    searchController.addListener(() {
      filterContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isSearching = searchController.text.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Connect with contacts",
          style: TextStyle(
              fontFamily: "Lato",
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          if (widget.newRegistration)
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: () {
                Provider.of<UserData>(context, listen: false).newRegistration =
                    false;
              },
              child: Text(
                ' Done ',
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
            ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                    labelText: "Search names",
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(
                            color: Theme.of(context).primaryColor)),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).primaryColor,
                    )),
                onChanged: (val) {
                  if (val == "") setState(() {});
                },
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: getPermissions,
                child: ListView(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(
                        isSearching
                            ? flockContactsFiltered.length == 0
                                ? ''
                                : "Connect now"
                            : "Connect now",
                        style: TextStyle(
                            fontFamily: "Lato",
                            fontWeight: FontWeight.bold,
                            fontSize: size.width / 20),
                      ),
                    ),
                    Container(
                      child: ListView.builder(
                          itemCount: isSearching
                              ? flockContactsFiltered.length
                              : flockContacts.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            CONTACT.Contact contact = isSearching
                                ? flockContactsFiltered[index]
                                : flockContacts[index];
                            return contact.phoneNo.length > 0
                                ? InkWell(
                                    onTap: () async {
                                      await Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (_) => ProfilePage(
                                                    userId: contact.userId,
                                                  )))
                                          .then((value) => _fetchContacts());
                                    },
                                    child: ListTile(
                                      leading: CustomImage(
                                          image: contact.userAvatar + '_thumb'),
                                      title: Text(
                                        contact.name,
                                        style: TextStyle(fontFamily: "Lato"),
                                      ),
                                      subtitle: Text(
                                        contact.phoneNo.length > 0
                                            ? contact.phoneNo
                                            : '',
                                        style: TextStyle(fontFamily: "Lato"),
                                      ),
                                      trailing: buttonPressed[contact.userId]
                                          ? ButtonTheme(
                                              child: RaisedButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    buttonPressed[
                                                        contact.userId] = false;
                                                  });

                                                  final userId =
                                                      Provider.of<UserData>(
                                                              context,
                                                              listen: false)
                                                          .userId;
                                                  final authToken =
                                                      Provider.of<UserData>(
                                                              context,
                                                              listen: false)
                                                          .authToken;
                                                  final resp = (await Provider
                                                          .of<DatabaseApiService>(
                                                              context,
                                                              listen: false)
                                                      .unfollow(
                                                          userId: userId,
                                                          foreignUserId:
                                                              contact.userId,
                                                          authorization:
                                                              authToken));
                                                  if (resp.isSuccessful) {
                                                    FollowingDatabase
                                                        .deleteFollowing(
                                                            contact.userId);
                                                  } else {
                                                    setState(() {
                                                      buttonPressed[contact
                                                          .userId] = true;
                                                    });
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'Something went wrong. Please try again');
                                                  }
                                                },
                                                color: Colors.white,
                                                child: Text('Following',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red[600],
                                                    )),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                  side: BorderSide(
                                                      color: Colors.red[600]),
                                                ),
                                                elevation: 0.0,
                                              ),
                                            )
                                          : ButtonTheme(
                                              child: RaisedButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    buttonPressed[
                                                        contact.userId] = true;
                                                  });
                                                  final userId =
                                                      Provider.of<UserData>(
                                                              context,
                                                              listen: false)
                                                          .userId;
                                                  final authToken =
                                                      Provider.of<UserData>(
                                                              context,
                                                              listen: false)
                                                          .authToken;
                                                  final resp = (await Provider
                                                          .of<DatabaseApiService>(
                                                              context,
                                                              listen: false)
                                                      .follow(
                                                          userId: userId,
                                                          foreignUserId:
                                                              contact.userId,
                                                          authorization:
                                                              authToken));
                                                  if (resp.isSuccessful) {
                                                    FollowingDatabase
                                                        .addFollowing(
                                                            contact.userId);
                                                  } else {
                                                    setState(() {
                                                      buttonPressed[contact
                                                          .userId] = false;
                                                    });
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'Something went wrong. Please try again');
                                                  }
                                                },
                                                color: Colors.red,
                                                child: Text('Follow',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    )),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                  side: BorderSide(
                                                      color: Colors.red[600]),
                                                ),
                                                elevation: 0.0,
                                              ),
                                            ),
                                    ),
                                  )
                                : Container();
                          }),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(
                        isSearching
                            ? contacts.length == 0
                                ? ""
                                : "Invite your contacts"
                            : "Invite your contacts",
                        style: TextStyle(
                            fontFamily: "Lato",
                            fontWeight: FontWeight.bold,
                            fontSize: size.width / 20),
                      ),
                    ),
                    Container(
                      child: ListView.builder(
                          itemCount: isSearching
                              ? contactsFiltered.length
                              : contacts.length,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemBuilder: (context, index) {
                            Contact contact = isSearching
                                ? contactsFiltered[index]
                                : contacts[index];
                            return contact.phones.length > 0
                                ? ListTile(
                                    leading: (contact.avatar != null &&
                                            contact.avatar.length > 0)
                                        ? CircleAvatar(
                                            backgroundImage:
                                                MemoryImage(contact.avatar))
                                        : CircleAvatar(
                                            child: Text(
                                            contact.initials(),
                                            style:
                                                TextStyle(fontFamily: "Lato"),
                                          )),
                                    title: Text(
                                      contact.displayName,
                                      style: TextStyle(fontFamily: "Lato"),
                                    ),
                                    subtitle: Text(
                                      contact.phones.length > 0
                                          ? contact.phones
                                              .elementAt(0)
                                              .value
                                              .replaceAll(' ', '')
                                          : '',
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
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: BorderSide(
                                              color: Colors.red[600]),
                                        ),
                                        elevation: 0.0,
                                      ),
                                    ),
                                  )
                                : Container();
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
