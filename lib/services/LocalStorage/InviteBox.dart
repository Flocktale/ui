
import 'package:contacts_service/contacts_service.dart' as CONTACT;
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:built_collection/built_collection.dart';

class InviteBox {
  static Box contactBox;
  static Future<void> init() async {
    if (contactBox == null) contactBox = await Hive.openBox('following');
  }

  static Future<List<String>> getNonSavedPhoneNumbers(
      BuildContext context) async {
    await init();
    if (await Permission.contacts.request().isGranted) {
      List<CONTACT.Contact> _contacts = await fetchContactsFromPhone();
      List<String> phoneNumbers = [];
      _contacts.forEach((element) {
        element.phones.forEach((element) {
          String phoneNo = element.value;

          if (phoneNo[0] != '+') return;
          // print(phoneNo);
          // print(contactBox.get(phoneNo);
          if (contactBox.get(phoneNo) == null) {
            // print(phoneNo);
            phoneNumbers.add(phoneNo);
            // addContact(phoneNo);
          }
        });
      });

      // BuiltList([])
      // Map<String, BuiltList<String>> m = {'contacts': BuiltList(phoneNumbers)};
      BuiltContacts b =  BuiltContacts((b)=>b
      ..contacts = BuiltList<String>(phoneNumbers).toBuilder()
      );

    // print(b);

      final result =
          await Provider.of<DatabaseApiService>(context, listen: false).
          // syncContacts(contacts: BuiltList<String>(phoneNumbers));
          syncContactsByPost(body: b);
          
          
              // .body;
      // // print(object)

      // debugPrint('${result}');
      // // debugprint(result);
      // result.forEach((element) {
      //   print(element); 
      // });
    } else {
      Fluttertoast.showToast(
          msg:
              "Please give phone number permissions to invite people to club via contacts");
    }
  }

  static Future<List<CONTACT.Contact>> fetchContactsFromPhone() async {
    List<CONTACT.Contact> _contacts =
        (await CONTACT.ContactsService.getContacts(withThumbnails: false)).toList();
    return _contacts;
  }

  static List getData() {
    List res = [];
    contactBox.values.forEach((element) {
      res.add(element);
    });
    print(res);
    return res;
  }

  static void addContact(String phoneNo,String userId, String userAvatar) {
    Contact c = new Contact(userId,userAvatar,phoneNo);
    contactBox.put(phoneNo, c);
  }

  static void clearContactDatabase() {
    contactBox.clear();
  }
}
