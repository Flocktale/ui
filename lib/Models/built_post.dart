import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flocktale/Models/enums/audienceStatus.dart';
import 'package:flocktale/Models/enums/clubStatus.dart';
import 'package:flocktale/Models/enums/notificationType.dart';
import 'package:flocktale/services/chopper/serializers.dart';

import 'enums/communityUserType.dart';

part 'built_post.g.dart';

abstract class AgoraToken implements Built<AgoraToken, AgoraTokenBuilder> {
  // fields go here
  @nullable
  String get agoraToken;

  AgoraToken._();

  factory AgoraToken([updates(AgoraTokenBuilder b)]) = _$AgoraToken;

  String toJson() {
    return json.encode(serializers.serializeWith(AgoraToken.serializer, this));
  }

  static AgoraToken fromJson(String jsonString) {
    return serializers.deserializeWith(
        AgoraToken.serializer, json.decode(jsonString));
  }

  static Serializer<AgoraToken> get serializer => _$agoraTokenSerializer;
}

abstract class ClubContentModel
    implements Built<ClubContentModel, ClubContentModelBuilder> {
  // fields go here

  @nullable
  String get source;
  @nullable
  String get title;
  @nullable
  String get url;
  @nullable
  String get decription;
  @nullable
  String get avatar;

  @nullable
  int get timestamp;

  ClubContentModel._();

  factory ClubContentModel([updates(ClubContentModelBuilder b)]) =
      _$ClubContentModel;

  static ClubContentModel fromJson(String jsonString) {
    return serializers.deserializeWith(
        ClubContentModel.serializer, json.decode(jsonString));
  }

  static Serializer<ClubContentModel> get serializer =>
      _$clubContentModelSerializer;
}

abstract class BuiltCommunityAndUser
    implements Built<BuiltCommunityAndUser, BuiltCommunityAndUserBuilder> {
  // fields go here
  @nullable
  BuiltCommunity get community;

  @nullable
  BuiltCommunityUser get communityUser;

  BuiltCommunityAndUser._();

  factory BuiltCommunityAndUser([updates(BuiltCommunityAndUserBuilder b)]) =
      _$BuiltCommunityAndUser;

  static Serializer<BuiltCommunityAndUser> get serializer =>
      _$builtCommunityAndUserSerializer;
}

abstract class CommunityImageUploadBody
    implements
        Built<CommunityImageUploadBody, CommunityImageUploadBodyBuilder> {
  // fields go here

  @nullable
  String get avatar;

  @nullable
  String get coverImage;

  CommunityImageUploadBody._();

  factory CommunityImageUploadBody(
          [updates(CommunityImageUploadBodyBuilder b)]) =
      _$CommunityImageUploadBody;

  static Serializer<CommunityImageUploadBody> get serializer =>
      _$communityImageUploadBodySerializer;
}

abstract class BuiltCommunityList
    implements Built<BuiltCommunityList, BuiltCommunityListBuilder> {
  // fields go here

  @nullable
  BuiltList<BuiltCommunity> get communities;

  @nullable
  String get lastevaluatedkey;

  BuiltCommunityList._();

  factory BuiltCommunityList([updates(BuiltCommunityListBuilder b)]) =
      _$BuiltCommunityList;

  static Serializer<BuiltCommunityList> get serializer =>
      _$builtCommunityListSerializer;
}

abstract class BuiltCommunityUser
    implements Built<BuiltCommunityUser, BuiltCommunityUserBuilder> {
  // fields go here

  @nullable
  BuiltCommunity get community;

  @nullable
  SummaryUser get user;

  @nullable
  CommunityUserType get type;

  @nullable
  int get timestamp;

  @nullable
  bool get invited;

  BuiltCommunityUser._();

  factory BuiltCommunityUser([updates(BuiltCommunityUserBuilder b)]) =
      _$BuiltCommunityUser;

  static Serializer<BuiltCommunityUser> get serializer =>
      _$builtCommunityUserSerializer;
}

abstract class BuiltCommunity
    implements Built<BuiltCommunity, BuiltCommunityBuilder> {
  // fields go here

  @nullable
  String get communityId;

  @nullable
  String get name;

  @nullable
  String get description;

  @nullable
  String get avatar;

  @nullable
  String get coverImage;

  @nullable
  SummaryUser get creator;

  @nullable
  BuiltSet<String> get hosts;

  @nullable
  int get liveClubCount;

  @nullable
  int get scheduledClubCount;

  @nullable
  int get memberCount;

  BuiltCommunity._();

  factory BuiltCommunity([updates(BuiltCommunityBuilder b)]) = _$BuiltCommunity;

  static Serializer<BuiltCommunity> get serializer =>
      _$builtCommunitySerializer;
}

abstract class AppConfigs implements Built<AppConfigs, AppConfigsBuilder> {
  // fields go here

  @nullable
  String get minAppVersion;

  AppConfigs._();

  factory AppConfigs([updates(AppConfigsBuilder b)]) = _$AppConfigs;

  static Serializer<AppConfigs> get serializer => _$appConfigsSerializer;
}

abstract class UsernameAvailability
    implements Built<UsernameAvailability, UsernameAvailabilityBuilder> {
  // fields go here

  @nullable
  bool get isAvailable;

  UsernameAvailability._();

  factory UsernameAvailability([updates(UsernameAvailabilityBuilder b)]) =
      _$UsernameAvailability;

  static Serializer<UsernameAvailability> get serializer =>
      _$usernameAvailabilitySerializer;
}

abstract class BuiltAudienceList
    implements Built<BuiltAudienceList, BuiltAudienceListBuilder> {
  @nullable
  BuiltList<AudienceData> get audience;

  @nullable
  String get lastevaluatedkey;

  BuiltAudienceList._();

  factory BuiltAudienceList([updates(BuiltAudienceListBuilder b)]) =
      _$BuiltAudienceList;

  static Serializer<BuiltAudienceList> get serializer =>
      _$builtAudienceListSerializer;
}

abstract class RelationActionResponse
    implements Built<RelationActionResponse, RelationActionResponseBuilder> {
  @nullable
  RelationIndexObject get relationIndexObj;

  @nullable
  int get friendsCount;

  @nullable
  int get followerCount;

  @nullable
  int get followingCount;

  RelationActionResponse._();

  factory RelationActionResponse([updates(RelationActionResponseBuilder b)]) =
      _$RelationActionResponse;

  static Serializer<RelationActionResponse> get serializer =>
      _$relationActionResponseSerializer;
}

abstract class NotificationData
    implements Built<NotificationData, NotificationDataBuilder> {
  @nullable
  NotificationType get type;
  @nullable
  String get title;
  @nullable
  String get avatar;
  @nullable
  int get timestamp;
  @nullable
  String get targetResourceId;
  @nullable
  String get notificationId;
  @nullable
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

abstract class BuiltClubAndAudience
    implements Built<BuiltClubAndAudience, BuiltClubAndAudienceBuilder> {
  // fields go here
  @nullable
  BuiltClub get club;

  @nullable
  AudienceData get audienceData;

  @nullable
  int get reactionIndexValue;
  BuiltClubAndAudience._();

  factory BuiltClubAndAudience([updates(BuiltClubAndAudienceBuilder b)]) =
      _$BuiltClubAndAudience;

  String toJson() {
    return json.encode(
        serializers.serializeWith(BuiltClubAndAudience.serializer, this));
  }

  static BuiltClubAndAudience fromJson(String jsonString) {
    return serializers.deserializeWith(
        BuiltClubAndAudience.serializer, json.decode(jsonString));
  }

  static Serializer<BuiltClubAndAudience> get serializer =>
      _$builtClubAndAudienceSerializer;
}

abstract class AudienceData
    implements Built<AudienceData, AudienceDataBuilder> {
  // fields go here
  @nullable
  AudienceStatus get status;

  @nullable
  bool get isMuted;

  @nullable
  int get joinRequestAttempts;

  SummaryUser get audience;

  @nullable
  String get invitationId;

  @nullable
  int get timestamp;

  AudienceData._();

  factory AudienceData([updates(AudienceDataBuilder b)]) = _$AudienceData;

  String toJson() {
    return json
        .encode(serializers.serializeWith(AudienceData.serializer, this));
  }

  static AudienceData fromJson(String jsonString) {
    return serializers.deserializeWith(
        AudienceData.serializer, json.decode(jsonString));
  }

  static Serializer<AudienceData> get serializer => _$audienceDataSerializer;
}

abstract class BuiltClub implements Built<BuiltClub, BuiltClubBuilder> {
  @nullable
  String get clubId;

  @nullable
  String get clubName;

  @nullable
  SummaryUser get creator;

  @nullable
  ClubStatus get status;

  @nullable
  String get category;

  @nullable
  String get subCategory;

  @nullable
  BuiltCommunity get community;

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
  String get externalUrl;

  @nullable
  bool get isLocal;

  @nullable
  bool get isGlobal;

  @nullable
  bool get isPrivate;

  @nullable
  BuiltList<String> get tags;

  @nullable
  int get estimatedAudience;

  @nullable
  BuiltSet<String> get participants;

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

  @nullable
  String get phone;

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
  @nullable
  int get joinRequestAttempts;
  @nullable
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
  String get userlastevaluatedkey;

  @nullable
  BuiltList<BuiltClub> get clubs;
  @nullable
  String get clublastevaluatedkey;

  @nullable
  BuiltList<BuiltCommunity> get communities;
  @nullable
  String get communitylastevaluatedkey;

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

abstract class BuiltInviteFormat
    implements Built<BuiltInviteFormat, BuiltInviteFormatBuilder> {
  // fields go here

  @nullable
  String get type;
  @nullable
  BuiltList<String> get invitee;

  BuiltInviteFormat._();

  factory BuiltInviteFormat([updates(BuiltInviteFormatBuilder b)]) =
      _$BuiltInviteFormat;

  String toJson() {
    return json
        .encode(serializers.serializeWith(BuiltInviteFormat.serializer, this));
  }

  static BuiltInviteFormat fromJson(String jsonString) {
    return serializers.deserializeWith(
        BuiltInviteFormat.serializer, json.decode(jsonString));
  }

  static Serializer<BuiltInviteFormat> get serializer =>
      _$builtInviteFormatSerializer;
}

abstract class BuiltContacts
    implements Built<BuiltContacts, BuiltContactsBuilder> {
  // fields go here
  @nullable
  BuiltList<String> get contacts;

  BuiltContacts._();

  factory BuiltContacts([updates(BuiltContactsBuilder b)]) = _$BuiltContacts;

  static Serializer<BuiltContacts> get serializer => _$builtContactsSerializer;
}
