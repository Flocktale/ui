import 'package:contacts_service/contacts_service.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/services/LocalStorage/InviteBox.dart';
import 'package:flocktale/services/shareApp.dart';
import 'package:flutter/material.dart';

class InviteContacts extends StatefulWidget {
  final BuiltClub club;

  final bool forPanelist;
  const InviteContacts({@required this.club, this.forPanelist = false});

  @override
  _InviteContactsState createState() => _InviteContactsState();
}

class _InviteContactsState extends State<InviteContacts>
    with AutomaticKeepAliveClientMixin {
  List<Contact> contacts = [];

  bool userConsent = true;

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

  _fetchContacts() async {
    userConsent = await InviteBox.getUserConsentForContacts(context);

    if (userConsent) {
      contacts = (await InviteBox.fetchContactsFromPhone());
      print("1212121212121212121212121212");
      print(contacts);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (userConsent == false) {
      return Center(
        child: Text(
          'Need contacts permission',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.redAccent),
        ),
      );
    }
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

  @override
  bool get wantKeepAlive => true;
}
