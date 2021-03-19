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
  List<Contact> flockUsersContacts = [];
  List<Contact> flockContactsFiltered = [];
  List<String> flockUersContactsAvatar = [];
  List<String> flockUersContactsAvatarFiltered = [];
  List<String> flockUsersContactsUserId = [];
  List<String> flockUsersContactsUserIdFiltered = [];
  List<bool> flockUsersContactsFollowingButtonPressed = [];
  List<bool> flockUsersContactsFollowingButtonPressedfiltered = [];
  String text = 'Hi! Join me on FlockTale.';
  String subject = 'Link to the app:';
  TextEditingController searchController = new TextEditingController();

  _fetchContacts() async {
    setState(() {
      contacts = InviteBox.getContacts();
      flockContacts = InviteBox.getData();
    });
    _flockContactsBuilder();
  }

  _flockContactsBuilder()async{
    print("******************************");
    print(flockContacts);
    print(contacts);
    print(flockContacts.length);
    print(contacts.length);

    for(int i=0;i<contacts.length;i++){
      for(int j=0;j<flockContacts.length;j++){
        if(contacts[i]!=null && contacts[i].phones!=null
            && contacts[i].phones.length!=0 && contacts[i].phones.elementAt(0).value.replaceAll(' ', '')==flockContacts[j].phoneNo){
          flockUsersContacts.add(contacts[i]);
          flockUersContactsAvatar.add(flockContacts[j].userAvatar);
          flockUsersContactsUserId.add(flockContacts[j].userId);
          if(FollowingDatabase.isFollowing(flockContacts[j].userId)) {
            flockUsersContactsFollowingButtonPressed.add(true);
          } else{
            flockUsersContactsFollowingButtonPressed.add(false);
          }
        }
      }
    }
    contacts.removeWhere((element) => flockUsersContacts.contains(element));
    setState(() {
    });
    print("******************************");
    print(flockUsersContacts);
//    print(contacts);
  }

  Future<void> getPermissions() async {
   // await InviteBox.clearContactDatabase();
    await InviteBox.getNonSavedPhoneNumbers(context);
    final userId = Provider.of<UserData>(context,listen:false).userId;
    await FollowingDatabase.fetchList(userId, context);
    _fetchContacts();
  }

  filterContacts() {
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);
    List<Contact> _flockUsersContacts = [];
    _flockUsersContacts.addAll(flockUsersContacts);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String contactName = contact.displayName.toLowerCase();
        return contactName.contains(searchTerm);
      });
      _flockUsersContacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String contactName = contact.displayName.toLowerCase();
        return contactName.contains(searchTerm);
      });
      setState(() {
        contactsFiltered = _contacts;
        flockContactsFiltered = _flockUsersContacts;
      });
      // for(int i=0;i<_flockUsersContacts.length;i++){
      //   String searchTerm = searchController.text.toLowerCase();
      //   String contact = _flockUsersContacts[i].displayName;
      //   String contactName = contact.toLowerCase();
      //   if(contactName.contains(searchTerm)){
      //     flockContactsFiltered.add(_flockUsersContacts[i]);
      //     flockUersContactsAvatarFiltered.add(flockUersContactsAvatar[i]);
      //     flockUsersContactsUserIdFiltered.add(flockUsersContactsUserId[i]);
      //   }
      // }
      // setState(() {
      //   contactsFiltered = _contacts;
      //   flockContactsFiltered = _flockUsersContacts;
      // });
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
                backgroundColor: MaterialStateProperty.all(Colors.redAccent),
              ),
              onPressed: () {
                Provider.of<UserData>(context, listen: false).newRegistration =
                    false;
              },
              child: Text(' Done '),
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
                onChanged: (val){
                  if(val=="")
                    setState(() {
                    });
                },
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: getPermissions,
                child:
                ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(
                        "Connect now",
                        style: TextStyle(
                            fontFamily: "Lato",
                            fontWeight: FontWeight.bold,
                            fontSize: size.width/20
                        ),
                      ),
                    ),
                    Container(
                      child: ListView.builder(
                          itemCount: isSearching ? flockContactsFiltered.length : flockUsersContacts.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            Contact contact =
                            isSearching ? flockContactsFiltered[index] : flockUsersContacts[index];
                            return contact.phones.length > 0
                                ? InkWell(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ProfilePage(userId: flockUsersContactsUserId[index],)));
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                    backgroundImage:
                                    NetworkImage(flockUersContactsAvatar[index])),
                                title: Text(
                                  contact.displayName,
                                  style: TextStyle(fontFamily: "Lato"),
                                ),
                                subtitle: Text(
                                  contact.phones.length > 0
                                      ? contact.phones.elementAt(0).value.replaceAll(' ', '')
                                      : '',
                                  style: TextStyle(fontFamily: "Lato"),
                                ),
                                trailing: flockUsersContactsFollowingButtonPressed[index]?
                                ButtonTheme(
                                  child: RaisedButton(
                                    onPressed: () async{
                                      setState(() {
                                        flockUsersContactsFollowingButtonPressed[index] = false;
                                      });

                                      final userId = Provider.of<UserData>(context,listen:false).userId;
                                      final authToken = Provider.of<UserData>(context,listen:false).authToken;
                                      final resp = (await Provider.of<DatabaseApiService>(context,listen: false).unfollow(userId: userId,
                                          foreignUserId: flockUsersContactsUserId[index], authorization: authToken));
                                      if(resp.isSuccessful){
                                        FollowingDatabase.deleteFollowing(flockUsersContactsUserId[index]);
                                      }
                                      else{
                                        setState(() {
                                          flockUsersContactsFollowingButtonPressed[index] = true;
                                        });
                                        Fluttertoast.showToast(msg: 'Something went wrong. Please try again');
                                      }

                                    },
                                    color: Colors.white,
                                    child: Text('Following',
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
                                ):
                                ButtonTheme(
                                  child: RaisedButton(
                                    onPressed: () async{
                                      setState(() {
                                        flockUsersContactsFollowingButtonPressed[index] = true;
                                      });
                                      final userId = Provider.of<UserData>(context,listen:false).userId;
                                      final authToken = Provider.of<UserData>(context,listen:false).authToken;
                                      final resp = (await Provider.of<DatabaseApiService>(context,listen: false).follow(userId: userId,
                                          foreignUserId: flockUsersContactsUserId[index], authorization: authToken));
                                      if(resp.isSuccessful){
                                        FollowingDatabase.addFollowing(flockUsersContactsUserId[index]);
                                      }
                                      else{
                                        setState(() {
                                          flockUsersContactsFollowingButtonPressed[index] = false;
                                        });
                                        Fluttertoast.showToast(msg: 'Something went wrong. Please try again');
                                      }
                                    },
                                    color: Colors.red,
                                    child: Text('Follow',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        )),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.red[600]),
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
                        "Invite your contacts",
                        style: TextStyle(
                            fontFamily: "Lato",
                            fontWeight: FontWeight.bold,
                            fontSize: size.width/20
                        ),
                      ),
                    ),
                    Container(
                      child: ListView.builder(
                          itemCount:
                          isSearching ? contactsFiltered.length : contacts.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
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
                                    ? contact.phones.elementAt(0).value.replaceAll(' ', '')
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
            ),
          ],
        ),
      ),
    );
  }
}
