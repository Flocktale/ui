import 'dart:convert';
import 'package:contacts_service/contacts_service.dart' as CONTACT;
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/Models/contacts.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:built_collection/built_collection.dart';

class InviteBox {
  static Box contactBox;
  static List<CONTACT.Contact> _contacts;
  static Future<void> init() async {
    if (contactBox == null) contactBox = await Hive.openBox('contacts');
  }

  static Future<bool> getUserConsentForContacts(BuildContext context) async {
    final contactPermission = await Permission.contacts.isGranted;

    if (contactPermission == true) return true;

    // show dialog box to let user know what we do with their contacts.
    final userConsent = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Allow Contacts Permission'),
        content: Text(
          'Flocktale will be able to use your contact list to search for your friends and others on Flocktale'
          '\n\nFlocktale does not save your contacts on its servers '
          'and does not share your contacts with others so that your privacy is maintained',
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final permission = await Permission.contacts.request().isGranted;
              Navigator.of(context).pop(permission);
            },
            child: Text('Ok'),
          ),
        ],
      ),
    );

    if (userConsent == true)
      return true;
    else
      return false;
  }

  static Future<bool> getNonSavedPhoneNumbers(BuildContext context) async {
    await init();

    if (await Permission.contacts.request().isGranted) {
      Map<String, String> phoneToName = {};
      _contacts = await fetchContactsFromPhone();
      List<String> phoneNumbers = [];
      int ind = -1;
      _contacts.forEach((element) {
        ind++;
        element.phones.forEach((element) {
          String phoneNo = element.value;

          if (phoneNo[0] != '+') return;
          phoneNo = phoneNo.replaceAll(' ', '');

          if (contactBox.get(phoneNo) == null) {
            phoneNumbers.add(phoneNo);
            phoneToName[phoneNo] = _contacts[ind].givenName;
          }
        });
      });

      BuiltContacts b = BuiltContacts(
          (b) => b..contacts = BuiltList<String>(phoneNumbers).toBuilder());

      final result =
          (await Provider.of<DatabaseApiService>(context, listen: false)
                  .syncContactsByPost(body: b))
              .body;

      result.forEach((element) {
        addContact(element.phone, element.userId, element.avatar,
            phoneToName[element.phone]);
      });

      return true;
    } else {
      Fluttertoast.showToast(
          msg:
              "Please give phone number permissions to invite people via contacts");
    }

    return false;
  }

  static Future<List<CONTACT.Contact>> fetchContactsFromPhone() async {
    List<CONTACT.Contact> _contacts =
        (await CONTACT.ContactsService.getContacts(withThumbnails: false))
            .toList();
    return _contacts;
  }

  static List<Contact> getData() {
    List<Contact> res = [];
    contactBox.values.forEach((element) {
      // print(element);
      res.add(Contact.fromJson(json.decode(element)));
      // print(element);
    });
    // print(res);
    return res;
  }

  static List<CONTACT.Contact> getContacts() {
    return _contacts;
  }

  static void addContact(
      String phoneNo, String userId, String userAvatar, String name) {
    Contact c = new Contact(userId, userAvatar, phoneNo, name);
    contactBox.put(phoneNo, c.toJson());
  }

  static void clearContactDatabase() async {
    await init();
    contactBox.clear();
  }
}
