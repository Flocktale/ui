import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:mootclub_app/services/chopper/serializers.dart';

part 'built_post.g.dart';

abstract class NotificationData
    implements Built<NotificationData, NotificationDataBuilder> {
  String get type;
  String get title;
  String get avatar;
  int get timestamp;
  String get targetResourceId;

  bool get opened;

  @nullable
  String get secondaryAvatar;

  NotificationData._();

  factory NotificationData([updates(NotificationDataBuilder b)]) =
      _$NotificationData;

  static Serializer<NotificationData> get serializer =>
      _$notificationDataSerializer;
}

abstract class BuiltNotificationList
    implements Built<BuiltNotificationList, BuiltNotificationListBuilder> {
  @nullable
  BuiltList<NotificationData> get notifications;

  @nullable
  String get lastevaluatedkey;

  BuiltNotificationList._();

  factory BuiltNotificationList([updates(BuiltNotificationListBuilder b)]) =
      _$BuiltNotificationList;

  static Serializer<BuiltNotificationList> get serializer =>
      _$builtNotificationListSerializer;
}

abstract class BuiltFCMToken
    implements Built<BuiltFCMToken, BuiltFCMTokenBuilder> {
  @nullable
  String get deviceToken;

  BuiltFCMToken._();

  factory BuiltFCMToken([updates(BuiltFCMTokenBuilder b)]) = _$BuiltFCMToken;

  static Serializer<BuiltFCMToken> get serializer => _$builtFCMTokenSerializer;
}

abstract class RelationIndexObject
    implements Built<RelationIndexObject, RelationIndexObjectBuilder> {
  bool get B1;
  bool get B2;
  bool get B3;
  bool get B4;
  bool get B5;

  RelationIndexObject._();

  factory RelationIndexObject([updates(RelationIndexObjectBuilder b)]) =
      _$RelationIndexObject;

  static Serializer<RelationIndexObject> get serializer =>
      _$relationIndexObjectSerializer;
}

abstract class BuiltProfile
    implements Built<BuiltProfile, BuiltProfileBuilder> {
  BuiltUser get user;

  @nullable
  RelationIndexObject get relationIndexObj;

  BuiltProfile._();

  factory BuiltProfile([updates(BuiltProfileBuilder b)]) = _$BuiltProfile;

  static Serializer<BuiltProfile> get serializer => _$builtProfileSerializer;
}

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
  String get tagline;

  @nullable
  int get online; // this field is, "0" when user is online and represent timestamp when user is offline.

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

  @nullable
  String get agoraToken;

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

  @nullable
  String get tagline;

  @nullable
  int get online; // this field is, "0" when user is online and represent timestamp when user is offline.

  SummaryUser._();

  factory SummaryUser([updates(SummaryUserBuilder b)]) = _$SummaryUser;
  static Serializer<SummaryUser> get serializer => _$summaryUserSerializer;
}

abstract class BuiltSearchUsers
    implements Built<BuiltSearchUsers, BuiltSearchUsersBuilder> {
  // fields go here

  @nullable
  BuiltList<SummaryUser> get users;
  @nullable
  String get lastevaluatedkey;
  BuiltSearchUsers._();

  factory BuiltSearchUsers([updates(BuiltSearchUsersBuilder b)]) =
      _$BuiltSearchUsers;
  static Serializer<BuiltSearchUsers> get serializer =>
      _$builtSearchUsersSerializer;
}

abstract class BuiltSearchClubs
    implements Built<BuiltSearchClubs, BuiltSearchClubsBuilder> {
  // fields go here
  @nullable
  BuiltList<BuiltClub> get clubs;
  @nullable
  String get lastevaluatedkey;

  BuiltSearchClubs._();

  factory BuiltSearchClubs([updates(BuiltSearchClubsBuilder b)]) =
      _$BuiltSearchClubs;

  static Serializer<BuiltSearchClubs> get serializer =>
      _$builtSearchClubsSerializer;
}

abstract class CategoryClubsList
    implements Built<CategoryClubsList, CategoryClubsListBuilder> {
  // fields go here
  @nullable
  String get category;

  @nullable
  BuiltList<BuiltClub> get clubs;
  CategoryClubsList._();

  factory CategoryClubsList([updates(CategoryClubsListBuilder b)]) =
      _$CategoryClubsList;

  static Serializer<CategoryClubsList> get serializer =>
      _$categoryClubsListSerializer;
}

abstract class BuiltAllClubsList
    implements Built<BuiltAllClubsList, BuiltAllClubsListBuilder> {
  // fields go here

  @nullable
  BuiltList<CategoryClubsList> get categoryClubs;

  BuiltAllClubsList._();

  factory BuiltAllClubsList([updates(BuiltAllClubsListBuilder b)]) =
      _$BuiltAllClubsList;

  static Serializer<BuiltAllClubsList> get serializer =>
      _$builtAllClubsListSerializer;
}

abstract class ReactionUser
    implements Built<ReactionUser, ReactionUserBuilder> {
  // fields go here

  SummaryUser get user;
  int get timestamp;
  int get indexValue;

  ReactionUser._();

  factory ReactionUser([updates(ReactionUserBuilder b)]) = _$ReactionUser;

  static Serializer<ReactionUser> get serializer => _$reactionUserSerializer;
}

abstract class BuiltReaction
    implements Built<BuiltReaction, BuiltReactionBuilder> {
  // fields go here

  BuiltList<ReactionUser> get reactions;
  @nullable
  String get lastevaluatedkey;

  BuiltReaction._();

  factory BuiltReaction([updates(BuiltReactionBuilder b)]) = _$BuiltReaction;
  static Serializer<BuiltReaction> get serializer => _$builtReactionSerializer;
}

abstract class ReportSummary
    implements Built<ReportSummary, ReportSummaryBuilder> {
  // fields go here

  String get body;
  ReportSummary._();

  factory ReportSummary([updates(ReportSummaryBuilder b)]) = _$ReportSummary;

  static Serializer<ReportSummary> get serializer => _$reportSummarySerializer;
}

abstract class JoinRequests
    implements Built<JoinRequests, JoinRequestsBuilder> {
  // fields go here

  int get joinRequestAttempts;
  int get timestamp;
  SummaryUser get audience;
  // BuiltList<SummaryUser> get audience;

  JoinRequests._();

  factory JoinRequests([updates(JoinRequestsBuilder b)]) = _$JoinRequests;

  static Serializer<JoinRequests> get serializer => _$joinRequestsSerializer;
}

abstract class BuiltActiveJoinRequests
    implements Built<BuiltActiveJoinRequests, BuiltActiveJoinRequestsBuilder> {
  // fields go here

  @nullable
  BuiltList<JoinRequests> get activeJoinRequestUsers;

  @nullable
  String get lastevaluatedkey;
  BuiltActiveJoinRequests._();

  factory BuiltActiveJoinRequests([updates(BuiltActiveJoinRequestsBuilder b)]) =
      _$BuiltActiveJoinRequests;

  String toJson() {
    return json.encode(
        serializers.serializeWith(BuiltActiveJoinRequests.serializer, this));
  }

  static Serializer<BuiltActiveJoinRequests> get serializer =>
      _$builtActiveJoinRequestsSerializer;
}

abstract class BuiltUnifiedSearchResults
    implements
        Built<BuiltUnifiedSearchResults, BuiltUnifiedSearchResultsBuilder> {
  // fields go here

  @nullable
  BuiltList<SummaryUser> get users;

  @nullable
  BuiltList<BuiltClub> get clubs;

  BuiltUnifiedSearchResults._();

  factory BuiltUnifiedSearchResults(
          [updates(BuiltUnifiedSearchResultsBuilder b)]) =
      _$BuiltUnifiedSearchResults;

  String toJson() {
    return json.encode(
        serializers.serializeWith(BuiltUnifiedSearchResults.serializer, this));
  }

  static Serializer<BuiltUnifiedSearchResults> get serializer =>
      _$builtUnifiedSearchResultsSerializer;
}


abstract class BuiltInviteFormat implements Built<BuiltInviteFormat, BuiltInviteFormatBuilder> {
  // fields go here

  @nullable
  BuiltList<String> get invitee;
  @nullable
  BuiltList<String> get type;

  BuiltInviteFormat._();

  factory BuiltInviteFormat([updates(BuiltInviteFormatBuilder b)]) = _$BuiltInviteFormat;

  String toJson() {
    return json.encode(serializers.serializeWith(BuiltInviteFormat.serializer, this));
  }

  static BuiltInviteFormat fromJson(String jsonString) {
    return serializers.deserializeWith(BuiltInviteFormat.serializer, json.decode(jsonString));
  }

  static Serializer<BuiltInviteFormat> get serializer => _$builtInviteFormatSerializer;
}