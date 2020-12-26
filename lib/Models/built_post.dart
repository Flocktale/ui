import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:mootclub_app/services/chopper/serializers.dart';

part 'built_post.g.dart';

abstract class BuiltUser implements Built<BuiltUser, BuiltUserBuilder> {
  @nullable
  String get userId;

  @nullable
  String get username;

  @nullable
  String get name;

  @nullable
  String get email;

  @nullable
  String get phone;

  @nullable
  String get avatar;

  @nullable
  String get bio;

  @nullable
  int get friendsCount;

  @nullable
  int get followerCount;

  @nullable
  int get followingCount;

  @nullable
  String get languagePreference;

  @nullable
  String get regionCode;

  @nullable
  double get geoLat;

  @nullable
  double get geoLong;

  @nullable
  bool get isBlackListed;

  @nullable
  bool get termsAccepted;

  @nullable
  bool get policyAccepted;


  @nullable
  int get clubsCreated;

  @nullable
  int get clubsParticipated;

  @nullable
  int get kickedOutCount;
  
  @nullable
  int get clubsJoinRequests;
  
  @nullable
  int get clubsAttended;
  

  BuiltUser._();

  factory BuiltUser([updates(BuiltUserBuilder b)]) = _$BuiltUser;

  static Serializer<BuiltUser> get serializer => _$builtUserSerializer;
}

abstract class BuiltProfileImage
    implements Built<BuiltProfileImage, BuiltProfileImageBuilder> {
  @nullable
  String get image;

  BuiltProfileImage._();

  factory BuiltProfileImage([updates(BuiltProfileImageBuilder b)]) =
      _$BuiltProfileImage;

  static Serializer<BuiltProfileImage> get serializer =>
      _$builtProfileImageSerializer;
}

abstract class BuiltFollow implements Built<BuiltFollow, BuiltFollowBuilder> {
  @nullable
  String get username;
  @nullable
  String get followername;
  @nullable
  String get userImageUrl;
  @nullable
  String get followerImageUrl;
  @nullable
  String get name;
  @nullable
  String get followerName;

  BuiltFollow._();

  factory BuiltFollow([updates(BuiltFollowBuilder b)]) = _$BuiltFollow;

  static Serializer<BuiltFollow> get serializer => _$builtFollowSerializer;
}

abstract class BuiltClub implements Built<BuiltClub, BuiltClubBuilder> {
  @nullable
  String get clubId;

  @nullable
  String get clubName;

  @nullable
  SummaryUser get creator;

  @nullable
  int get timeWindow;

  @nullable 
  String get category;

  @nullable 
  int get createdOn;

  @nullable 
  int get modifiedOn;

  @nullable
  int get scheduleTime;

  @nullable
  String get clubAvatar;

  @nullable
  String get description;

  @nullable 
  bool get isLocal;

  @nullable
  bool get isGlobal;

  @nullable
  bool get isPrivate;

  @nullable
  BuiltList<String> get tags;


  BuiltClub._();

  factory BuiltClub([updates(BuiltClubBuilder b)]) = _$BuiltClub;

  static Serializer<BuiltClub> get serializer => _$builtClubSerializer;
}



abstract class SummaryUser implements Built<SummaryUser, SummaryUserBuilder> {

  @nullable
  String get userId;

  @nullable
  String get username;

  @nullable
  String get name;

  @nullable
  String get avatar;
  
  SummaryUser._();

  factory SummaryUser([updates(SummaryUserBuilder b)]) = _$SummaryUser;
  static Serializer<SummaryUser> get serializer => _$summaryUserSerializer;
}

abstract class BuiltSearchUsers implements Built<BuiltSearchUsers, BuiltSearchUsersBuilder> {
  // fields go here


  @nullable
  BuiltList<SummaryUser> get users;
  @nullable
  String get lastevaluatedkey;
  BuiltSearchUsers._();

  factory BuiltSearchUsers([updates(BuiltSearchUsersBuilder b)]) = _$BuiltSearchUsers;
  static Serializer<BuiltSearchUsers> get serializer => _$builtSearchUsersSerializer; 

}


abstract class BuiltSearchClubs implements Built<BuiltSearchClubs, BuiltSearchClubsBuilder> {
  // fields go here
  @nullable
  BuiltList<BuiltClub> get clubs;
  @nullable
  String get lastevaluatedkey;


  BuiltSearchClubs._();

  factory BuiltSearchClubs([updates(BuiltSearchClubsBuilder b)]) = _$BuiltSearchClubs;

  
  static Serializer<BuiltSearchClubs> get serializer => _$builtSearchClubsSerializer;
}


abstract class CategoryClubsList implements Built<CategoryClubsList, CategoryClubsListBuilder> {
  // fields go here
 @nullable
  String get category;

  @nullable
  BuiltList<BuiltClub> get clubs;
  CategoryClubsList._();

  factory CategoryClubsList([updates(CategoryClubsListBuilder b)]) = _$CategoryClubsList;

 
  static Serializer<CategoryClubsList> get serializer => _$categoryClubsListSerializer;
}

abstract class BuiltAllClubsList implements Built<BuiltAllClubsList, BuiltAllClubsListBuilder> {
  // fields go here

  @nullable
  BuiltList<CategoryClubsList> get categoryClubs;

  BuiltAllClubsList._();

  factory BuiltAllClubsList([updates(BuiltAllClubsListBuilder b)]) = _$BuiltAllClubsList;

 

  static Serializer<BuiltAllClubsList> get serializer => _$builtAllClubsListSerializer;
}