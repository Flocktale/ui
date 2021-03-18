import 'package:flocktale/providers/userData.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ContactsPage extends StatefulWidget {
  final bool newRegistration;

  const ContactsPage({Key key, this.newRegistration = false}) : super(key: key);
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  String text = 'Hi! Join me on FlockTale.';
  String subject = 'Link to the app:';
  TextEditingController searchController = new TextEditingController();

  _fetchContacts() async {
    List<Contact> _contacts =
        (await ContactsService.getContacts(withThumbnails: false)).toList();
    setState(() {
      contacts = _contacts;
    });
  }

  getPermissions() async {
    if (await Permission.contacts.request().isGranted) {
      _fetchContacts();
    }
  }

  filterContacts() {
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String contactName = contact.displayName.toLowerCase();
        return contactName.contains(searchTerm);
      });
      setState(() {
        contactsFiltered = _contacts;
      });
    }
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
                backgroundColor: MaterialStateProperty.all(Colors.redAccent),
              ),
              onPressed: () {
                Provider.of<UserData>(context, listen: false).newRegistration =
                    false;
              },
              child: Text(' Skip '),
            ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          children: [
            Container(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                    labelText: "Search",
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(
                            color: Theme.of(context).primaryColor)),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).primaryColor,
                    )),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount:
                      isSearching ? contactsFiltered.length : contacts.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    Contact contact =
                        isSearching ? contactsFiltered[index] : contacts[index];
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
                                    style: TextStyle(fontFamily: "Lato"),
                                  )),
                            title: Text(
                              contact.displayName,
                              style: TextStyle(fontFamily: "Lato"),
                            ),
                            subtitle: Text(
                              contact.phones.length > 0
                                  ? contact.phones.elementAt(0).value
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
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.red[600]),
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
    );
  }
}
