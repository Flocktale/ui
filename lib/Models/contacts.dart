import 'package:hive/hive.dart';
import 'dart:convert';


@HiveType()
class Contact {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String userAvatar;

  @HiveField(2)
  final String phoneNo;

  
  dynamic toJson(){
    Map<String,String> m = {};
    m['phoneNo'] = phoneNo;
    m['userid'] = userId;
    m['userAvatar'] = userAvatar;
    return json.encode(m);
  }

  Contact.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        userAvatar = json['userAvatar'],
        phoneNo = json['phoneNo'];

  Contact(this.userId,this.userAvatar,this.phoneNo);
}
