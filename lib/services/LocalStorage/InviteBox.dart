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

  static Future<List<String>> getNonSavedPhoneNumbers(
      BuildContext context) async {
    await init();
    if (await Permission.contacts.request().isGranted) {
       _contacts = await fetchContactsFromPhone();
      List<String> phoneNumbers = [];
      _contacts.forEach((element) {
        element.phones.forEach((element) {
          String phoneNo = element.value;

          if (phoneNo[0] != '+') return;
          phoneNo = phoneNo.replaceAll(' ', '');

          if (contactBox.get(phoneNo) == null) {
            phoneNumbers.add(phoneNo);
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
        addContact(element.phone, element.userId, element.avatar);
      });
    } else {
      Fluttertoast.showToast(
          msg:
              "Please give phone number permissions to invite people to club via contacts");
    }
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
      print(element);
      res.add(Contact.fromJson(json.decode(element)));
      // print(element);
    });
    print(res);
    return res;
  }

  static List<CONTACT.Contact> getContacts(){
    return _contacts;
  }

  static void addContact(String phoneNo, String userId, String userAvatar) {
    Contact c = new Contact(userId, userAvatar, phoneNo);
    contactBox.put(phoneNo, c.toJson());
  }

  static void clearContactDatabase() async{
    await init();
    contactBox.clear();
  }
}
