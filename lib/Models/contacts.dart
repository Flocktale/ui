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

  @HiveField(3)
  final String name;
  
  dynamic toJson(){
    Map<String,String> m = {};
    m['phoneNo'] = phoneNo;
    m['userId'] = userId;
    m['userAvatar'] = userAvatar;
    m['name'] = name;
    return json.encode(m);
  }

  Contact.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        userAvatar = json['userAvatar'],
        phoneNo = json['phoneNo'],
        name = json['name'];

  Contact(this.userId,this.userAvatar,this.phoneNo,this.name);
}
