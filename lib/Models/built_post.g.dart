// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'built_post.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AgoraToken> _$agoraTokenSerializer = new _$AgoraTokenSerializer();
Serializer<ClubContentModel> _$clubContentModelSerializer =
    new _$ClubContentModelSerializer();
Serializer<BuiltCommunityAndUser> _$builtCommunityAndUserSerializer =
    new _$BuiltCommunityAndUserSerializer();
Serializer<CommunityImageUploadBody> _$communityImageUploadBodySerializer =
    new _$CommunityImageUploadBodySerializer();
Serializer<BuiltCommunityList> _$builtCommunityListSerializer =
    new _$BuiltCommunityListSerializer();
Serializer<BuiltCommunityUser> _$builtCommunityUserSerializer =
    new _$BuiltCommunityUserSerializer();
Serializer<BuiltCommunity> _$builtCommunitySerializer =
    new _$BuiltCommunitySerializer();
Serializer<AppConfigs> _$appConfigsSerializer = new _$AppConfigsSerializer();
Serializer<UsernameAvailability> _$usernameAvailabilitySerializer =
    new _$UsernameAvailabilitySerializer();
Serializer<BuiltAudienceList> _$builtAudienceListSerializer =
    new _$BuiltAudienceListSerializer();
Serializer<RelationActionResponse> _$relationActionResponseSerializer =
    new _$RelationActionResponseSerializer();
Serializer<NotificationData> _$notificationDataSerializer =
    new _$NotificationDataSerializer();
Serializer<BuiltNotificationList> _$builtNotificationListSerializer =
    new _$BuiltNotificationListSerializer();
Serializer<BuiltFCMToken> _$builtFCMTokenSerializer =
    new _$BuiltFCMTokenSerializer();
Serializer<RelationIndexObject> _$relationIndexObjectSerializer =
    new _$RelationIndexObjectSerializer();
Serializer<BuiltProfile> _$builtProfileSerializer =
    new _$BuiltProfileSerializer();
Serializer<BuiltUser> _$builtUserSerializer = new _$BuiltUserSerializer();
Serializer<BuiltProfileImage> _$builtProfileImageSerializer =
    new _$BuiltProfileImageSerializer();
Serializer<BuiltFollow> _$builtFollowSerializer = new _$BuiltFollowSerializer();
Serializer<BuiltClubAndAudience> _$builtClubAndAudienceSerializer =
    new _$BuiltClubAndAudienceSerializer();
Serializer<AudienceData> _$audienceDataSerializer =
    new _$AudienceDataSerializer();
Serializer<BuiltClub> _$builtClubSerializer = new _$BuiltClubSerializer();
Serializer<SummaryUser> _$summaryUserSerializer = new _$SummaryUserSerializer();
Serializer<BuiltSearchUsers> _$builtSearchUsersSerializer =
    new _$BuiltSearchUsersSerializer();
Serializer<BuiltSearchClubs> _$builtSearchClubsSerializer =
    new _$BuiltSearchClubsSerializer();
Serializer<CategoryClubsList> _$categoryClubsListSerializer =
    new _$CategoryClubsListSerializer();
Serializer<BuiltAllClubsList> _$builtAllClubsListSerializer =
    new _$BuiltAllClubsListSerializer();
Serializer<ReactionUser> _$reactionUserSerializer =
    new _$ReactionUserSerializer();
Serializer<BuiltReaction> _$builtReactionSerializer =
    new _$BuiltReactionSerializer();
Serializer<ReportSummary> _$reportSummarySerializer =
    new _$ReportSummarySerializer();
Serializer<JoinRequests> _$joinRequestsSerializer =
    new _$JoinRequestsSerializer();
Serializer<BuiltActiveJoinRequests> _$builtActiveJoinRequestsSerializer =
    new _$BuiltActiveJoinRequestsSerializer();
Serializer<BuiltUnifiedSearchResults> _$builtUnifiedSearchResultsSerializer =
    new _$BuiltUnifiedSearchResultsSerializer();
Serializer<BuiltInviteFormat> _$builtInviteFormatSerializer =
    new _$BuiltInviteFormatSerializer();
Serializer<BuiltContacts> _$builtContactsSerializer =
    new _$BuiltContactsSerializer();

class _$AgoraTokenSerializer implements StructuredSerializer<AgoraToken> {
  @override
  final Iterable<Type> types = const [AgoraToken, _$AgoraToken];
  @override
  final String wireName = 'AgoraToken';

  @override
  Iterable<Object> serialize(Serializers serializers, AgoraToken object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.agoraToken != null) {
      result
        ..add('agoraToken')
        ..add(serializers.serialize(object.agoraToken,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  AgoraToken deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AgoraTokenBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'agoraToken':
          result.agoraToken = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ClubContentModelSerializer
    implements StructuredSerializer<ClubContentModel> {
  @override
  final Iterable<Type> types = const [ClubContentModel, _$ClubContentModel];
  @override
  final String wireName = 'ClubContentModel';

  @override
  Iterable<Object> serialize(Serializers serializers, ClubContentModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.source != null) {
      result
        ..add('source')
        ..add(serializers.serialize(object.source,
            specifiedType: const FullType(String)));
    }
    if (object.title != null) {
      result
        ..add('title')
        ..add(serializers.serialize(object.title,
            specifiedType: const FullType(String)));
    }
    if (object.url != null) {
      result
        ..add('url')
        ..add(serializers.serialize(object.url,
            specifiedType: const FullType(String)));
    }
    if (object.decription != null) {
      result
        ..add('decription')
        ..add(serializers.serialize(object.decription,
            specifiedType: const FullType(String)));
    }
    if (object.avatar != null) {
      result
        ..add('avatar')
        ..add(serializers.serialize(object.avatar,
            specifiedType: const FullType(String)));
    }
    if (object.timestamp != null) {
      result
        ..add('timestamp')
        ..add(serializers.serialize(object.timestamp,
            specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  ClubContentModel deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ClubContentModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'source':
          result.source = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'url':
          result.url = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'decription':
          result.decription = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'avatar':
          result.avatar = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'timestamp':
          result.timestamp = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$BuiltCommunityAndUserSerializer
    implements StructuredSerializer<BuiltCommunityAndUser> {
  @override
  final Iterable<Type> types = const [
    BuiltCommunityAndUser,
    _$BuiltCommunityAndUser
  ];
  @override
  final String wireName = 'BuiltCommunityAndUser';

  @override
  Iterable<Object> serialize(
      Serializers serializers, BuiltCommunityAndUser object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.community != null) {
      result
        ..add('community')
        ..add(serializers.serialize(object.community,
            specifiedType: const FullType(BuiltCommunity)));
    }
    if (object.communityUser != null) {
      result
        ..add('communityUser')
        ..add(serializers.serialize(object.communityUser,
            specifiedType: const FullType(BuiltCommunityUser)));
    }
    return result;
  }

  @override
  BuiltCommunityAndUser deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuiltCommunityAndUserBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'community':
          result.community.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltCommunity)) as BuiltCommunity);
          break;
        case 'communityUser':
          result.communityUser.replace(serializers.deserialize(value,
                  specifiedType: const FullType(BuiltCommunityUser))
              as BuiltCommunityUser);
          break;
      }
    }

    return result.build();
  }
}

class _$CommunityImageUploadBodySerializer
    implements StructuredSerializer<CommunityImageUploadBody> {
  @override
  final Iterable<Type> types = const [
    CommunityImageUploadBody,
    _$CommunityImageUploadBody
  ];
  @override
  final String wireName = 'CommunityImageUploadBody';

  @override
  Iterable<Object> serialize(
      Serializers serializers, CommunityImageUploadBody object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.avatar != null) {
      result
        ..add('avatar')
        ..add(serializers.serialize(object.avatar,
            specifiedType: const FullType(String)));
    }
    if (object.coverImage != null) {
      result
        ..add('coverImage')
        ..add(serializers.serialize(object.coverImage,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  CommunityImageUploadBody deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CommunityImageUploadBodyBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'avatar':
          result.avatar = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'coverImage':
          result.coverImage = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$BuiltCommunityListSerializer
    implements StructuredSerializer<BuiltCommunityList> {
  @override
  final Iterable<Type> types = const [BuiltCommunityList, _$BuiltCommunityList];
  @override
  final String wireName = 'BuiltCommunityList';

  @override
  Iterable<Object> serialize(Serializers serializers, BuiltCommunityList object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.communities != null) {
      result
        ..add('communities')
        ..add(serializers.serialize(object.communities,
            specifiedType: const FullType(
                BuiltList, const [const FullType(BuiltCommunity)])));
    }
    if (object.lastevaluatedkey != null) {
      result
        ..add('lastevaluatedkey')
        ..add(serializers.serialize(object.lastevaluatedkey,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  BuiltCommunityList deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuiltCommunityListBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'communities':
          result.communities.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(BuiltCommunity)]))
              as BuiltList<Object>);
          break;
        case 'lastevaluatedkey':
          result.lastevaluatedkey = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$BuiltCommunityUserSerializer
    implements StructuredSerializer<BuiltCommunityUser> {
  @override
  final Iterable<Type> types = const [BuiltCommunityUser, _$BuiltCommunityUser];
  @override
  final String wireName = 'BuiltCommunityUser';

  @override
  Iterable<Object> serialize(Serializers serializers, BuiltCommunityUser object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.community != null) {
      result
        ..add('community')
        ..add(serializers.serialize(object.community,
            specifiedType: const FullType(BuiltCommunity)));
    }
    if (object.user != null) {
      result
        ..add('user')
        ..add(serializers.serialize(object.user,
            specifiedType: const FullType(SummaryUser)));
    }
    if (object.type != null) {
      result
        ..add('type')
        ..add(serializers.serialize(object.type,
            specifiedType: const FullType(CommunityUserType)));
    }
    if (object.timestamp != null) {
      result
        ..add('timestamp')
        ..add(serializers.serialize(object.timestamp,
            specifiedType: const FullType(int)));
    }
    if (object.invited != null) {
      result
        ..add('invited')
        ..add(serializers.serialize(object.invited,
            specifiedType: const FullType(bool)));
    }
    return result;
  }

  @override
  BuiltCommunityUser deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuiltCommunityUserBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'community':
          result.community.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltCommunity)) as BuiltCommunity);
          break;
        case 'user':
          result.user.replace(serializers.deserialize(value,
              specifiedType: const FullType(SummaryUser)) as SummaryUser);
          break;
        case 'type':
          result.type = serializers.deserialize(value,
                  specifiedType: const FullType(CommunityUserType))
              as CommunityUserType;
          break;
        case 'timestamp':
          result.timestamp = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'invited':
          result.invited = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$BuiltCommunitySerializer
    implements StructuredSerializer<BuiltCommunity> {
  @override
  final Iterable<Type> types = const [BuiltCommunity, _$BuiltCommunity];
  @override
  final String wireName = 'BuiltCommunity';

  @override
  Iterable<Object> serialize(Serializers serializers, BuiltCommunity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.communityId != null) {
      result
        ..add('communityId')
        ..add(serializers.serialize(object.communityId,
            specifiedType: const FullType(String)));
    }
    if (object.name != null) {
      result
        ..add('name')
        ..add(serializers.serialize(object.name,
            specifiedType: const FullType(String)));
    }
    if (object.description != null) {
      result
        ..add('description')
        ..add(serializers.serialize(object.description,
            specifiedType: const FullType(String)));
    }
    if (object.avatar != null) {
      result
        ..add('avatar')
        ..add(serializers.serialize(object.avatar,
            specifiedType: const FullType(String)));
    }
    if (object.coverImage != null) {
      result
        ..add('coverImage')
        ..add(serializers.serialize(object.coverImage,
            specifiedType: const FullType(String)));
    }
    if (object.creator != null) {
      result
        ..add('creator')
        ..add(serializers.serialize(object.creator,
            specifiedType: const FullType(SummaryUser)));
    }
    if (object.hosts != null) {
      result
        ..add('hosts')
        ..add(serializers.serialize(object.hosts,
            specifiedType:
                const FullType(BuiltSet, const [const FullType(String)])));
    }
    if (object.liveClubCount != null) {
      result
        ..add('liveClubCount')
        ..add(serializers.serialize(object.liveClubCount,
            specifiedType: const FullType(int)));
    }
    if (object.scheduledClubCount != null) {
      result
        ..add('scheduledClubCount')
        ..add(serializers.serialize(object.scheduledClubCount,
            specifiedType: const FullType(int)));
    }
    if (object.memberCount != null) {
      result
        ..add('memberCount')
        ..add(serializers.serialize(object.memberCount,
            specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  BuiltCommunity deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuiltCommunityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'communityId':
          result.communityId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'avatar':
          result.avatar = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'coverImage':
          result.coverImage = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'creator':
          result.creator.replace(serializers.deserialize(value,
              specifiedType: const FullType(SummaryUser)) as SummaryUser);
          break;
        case 'hosts':
          result.hosts.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltSet, const [const FullType(String)]))
              as BuiltSet<Object>);
          break;
        case 'liveClubCount':
          result.liveClubCount = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'scheduledClubCount':
          result.scheduledClubCount = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'memberCount':
          result.memberCount = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$AppConfigsSerializer implements StructuredSerializer<AppConfigs> {
  @override
  final Iterable<Type> types = const [AppConfigs, _$AppConfigs];
  @override
  final String wireName = 'AppConfigs';

  @override
  Iterable<Object> serialize(Serializers serializers, AppConfigs object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.minAppVersion != null) {
      result
        ..add('minAppVersion')
        ..add(serializers.serialize(object.minAppVersion,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  AppConfigs deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AppConfigsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'minAppVersion':
          result.minAppVersion = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$UsernameAvailabilitySerializer
    implements StructuredSerializer<UsernameAvailability> {
  @override
  final Iterable<Type> types = const [
    UsernameAvailability,
    _$UsernameAvailability
  ];
  @override
  final String wireName = 'UsernameAvailability';

  @override
  Iterable<Object> serialize(
      Serializers serializers, UsernameAvailability object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.isAvailable != null) {
      result
        ..add('isAvailable')
        ..add(serializers.serialize(object.isAvailable,
            specifiedType: const FullType(bool)));
    }
    return result;
  }

  @override
  UsernameAvailability deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new UsernameAvailabilityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'isAvailable':
          result.isAvailable = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$BuiltAudienceListSerializer
    implements StructuredSerializer<BuiltAudienceList> {
  @override
  final Iterable<Type> types = const [BuiltAudienceList, _$BuiltAudienceList];
  @override
  final String wireName = 'BuiltAudienceList';

  @override
  Iterable<Object> serialize(Serializers serializers, BuiltAudienceList object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.audience != null) {
      result
        ..add('audience')
        ..add(serializers.serialize(object.audience,
            specifiedType: const FullType(
                BuiltList, const [const FullType(AudienceData)])));
    }
    if (object.lastevaluatedkey != null) {
      result
        ..add('lastevaluatedkey')
        ..add(serializers.serialize(object.lastevaluatedkey,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  BuiltAudienceList deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuiltAudienceListBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'audience':
          result.audience.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(AudienceData)]))
              as BuiltList<Object>);
          break;
        case 'lastevaluatedkey':
          result.lastevaluatedkey = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$RelationActionResponseSerializer
    implements StructuredSerializer<RelationActionResponse> {
  @override
  final Iterable<Type> types = const [
    RelationActionResponse,
    _$RelationActionResponse
  ];
  @override
  final String wireName = 'RelationActionResponse';

  @override
  Iterable<Object> serialize(
      Serializers serializers, RelationActionResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.relationIndexObj != null) {
      result
        ..add('relationIndexObj')
        ..add(serializers.serialize(object.relationIndexObj,
            specifiedType: const FullType(RelationIndexObject)));
    }
    if (object.friendsCount != null) {
      result
        ..add('friendsCount')
        ..add(serializers.serialize(object.friendsCount,
            specifiedType: const FullType(int)));
    }
    if (object.followerCount != null) {
      result
        ..add('followerCount')
        ..add(serializers.serialize(object.followerCount,
            specifiedType: const FullType(int)));
    }
    if (object.followingCount != null) {
      result
        ..add('followingCount')
        ..add(serializers.serialize(object.followingCount,
            specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  RelationActionResponse deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new RelationActionResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'relationIndexObj':
          result.relationIndexObj.replace(serializers.deserialize(value,
                  specifiedType: const FullType(RelationIndexObject))
              as RelationIndexObject);
          break;
        case 'friendsCount':
          result.friendsCount = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'followerCount':
          result.followerCount = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'followingCount':
          result.followingCount = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$NotificationDataSerializer
    implements StructuredSerializer<NotificationData> {
  @override
  final Iterable<Type> types = const [NotificationData, _$NotificationData];
  @override
  final String wireName = 'NotificationData';

  @override
  Iterable<Object> serialize(Serializers serializers, NotificationData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.type != null) {
      result
        ..add('type')
        ..add(serializers.serialize(object.type,
            specifiedType: const FullType(NotificationType)));
    }
    if (object.title != null) {
      result
        ..add('title')
        ..add(serializers.serialize(object.title,
            specifiedType: const FullType(String)));
    }
    if (object.avatar != null) {
      result
        ..add('avatar')
        ..add(serializers.serialize(object.avatar,
            specifiedType: const FullType(String)));
    }
    if (object.timestamp != null) {
      result
        ..add('timestamp')
        ..add(serializers.serialize(object.timestamp,
            specifiedType: const FullType(int)));
    }
    if (object.targetResourceId != null) {
      result
        ..add('targetResourceId')
        ..add(serializers.serialize(object.targetResourceId,
            specifiedType: const FullType(String)));
    }
    if (object.notificationId != null) {
      result
        ..add('notificationId')
        ..add(serializers.serialize(object.notificationId,
            specifiedType: const FullType(String)));
    }
    if (object.opened != null) {
      result
        ..add('opened')
        ..add(serializers.serialize(object.opened,
            specifiedType: const FullType(bool)));
    }
    if (object.secondaryAvatar != null) {
      result
        ..add('secondaryAvatar')
        ..add(serializers.serialize(object.secondaryAvatar,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  NotificationData deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new NotificationDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'type':
          result.type = serializers.deserialize(value,
                  specifiedType: const FullType(NotificationType))
              as NotificationType;
          break;
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'avatar':
          result.avatar = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'timestamp':
          result.timestamp = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'targetResourceId':
          result.targetResourceId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'notificationId':
          result.notificationId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'opened':
          result.opened = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'secondaryAvatar':
          result.secondaryAvatar = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$BuiltNotificationListSerializer
    implements StructuredSerializer<BuiltNotificationList> {
  @override
  final Iterable<Type> types = const [
    BuiltNotificationList,
    _$BuiltNotificationList
  ];
  @override
  final String wireName = 'BuiltNotificationList';

  @override
  Iterable<Object> serialize(
      Serializers serializers, BuiltNotificationList object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.notifications != null) {
      result
        ..add('notifications')
        ..add(serializers.serialize(object.notifications,
            specifiedType: const FullType(
                BuiltList, const [const FullType(NotificationData)])));
    }
    if (object.lastevaluatedkey != null) {
      result
        ..add('lastevaluatedkey')
        ..add(serializers.serialize(object.lastevaluatedkey,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  BuiltNotificationList deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuiltNotificationListBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'notifications':
          result.notifications.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(NotificationData)]))
              as BuiltList<Object>);
          break;
        case 'lastevaluatedkey':
          result.lastevaluatedkey = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$BuiltFCMTokenSerializer implements StructuredSerializer<BuiltFCMToken> {
  @override
  final Iterable<Type> types = const [BuiltFCMToken, _$BuiltFCMToken];
  @override
  final String wireName = 'BuiltFCMToken';

  @override
  Iterable<Object> serialize(Serializers serializers, BuiltFCMToken object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.deviceToken != null) {
      result
        ..add('deviceToken')
        ..add(serializers.serialize(object.deviceToken,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  BuiltFCMToken deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuiltFCMTokenBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'deviceToken':
          result.deviceToken = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$RelationIndexObjectSerializer
    implements StructuredSerializer<RelationIndexObject> {
  @override
  final Iterable<Type> types = const [
    RelationIndexObject,
    _$RelationIndexObject
  ];
  @override
  final String wireName = 'RelationIndexObject';

  @override
  Iterable<Object> serialize(
      Serializers serializers, RelationIndexObject object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'B1',
      serializers.serialize(object.B1, specifiedType: const FullType(bool)),
      'B2',
      serializers.serialize(object.B2, specifiedType: const FullType(bool)),
      'B3',
      serializers.serialize(object.B3, specifiedType: const FullType(bool)),
      'B4',
      serializers.serialize(object.B4, specifiedType: const FullType(bool)),
      'B5',
      serializers.serialize(object.B5, specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  RelationIndexObject deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new RelationIndexObjectBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'B1':
          result.B1 = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'B2':
          result.B2 = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'B3':
          result.B3 = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'B4':
          result.B4 = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'B5':
          result.B5 = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$BuiltProfileSerializer implements StructuredSerializer<BuiltProfile> {
  @override
  final Iterable<Type> types = const [BuiltProfile, _$BuiltProfile];
  @override
  final String wireName = 'BuiltProfile';

  @override
  Iterable<Object> serialize(Serializers serializers, BuiltProfile object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'user',
      serializers.serialize(object.user,
          specifiedType: const FullType(BuiltUser)),
    ];
    if (object.relationIndexObj != null) {
      result
        ..add('relationIndexObj')
        ..add(serializers.serialize(object.relationIndexObj,
            specifiedType: const FullType(RelationIndexObject)));
    }
    return result;
  }

  @override
  BuiltProfile deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuiltProfileBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'user':
          result.user.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltUser)) as BuiltUser);
          break;
        case 'relationIndexObj':
          result.relationIndexObj.replace(serializers.deserialize(value,
                  specifiedType: const FullType(RelationIndexObject))
              as RelationIndexObject);
          break;
      }
    }

    return result.build();
  }
}

class _$BuiltUserSerializer implements StructuredSerializer<BuiltUser> {
  @override
  final Iterable<Type> types = const [BuiltUser, _$BuiltUser];
  @override
  final String wireName = 'BuiltUser';

  @override
  Iterable<Object> serialize(Serializers serializers, BuiltUser object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.userId != null) {
      result
        ..add('userId')
        ..add(serializers.serialize(object.userId,
            specifiedType: const FullType(String)));
    }
    if (object.username != null) {
      result
        ..add('username')
        ..add(serializers.serialize(object.username,
            specifiedType: const FullType(String)));
    }
    if (object.name != null) {
      result
        ..add('name')
        ..add(serializers.serialize(object.name,
            specifiedType: const FullType(String)));
    }
    if (object.email != null) {
      result
        ..add('email')
        ..add(serializers.serialize(object.email,
            specifiedType: const FullType(String)));
    }
    if (object.phone != null) {
      result
        ..add('phone')
        ..add(serializers.serialize(object.phone,
            specifiedType: const FullType(String)));
    }
    if (object.avatar != null) {
      result
        ..add('avatar')
        ..add(serializers.serialize(object.avatar,
            specifiedType: const FullType(String)));
    }
    if (object.tagline != null) {
      result
        ..add('tagline')
        ..add(serializers.serialize(object.tagline,
            specifiedType: const FullType(String)));
    }
    if (object.online != null) {
      result
        ..add('online')
        ..add(serializers.serialize(object.online,
            specifiedType: const FullType(int)));
    }
    if (object.bio != null) {
      result
        ..add('bio')
        ..add(serializers.serialize(object.bio,
            specifiedType: const FullType(String)));
    }
    if (object.friendsCount != null) {
      result
        ..add('friendsCount')
        ..add(serializers.serialize(object.friendsCount,
            specifiedType: const FullType(int)));
    }
    if (object.followerCount != null) {
      result
        ..add('followerCount')
        ..add(serializers.serialize(object.followerCount,
            specifiedType: const FullType(int)));
    }
    if (object.followingCount != null) {
      result
        ..add('followingCount')
        ..add(serializers.serialize(object.followingCount,
            specifiedType: const FullType(int)));
    }
    if (object.languagePreference != null) {
      result
        ..add('languagePreference')
        ..add(serializers.serialize(object.languagePreference,
            specifiedType: const FullType(String)));
    }
    if (object.regionCode != null) {
      result
        ..add('regionCode')
        ..add(serializers.serialize(object.regionCode,
            specifiedType: const FullType(String)));
    }
    if (object.geoLat != null) {
      result
        ..add('geoLat')
        ..add(serializers.serialize(object.geoLat,
            specifiedType: const FullType(double)));
    }
    if (object.geoLong != null) {
      result
        ..add('geoLong')
        ..add(serializers.serialize(object.geoLong,
            specifiedType: const FullType(double)));
    }
    if (object.isBlackListed != null) {
      result
        ..add('isBlackListed')
        ..add(serializers.serialize(object.isBlackListed,
            specifiedType: const FullType(bool)));
    }
    if (object.termsAccepted != null) {
      result
        ..add('termsAccepted')
        ..add(serializers.serialize(object.termsAccepted,
            specifiedType: const FullType(bool)));
    }
    if (object.policyAccepted != null) {
      result
        ..add('policyAccepted')
        ..add(serializers.serialize(object.policyAccepted,
            specifiedType: const FullType(bool)));
    }
    if (object.clubsCreated != null) {
      result
        ..add('clubsCreated')
        ..add(serializers.serialize(object.clubsCreated,
            specifiedType: const FullType(int)));
    }
    if (object.clubsParticipated != null) {
      result
        ..add('clubsParticipated')
        ..add(serializers.serialize(object.clubsParticipated,
            specifiedType: const FullType(int)));
    }
    if (object.kickedOutCount != null) {
      result
        ..add('kickedOutCount')
        ..add(serializers.serialize(object.kickedOutCount,
            specifiedType: const FullType(int)));
    }
    if (object.clubsJoinRequests != null) {
      result
        ..add('clubsJoinRequests')
        ..add(serializers.serialize(object.clubsJoinRequests,
            specifiedType: const FullType(int)));
    }
    if (object.clubsAttended != null) {
      result
        ..add('clubsAttended')
        ..add(serializers.serialize(object.clubsAttended,
            specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  BuiltUser deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuiltUserBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'userId':
          result.userId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'username':
          result.username = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'phone':
          result.phone = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'avatar':
          result.avatar = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'tagline':
          result.tagline = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'online':
          result.online = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'bio':
          result.bio = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'friendsCount':
          result.friendsCount = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'followerCount':
          result.followerCount = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'followingCount':
          result.followingCount = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'languagePreference':
          result.languagePreference = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'regionCode':
          result.regionCode = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'geoLat':
          result.geoLat = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'geoLong':
          result.geoLong = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'isBlackListed':
          result.isBlackListed = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'termsAccepted':
          result.termsAccepted = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'policyAccepted':
          result.policyAccepted = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'clubsCreated':
          result.clubsCreated = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'clubsParticipated':
          result.clubsParticipated = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'kickedOutCount':
          result.kickedOutCount = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'clubsJoinRequests':
          result.clubsJoinRequests = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'clubsAttended':
          result.clubsAttended = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$BuiltProfileImageSerializer
    implements StructuredSerializer<BuiltProfileImage> {
  @override
  final Iterable<Type> types = const [BuiltProfileImage, _$BuiltProfileImage];
  @override
  final String wireName = 'BuiltProfileImage';

  @override
  Iterable<Object> serialize(Serializers serializers, BuiltProfileImage object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.image != null) {
      result
        ..add('image')
        ..add(serializers.serialize(object.image,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  BuiltProfileImage deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuiltProfileImageBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'image':
          result.image = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$BuiltFollowSerializer implements StructuredSerializer<BuiltFollow> {
  @override
  final Iterable<Type> types = const [BuiltFollow, _$BuiltFollow];
  @override
  final String wireName = 'BuiltFollow';

  @override
  Iterable<Object> serialize(Serializers serializers, BuiltFollow object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.username != null) {
      result
        ..add('username')
        ..add(serializers.serialize(object.username,
            specifiedType: const FullType(String)));
    }
    if (object.followername != null) {
      result
        ..add('followername')
        ..add(serializers.serialize(object.followername,
            specifiedType: const FullType(String)));
    }
    if (object.userImageUrl != null) {
      result
        ..add('userImageUrl')
        ..add(serializers.serialize(object.userImageUrl,
            specifiedType: const FullType(String)));
    }
    if (object.followerImageUrl != null) {
      result
        ..add('followerImageUrl')
        ..add(serializers.serialize(object.followerImageUrl,
            specifiedType: const FullType(String)));
    }
    if (object.name != null) {
      result
        ..add('name')
        ..add(serializers.serialize(object.name,
            specifiedType: const FullType(String)));
    }
    if (object.followerName != null) {
      result
        ..add('followerName')
        ..add(serializers.serialize(object.followerName,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  BuiltFollow deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuiltFollowBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'username':
          result.username = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'followername':
          result.followername = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'userImageUrl':
          result.userImageUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'followerImageUrl':
          result.followerImageUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'followerName':
          result.followerName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$BuiltClubAndAudienceSerializer
    implements StructuredSerializer<BuiltClubAndAudience> {
  @override
  final Iterable<Type> types = const [
    BuiltClubAndAudience,
    _$BuiltClubAndAudience
  ];
  @override
  final String wireName = 'BuiltClubAndAudience';

  @override
  Iterable<Object> serialize(
      Serializers serializers, BuiltClubAndAudience object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.club != null) {
      result
        ..add('club')
        ..add(serializers.serialize(object.club,
            specifiedType: const FullType(BuiltClub)));
    }
    if (object.audienceData != null) {
      result
        ..add('audienceData')
        ..add(serializers.serialize(object.audienceData,
            specifiedType: const FullType(AudienceData)));
    }
    if (object.reactionIndexValue != null) {
      result
        ..add('reactionIndexValue')
        ..add(serializers.serialize(object.reactionIndexValue,
            specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  BuiltClubAndAudience deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuiltClubAndAudienceBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'club':
          result.club.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltClub)) as BuiltClub);
          break;
        case 'audienceData':
          result.audienceData.replace(serializers.deserialize(value,
              specifiedType: const FullType(AudienceData)) as AudienceData);
          break;
        case 'reactionIndexValue':
          result.reactionIndexValue = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$AudienceDataSerializer implements StructuredSerializer<AudienceData> {
  @override
  final Iterable<Type> types = const [AudienceData, _$AudienceData];
  @override
  final String wireName = 'AudienceData';

  @override
  Iterable<Object> serialize(Serializers serializers, AudienceData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'audience',
      serializers.serialize(object.audience,
          specifiedType: const FullType(SummaryUser)),
    ];
    if (object.status != null) {
      result
        ..add('status')
        ..add(serializers.serialize(object.status,
            specifiedType: const FullType(AudienceStatus)));
    }
    if (object.isMuted != null) {
      result
        ..add('isMuted')
        ..add(serializers.serialize(object.isMuted,
            specifiedType: const FullType(bool)));
    }
    if (object.joinRequestAttempts != null) {
      result
        ..add('joinRequestAttempts')
        ..add(serializers.serialize(object.joinRequestAttempts,
            specifiedType: const FullType(int)));
    }
    if (object.invitationId != null) {
      result
        ..add('invitationId')
        ..add(serializers.serialize(object.invitationId,
            specifiedType: const FullType(String)));
    }
    if (object.timestamp != null) {
      result
        ..add('timestamp')
        ..add(serializers.serialize(object.timestamp,
            specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  AudienceData deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AudienceDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(AudienceStatus)) as AudienceStatus;
          break;
        case 'isMuted':
          result.isMuted = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'joinRequestAttempts':
          result.joinRequestAttempts = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'audience':
          result.audience.replace(serializers.deserialize(value,
              specifiedType: const FullType(SummaryUser)) as SummaryUser);
          break;
        case 'invitationId':
          result.invitationId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'timestamp':
          result.timestamp = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$BuiltClubSerializer implements StructuredSerializer<BuiltClub> {
  @override
  final Iterable<Type> types = const [BuiltClub, _$BuiltClub];
  @override
  final String wireName = 'BuiltClub';

  @override
  Iterable<Object> serialize(Serializers serializers, BuiltClub object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.clubId != null) {
      result
        ..add('clubId')
        ..add(serializers.serialize(object.clubId,
            specifiedType: const FullType(String)));
    }
    if (object.clubName != null) {
      result
        ..add('clubName')
        ..add(serializers.serialize(object.clubName,
            specifiedType: const FullType(String)));
    }
    if (object.creator != null) {
      result
        ..add('creator')
        ..add(serializers.serialize(object.creator,
            specifiedType: const FullType(SummaryUser)));
    }
    if (object.status != null) {
      result
        ..add('status')
        ..add(serializers.serialize(object.status,
            specifiedType: const FullType(ClubStatus)));
    }
    if (object.category != null) {
      result
        ..add('category')
        ..add(serializers.serialize(object.category,
            specifiedType: const FullType(String)));
    }
    if (object.subCategory != null) {
      result
        ..add('subCategory')
        ..add(serializers.serialize(object.subCategory,
            specifiedType: const FullType(String)));
    }
    if (object.community != null) {
      result
        ..add('community')
        ..add(serializers.serialize(object.community,
            specifiedType: const FullType(BuiltCommunity)));
    }
    if (object.createdOn != null) {
      result
        ..add('createdOn')
        ..add(serializers.serialize(object.createdOn,
            specifiedType: const FullType(int)));
    }
    if (object.modifiedOn != null) {
      result
        ..add('modifiedOn')
        ..add(serializers.serialize(object.modifiedOn,
            specifiedType: const FullType(int)));
    }
    if (object.scheduleTime != null) {
      result
        ..add('scheduleTime')
        ..add(serializers.serialize(object.scheduleTime,
            specifiedType: const FullType(int)));
    }
    if (object.clubAvatar != null) {
      result
        ..add('clubAvatar')
        ..add(serializers.serialize(object.clubAvatar,
            specifiedType: const FullType(String)));
    }
    if (object.description != null) {
      result
        ..add('description')
        ..add(serializers.serialize(object.description,
            specifiedType: const FullType(String)));
    }
    if (object.externalUrl != null) {
      result
        ..add('externalUrl')
        ..add(serializers.serialize(object.externalUrl,
            specifiedType: const FullType(String)));
    }
    if (object.isLocal != null) {
      result
        ..add('isLocal')
        ..add(serializers.serialize(object.isLocal,
            specifiedType: const FullType(bool)));
    }
    if (object.isGlobal != null) {
      result
        ..add('isGlobal')
        ..add(serializers.serialize(object.isGlobal,
            specifiedType: const FullType(bool)));
    }
    if (object.isPrivate != null) {
      result
        ..add('isPrivate')
        ..add(serializers.serialize(object.isPrivate,
            specifiedType: const FullType(bool)));
    }
    if (object.tags != null) {
      result
        ..add('tags')
        ..add(serializers.serialize(object.tags,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    if (object.estimatedAudience != null) {
      result
        ..add('estimatedAudience')
        ..add(serializers.serialize(object.estimatedAudience,
            specifiedType: const FullType(int)));
    }
    if (object.participants != null) {
      result
        ..add('participants')
        ..add(serializers.serialize(object.participants,
            specifiedType:
                const FullType(BuiltSet, const [const FullType(String)])));
    }
    return result;
  }

  @override
  BuiltClub deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuiltClubBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'clubId':
          result.clubId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'clubName':
          result.clubName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'creator':
          result.creator.replace(serializers.deserialize(value,
              specifiedType: const FullType(SummaryUser)) as SummaryUser);
          break;
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(ClubStatus)) as ClubStatus;
          break;
        case 'category':
          result.category = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'subCategory':
          result.subCategory = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'community':
          result.community.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltCommunity)) as BuiltCommunity);
          break;
        case 'createdOn':
          result.createdOn = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'modifiedOn':
          result.modifiedOn = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'scheduleTime':
          result.scheduleTime = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'clubAvatar':
          result.clubAvatar = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'externalUrl':
          result.externalUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'isLocal':
          result.isLocal = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'isGlobal':
          result.isGlobal = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'isPrivate':
          result.isPrivate = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'tags':
          result.tags.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList<Object>);
          break;
        case 'estimatedAudience':
          result.estimatedAudience = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'participants':
          result.participants.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltSet, const [const FullType(String)]))
              as BuiltSet<Object>);
          break;
      }
    }

    return result.build();
  }
}

class _$SummaryUserSerializer implements StructuredSerializer<SummaryUser> {
  @override
  final Iterable<Type> types = const [SummaryUser, _$SummaryUser];
  @override
  final String wireName = 'SummaryUser';

  @override
  Iterable<Object> serialize(Serializers serializers, SummaryUser object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.userId != null) {
      result
        ..add('userId')
        ..add(serializers.serialize(object.userId,
            specifiedType: const FullType(String)));
    }
    if (object.username != null) {
      result
        ..add('username')
        ..add(serializers.serialize(object.username,
            specifiedType: const FullType(String)));
    }
    if (object.name != null) {
      result
        ..add('name')
        ..add(serializers.serialize(object.name,
            specifiedType: const FullType(String)));
    }
    if (object.avatar != null) {
      result
        ..add('avatar')
        ..add(serializers.serialize(object.avatar,
            specifiedType: const FullType(String)));
    }
    if (object.tagline != null) {
      result
        ..add('tagline')
        ..add(serializers.serialize(object.tagline,
            specifiedType: const FullType(String)));
    }
    if (object.online != null) {
      result
        ..add('online')
        ..add(serializers.serialize(object.online,
            specifiedType: const FullType(int)));
    }
    if (object.phone != null) {
      result
        ..add('phone')
        ..add(serializers.serialize(object.phone,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  SummaryUser deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SummaryUserBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'userId':
          result.userId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'username':
          result.username = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'avatar':
          result.avatar = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'tagline':
          result.tagline = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'online':
          result.online = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'phone':
          result.phone = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$BuiltSearchUsersSerializer
    implements StructuredSerializer<BuiltSearchUsers> {
  @override
  final Iterable<Type> types = const [BuiltSearchUsers, _$BuiltSearchUsers];
  @override
  final String wireName = 'BuiltSearchUsers';

  @override
  Iterable<Object> serialize(Serializers serializers, BuiltSearchUsers object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.users != null) {
      result
        ..add('users')
        ..add(serializers.serialize(object.users,
            specifiedType: const FullType(
                BuiltList, const [const FullType(SummaryUser)])));
    }
    if (object.lastevaluatedkey != null) {
      result
        ..add('lastevaluatedkey')
        ..add(serializers.serialize(object.lastevaluatedkey,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  BuiltSearchUsers deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuiltSearchUsersBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'users':
          result.users.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(SummaryUser)]))
              as BuiltList<Object>);
          break;
        case 'lastevaluatedkey':
          result.lastevaluatedkey = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$BuiltSearchClubsSerializer
    implements StructuredSerializer<BuiltSearchClubs> {
  @override
  final Iterable<Type> types = const [BuiltSearchClubs, _$BuiltSearchClubs];
  @override
  final String wireName = 'BuiltSearchClubs';

  @override
  Iterable<Object> serialize(Serializers serializers, BuiltSearchClubs object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.clubs != null) {
      result
        ..add('clubs')
        ..add(serializers.serialize(object.clubs,
            specifiedType:
                const FullType(BuiltList, const [const FullType(BuiltClub)])));
    }
    if (object.lastevaluatedkey != null) {
      result
        ..add('lastevaluatedkey')
        ..add(serializers.serialize(object.lastevaluatedkey,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  BuiltSearchClubs deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuiltSearchClubsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'clubs':
          result.clubs.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(BuiltClub)]))
              as BuiltList<Object>);
          break;
        case 'lastevaluatedkey':
          result.lastevaluatedkey = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$CategoryClubsListSerializer
    implements StructuredSerializer<CategoryClubsList> {
  @override
  final Iterable<Type> types = const [CategoryClubsList, _$CategoryClubsList];
  @override
  final String wireName = 'CategoryClubsList';

  @override
  Iterable<Object> serialize(Serializers serializers, CategoryClubsList object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.category != null) {
      result
        ..add('category')
        ..add(serializers.serialize(object.category,
            specifiedType: const FullType(String)));
    }
    if (object.clubs != null) {
      result
        ..add('clubs')
        ..add(serializers.serialize(object.clubs,
            specifiedType:
                const FullType(BuiltList, const [const FullType(BuiltClub)])));
    }
    return result;
  }

  @override
  CategoryClubsList deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CategoryClubsListBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'category':
          result.category = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'clubs':
          result.clubs.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(BuiltClub)]))
              as BuiltList<Object>);
          break;
      }
    }

    return result.build();
  }
}

class _$BuiltAllClubsListSerializer
    implements StructuredSerializer<BuiltAllClubsList> {
  @override
  final Iterable<Type> types = const [BuiltAllClubsList, _$BuiltAllClubsList];
  @override
  final String wireName = 'BuiltAllClubsList';

  @override
  Iterable<Object> serialize(Serializers serializers, BuiltAllClubsList object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.categoryClubs != null) {
      result
        ..add('categoryClubs')
        ..add(serializers.serialize(object.categoryClubs,
            specifiedType: const FullType(
                BuiltList, const [const FullType(CategoryClubsList)])));
    }
    return result;
  }

  @override
  BuiltAllClubsList deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuiltAllClubsListBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'categoryClubs':
          result.categoryClubs.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(CategoryClubsList)]))
              as BuiltList<Object>);
          break;
      }
    }

    return result.build();
  }
}

class _$ReactionUserSerializer implements StructuredSerializer<ReactionUser> {
  @override
  final Iterable<Type> types = const [ReactionUser, _$ReactionUser];
  @override
  final String wireName = 'ReactionUser';

  @override
  Iterable<Object> serialize(Serializers serializers, ReactionUser object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'user',
      serializers.serialize(object.user,
          specifiedType: const FullType(SummaryUser)),
      'timestamp',
      serializers.serialize(object.timestamp,
          specifiedType: const FullType(int)),
      'indexValue',
      serializers.serialize(object.indexValue,
          specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  ReactionUser deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ReactionUserBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'user':
          result.user.replace(serializers.deserialize(value,
              specifiedType: const FullType(SummaryUser)) as SummaryUser);
          break;
        case 'timestamp':
          result.timestamp = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'indexValue':
          result.indexValue = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$BuiltReactionSerializer implements StructuredSerializer<BuiltReaction> {
  @override
  final Iterable<Type> types = const [BuiltReaction, _$BuiltReaction];
  @override
  final String wireName = 'BuiltReaction';

  @override
  Iterable<Object> serialize(Serializers serializers, BuiltReaction object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'reactions',
      serializers.serialize(object.reactions,
          specifiedType:
              const FullType(BuiltList, const [const FullType(ReactionUser)])),
    ];
    if (object.lastevaluatedkey != null) {
      result
        ..add('lastevaluatedkey')
        ..add(serializers.serialize(object.lastevaluatedkey,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  BuiltReaction deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuiltReactionBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'reactions':
          result.reactions.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(ReactionUser)]))
              as BuiltList<Object>);
          break;
        case 'lastevaluatedkey':
          result.lastevaluatedkey = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ReportSummarySerializer implements StructuredSerializer<ReportSummary> {
  @override
  final Iterable<Type> types = const [ReportSummary, _$ReportSummary];
  @override
  final String wireName = 'ReportSummary';

  @override
  Iterable<Object> serialize(Serializers serializers, ReportSummary object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'body',
      serializers.serialize(object.body, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  ReportSummary deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ReportSummaryBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'body':
          result.body = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$JoinRequestsSerializer implements StructuredSerializer<JoinRequests> {
  @override
  final Iterable<Type> types = const [JoinRequests, _$JoinRequests];
  @override
  final String wireName = 'JoinRequests';

  @override
  Iterable<Object> serialize(Serializers serializers, JoinRequests object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'audience',
      serializers.serialize(object.audience,
          specifiedType: const FullType(SummaryUser)),
    ];
    if (object.joinRequestAttempts != null) {
      result
        ..add('joinRequestAttempts')
        ..add(serializers.serialize(object.joinRequestAttempts,
            specifiedType: const FullType(int)));
    }
    if (object.timestamp != null) {
      result
        ..add('timestamp')
        ..add(serializers.serialize(object.timestamp,
            specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  JoinRequests deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new JoinRequestsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'joinRequestAttempts':
          result.joinRequestAttempts = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'timestamp':
          result.timestamp = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'audience':
          result.audience.replace(serializers.deserialize(value,
              specifiedType: const FullType(SummaryUser)) as SummaryUser);
          break;
      }
    }

    return result.build();
  }
}

class _$BuiltActiveJoinRequestsSerializer
    implements StructuredSerializer<BuiltActiveJoinRequests> {
  @override
  final Iterable<Type> types = const [
    BuiltActiveJoinRequests,
    _$BuiltActiveJoinRequests
  ];
  @override
  final String wireName = 'BuiltActiveJoinRequests';

  @override
  Iterable<Object> serialize(
      Serializers serializers, BuiltActiveJoinRequests object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.activeJoinRequestUsers != null) {
      result
        ..add('activeJoinRequestUsers')
        ..add(serializers.serialize(object.activeJoinRequestUsers,
            specifiedType: const FullType(
                BuiltList, const [const FullType(JoinRequests)])));
    }
    if (object.lastevaluatedkey != null) {
      result
        ..add('lastevaluatedkey')
        ..add(serializers.serialize(object.lastevaluatedkey,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  BuiltActiveJoinRequests deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuiltActiveJoinRequestsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'activeJoinRequestUsers':
          result.activeJoinRequestUsers.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(JoinRequests)]))
              as BuiltList<Object>);
          break;
        case 'lastevaluatedkey':
          result.lastevaluatedkey = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$BuiltUnifiedSearchResultsSerializer
    implements StructuredSerializer<BuiltUnifiedSearchResults> {
  @override
  final Iterable<Type> types = const [
    BuiltUnifiedSearchResults,
    _$BuiltUnifiedSearchResults
  ];
  @override
  final String wireName = 'BuiltUnifiedSearchResults';

  @override
  Iterable<Object> serialize(
      Serializers serializers, BuiltUnifiedSearchResults object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.users != null) {
      result
        ..add('users')
        ..add(serializers.serialize(object.users,
            specifiedType: const FullType(
                BuiltList, const [const FullType(SummaryUser)])));
    }
    if (object.userlastevaluatedkey != null) {
      result
        ..add('userlastevaluatedkey')
        ..add(serializers.serialize(object.userlastevaluatedkey,
            specifiedType: const FullType(String)));
    }
    if (object.clubs != null) {
      result
        ..add('clubs')
        ..add(serializers.serialize(object.clubs,
            specifiedType:
                const FullType(BuiltList, const [const FullType(BuiltClub)])));
    }
    if (object.clublastevaluatedkey != null) {
      result
        ..add('clublastevaluatedkey')
        ..add(serializers.serialize(object.clublastevaluatedkey,
            specifiedType: const FullType(String)));
    }
    if (object.communities != null) {
      result
        ..add('communities')
        ..add(serializers.serialize(object.communities,
            specifiedType: const FullType(
                BuiltList, const [const FullType(BuiltCommunity)])));
    }
    if (object.communitylastevaluatedkey != null) {
      result
        ..add('communitylastevaluatedkey')
        ..add(serializers.serialize(object.communitylastevaluatedkey,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  BuiltUnifiedSearchResults deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuiltUnifiedSearchResultsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'users':
          result.users.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(SummaryUser)]))
              as BuiltList<Object>);
          break;
        case 'userlastevaluatedkey':
          result.userlastevaluatedkey = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'clubs':
          result.clubs.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(BuiltClub)]))
              as BuiltList<Object>);
          break;
        case 'clublastevaluatedkey':
          result.clublastevaluatedkey = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'communities':
          result.communities.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(BuiltCommunity)]))
              as BuiltList<Object>);
          break;
        case 'communitylastevaluatedkey':
          result.communitylastevaluatedkey = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$BuiltInviteFormatSerializer
    implements StructuredSerializer<BuiltInviteFormat> {
  @override
  final Iterable<Type> types = const [BuiltInviteFormat, _$BuiltInviteFormat];
  @override
  final String wireName = 'BuiltInviteFormat';

  @override
  Iterable<Object> serialize(Serializers serializers, BuiltInviteFormat object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.type != null) {
      result
        ..add('type')
        ..add(serializers.serialize(object.type,
            specifiedType: const FullType(String)));
    }
    if (object.invitee != null) {
      result
        ..add('invitee')
        ..add(serializers.serialize(object.invitee,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    return result;
  }

  @override
  BuiltInviteFormat deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuiltInviteFormatBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'invitee':
          result.invitee.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList<Object>);
          break;
      }
    }

    return result.build();
  }
}

class _$BuiltContactsSerializer implements StructuredSerializer<BuiltContacts> {
  @override
  final Iterable<Type> types = const [BuiltContacts, _$BuiltContacts];
  @override
  final String wireName = 'BuiltContacts';

  @override
  Iterable<Object> serialize(Serializers serializers, BuiltContacts object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.contacts != null) {
      result
        ..add('contacts')
        ..add(serializers.serialize(object.contacts,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    return result;
  }

  @override
  BuiltContacts deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuiltContactsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'contacts':
          result.contacts.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList<Object>);
          break;
      }
    }

    return result.build();
  }
}

class _$AgoraToken extends AgoraToken {
  @override
  final String agoraToken;

  factory _$AgoraToken([void Function(AgoraTokenBuilder) updates]) =>
      (new AgoraTokenBuilder()..update(updates)).build();

  _$AgoraToken._({this.agoraToken}) : super._();

  @override
  AgoraToken rebuild(void Function(AgoraTokenBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AgoraTokenBuilder toBuilder() => new AgoraTokenBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AgoraToken && agoraToken == other.agoraToken;
  }

  @override
  int get hashCode {
    return $jf($jc(0, agoraToken.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AgoraToken')
          ..add('agoraToken', agoraToken))
        .toString();
  }
}

class AgoraTokenBuilder implements Builder<AgoraToken, AgoraTokenBuilder> {
  _$AgoraToken _$v;

  String _agoraToken;
  String get agoraToken => _$this._agoraToken;
  set agoraToken(String agoraToken) => _$this._agoraToken = agoraToken;

  AgoraTokenBuilder();

  AgoraTokenBuilder get _$this {
    if (_$v != null) {
      _agoraToken = _$v.agoraToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AgoraToken other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AgoraToken;
  }

  @override
  void update(void Function(AgoraTokenBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AgoraToken build() {
    final _$result = _$v ?? new _$AgoraToken._(agoraToken: agoraToken);
    replace(_$result);
    return _$result;
  }
}

class _$ClubContentModel extends ClubContentModel {
  @override
  final String source;
  @override
  final String title;
  @override
  final String url;
  @override
  final String decription;
  @override
  final String avatar;
  @override
  final int timestamp;

  factory _$ClubContentModel(
          [void Function(ClubContentModelBuilder) updates]) =>
      (new ClubContentModelBuilder()..update(updates)).build();

  _$ClubContentModel._(
      {this.source,
      this.title,
      this.url,
      this.decription,
      this.avatar,
      this.timestamp})
      : super._();

  @override
  ClubContentModel rebuild(void Function(ClubContentModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ClubContentModelBuilder toBuilder() =>
      new ClubContentModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ClubContentModel &&
        source == other.source &&
        title == other.title &&
        url == other.url &&
        decription == other.decription &&
        avatar == other.avatar &&
        timestamp == other.timestamp;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc($jc(0, source.hashCode), title.hashCode), url.hashCode),
                decription.hashCode),
            avatar.hashCode),
        timestamp.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ClubContentModel')
          ..add('source', source)
          ..add('title', title)
          ..add('url', url)
          ..add('decription', decription)
          ..add('avatar', avatar)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class ClubContentModelBuilder
    implements Builder<ClubContentModel, ClubContentModelBuilder> {
  _$ClubContentModel _$v;

  String _source;
  String get source => _$this._source;
  set source(String source) => _$this._source = source;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  String _url;
  String get url => _$this._url;
  set url(String url) => _$this._url = url;

  String _decription;
  String get decription => _$this._decription;
  set decription(String decription) => _$this._decription = decription;

  String _avatar;
  String get avatar => _$this._avatar;
  set avatar(String avatar) => _$this._avatar = avatar;

  int _timestamp;
  int get timestamp => _$this._timestamp;
  set timestamp(int timestamp) => _$this._timestamp = timestamp;

  ClubContentModelBuilder();

  ClubContentModelBuilder get _$this {
    if (_$v != null) {
      _source = _$v.source;
      _title = _$v.title;
      _url = _$v.url;
      _decription = _$v.decription;
      _avatar = _$v.avatar;
      _timestamp = _$v.timestamp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ClubContentModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ClubContentModel;
  }

  @override
  void update(void Function(ClubContentModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ClubContentModel build() {
    final _$result = _$v ??
        new _$ClubContentModel._(
            source: source,
            title: title,
            url: url,
            decription: decription,
            avatar: avatar,
            timestamp: timestamp);
    replace(_$result);
    return _$result;
  }
}

class _$BuiltCommunityAndUser extends BuiltCommunityAndUser {
  @override
  final BuiltCommunity community;
  @override
  final BuiltCommunityUser communityUser;

  factory _$BuiltCommunityAndUser(
          [void Function(BuiltCommunityAndUserBuilder) updates]) =>
      (new BuiltCommunityAndUserBuilder()..update(updates)).build();

  _$BuiltCommunityAndUser._({this.community, this.communityUser}) : super._();

  @override
  BuiltCommunityAndUser rebuild(
          void Function(BuiltCommunityAndUserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltCommunityAndUserBuilder toBuilder() =>
      new BuiltCommunityAndUserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltCommunityAndUser &&
        community == other.community &&
        communityUser == other.communityUser;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, community.hashCode), communityUser.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuiltCommunityAndUser')
          ..add('community', community)
          ..add('communityUser', communityUser))
        .toString();
  }
}

class BuiltCommunityAndUserBuilder
    implements Builder<BuiltCommunityAndUser, BuiltCommunityAndUserBuilder> {
  _$BuiltCommunityAndUser _$v;

  BuiltCommunityBuilder _community;
  BuiltCommunityBuilder get community =>
      _$this._community ??= new BuiltCommunityBuilder();
  set community(BuiltCommunityBuilder community) =>
      _$this._community = community;

  BuiltCommunityUserBuilder _communityUser;
  BuiltCommunityUserBuilder get communityUser =>
      _$this._communityUser ??= new BuiltCommunityUserBuilder();
  set communityUser(BuiltCommunityUserBuilder communityUser) =>
      _$this._communityUser = communityUser;

  BuiltCommunityAndUserBuilder();

  BuiltCommunityAndUserBuilder get _$this {
    if (_$v != null) {
      _community = _$v.community?.toBuilder();
      _communityUser = _$v.communityUser?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltCommunityAndUser other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuiltCommunityAndUser;
  }

  @override
  void update(void Function(BuiltCommunityAndUserBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuiltCommunityAndUser build() {
    _$BuiltCommunityAndUser _$result;
    try {
      _$result = _$v ??
          new _$BuiltCommunityAndUser._(
              community: _community?.build(),
              communityUser: _communityUser?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'community';
        _community?.build();
        _$failedField = 'communityUser';
        _communityUser?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'BuiltCommunityAndUser', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$CommunityImageUploadBody extends CommunityImageUploadBody {
  @override
  final String avatar;
  @override
  final String coverImage;

  factory _$CommunityImageUploadBody(
          [void Function(CommunityImageUploadBodyBuilder) updates]) =>
      (new CommunityImageUploadBodyBuilder()..update(updates)).build();

  _$CommunityImageUploadBody._({this.avatar, this.coverImage}) : super._();

  @override
  CommunityImageUploadBody rebuild(
          void Function(CommunityImageUploadBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CommunityImageUploadBodyBuilder toBuilder() =>
      new CommunityImageUploadBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CommunityImageUploadBody &&
        avatar == other.avatar &&
        coverImage == other.coverImage;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, avatar.hashCode), coverImage.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('CommunityImageUploadBody')
          ..add('avatar', avatar)
          ..add('coverImage', coverImage))
        .toString();
  }
}

class CommunityImageUploadBodyBuilder
    implements
        Builder<CommunityImageUploadBody, CommunityImageUploadBodyBuilder> {
  _$CommunityImageUploadBody _$v;

  String _avatar;
  String get avatar => _$this._avatar;
  set avatar(String avatar) => _$this._avatar = avatar;

  String _coverImage;
  String get coverImage => _$this._coverImage;
  set coverImage(String coverImage) => _$this._coverImage = coverImage;

  CommunityImageUploadBodyBuilder();

  CommunityImageUploadBodyBuilder get _$this {
    if (_$v != null) {
      _avatar = _$v.avatar;
      _coverImage = _$v.coverImage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CommunityImageUploadBody other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$CommunityImageUploadBody;
  }

  @override
  void update(void Function(CommunityImageUploadBodyBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$CommunityImageUploadBody build() {
    final _$result = _$v ??
        new _$CommunityImageUploadBody._(
            avatar: avatar, coverImage: coverImage);
    replace(_$result);
    return _$result;
  }
}

class _$BuiltCommunityList extends BuiltCommunityList {
  @override
  final BuiltList<BuiltCommunity> communities;
  @override
  final String lastevaluatedkey;

  factory _$BuiltCommunityList(
          [void Function(BuiltCommunityListBuilder) updates]) =>
      (new BuiltCommunityListBuilder()..update(updates)).build();

  _$BuiltCommunityList._({this.communities, this.lastevaluatedkey}) : super._();

  @override
  BuiltCommunityList rebuild(
          void Function(BuiltCommunityListBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltCommunityListBuilder toBuilder() =>
      new BuiltCommunityListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltCommunityList &&
        communities == other.communities &&
        lastevaluatedkey == other.lastevaluatedkey;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, communities.hashCode), lastevaluatedkey.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuiltCommunityList')
          ..add('communities', communities)
          ..add('lastevaluatedkey', lastevaluatedkey))
        .toString();
  }
}

class BuiltCommunityListBuilder
    implements Builder<BuiltCommunityList, BuiltCommunityListBuilder> {
  _$BuiltCommunityList _$v;

  ListBuilder<BuiltCommunity> _communities;
  ListBuilder<BuiltCommunity> get communities =>
      _$this._communities ??= new ListBuilder<BuiltCommunity>();
  set communities(ListBuilder<BuiltCommunity> communities) =>
      _$this._communities = communities;

  String _lastevaluatedkey;
  String get lastevaluatedkey => _$this._lastevaluatedkey;
  set lastevaluatedkey(String lastevaluatedkey) =>
      _$this._lastevaluatedkey = lastevaluatedkey;

  BuiltCommunityListBuilder();

  BuiltCommunityListBuilder get _$this {
    if (_$v != null) {
      _communities = _$v.communities?.toBuilder();
      _lastevaluatedkey = _$v.lastevaluatedkey;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltCommunityList other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuiltCommunityList;
  }

  @override
  void update(void Function(BuiltCommunityListBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuiltCommunityList build() {
    _$BuiltCommunityList _$result;
    try {
      _$result = _$v ??
          new _$BuiltCommunityList._(
              communities: _communities?.build(),
              lastevaluatedkey: lastevaluatedkey);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'communities';
        _communities?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'BuiltCommunityList', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$BuiltCommunityUser extends BuiltCommunityUser {
  @override
  final BuiltCommunity community;
  @override
  final SummaryUser user;
  @override
  final CommunityUserType type;
  @override
  final int timestamp;
  @override
  final bool invited;

  factory _$BuiltCommunityUser(
          [void Function(BuiltCommunityUserBuilder) updates]) =>
      (new BuiltCommunityUserBuilder()..update(updates)).build();

  _$BuiltCommunityUser._(
      {this.community, this.user, this.type, this.timestamp, this.invited})
      : super._();

  @override
  BuiltCommunityUser rebuild(
          void Function(BuiltCommunityUserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltCommunityUserBuilder toBuilder() =>
      new BuiltCommunityUserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltCommunityUser &&
        community == other.community &&
        user == other.user &&
        type == other.type &&
        timestamp == other.timestamp &&
        invited == other.invited;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, community.hashCode), user.hashCode), type.hashCode),
            timestamp.hashCode),
        invited.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuiltCommunityUser')
          ..add('community', community)
          ..add('user', user)
          ..add('type', type)
          ..add('timestamp', timestamp)
          ..add('invited', invited))
        .toString();
  }
}

class BuiltCommunityUserBuilder
    implements Builder<BuiltCommunityUser, BuiltCommunityUserBuilder> {
  _$BuiltCommunityUser _$v;

  BuiltCommunityBuilder _community;
  BuiltCommunityBuilder get community =>
      _$this._community ??= new BuiltCommunityBuilder();
  set community(BuiltCommunityBuilder community) =>
      _$this._community = community;

  SummaryUserBuilder _user;
  SummaryUserBuilder get user => _$this._user ??= new SummaryUserBuilder();
  set user(SummaryUserBuilder user) => _$this._user = user;

  CommunityUserType _type;
  CommunityUserType get type => _$this._type;
  set type(CommunityUserType type) => _$this._type = type;

  int _timestamp;
  int get timestamp => _$this._timestamp;
  set timestamp(int timestamp) => _$this._timestamp = timestamp;

  bool _invited;
  bool get invited => _$this._invited;
  set invited(bool invited) => _$this._invited = invited;

  BuiltCommunityUserBuilder();

  BuiltCommunityUserBuilder get _$this {
    if (_$v != null) {
      _community = _$v.community?.toBuilder();
      _user = _$v.user?.toBuilder();
      _type = _$v.type;
      _timestamp = _$v.timestamp;
      _invited = _$v.invited;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltCommunityUser other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuiltCommunityUser;
  }

  @override
  void update(void Function(BuiltCommunityUserBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuiltCommunityUser build() {
    _$BuiltCommunityUser _$result;
    try {
      _$result = _$v ??
          new _$BuiltCommunityUser._(
              community: _community?.build(),
              user: _user?.build(),
              type: type,
              timestamp: timestamp,
              invited: invited);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'community';
        _community?.build();
        _$failedField = 'user';
        _user?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'BuiltCommunityUser', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$BuiltCommunity extends BuiltCommunity {
  @override
  final String communityId;
  @override
  final String name;
  @override
  final String description;
  @override
  final String avatar;
  @override
  final String coverImage;
  @override
  final SummaryUser creator;
  @override
  final BuiltSet<String> hosts;
  @override
  final int liveClubCount;
  @override
  final int scheduledClubCount;
  @override
  final int memberCount;

  factory _$BuiltCommunity([void Function(BuiltCommunityBuilder) updates]) =>
      (new BuiltCommunityBuilder()..update(updates)).build();

  _$BuiltCommunity._(
      {this.communityId,
      this.name,
      this.description,
      this.avatar,
      this.coverImage,
      this.creator,
      this.hosts,
      this.liveClubCount,
      this.scheduledClubCount,
      this.memberCount})
      : super._();

  @override
  BuiltCommunity rebuild(void Function(BuiltCommunityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltCommunityBuilder toBuilder() =>
      new BuiltCommunityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltCommunity &&
        communityId == other.communityId &&
        name == other.name &&
        description == other.description &&
        avatar == other.avatar &&
        coverImage == other.coverImage &&
        creator == other.creator &&
        hosts == other.hosts &&
        liveClubCount == other.liveClubCount &&
        scheduledClubCount == other.scheduledClubCount &&
        memberCount == other.memberCount;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc($jc(0, communityId.hashCode),
                                        name.hashCode),
                                    description.hashCode),
                                avatar.hashCode),
                            coverImage.hashCode),
                        creator.hashCode),
                    hosts.hashCode),
                liveClubCount.hashCode),
            scheduledClubCount.hashCode),
        memberCount.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuiltCommunity')
          ..add('communityId', communityId)
          ..add('name', name)
          ..add('description', description)
          ..add('avatar', avatar)
          ..add('coverImage', coverImage)
          ..add('creator', creator)
          ..add('hosts', hosts)
          ..add('liveClubCount', liveClubCount)
          ..add('scheduledClubCount', scheduledClubCount)
          ..add('memberCount', memberCount))
        .toString();
  }
}

class BuiltCommunityBuilder
    implements Builder<BuiltCommunity, BuiltCommunityBuilder> {
  _$BuiltCommunity _$v;

  String _communityId;
  String get communityId => _$this._communityId;
  set communityId(String communityId) => _$this._communityId = communityId;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  String _avatar;
  String get avatar => _$this._avatar;
  set avatar(String avatar) => _$this._avatar = avatar;

  String _coverImage;
  String get coverImage => _$this._coverImage;
  set coverImage(String coverImage) => _$this._coverImage = coverImage;

  SummaryUserBuilder _creator;
  SummaryUserBuilder get creator =>
      _$this._creator ??= new SummaryUserBuilder();
  set creator(SummaryUserBuilder creator) => _$this._creator = creator;

  SetBuilder<String> _hosts;
  SetBuilder<String> get hosts => _$this._hosts ??= new SetBuilder<String>();
  set hosts(SetBuilder<String> hosts) => _$this._hosts = hosts;

  int _liveClubCount;
  int get liveClubCount => _$this._liveClubCount;
  set liveClubCount(int liveClubCount) => _$this._liveClubCount = liveClubCount;

  int _scheduledClubCount;
  int get scheduledClubCount => _$this._scheduledClubCount;
  set scheduledClubCount(int scheduledClubCount) =>
      _$this._scheduledClubCount = scheduledClubCount;

  int _memberCount;
  int get memberCount => _$this._memberCount;
  set memberCount(int memberCount) => _$this._memberCount = memberCount;

  BuiltCommunityBuilder();

  BuiltCommunityBuilder get _$this {
    if (_$v != null) {
      _communityId = _$v.communityId;
      _name = _$v.name;
      _description = _$v.description;
      _avatar = _$v.avatar;
      _coverImage = _$v.coverImage;
      _creator = _$v.creator?.toBuilder();
      _hosts = _$v.hosts?.toBuilder();
      _liveClubCount = _$v.liveClubCount;
      _scheduledClubCount = _$v.scheduledClubCount;
      _memberCount = _$v.memberCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltCommunity other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuiltCommunity;
  }

  @override
  void update(void Function(BuiltCommunityBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuiltCommunity build() {
    _$BuiltCommunity _$result;
    try {
      _$result = _$v ??
          new _$BuiltCommunity._(
              communityId: communityId,
              name: name,
              description: description,
              avatar: avatar,
              coverImage: coverImage,
              creator: _creator?.build(),
              hosts: _hosts?.build(),
              liveClubCount: liveClubCount,
              scheduledClubCount: scheduledClubCount,
              memberCount: memberCount);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'creator';
        _creator?.build();
        _$failedField = 'hosts';
        _hosts?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'BuiltCommunity', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$AppConfigs extends AppConfigs {
  @override
  final String minAppVersion;

  factory _$AppConfigs([void Function(AppConfigsBuilder) updates]) =>
      (new AppConfigsBuilder()..update(updates)).build();

  _$AppConfigs._({this.minAppVersion}) : super._();

  @override
  AppConfigs rebuild(void Function(AppConfigsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppConfigsBuilder toBuilder() => new AppConfigsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppConfigs && minAppVersion == other.minAppVersion;
  }

  @override
  int get hashCode {
    return $jf($jc(0, minAppVersion.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AppConfigs')
          ..add('minAppVersion', minAppVersion))
        .toString();
  }
}

class AppConfigsBuilder implements Builder<AppConfigs, AppConfigsBuilder> {
  _$AppConfigs _$v;

  String _minAppVersion;
  String get minAppVersion => _$this._minAppVersion;
  set minAppVersion(String minAppVersion) =>
      _$this._minAppVersion = minAppVersion;

  AppConfigsBuilder();

  AppConfigsBuilder get _$this {
    if (_$v != null) {
      _minAppVersion = _$v.minAppVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppConfigs other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AppConfigs;
  }

  @override
  void update(void Function(AppConfigsBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AppConfigs build() {
    final _$result = _$v ?? new _$AppConfigs._(minAppVersion: minAppVersion);
    replace(_$result);
    return _$result;
  }
}

class _$UsernameAvailability extends UsernameAvailability {
  @override
  final bool isAvailable;

  factory _$UsernameAvailability(
          [void Function(UsernameAvailabilityBuilder) updates]) =>
      (new UsernameAvailabilityBuilder()..update(updates)).build();

  _$UsernameAvailability._({this.isAvailable}) : super._();

  @override
  UsernameAvailability rebuild(
          void Function(UsernameAvailabilityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UsernameAvailabilityBuilder toBuilder() =>
      new UsernameAvailabilityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UsernameAvailability && isAvailable == other.isAvailable;
  }

  @override
  int get hashCode {
    return $jf($jc(0, isAvailable.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('UsernameAvailability')
          ..add('isAvailable', isAvailable))
        .toString();
  }
}

class UsernameAvailabilityBuilder
    implements Builder<UsernameAvailability, UsernameAvailabilityBuilder> {
  _$UsernameAvailability _$v;

  bool _isAvailable;
  bool get isAvailable => _$this._isAvailable;
  set isAvailable(bool isAvailable) => _$this._isAvailable = isAvailable;

  UsernameAvailabilityBuilder();

  UsernameAvailabilityBuilder get _$this {
    if (_$v != null) {
      _isAvailable = _$v.isAvailable;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UsernameAvailability other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$UsernameAvailability;
  }

  @override
  void update(void Function(UsernameAvailabilityBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$UsernameAvailability build() {
    final _$result =
        _$v ?? new _$UsernameAvailability._(isAvailable: isAvailable);
    replace(_$result);
    return _$result;
  }
}

class _$BuiltAudienceList extends BuiltAudienceList {
  @override
  final BuiltList<AudienceData> audience;
  @override
  final String lastevaluatedkey;

  factory _$BuiltAudienceList(
          [void Function(BuiltAudienceListBuilder) updates]) =>
      (new BuiltAudienceListBuilder()..update(updates)).build();

  _$BuiltAudienceList._({this.audience, this.lastevaluatedkey}) : super._();

  @override
  BuiltAudienceList rebuild(void Function(BuiltAudienceListBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltAudienceListBuilder toBuilder() =>
      new BuiltAudienceListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltAudienceList &&
        audience == other.audience &&
        lastevaluatedkey == other.lastevaluatedkey;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, audience.hashCode), lastevaluatedkey.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuiltAudienceList')
          ..add('audience', audience)
          ..add('lastevaluatedkey', lastevaluatedkey))
        .toString();
  }
}

class BuiltAudienceListBuilder
    implements Builder<BuiltAudienceList, BuiltAudienceListBuilder> {
  _$BuiltAudienceList _$v;

  ListBuilder<AudienceData> _audience;
  ListBuilder<AudienceData> get audience =>
      _$this._audience ??= new ListBuilder<AudienceData>();
  set audience(ListBuilder<AudienceData> audience) =>
      _$this._audience = audience;

  String _lastevaluatedkey;
  String get lastevaluatedkey => _$this._lastevaluatedkey;
  set lastevaluatedkey(String lastevaluatedkey) =>
      _$this._lastevaluatedkey = lastevaluatedkey;

  BuiltAudienceListBuilder();

  BuiltAudienceListBuilder get _$this {
    if (_$v != null) {
      _audience = _$v.audience?.toBuilder();
      _lastevaluatedkey = _$v.lastevaluatedkey;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltAudienceList other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuiltAudienceList;
  }

  @override
  void update(void Function(BuiltAudienceListBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuiltAudienceList build() {
    _$BuiltAudienceList _$result;
    try {
      _$result = _$v ??
          new _$BuiltAudienceList._(
              audience: _audience?.build(), lastevaluatedkey: lastevaluatedkey);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'audience';
        _audience?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'BuiltAudienceList', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$RelationActionResponse extends RelationActionResponse {
  @override
  final RelationIndexObject relationIndexObj;
  @override
  final int friendsCount;
  @override
  final int followerCount;
  @override
  final int followingCount;

  factory _$RelationActionResponse(
          [void Function(RelationActionResponseBuilder) updates]) =>
      (new RelationActionResponseBuilder()..update(updates)).build();

  _$RelationActionResponse._(
      {this.relationIndexObj,
      this.friendsCount,
      this.followerCount,
      this.followingCount})
      : super._();

  @override
  RelationActionResponse rebuild(
          void Function(RelationActionResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RelationActionResponseBuilder toBuilder() =>
      new RelationActionResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RelationActionResponse &&
        relationIndexObj == other.relationIndexObj &&
        friendsCount == other.friendsCount &&
        followerCount == other.followerCount &&
        followingCount == other.followingCount;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, relationIndexObj.hashCode), friendsCount.hashCode),
            followerCount.hashCode),
        followingCount.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('RelationActionResponse')
          ..add('relationIndexObj', relationIndexObj)
          ..add('friendsCount', friendsCount)
          ..add('followerCount', followerCount)
          ..add('followingCount', followingCount))
        .toString();
  }
}

class RelationActionResponseBuilder
    implements Builder<RelationActionResponse, RelationActionResponseBuilder> {
  _$RelationActionResponse _$v;

  RelationIndexObjectBuilder _relationIndexObj;
  RelationIndexObjectBuilder get relationIndexObj =>
      _$this._relationIndexObj ??= new RelationIndexObjectBuilder();
  set relationIndexObj(RelationIndexObjectBuilder relationIndexObj) =>
      _$this._relationIndexObj = relationIndexObj;

  int _friendsCount;
  int get friendsCount => _$this._friendsCount;
  set friendsCount(int friendsCount) => _$this._friendsCount = friendsCount;

  int _followerCount;
  int get followerCount => _$this._followerCount;
  set followerCount(int followerCount) => _$this._followerCount = followerCount;

  int _followingCount;
  int get followingCount => _$this._followingCount;
  set followingCount(int followingCount) =>
      _$this._followingCount = followingCount;

  RelationActionResponseBuilder();

  RelationActionResponseBuilder get _$this {
    if (_$v != null) {
      _relationIndexObj = _$v.relationIndexObj?.toBuilder();
      _friendsCount = _$v.friendsCount;
      _followerCount = _$v.followerCount;
      _followingCount = _$v.followingCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RelationActionResponse other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$RelationActionResponse;
  }

  @override
  void update(void Function(RelationActionResponseBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$RelationActionResponse build() {
    _$RelationActionResponse _$result;
    try {
      _$result = _$v ??
          new _$RelationActionResponse._(
              relationIndexObj: _relationIndexObj?.build(),
              friendsCount: friendsCount,
              followerCount: followerCount,
              followingCount: followingCount);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'relationIndexObj';
        _relationIndexObj?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'RelationActionResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$NotificationData extends NotificationData {
  @override
  final NotificationType type;
  @override
  final String title;
  @override
  final String avatar;
  @override
  final int timestamp;
  @override
  final String targetResourceId;
  @override
  final String notificationId;
  @override
  final bool opened;
  @override
  final String secondaryAvatar;

  factory _$NotificationData(
          [void Function(NotificationDataBuilder) updates]) =>
      (new NotificationDataBuilder()..update(updates)).build();

  _$NotificationData._(
      {this.type,
      this.title,
      this.avatar,
      this.timestamp,
      this.targetResourceId,
      this.notificationId,
      this.opened,
      this.secondaryAvatar})
      : super._();

  @override
  NotificationData rebuild(void Function(NotificationDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationDataBuilder toBuilder() =>
      new NotificationDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationData &&
        type == other.type &&
        title == other.title &&
        avatar == other.avatar &&
        timestamp == other.timestamp &&
        targetResourceId == other.targetResourceId &&
        notificationId == other.notificationId &&
        opened == other.opened &&
        secondaryAvatar == other.secondaryAvatar;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, type.hashCode), title.hashCode),
                            avatar.hashCode),
                        timestamp.hashCode),
                    targetResourceId.hashCode),
                notificationId.hashCode),
            opened.hashCode),
        secondaryAvatar.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('NotificationData')
          ..add('type', type)
          ..add('title', title)
          ..add('avatar', avatar)
          ..add('timestamp', timestamp)
          ..add('targetResourceId', targetResourceId)
          ..add('notificationId', notificationId)
          ..add('opened', opened)
          ..add('secondaryAvatar', secondaryAvatar))
        .toString();
  }
}

class NotificationDataBuilder
    implements Builder<NotificationData, NotificationDataBuilder> {
  _$NotificationData _$v;

  NotificationType _type;
  NotificationType get type => _$this._type;
  set type(NotificationType type) => _$this._type = type;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  String _avatar;
  String get avatar => _$this._avatar;
  set avatar(String avatar) => _$this._avatar = avatar;

  int _timestamp;
  int get timestamp => _$this._timestamp;
  set timestamp(int timestamp) => _$this._timestamp = timestamp;

  String _targetResourceId;
  String get targetResourceId => _$this._targetResourceId;
  set targetResourceId(String targetResourceId) =>
      _$this._targetResourceId = targetResourceId;

  String _notificationId;
  String get notificationId => _$this._notificationId;
  set notificationId(String notificationId) =>
      _$this._notificationId = notificationId;

  bool _opened;
  bool get opened => _$this._opened;
  set opened(bool opened) => _$this._opened = opened;

  String _secondaryAvatar;
  String get secondaryAvatar => _$this._secondaryAvatar;
  set secondaryAvatar(String secondaryAvatar) =>
      _$this._secondaryAvatar = secondaryAvatar;

  NotificationDataBuilder();

  NotificationDataBuilder get _$this {
    if (_$v != null) {
      _type = _$v.type;
      _title = _$v.title;
      _avatar = _$v.avatar;
      _timestamp = _$v.timestamp;
      _targetResourceId = _$v.targetResourceId;
      _notificationId = _$v.notificationId;
      _opened = _$v.opened;
      _secondaryAvatar = _$v.secondaryAvatar;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationData other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$NotificationData;
  }

  @override
  void update(void Function(NotificationDataBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$NotificationData build() {
    final _$result = _$v ??
        new _$NotificationData._(
            type: type,
            title: title,
            avatar: avatar,
            timestamp: timestamp,
            targetResourceId: targetResourceId,
            notificationId: notificationId,
            opened: opened,
            secondaryAvatar: secondaryAvatar);
    replace(_$result);
    return _$result;
  }
}

class _$BuiltNotificationList extends BuiltNotificationList {
  @override
  final BuiltList<NotificationData> notifications;
  @override
  final String lastevaluatedkey;

  factory _$BuiltNotificationList(
          [void Function(BuiltNotificationListBuilder) updates]) =>
      (new BuiltNotificationListBuilder()..update(updates)).build();

  _$BuiltNotificationList._({this.notifications, this.lastevaluatedkey})
      : super._();

  @override
  BuiltNotificationList rebuild(
          void Function(BuiltNotificationListBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltNotificationListBuilder toBuilder() =>
      new BuiltNotificationListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltNotificationList &&
        notifications == other.notifications &&
        lastevaluatedkey == other.lastevaluatedkey;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, notifications.hashCode), lastevaluatedkey.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuiltNotificationList')
          ..add('notifications', notifications)
          ..add('lastevaluatedkey', lastevaluatedkey))
        .toString();
  }
}

class BuiltNotificationListBuilder
    implements Builder<BuiltNotificationList, BuiltNotificationListBuilder> {
  _$BuiltNotificationList _$v;

  ListBuilder<NotificationData> _notifications;
  ListBuilder<NotificationData> get notifications =>
      _$this._notifications ??= new ListBuilder<NotificationData>();
  set notifications(ListBuilder<NotificationData> notifications) =>
      _$this._notifications = notifications;

  String _lastevaluatedkey;
  String get lastevaluatedkey => _$this._lastevaluatedkey;
  set lastevaluatedkey(String lastevaluatedkey) =>
      _$this._lastevaluatedkey = lastevaluatedkey;

  BuiltNotificationListBuilder();

  BuiltNotificationListBuilder get _$this {
    if (_$v != null) {
      _notifications = _$v.notifications?.toBuilder();
      _lastevaluatedkey = _$v.lastevaluatedkey;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltNotificationList other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuiltNotificationList;
  }

  @override
  void update(void Function(BuiltNotificationListBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuiltNotificationList build() {
    _$BuiltNotificationList _$result;
    try {
      _$result = _$v ??
          new _$BuiltNotificationList._(
              notifications: _notifications?.build(),
              lastevaluatedkey: lastevaluatedkey);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'notifications';
        _notifications?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'BuiltNotificationList', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$BuiltFCMToken extends BuiltFCMToken {
  @override
  final String deviceToken;

  factory _$BuiltFCMToken([void Function(BuiltFCMTokenBuilder) updates]) =>
      (new BuiltFCMTokenBuilder()..update(updates)).build();

  _$BuiltFCMToken._({this.deviceToken}) : super._();

  @override
  BuiltFCMToken rebuild(void Function(BuiltFCMTokenBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltFCMTokenBuilder toBuilder() => new BuiltFCMTokenBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltFCMToken && deviceToken == other.deviceToken;
  }

  @override
  int get hashCode {
    return $jf($jc(0, deviceToken.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuiltFCMToken')
          ..add('deviceToken', deviceToken))
        .toString();
  }
}

class BuiltFCMTokenBuilder
    implements Builder<BuiltFCMToken, BuiltFCMTokenBuilder> {
  _$BuiltFCMToken _$v;

  String _deviceToken;
  String get deviceToken => _$this._deviceToken;
  set deviceToken(String deviceToken) => _$this._deviceToken = deviceToken;

  BuiltFCMTokenBuilder();

  BuiltFCMTokenBuilder get _$this {
    if (_$v != null) {
      _deviceToken = _$v.deviceToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltFCMToken other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuiltFCMToken;
  }

  @override
  void update(void Function(BuiltFCMTokenBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuiltFCMToken build() {
    final _$result = _$v ?? new _$BuiltFCMToken._(deviceToken: deviceToken);
    replace(_$result);
    return _$result;
  }
}

class _$RelationIndexObject extends RelationIndexObject {
  @override
  final bool B1;
  @override
  final bool B2;
  @override
  final bool B3;
  @override
  final bool B4;
  @override
  final bool B5;

  factory _$RelationIndexObject(
          [void Function(RelationIndexObjectBuilder) updates]) =>
      (new RelationIndexObjectBuilder()..update(updates)).build();

  _$RelationIndexObject._({this.B1, this.B2, this.B3, this.B4, this.B5})
      : super._() {
    if (B1 == null) {
      throw new BuiltValueNullFieldError('RelationIndexObject', 'B1');
    }
    if (B2 == null) {
      throw new BuiltValueNullFieldError('RelationIndexObject', 'B2');
    }
    if (B3 == null) {
      throw new BuiltValueNullFieldError('RelationIndexObject', 'B3');
    }
    if (B4 == null) {
      throw new BuiltValueNullFieldError('RelationIndexObject', 'B4');
    }
    if (B5 == null) {
      throw new BuiltValueNullFieldError('RelationIndexObject', 'B5');
    }
  }

  @override
  RelationIndexObject rebuild(
          void Function(RelationIndexObjectBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RelationIndexObjectBuilder toBuilder() =>
      new RelationIndexObjectBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RelationIndexObject &&
        B1 == other.B1 &&
        B2 == other.B2 &&
        B3 == other.B3 &&
        B4 == other.B4 &&
        B5 == other.B5;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, B1.hashCode), B2.hashCode), B3.hashCode),
            B4.hashCode),
        B5.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('RelationIndexObject')
          ..add('B1', B1)
          ..add('B2', B2)
          ..add('B3', B3)
          ..add('B4', B4)
          ..add('B5', B5))
        .toString();
  }
}

class RelationIndexObjectBuilder
    implements Builder<RelationIndexObject, RelationIndexObjectBuilder> {
  _$RelationIndexObject _$v;

  bool _B1;
  bool get B1 => _$this._B1;
  set B1(bool B1) => _$this._B1 = B1;

  bool _B2;
  bool get B2 => _$this._B2;
  set B2(bool B2) => _$this._B2 = B2;

  bool _B3;
  bool get B3 => _$this._B3;
  set B3(bool B3) => _$this._B3 = B3;

  bool _B4;
  bool get B4 => _$this._B4;
  set B4(bool B4) => _$this._B4 = B4;

  bool _B5;
  bool get B5 => _$this._B5;
  set B5(bool B5) => _$this._B5 = B5;

  RelationIndexObjectBuilder();

  RelationIndexObjectBuilder get _$this {
    if (_$v != null) {
      _B1 = _$v.B1;
      _B2 = _$v.B2;
      _B3 = _$v.B3;
      _B4 = _$v.B4;
      _B5 = _$v.B5;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RelationIndexObject other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$RelationIndexObject;
  }

  @override
  void update(void Function(RelationIndexObjectBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$RelationIndexObject build() {
    final _$result = _$v ??
        new _$RelationIndexObject._(B1: B1, B2: B2, B3: B3, B4: B4, B5: B5);
    replace(_$result);
    return _$result;
  }
}

class _$BuiltProfile extends BuiltProfile {
  @override
  final BuiltUser user;
  @override
  final RelationIndexObject relationIndexObj;

  factory _$BuiltProfile([void Function(BuiltProfileBuilder) updates]) =>
      (new BuiltProfileBuilder()..update(updates)).build();

  _$BuiltProfile._({this.user, this.relationIndexObj}) : super._() {
    if (user == null) {
      throw new BuiltValueNullFieldError('BuiltProfile', 'user');
    }
  }

  @override
  BuiltProfile rebuild(void Function(BuiltProfileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltProfileBuilder toBuilder() => new BuiltProfileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltProfile &&
        user == other.user &&
        relationIndexObj == other.relationIndexObj;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, user.hashCode), relationIndexObj.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuiltProfile')
          ..add('user', user)
          ..add('relationIndexObj', relationIndexObj))
        .toString();
  }
}

class BuiltProfileBuilder
    implements Builder<BuiltProfile, BuiltProfileBuilder> {
  _$BuiltProfile _$v;

  BuiltUserBuilder _user;
  BuiltUserBuilder get user => _$this._user ??= new BuiltUserBuilder();
  set user(BuiltUserBuilder user) => _$this._user = user;

  RelationIndexObjectBuilder _relationIndexObj;
  RelationIndexObjectBuilder get relationIndexObj =>
      _$this._relationIndexObj ??= new RelationIndexObjectBuilder();
  set relationIndexObj(RelationIndexObjectBuilder relationIndexObj) =>
      _$this._relationIndexObj = relationIndexObj;

  BuiltProfileBuilder();

  BuiltProfileBuilder get _$this {
    if (_$v != null) {
      _user = _$v.user?.toBuilder();
      _relationIndexObj = _$v.relationIndexObj?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltProfile other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuiltProfile;
  }

  @override
  void update(void Function(BuiltProfileBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuiltProfile build() {
    _$BuiltProfile _$result;
    try {
      _$result = _$v ??
          new _$BuiltProfile._(
              user: user.build(), relationIndexObj: _relationIndexObj?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
        _$failedField = 'relationIndexObj';
        _relationIndexObj?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'BuiltProfile', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$BuiltUser extends BuiltUser {
  @override
  final String userId;
  @override
  final String username;
  @override
  final String name;
  @override
  final String email;
  @override
  final String phone;
  @override
  final String avatar;
  @override
  final String tagline;
  @override
  final int online;
  @override
  final String bio;
  @override
  final int friendsCount;
  @override
  final int followerCount;
  @override
  final int followingCount;
  @override
  final String languagePreference;
  @override
  final String regionCode;
  @override
  final double geoLat;
  @override
  final double geoLong;
  @override
  final bool isBlackListed;
  @override
  final bool termsAccepted;
  @override
  final bool policyAccepted;
  @override
  final int clubsCreated;
  @override
  final int clubsParticipated;
  @override
  final int kickedOutCount;
  @override
  final int clubsJoinRequests;
  @override
  final int clubsAttended;

  factory _$BuiltUser([void Function(BuiltUserBuilder) updates]) =>
      (new BuiltUserBuilder()..update(updates)).build();

  _$BuiltUser._(
      {this.userId,
      this.username,
      this.name,
      this.email,
      this.phone,
      this.avatar,
      this.tagline,
      this.online,
      this.bio,
      this.friendsCount,
      this.followerCount,
      this.followingCount,
      this.languagePreference,
      this.regionCode,
      this.geoLat,
      this.geoLong,
      this.isBlackListed,
      this.termsAccepted,
      this.policyAccepted,
      this.clubsCreated,
      this.clubsParticipated,
      this.kickedOutCount,
      this.clubsJoinRequests,
      this.clubsAttended})
      : super._();

  @override
  BuiltUser rebuild(void Function(BuiltUserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltUserBuilder toBuilder() => new BuiltUserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltUser &&
        userId == other.userId &&
        username == other.username &&
        name == other.name &&
        email == other.email &&
        phone == other.phone &&
        avatar == other.avatar &&
        tagline == other.tagline &&
        online == other.online &&
        bio == other.bio &&
        friendsCount == other.friendsCount &&
        followerCount == other.followerCount &&
        followingCount == other.followingCount &&
        languagePreference == other.languagePreference &&
        regionCode == other.regionCode &&
        geoLat == other.geoLat &&
        geoLong == other.geoLong &&
        isBlackListed == other.isBlackListed &&
        termsAccepted == other.termsAccepted &&
        policyAccepted == other.policyAccepted &&
        clubsCreated == other.clubsCreated &&
        clubsParticipated == other.clubsParticipated &&
        kickedOutCount == other.kickedOutCount &&
        clubsJoinRequests == other.clubsJoinRequests &&
        clubsAttended == other.clubsAttended;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc(
                                                $jc(
                                                    $jc(
                                                        $jc(
                                                            $jc(
                                                                $jc(
                                                                    $jc(
                                                                        $jc(
                                                                            $jc($jc($jc($jc($jc($jc(0, userId.hashCode), username.hashCode), name.hashCode), email.hashCode), phone.hashCode),
                                                                                avatar.hashCode),
                                                                            tagline.hashCode),
                                                                        online.hashCode),
                                                                    bio.hashCode),
                                                                friendsCount.hashCode),
                                                            followerCount.hashCode),
                                                        followingCount.hashCode),
                                                    languagePreference.hashCode),
                                                regionCode.hashCode),
                                            geoLat.hashCode),
                                        geoLong.hashCode),
                                    isBlackListed.hashCode),
                                termsAccepted.hashCode),
                            policyAccepted.hashCode),
                        clubsCreated.hashCode),
                    clubsParticipated.hashCode),
                kickedOutCount.hashCode),
            clubsJoinRequests.hashCode),
        clubsAttended.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuiltUser')
          ..add('userId', userId)
          ..add('username', username)
          ..add('name', name)
          ..add('email', email)
          ..add('phone', phone)
          ..add('avatar', avatar)
          ..add('tagline', tagline)
          ..add('online', online)
          ..add('bio', bio)
          ..add('friendsCount', friendsCount)
          ..add('followerCount', followerCount)
          ..add('followingCount', followingCount)
          ..add('languagePreference', languagePreference)
          ..add('regionCode', regionCode)
          ..add('geoLat', geoLat)
          ..add('geoLong', geoLong)
          ..add('isBlackListed', isBlackListed)
          ..add('termsAccepted', termsAccepted)
          ..add('policyAccepted', policyAccepted)
          ..add('clubsCreated', clubsCreated)
          ..add('clubsParticipated', clubsParticipated)
          ..add('kickedOutCount', kickedOutCount)
          ..add('clubsJoinRequests', clubsJoinRequests)
          ..add('clubsAttended', clubsAttended))
        .toString();
  }
}

class BuiltUserBuilder implements Builder<BuiltUser, BuiltUserBuilder> {
  _$BuiltUser _$v;

  String _userId;
  String get userId => _$this._userId;
  set userId(String userId) => _$this._userId = userId;

  String _username;
  String get username => _$this._username;
  set username(String username) => _$this._username = username;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _email;
  String get email => _$this._email;
  set email(String email) => _$this._email = email;

  String _phone;
  String get phone => _$this._phone;
  set phone(String phone) => _$this._phone = phone;

  String _avatar;
  String get avatar => _$this._avatar;
  set avatar(String avatar) => _$this._avatar = avatar;

  String _tagline;
  String get tagline => _$this._tagline;
  set tagline(String tagline) => _$this._tagline = tagline;

  int _online;
  int get online => _$this._online;
  set online(int online) => _$this._online = online;

  String _bio;
  String get bio => _$this._bio;
  set bio(String bio) => _$this._bio = bio;

  int _friendsCount;
  int get friendsCount => _$this._friendsCount;
  set friendsCount(int friendsCount) => _$this._friendsCount = friendsCount;

  int _followerCount;
  int get followerCount => _$this._followerCount;
  set followerCount(int followerCount) => _$this._followerCount = followerCount;

  int _followingCount;
  int get followingCount => _$this._followingCount;
  set followingCount(int followingCount) =>
      _$this._followingCount = followingCount;

  String _languagePreference;
  String get languagePreference => _$this._languagePreference;
  set languagePreference(String languagePreference) =>
      _$this._languagePreference = languagePreference;

  String _regionCode;
  String get regionCode => _$this._regionCode;
  set regionCode(String regionCode) => _$this._regionCode = regionCode;

  double _geoLat;
  double get geoLat => _$this._geoLat;
  set geoLat(double geoLat) => _$this._geoLat = geoLat;

  double _geoLong;
  double get geoLong => _$this._geoLong;
  set geoLong(double geoLong) => _$this._geoLong = geoLong;

  bool _isBlackListed;
  bool get isBlackListed => _$this._isBlackListed;
  set isBlackListed(bool isBlackListed) =>
      _$this._isBlackListed = isBlackListed;

  bool _termsAccepted;
  bool get termsAccepted => _$this._termsAccepted;
  set termsAccepted(bool termsAccepted) =>
      _$this._termsAccepted = termsAccepted;

  bool _policyAccepted;
  bool get policyAccepted => _$this._policyAccepted;
  set policyAccepted(bool policyAccepted) =>
      _$this._policyAccepted = policyAccepted;

  int _clubsCreated;
  int get clubsCreated => _$this._clubsCreated;
  set clubsCreated(int clubsCreated) => _$this._clubsCreated = clubsCreated;

  int _clubsParticipated;
  int get clubsParticipated => _$this._clubsParticipated;
  set clubsParticipated(int clubsParticipated) =>
      _$this._clubsParticipated = clubsParticipated;

  int _kickedOutCount;
  int get kickedOutCount => _$this._kickedOutCount;
  set kickedOutCount(int kickedOutCount) =>
      _$this._kickedOutCount = kickedOutCount;

  int _clubsJoinRequests;
  int get clubsJoinRequests => _$this._clubsJoinRequests;
  set clubsJoinRequests(int clubsJoinRequests) =>
      _$this._clubsJoinRequests = clubsJoinRequests;

  int _clubsAttended;
  int get clubsAttended => _$this._clubsAttended;
  set clubsAttended(int clubsAttended) => _$this._clubsAttended = clubsAttended;

  BuiltUserBuilder();

  BuiltUserBuilder get _$this {
    if (_$v != null) {
      _userId = _$v.userId;
      _username = _$v.username;
      _name = _$v.name;
      _email = _$v.email;
      _phone = _$v.phone;
      _avatar = _$v.avatar;
      _tagline = _$v.tagline;
      _online = _$v.online;
      _bio = _$v.bio;
      _friendsCount = _$v.friendsCount;
      _followerCount = _$v.followerCount;
      _followingCount = _$v.followingCount;
      _languagePreference = _$v.languagePreference;
      _regionCode = _$v.regionCode;
      _geoLat = _$v.geoLat;
      _geoLong = _$v.geoLong;
      _isBlackListed = _$v.isBlackListed;
      _termsAccepted = _$v.termsAccepted;
      _policyAccepted = _$v.policyAccepted;
      _clubsCreated = _$v.clubsCreated;
      _clubsParticipated = _$v.clubsParticipated;
      _kickedOutCount = _$v.kickedOutCount;
      _clubsJoinRequests = _$v.clubsJoinRequests;
      _clubsAttended = _$v.clubsAttended;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltUser other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuiltUser;
  }

  @override
  void update(void Function(BuiltUserBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuiltUser build() {
    final _$result = _$v ??
        new _$BuiltUser._(
            userId: userId,
            username: username,
            name: name,
            email: email,
            phone: phone,
            avatar: avatar,
            tagline: tagline,
            online: online,
            bio: bio,
            friendsCount: friendsCount,
            followerCount: followerCount,
            followingCount: followingCount,
            languagePreference: languagePreference,
            regionCode: regionCode,
            geoLat: geoLat,
            geoLong: geoLong,
            isBlackListed: isBlackListed,
            termsAccepted: termsAccepted,
            policyAccepted: policyAccepted,
            clubsCreated: clubsCreated,
            clubsParticipated: clubsParticipated,
            kickedOutCount: kickedOutCount,
            clubsJoinRequests: clubsJoinRequests,
            clubsAttended: clubsAttended);
    replace(_$result);
    return _$result;
  }
}

class _$BuiltProfileImage extends BuiltProfileImage {
  @override
  final String image;

  factory _$BuiltProfileImage(
          [void Function(BuiltProfileImageBuilder) updates]) =>
      (new BuiltProfileImageBuilder()..update(updates)).build();

  _$BuiltProfileImage._({this.image}) : super._();

  @override
  BuiltProfileImage rebuild(void Function(BuiltProfileImageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltProfileImageBuilder toBuilder() =>
      new BuiltProfileImageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltProfileImage && image == other.image;
  }

  @override
  int get hashCode {
    return $jf($jc(0, image.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuiltProfileImage')
          ..add('image', image))
        .toString();
  }
}

class BuiltProfileImageBuilder
    implements Builder<BuiltProfileImage, BuiltProfileImageBuilder> {
  _$BuiltProfileImage _$v;

  String _image;
  String get image => _$this._image;
  set image(String image) => _$this._image = image;

  BuiltProfileImageBuilder();

  BuiltProfileImageBuilder get _$this {
    if (_$v != null) {
      _image = _$v.image;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltProfileImage other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuiltProfileImage;
  }

  @override
  void update(void Function(BuiltProfileImageBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuiltProfileImage build() {
    final _$result = _$v ?? new _$BuiltProfileImage._(image: image);
    replace(_$result);
    return _$result;
  }
}

class _$BuiltFollow extends BuiltFollow {
  @override
  final String username;
  @override
  final String followername;
  @override
  final String userImageUrl;
  @override
  final String followerImageUrl;
  @override
  final String name;
  @override
  final String followerName;

  factory _$BuiltFollow([void Function(BuiltFollowBuilder) updates]) =>
      (new BuiltFollowBuilder()..update(updates)).build();

  _$BuiltFollow._(
      {this.username,
      this.followername,
      this.userImageUrl,
      this.followerImageUrl,
      this.name,
      this.followerName})
      : super._();

  @override
  BuiltFollow rebuild(void Function(BuiltFollowBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltFollowBuilder toBuilder() => new BuiltFollowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltFollow &&
        username == other.username &&
        followername == other.followername &&
        userImageUrl == other.userImageUrl &&
        followerImageUrl == other.followerImageUrl &&
        name == other.name &&
        followerName == other.followerName;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc($jc($jc(0, username.hashCode), followername.hashCode),
                    userImageUrl.hashCode),
                followerImageUrl.hashCode),
            name.hashCode),
        followerName.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuiltFollow')
          ..add('username', username)
          ..add('followername', followername)
          ..add('userImageUrl', userImageUrl)
          ..add('followerImageUrl', followerImageUrl)
          ..add('name', name)
          ..add('followerName', followerName))
        .toString();
  }
}

class BuiltFollowBuilder implements Builder<BuiltFollow, BuiltFollowBuilder> {
  _$BuiltFollow _$v;

  String _username;
  String get username => _$this._username;
  set username(String username) => _$this._username = username;

  String _followername;
  String get followername => _$this._followername;
  set followername(String followername) => _$this._followername = followername;

  String _userImageUrl;
  String get userImageUrl => _$this._userImageUrl;
  set userImageUrl(String userImageUrl) => _$this._userImageUrl = userImageUrl;

  String _followerImageUrl;
  String get followerImageUrl => _$this._followerImageUrl;
  set followerImageUrl(String followerImageUrl) =>
      _$this._followerImageUrl = followerImageUrl;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _followerName;
  String get followerName => _$this._followerName;
  set followerName(String followerName) => _$this._followerName = followerName;

  BuiltFollowBuilder();

  BuiltFollowBuilder get _$this {
    if (_$v != null) {
      _username = _$v.username;
      _followername = _$v.followername;
      _userImageUrl = _$v.userImageUrl;
      _followerImageUrl = _$v.followerImageUrl;
      _name = _$v.name;
      _followerName = _$v.followerName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltFollow other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuiltFollow;
  }

  @override
  void update(void Function(BuiltFollowBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuiltFollow build() {
    final _$result = _$v ??
        new _$BuiltFollow._(
            username: username,
            followername: followername,
            userImageUrl: userImageUrl,
            followerImageUrl: followerImageUrl,
            name: name,
            followerName: followerName);
    replace(_$result);
    return _$result;
  }
}

class _$BuiltClubAndAudience extends BuiltClubAndAudience {
  @override
  final BuiltClub club;
  @override
  final AudienceData audienceData;
  @override
  final int reactionIndexValue;

  factory _$BuiltClubAndAudience(
          [void Function(BuiltClubAndAudienceBuilder) updates]) =>
      (new BuiltClubAndAudienceBuilder()..update(updates)).build();

  _$BuiltClubAndAudience._(
      {this.club, this.audienceData, this.reactionIndexValue})
      : super._();

  @override
  BuiltClubAndAudience rebuild(
          void Function(BuiltClubAndAudienceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltClubAndAudienceBuilder toBuilder() =>
      new BuiltClubAndAudienceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltClubAndAudience &&
        club == other.club &&
        audienceData == other.audienceData &&
        reactionIndexValue == other.reactionIndexValue;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, club.hashCode), audienceData.hashCode),
        reactionIndexValue.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuiltClubAndAudience')
          ..add('club', club)
          ..add('audienceData', audienceData)
          ..add('reactionIndexValue', reactionIndexValue))
        .toString();
  }
}

class BuiltClubAndAudienceBuilder
    implements Builder<BuiltClubAndAudience, BuiltClubAndAudienceBuilder> {
  _$BuiltClubAndAudience _$v;

  BuiltClubBuilder _club;
  BuiltClubBuilder get club => _$this._club ??= new BuiltClubBuilder();
  set club(BuiltClubBuilder club) => _$this._club = club;

  AudienceDataBuilder _audienceData;
  AudienceDataBuilder get audienceData =>
      _$this._audienceData ??= new AudienceDataBuilder();
  set audienceData(AudienceDataBuilder audienceData) =>
      _$this._audienceData = audienceData;

  int _reactionIndexValue;
  int get reactionIndexValue => _$this._reactionIndexValue;
  set reactionIndexValue(int reactionIndexValue) =>
      _$this._reactionIndexValue = reactionIndexValue;

  BuiltClubAndAudienceBuilder();

  BuiltClubAndAudienceBuilder get _$this {
    if (_$v != null) {
      _club = _$v.club?.toBuilder();
      _audienceData = _$v.audienceData?.toBuilder();
      _reactionIndexValue = _$v.reactionIndexValue;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltClubAndAudience other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuiltClubAndAudience;
  }

  @override
  void update(void Function(BuiltClubAndAudienceBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuiltClubAndAudience build() {
    _$BuiltClubAndAudience _$result;
    try {
      _$result = _$v ??
          new _$BuiltClubAndAudience._(
              club: _club?.build(),
              audienceData: _audienceData?.build(),
              reactionIndexValue: reactionIndexValue);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'club';
        _club?.build();
        _$failedField = 'audienceData';
        _audienceData?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'BuiltClubAndAudience', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$AudienceData extends AudienceData {
  @override
  final AudienceStatus status;
  @override
  final bool isMuted;
  @override
  final int joinRequestAttempts;
  @override
  final SummaryUser audience;
  @override
  final String invitationId;
  @override
  final int timestamp;

  factory _$AudienceData([void Function(AudienceDataBuilder) updates]) =>
      (new AudienceDataBuilder()..update(updates)).build();

  _$AudienceData._(
      {this.status,
      this.isMuted,
      this.joinRequestAttempts,
      this.audience,
      this.invitationId,
      this.timestamp})
      : super._() {
    if (audience == null) {
      throw new BuiltValueNullFieldError('AudienceData', 'audience');
    }
  }

  @override
  AudienceData rebuild(void Function(AudienceDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AudienceDataBuilder toBuilder() => new AudienceDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AudienceData &&
        status == other.status &&
        isMuted == other.isMuted &&
        joinRequestAttempts == other.joinRequestAttempts &&
        audience == other.audience &&
        invitationId == other.invitationId &&
        timestamp == other.timestamp;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc($jc($jc(0, status.hashCode), isMuted.hashCode),
                    joinRequestAttempts.hashCode),
                audience.hashCode),
            invitationId.hashCode),
        timestamp.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AudienceData')
          ..add('status', status)
          ..add('isMuted', isMuted)
          ..add('joinRequestAttempts', joinRequestAttempts)
          ..add('audience', audience)
          ..add('invitationId', invitationId)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class AudienceDataBuilder
    implements Builder<AudienceData, AudienceDataBuilder> {
  _$AudienceData _$v;

  AudienceStatus _status;
  AudienceStatus get status => _$this._status;
  set status(AudienceStatus status) => _$this._status = status;

  bool _isMuted;
  bool get isMuted => _$this._isMuted;
  set isMuted(bool isMuted) => _$this._isMuted = isMuted;

  int _joinRequestAttempts;
  int get joinRequestAttempts => _$this._joinRequestAttempts;
  set joinRequestAttempts(int joinRequestAttempts) =>
      _$this._joinRequestAttempts = joinRequestAttempts;

  SummaryUserBuilder _audience;
  SummaryUserBuilder get audience =>
      _$this._audience ??= new SummaryUserBuilder();
  set audience(SummaryUserBuilder audience) => _$this._audience = audience;

  String _invitationId;
  String get invitationId => _$this._invitationId;
  set invitationId(String invitationId) => _$this._invitationId = invitationId;

  int _timestamp;
  int get timestamp => _$this._timestamp;
  set timestamp(int timestamp) => _$this._timestamp = timestamp;

  AudienceDataBuilder();

  AudienceDataBuilder get _$this {
    if (_$v != null) {
      _status = _$v.status;
      _isMuted = _$v.isMuted;
      _joinRequestAttempts = _$v.joinRequestAttempts;
      _audience = _$v.audience?.toBuilder();
      _invitationId = _$v.invitationId;
      _timestamp = _$v.timestamp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AudienceData other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AudienceData;
  }

  @override
  void update(void Function(AudienceDataBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AudienceData build() {
    _$AudienceData _$result;
    try {
      _$result = _$v ??
          new _$AudienceData._(
              status: status,
              isMuted: isMuted,
              joinRequestAttempts: joinRequestAttempts,
              audience: audience.build(),
              invitationId: invitationId,
              timestamp: timestamp);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'audience';
        audience.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'AudienceData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$BuiltClub extends BuiltClub {
  @override
  final String clubId;
  @override
  final String clubName;
  @override
  final SummaryUser creator;
  @override
  final ClubStatus status;
  @override
  final String category;
  @override
  final String subCategory;
  @override
  final BuiltCommunity community;
  @override
  final int createdOn;
  @override
  final int modifiedOn;
  @override
  final int scheduleTime;
  @override
  final String clubAvatar;
  @override
  final String description;
  @override
  final String externalUrl;
  @override
  final bool isLocal;
  @override
  final bool isGlobal;
  @override
  final bool isPrivate;
  @override
  final BuiltList<String> tags;
  @override
  final int estimatedAudience;
  @override
  final BuiltSet<String> participants;

  factory _$BuiltClub([void Function(BuiltClubBuilder) updates]) =>
      (new BuiltClubBuilder()..update(updates)).build();

  _$BuiltClub._(
      {this.clubId,
      this.clubName,
      this.creator,
      this.status,
      this.category,
      this.subCategory,
      this.community,
      this.createdOn,
      this.modifiedOn,
      this.scheduleTime,
      this.clubAvatar,
      this.description,
      this.externalUrl,
      this.isLocal,
      this.isGlobal,
      this.isPrivate,
      this.tags,
      this.estimatedAudience,
      this.participants})
      : super._();

  @override
  BuiltClub rebuild(void Function(BuiltClubBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltClubBuilder toBuilder() => new BuiltClubBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltClub &&
        clubId == other.clubId &&
        clubName == other.clubName &&
        creator == other.creator &&
        status == other.status &&
        category == other.category &&
        subCategory == other.subCategory &&
        community == other.community &&
        createdOn == other.createdOn &&
        modifiedOn == other.modifiedOn &&
        scheduleTime == other.scheduleTime &&
        clubAvatar == other.clubAvatar &&
        description == other.description &&
        externalUrl == other.externalUrl &&
        isLocal == other.isLocal &&
        isGlobal == other.isGlobal &&
        isPrivate == other.isPrivate &&
        tags == other.tags &&
        estimatedAudience == other.estimatedAudience &&
        participants == other.participants;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc(
                                                $jc(
                                                    $jc(
                                                        $jc(
                                                            $jc(
                                                                $jc(
                                                                    $jc(
                                                                        $jc(
                                                                            $jc(
                                                                                0,
                                                                                clubId
                                                                                    .hashCode),
                                                                            clubName
                                                                                .hashCode),
                                                                        creator
                                                                            .hashCode),
                                                                    status
                                                                        .hashCode),
                                                                category
                                                                    .hashCode),
                                                            subCategory
                                                                .hashCode),
                                                        community.hashCode),
                                                    createdOn.hashCode),
                                                modifiedOn.hashCode),
                                            scheduleTime.hashCode),
                                        clubAvatar.hashCode),
                                    description.hashCode),
                                externalUrl.hashCode),
                            isLocal.hashCode),
                        isGlobal.hashCode),
                    isPrivate.hashCode),
                tags.hashCode),
            estimatedAudience.hashCode),
        participants.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuiltClub')
          ..add('clubId', clubId)
          ..add('clubName', clubName)
          ..add('creator', creator)
          ..add('status', status)
          ..add('category', category)
          ..add('subCategory', subCategory)
          ..add('community', community)
          ..add('createdOn', createdOn)
          ..add('modifiedOn', modifiedOn)
          ..add('scheduleTime', scheduleTime)
          ..add('clubAvatar', clubAvatar)
          ..add('description', description)
          ..add('externalUrl', externalUrl)
          ..add('isLocal', isLocal)
          ..add('isGlobal', isGlobal)
          ..add('isPrivate', isPrivate)
          ..add('tags', tags)
          ..add('estimatedAudience', estimatedAudience)
          ..add('participants', participants))
        .toString();
  }
}

class BuiltClubBuilder implements Builder<BuiltClub, BuiltClubBuilder> {
  _$BuiltClub _$v;

  String _clubId;
  String get clubId => _$this._clubId;
  set clubId(String clubId) => _$this._clubId = clubId;

  String _clubName;
  String get clubName => _$this._clubName;
  set clubName(String clubName) => _$this._clubName = clubName;

  SummaryUserBuilder _creator;
  SummaryUserBuilder get creator =>
      _$this._creator ??= new SummaryUserBuilder();
  set creator(SummaryUserBuilder creator) => _$this._creator = creator;

  ClubStatus _status;
  ClubStatus get status => _$this._status;
  set status(ClubStatus status) => _$this._status = status;

  String _category;
  String get category => _$this._category;
  set category(String category) => _$this._category = category;

  String _subCategory;
  String get subCategory => _$this._subCategory;
  set subCategory(String subCategory) => _$this._subCategory = subCategory;

  BuiltCommunityBuilder _community;
  BuiltCommunityBuilder get community =>
      _$this._community ??= new BuiltCommunityBuilder();
  set community(BuiltCommunityBuilder community) =>
      _$this._community = community;

  int _createdOn;
  int get createdOn => _$this._createdOn;
  set createdOn(int createdOn) => _$this._createdOn = createdOn;

  int _modifiedOn;
  int get modifiedOn => _$this._modifiedOn;
  set modifiedOn(int modifiedOn) => _$this._modifiedOn = modifiedOn;

  int _scheduleTime;
  int get scheduleTime => _$this._scheduleTime;
  set scheduleTime(int scheduleTime) => _$this._scheduleTime = scheduleTime;

  String _clubAvatar;
  String get clubAvatar => _$this._clubAvatar;
  set clubAvatar(String clubAvatar) => _$this._clubAvatar = clubAvatar;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  String _externalUrl;
  String get externalUrl => _$this._externalUrl;
  set externalUrl(String externalUrl) => _$this._externalUrl = externalUrl;

  bool _isLocal;
  bool get isLocal => _$this._isLocal;
  set isLocal(bool isLocal) => _$this._isLocal = isLocal;

  bool _isGlobal;
  bool get isGlobal => _$this._isGlobal;
  set isGlobal(bool isGlobal) => _$this._isGlobal = isGlobal;

  bool _isPrivate;
  bool get isPrivate => _$this._isPrivate;
  set isPrivate(bool isPrivate) => _$this._isPrivate = isPrivate;

  ListBuilder<String> _tags;
  ListBuilder<String> get tags => _$this._tags ??= new ListBuilder<String>();
  set tags(ListBuilder<String> tags) => _$this._tags = tags;

  int _estimatedAudience;
  int get estimatedAudience => _$this._estimatedAudience;
  set estimatedAudience(int estimatedAudience) =>
      _$this._estimatedAudience = estimatedAudience;

  SetBuilder<String> _participants;
  SetBuilder<String> get participants =>
      _$this._participants ??= new SetBuilder<String>();
  set participants(SetBuilder<String> participants) =>
      _$this._participants = participants;

  BuiltClubBuilder();

  BuiltClubBuilder get _$this {
    if (_$v != null) {
      _clubId = _$v.clubId;
      _clubName = _$v.clubName;
      _creator = _$v.creator?.toBuilder();
      _status = _$v.status;
      _category = _$v.category;
      _subCategory = _$v.subCategory;
      _community = _$v.community?.toBuilder();
      _createdOn = _$v.createdOn;
      _modifiedOn = _$v.modifiedOn;
      _scheduleTime = _$v.scheduleTime;
      _clubAvatar = _$v.clubAvatar;
      _description = _$v.description;
      _externalUrl = _$v.externalUrl;
      _isLocal = _$v.isLocal;
      _isGlobal = _$v.isGlobal;
      _isPrivate = _$v.isPrivate;
      _tags = _$v.tags?.toBuilder();
      _estimatedAudience = _$v.estimatedAudience;
      _participants = _$v.participants?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltClub other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuiltClub;
  }

  @override
  void update(void Function(BuiltClubBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuiltClub build() {
    _$BuiltClub _$result;
    try {
      _$result = _$v ??
          new _$BuiltClub._(
              clubId: clubId,
              clubName: clubName,
              creator: _creator?.build(),
              status: status,
              category: category,
              subCategory: subCategory,
              community: _community?.build(),
              createdOn: createdOn,
              modifiedOn: modifiedOn,
              scheduleTime: scheduleTime,
              clubAvatar: clubAvatar,
              description: description,
              externalUrl: externalUrl,
              isLocal: isLocal,
              isGlobal: isGlobal,
              isPrivate: isPrivate,
              tags: _tags?.build(),
              estimatedAudience: estimatedAudience,
              participants: _participants?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'creator';
        _creator?.build();

        _$failedField = 'community';
        _community?.build();

        _$failedField = 'tags';
        _tags?.build();

        _$failedField = 'participants';
        _participants?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'BuiltClub', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$SummaryUser extends SummaryUser {
  @override
  final String userId;
  @override
  final String username;
  @override
  final String name;
  @override
  final String avatar;
  @override
  final String tagline;
  @override
  final int online;
  @override
  final String phone;

  factory _$SummaryUser([void Function(SummaryUserBuilder) updates]) =>
      (new SummaryUserBuilder()..update(updates)).build();

  _$SummaryUser._(
      {this.userId,
      this.username,
      this.name,
      this.avatar,
      this.tagline,
      this.online,
      this.phone})
      : super._();

  @override
  SummaryUser rebuild(void Function(SummaryUserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SummaryUserBuilder toBuilder() => new SummaryUserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SummaryUser &&
        userId == other.userId &&
        username == other.username &&
        name == other.name &&
        avatar == other.avatar &&
        tagline == other.tagline &&
        online == other.online &&
        phone == other.phone;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc(0, userId.hashCode), username.hashCode),
                        name.hashCode),
                    avatar.hashCode),
                tagline.hashCode),
            online.hashCode),
        phone.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SummaryUser')
          ..add('userId', userId)
          ..add('username', username)
          ..add('name', name)
          ..add('avatar', avatar)
          ..add('tagline', tagline)
          ..add('online', online)
          ..add('phone', phone))
        .toString();
  }
}

class SummaryUserBuilder implements Builder<SummaryUser, SummaryUserBuilder> {
  _$SummaryUser _$v;

  String _userId;
  String get userId => _$this._userId;
  set userId(String userId) => _$this._userId = userId;

  String _username;
  String get username => _$this._username;
  set username(String username) => _$this._username = username;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _avatar;
  String get avatar => _$this._avatar;
  set avatar(String avatar) => _$this._avatar = avatar;

  String _tagline;
  String get tagline => _$this._tagline;
  set tagline(String tagline) => _$this._tagline = tagline;

  int _online;
  int get online => _$this._online;
  set online(int online) => _$this._online = online;

  String _phone;
  String get phone => _$this._phone;
  set phone(String phone) => _$this._phone = phone;

  SummaryUserBuilder();

  SummaryUserBuilder get _$this {
    if (_$v != null) {
      _userId = _$v.userId;
      _username = _$v.username;
      _name = _$v.name;
      _avatar = _$v.avatar;
      _tagline = _$v.tagline;
      _online = _$v.online;
      _phone = _$v.phone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SummaryUser other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$SummaryUser;
  }

  @override
  void update(void Function(SummaryUserBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$SummaryUser build() {
    final _$result = _$v ??
        new _$SummaryUser._(
            userId: userId,
            username: username,
            name: name,
            avatar: avatar,
            tagline: tagline,
            online: online,
            phone: phone);
    replace(_$result);
    return _$result;
  }
}

class _$BuiltSearchUsers extends BuiltSearchUsers {
  @override
  final BuiltList<SummaryUser> users;
  @override
  final String lastevaluatedkey;

  factory _$BuiltSearchUsers(
          [void Function(BuiltSearchUsersBuilder) updates]) =>
      (new BuiltSearchUsersBuilder()..update(updates)).build();

  _$BuiltSearchUsers._({this.users, this.lastevaluatedkey}) : super._();

  @override
  BuiltSearchUsers rebuild(void Function(BuiltSearchUsersBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltSearchUsersBuilder toBuilder() =>
      new BuiltSearchUsersBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltSearchUsers &&
        users == other.users &&
        lastevaluatedkey == other.lastevaluatedkey;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, users.hashCode), lastevaluatedkey.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuiltSearchUsers')
          ..add('users', users)
          ..add('lastevaluatedkey', lastevaluatedkey))
        .toString();
  }
}

class BuiltSearchUsersBuilder
    implements Builder<BuiltSearchUsers, BuiltSearchUsersBuilder> {
  _$BuiltSearchUsers _$v;

  ListBuilder<SummaryUser> _users;
  ListBuilder<SummaryUser> get users =>
      _$this._users ??= new ListBuilder<SummaryUser>();
  set users(ListBuilder<SummaryUser> users) => _$this._users = users;

  String _lastevaluatedkey;
  String get lastevaluatedkey => _$this._lastevaluatedkey;
  set lastevaluatedkey(String lastevaluatedkey) =>
      _$this._lastevaluatedkey = lastevaluatedkey;

  BuiltSearchUsersBuilder();

  BuiltSearchUsersBuilder get _$this {
    if (_$v != null) {
      _users = _$v.users?.toBuilder();
      _lastevaluatedkey = _$v.lastevaluatedkey;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltSearchUsers other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuiltSearchUsers;
  }

  @override
  void update(void Function(BuiltSearchUsersBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuiltSearchUsers build() {
    _$BuiltSearchUsers _$result;
    try {
      _$result = _$v ??
          new _$BuiltSearchUsers._(
              users: _users?.build(), lastevaluatedkey: lastevaluatedkey);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'users';
        _users?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'BuiltSearchUsers', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$BuiltSearchClubs extends BuiltSearchClubs {
  @override
  final BuiltList<BuiltClub> clubs;
  @override
  final String lastevaluatedkey;

  factory _$BuiltSearchClubs(
          [void Function(BuiltSearchClubsBuilder) updates]) =>
      (new BuiltSearchClubsBuilder()..update(updates)).build();

  _$BuiltSearchClubs._({this.clubs, this.lastevaluatedkey}) : super._();

  @override
  BuiltSearchClubs rebuild(void Function(BuiltSearchClubsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltSearchClubsBuilder toBuilder() =>
      new BuiltSearchClubsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltSearchClubs &&
        clubs == other.clubs &&
        lastevaluatedkey == other.lastevaluatedkey;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, clubs.hashCode), lastevaluatedkey.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuiltSearchClubs')
          ..add('clubs', clubs)
          ..add('lastevaluatedkey', lastevaluatedkey))
        .toString();
  }
}

class BuiltSearchClubsBuilder
    implements Builder<BuiltSearchClubs, BuiltSearchClubsBuilder> {
  _$BuiltSearchClubs _$v;

  ListBuilder<BuiltClub> _clubs;
  ListBuilder<BuiltClub> get clubs =>
      _$this._clubs ??= new ListBuilder<BuiltClub>();
  set clubs(ListBuilder<BuiltClub> clubs) => _$this._clubs = clubs;

  String _lastevaluatedkey;
  String get lastevaluatedkey => _$this._lastevaluatedkey;
  set lastevaluatedkey(String lastevaluatedkey) =>
      _$this._lastevaluatedkey = lastevaluatedkey;

  BuiltSearchClubsBuilder();

  BuiltSearchClubsBuilder get _$this {
    if (_$v != null) {
      _clubs = _$v.clubs?.toBuilder();
      _lastevaluatedkey = _$v.lastevaluatedkey;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltSearchClubs other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuiltSearchClubs;
  }

  @override
  void update(void Function(BuiltSearchClubsBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuiltSearchClubs build() {
    _$BuiltSearchClubs _$result;
    try {
      _$result = _$v ??
          new _$BuiltSearchClubs._(
              clubs: _clubs?.build(), lastevaluatedkey: lastevaluatedkey);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'clubs';
        _clubs?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'BuiltSearchClubs', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$CategoryClubsList extends CategoryClubsList {
  @override
  final String category;
  @override
  final BuiltList<BuiltClub> clubs;

  factory _$CategoryClubsList(
          [void Function(CategoryClubsListBuilder) updates]) =>
      (new CategoryClubsListBuilder()..update(updates)).build();

  _$CategoryClubsList._({this.category, this.clubs}) : super._();

  @override
  CategoryClubsList rebuild(void Function(CategoryClubsListBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CategoryClubsListBuilder toBuilder() =>
      new CategoryClubsListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CategoryClubsList &&
        category == other.category &&
        clubs == other.clubs;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, category.hashCode), clubs.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('CategoryClubsList')
          ..add('category', category)
          ..add('clubs', clubs))
        .toString();
  }
}

class CategoryClubsListBuilder
    implements Builder<CategoryClubsList, CategoryClubsListBuilder> {
  _$CategoryClubsList _$v;

  String _category;
  String get category => _$this._category;
  set category(String category) => _$this._category = category;

  ListBuilder<BuiltClub> _clubs;
  ListBuilder<BuiltClub> get clubs =>
      _$this._clubs ??= new ListBuilder<BuiltClub>();
  set clubs(ListBuilder<BuiltClub> clubs) => _$this._clubs = clubs;

  CategoryClubsListBuilder();

  CategoryClubsListBuilder get _$this {
    if (_$v != null) {
      _category = _$v.category;
      _clubs = _$v.clubs?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CategoryClubsList other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$CategoryClubsList;
  }

  @override
  void update(void Function(CategoryClubsListBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$CategoryClubsList build() {
    _$CategoryClubsList _$result;
    try {
      _$result = _$v ??
          new _$CategoryClubsList._(category: category, clubs: _clubs?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'clubs';
        _clubs?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'CategoryClubsList', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$BuiltAllClubsList extends BuiltAllClubsList {
  @override
  final BuiltList<CategoryClubsList> categoryClubs;

  factory _$BuiltAllClubsList(
          [void Function(BuiltAllClubsListBuilder) updates]) =>
      (new BuiltAllClubsListBuilder()..update(updates)).build();

  _$BuiltAllClubsList._({this.categoryClubs}) : super._();

  @override
  BuiltAllClubsList rebuild(void Function(BuiltAllClubsListBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltAllClubsListBuilder toBuilder() =>
      new BuiltAllClubsListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltAllClubsList && categoryClubs == other.categoryClubs;
  }

  @override
  int get hashCode {
    return $jf($jc(0, categoryClubs.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuiltAllClubsList')
          ..add('categoryClubs', categoryClubs))
        .toString();
  }
}

class BuiltAllClubsListBuilder
    implements Builder<BuiltAllClubsList, BuiltAllClubsListBuilder> {
  _$BuiltAllClubsList _$v;

  ListBuilder<CategoryClubsList> _categoryClubs;
  ListBuilder<CategoryClubsList> get categoryClubs =>
      _$this._categoryClubs ??= new ListBuilder<CategoryClubsList>();
  set categoryClubs(ListBuilder<CategoryClubsList> categoryClubs) =>
      _$this._categoryClubs = categoryClubs;

  BuiltAllClubsListBuilder();

  BuiltAllClubsListBuilder get _$this {
    if (_$v != null) {
      _categoryClubs = _$v.categoryClubs?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltAllClubsList other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuiltAllClubsList;
  }

  @override
  void update(void Function(BuiltAllClubsListBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuiltAllClubsList build() {
    _$BuiltAllClubsList _$result;
    try {
      _$result = _$v ??
          new _$BuiltAllClubsList._(categoryClubs: _categoryClubs?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'categoryClubs';
        _categoryClubs?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'BuiltAllClubsList', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ReactionUser extends ReactionUser {
  @override
  final SummaryUser user;
  @override
  final int timestamp;
  @override
  final int indexValue;

  factory _$ReactionUser([void Function(ReactionUserBuilder) updates]) =>
      (new ReactionUserBuilder()..update(updates)).build();

  _$ReactionUser._({this.user, this.timestamp, this.indexValue}) : super._() {
    if (user == null) {
      throw new BuiltValueNullFieldError('ReactionUser', 'user');
    }
    if (timestamp == null) {
      throw new BuiltValueNullFieldError('ReactionUser', 'timestamp');
    }
    if (indexValue == null) {
      throw new BuiltValueNullFieldError('ReactionUser', 'indexValue');
    }
  }

  @override
  ReactionUser rebuild(void Function(ReactionUserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReactionUserBuilder toBuilder() => new ReactionUserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReactionUser &&
        user == other.user &&
        timestamp == other.timestamp &&
        indexValue == other.indexValue;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc(0, user.hashCode), timestamp.hashCode), indexValue.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ReactionUser')
          ..add('user', user)
          ..add('timestamp', timestamp)
          ..add('indexValue', indexValue))
        .toString();
  }
}

class ReactionUserBuilder
    implements Builder<ReactionUser, ReactionUserBuilder> {
  _$ReactionUser _$v;

  SummaryUserBuilder _user;
  SummaryUserBuilder get user => _$this._user ??= new SummaryUserBuilder();
  set user(SummaryUserBuilder user) => _$this._user = user;

  int _timestamp;
  int get timestamp => _$this._timestamp;
  set timestamp(int timestamp) => _$this._timestamp = timestamp;

  int _indexValue;
  int get indexValue => _$this._indexValue;
  set indexValue(int indexValue) => _$this._indexValue = indexValue;

  ReactionUserBuilder();

  ReactionUserBuilder get _$this {
    if (_$v != null) {
      _user = _$v.user?.toBuilder();
      _timestamp = _$v.timestamp;
      _indexValue = _$v.indexValue;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReactionUser other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ReactionUser;
  }

  @override
  void update(void Function(ReactionUserBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ReactionUser build() {
    _$ReactionUser _$result;
    try {
      _$result = _$v ??
          new _$ReactionUser._(
              user: user.build(), timestamp: timestamp, indexValue: indexValue);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'ReactionUser', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$BuiltReaction extends BuiltReaction {
  @override
  final BuiltList<ReactionUser> reactions;
  @override
  final String lastevaluatedkey;

  factory _$BuiltReaction([void Function(BuiltReactionBuilder) updates]) =>
      (new BuiltReactionBuilder()..update(updates)).build();

  _$BuiltReaction._({this.reactions, this.lastevaluatedkey}) : super._() {
    if (reactions == null) {
      throw new BuiltValueNullFieldError('BuiltReaction', 'reactions');
    }
  }

  @override
  BuiltReaction rebuild(void Function(BuiltReactionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltReactionBuilder toBuilder() => new BuiltReactionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltReaction &&
        reactions == other.reactions &&
        lastevaluatedkey == other.lastevaluatedkey;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, reactions.hashCode), lastevaluatedkey.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuiltReaction')
          ..add('reactions', reactions)
          ..add('lastevaluatedkey', lastevaluatedkey))
        .toString();
  }
}

class BuiltReactionBuilder
    implements Builder<BuiltReaction, BuiltReactionBuilder> {
  _$BuiltReaction _$v;

  ListBuilder<ReactionUser> _reactions;
  ListBuilder<ReactionUser> get reactions =>
      _$this._reactions ??= new ListBuilder<ReactionUser>();
  set reactions(ListBuilder<ReactionUser> reactions) =>
      _$this._reactions = reactions;

  String _lastevaluatedkey;
  String get lastevaluatedkey => _$this._lastevaluatedkey;
  set lastevaluatedkey(String lastevaluatedkey) =>
      _$this._lastevaluatedkey = lastevaluatedkey;

  BuiltReactionBuilder();

  BuiltReactionBuilder get _$this {
    if (_$v != null) {
      _reactions = _$v.reactions?.toBuilder();
      _lastevaluatedkey = _$v.lastevaluatedkey;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltReaction other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuiltReaction;
  }

  @override
  void update(void Function(BuiltReactionBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuiltReaction build() {
    _$BuiltReaction _$result;
    try {
      _$result = _$v ??
          new _$BuiltReaction._(
              reactions: reactions.build(), lastevaluatedkey: lastevaluatedkey);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'reactions';
        reactions.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'BuiltReaction', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ReportSummary extends ReportSummary {
  @override
  final String body;

  factory _$ReportSummary([void Function(ReportSummaryBuilder) updates]) =>
      (new ReportSummaryBuilder()..update(updates)).build();

  _$ReportSummary._({this.body}) : super._() {
    if (body == null) {
      throw new BuiltValueNullFieldError('ReportSummary', 'body');
    }
  }

  @override
  ReportSummary rebuild(void Function(ReportSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReportSummaryBuilder toBuilder() => new ReportSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReportSummary && body == other.body;
  }

  @override
  int get hashCode {
    return $jf($jc(0, body.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ReportSummary')..add('body', body))
        .toString();
  }
}

class ReportSummaryBuilder
    implements Builder<ReportSummary, ReportSummaryBuilder> {
  _$ReportSummary _$v;

  String _body;
  String get body => _$this._body;
  set body(String body) => _$this._body = body;

  ReportSummaryBuilder();

  ReportSummaryBuilder get _$this {
    if (_$v != null) {
      _body = _$v.body;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReportSummary other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ReportSummary;
  }

  @override
  void update(void Function(ReportSummaryBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ReportSummary build() {
    final _$result = _$v ?? new _$ReportSummary._(body: body);
    replace(_$result);
    return _$result;
  }
}

class _$JoinRequests extends JoinRequests {
  @override
  final int joinRequestAttempts;
  @override
  final int timestamp;
  @override
  final SummaryUser audience;

  factory _$JoinRequests([void Function(JoinRequestsBuilder) updates]) =>
      (new JoinRequestsBuilder()..update(updates)).build();

  _$JoinRequests._({this.joinRequestAttempts, this.timestamp, this.audience})
      : super._() {
    if (audience == null) {
      throw new BuiltValueNullFieldError('JoinRequests', 'audience');
    }
  }

  @override
  JoinRequests rebuild(void Function(JoinRequestsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  JoinRequestsBuilder toBuilder() => new JoinRequestsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is JoinRequests &&
        joinRequestAttempts == other.joinRequestAttempts &&
        timestamp == other.timestamp &&
        audience == other.audience;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc(0, joinRequestAttempts.hashCode), timestamp.hashCode),
        audience.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('JoinRequests')
          ..add('joinRequestAttempts', joinRequestAttempts)
          ..add('timestamp', timestamp)
          ..add('audience', audience))
        .toString();
  }
}

class JoinRequestsBuilder
    implements Builder<JoinRequests, JoinRequestsBuilder> {
  _$JoinRequests _$v;

  int _joinRequestAttempts;
  int get joinRequestAttempts => _$this._joinRequestAttempts;
  set joinRequestAttempts(int joinRequestAttempts) =>
      _$this._joinRequestAttempts = joinRequestAttempts;

  int _timestamp;
  int get timestamp => _$this._timestamp;
  set timestamp(int timestamp) => _$this._timestamp = timestamp;

  SummaryUserBuilder _audience;
  SummaryUserBuilder get audience =>
      _$this._audience ??= new SummaryUserBuilder();
  set audience(SummaryUserBuilder audience) => _$this._audience = audience;

  JoinRequestsBuilder();

  JoinRequestsBuilder get _$this {
    if (_$v != null) {
      _joinRequestAttempts = _$v.joinRequestAttempts;
      _timestamp = _$v.timestamp;
      _audience = _$v.audience?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(JoinRequests other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$JoinRequests;
  }

  @override
  void update(void Function(JoinRequestsBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$JoinRequests build() {
    _$JoinRequests _$result;
    try {
      _$result = _$v ??
          new _$JoinRequests._(
              joinRequestAttempts: joinRequestAttempts,
              timestamp: timestamp,
              audience: audience.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'audience';
        audience.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'JoinRequests', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$BuiltActiveJoinRequests extends BuiltActiveJoinRequests {
  @override
  final BuiltList<JoinRequests> activeJoinRequestUsers;
  @override
  final String lastevaluatedkey;

  factory _$BuiltActiveJoinRequests(
          [void Function(BuiltActiveJoinRequestsBuilder) updates]) =>
      (new BuiltActiveJoinRequestsBuilder()..update(updates)).build();

  _$BuiltActiveJoinRequests._(
      {this.activeJoinRequestUsers, this.lastevaluatedkey})
      : super._();

  @override
  BuiltActiveJoinRequests rebuild(
          void Function(BuiltActiveJoinRequestsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltActiveJoinRequestsBuilder toBuilder() =>
      new BuiltActiveJoinRequestsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltActiveJoinRequests &&
        activeJoinRequestUsers == other.activeJoinRequestUsers &&
        lastevaluatedkey == other.lastevaluatedkey;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(0, activeJoinRequestUsers.hashCode), lastevaluatedkey.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuiltActiveJoinRequests')
          ..add('activeJoinRequestUsers', activeJoinRequestUsers)
          ..add('lastevaluatedkey', lastevaluatedkey))
        .toString();
  }
}

class BuiltActiveJoinRequestsBuilder
    implements
        Builder<BuiltActiveJoinRequests, BuiltActiveJoinRequestsBuilder> {
  _$BuiltActiveJoinRequests _$v;

  ListBuilder<JoinRequests> _activeJoinRequestUsers;
  ListBuilder<JoinRequests> get activeJoinRequestUsers =>
      _$this._activeJoinRequestUsers ??= new ListBuilder<JoinRequests>();
  set activeJoinRequestUsers(
          ListBuilder<JoinRequests> activeJoinRequestUsers) =>
      _$this._activeJoinRequestUsers = activeJoinRequestUsers;

  String _lastevaluatedkey;
  String get lastevaluatedkey => _$this._lastevaluatedkey;
  set lastevaluatedkey(String lastevaluatedkey) =>
      _$this._lastevaluatedkey = lastevaluatedkey;

  BuiltActiveJoinRequestsBuilder();

  BuiltActiveJoinRequestsBuilder get _$this {
    if (_$v != null) {
      _activeJoinRequestUsers = _$v.activeJoinRequestUsers?.toBuilder();
      _lastevaluatedkey = _$v.lastevaluatedkey;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltActiveJoinRequests other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuiltActiveJoinRequests;
  }

  @override
  void update(void Function(BuiltActiveJoinRequestsBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuiltActiveJoinRequests build() {
    _$BuiltActiveJoinRequests _$result;
    try {
      _$result = _$v ??
          new _$BuiltActiveJoinRequests._(
              activeJoinRequestUsers: _activeJoinRequestUsers?.build(),
              lastevaluatedkey: lastevaluatedkey);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'activeJoinRequestUsers';
        _activeJoinRequestUsers?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'BuiltActiveJoinRequests', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$BuiltUnifiedSearchResults extends BuiltUnifiedSearchResults {
  @override
  final BuiltList<SummaryUser> users;
  @override
  final String userlastevaluatedkey;
  @override
  final BuiltList<BuiltClub> clubs;
  @override
  final String clublastevaluatedkey;
  @override
  final BuiltList<BuiltCommunity> communities;
  @override
  final String communitylastevaluatedkey;

  factory _$BuiltUnifiedSearchResults(
          [void Function(BuiltUnifiedSearchResultsBuilder) updates]) =>
      (new BuiltUnifiedSearchResultsBuilder()..update(updates)).build();

  _$BuiltUnifiedSearchResults._(
      {this.users,
      this.userlastevaluatedkey,
      this.clubs,
      this.clublastevaluatedkey,
      this.communities,
      this.communitylastevaluatedkey})
      : super._();

  @override
  BuiltUnifiedSearchResults rebuild(
          void Function(BuiltUnifiedSearchResultsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltUnifiedSearchResultsBuilder toBuilder() =>
      new BuiltUnifiedSearchResultsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltUnifiedSearchResults &&
        users == other.users &&
        userlastevaluatedkey == other.userlastevaluatedkey &&
        clubs == other.clubs &&
        clublastevaluatedkey == other.clublastevaluatedkey &&
        communities == other.communities &&
        communitylastevaluatedkey == other.communitylastevaluatedkey;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc($jc($jc(0, users.hashCode), userlastevaluatedkey.hashCode),
                    clubs.hashCode),
                clublastevaluatedkey.hashCode),
            communities.hashCode),
        communitylastevaluatedkey.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuiltUnifiedSearchResults')
          ..add('users', users)
          ..add('userlastevaluatedkey', userlastevaluatedkey)
          ..add('clubs', clubs)
          ..add('clublastevaluatedkey', clublastevaluatedkey)
          ..add('communities', communities)
          ..add('communitylastevaluatedkey', communitylastevaluatedkey))
        .toString();
  }
}

class BuiltUnifiedSearchResultsBuilder
    implements
        Builder<BuiltUnifiedSearchResults, BuiltUnifiedSearchResultsBuilder> {
  _$BuiltUnifiedSearchResults _$v;

  ListBuilder<SummaryUser> _users;
  ListBuilder<SummaryUser> get users =>
      _$this._users ??= new ListBuilder<SummaryUser>();
  set users(ListBuilder<SummaryUser> users) => _$this._users = users;

  String _userlastevaluatedkey;
  String get userlastevaluatedkey => _$this._userlastevaluatedkey;
  set userlastevaluatedkey(String userlastevaluatedkey) =>
      _$this._userlastevaluatedkey = userlastevaluatedkey;

  ListBuilder<BuiltClub> _clubs;
  ListBuilder<BuiltClub> get clubs =>
      _$this._clubs ??= new ListBuilder<BuiltClub>();
  set clubs(ListBuilder<BuiltClub> clubs) => _$this._clubs = clubs;

  String _clublastevaluatedkey;
  String get clublastevaluatedkey => _$this._clublastevaluatedkey;
  set clublastevaluatedkey(String clublastevaluatedkey) =>
      _$this._clublastevaluatedkey = clublastevaluatedkey;

  ListBuilder<BuiltCommunity> _communities;
  ListBuilder<BuiltCommunity> get communities =>
      _$this._communities ??= new ListBuilder<BuiltCommunity>();
  set communities(ListBuilder<BuiltCommunity> communities) =>
      _$this._communities = communities;

  String _communitylastevaluatedkey;
  String get communitylastevaluatedkey => _$this._communitylastevaluatedkey;
  set communitylastevaluatedkey(String communitylastevaluatedkey) =>
      _$this._communitylastevaluatedkey = communitylastevaluatedkey;

  BuiltUnifiedSearchResultsBuilder();

  BuiltUnifiedSearchResultsBuilder get _$this {
    if (_$v != null) {
      _users = _$v.users?.toBuilder();
      _userlastevaluatedkey = _$v.userlastevaluatedkey;
      _clubs = _$v.clubs?.toBuilder();
      _clublastevaluatedkey = _$v.clublastevaluatedkey;
      _communities = _$v.communities?.toBuilder();
      _communitylastevaluatedkey = _$v.communitylastevaluatedkey;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltUnifiedSearchResults other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuiltUnifiedSearchResults;
  }

  @override
  void update(void Function(BuiltUnifiedSearchResultsBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuiltUnifiedSearchResults build() {
    _$BuiltUnifiedSearchResults _$result;
    try {
      _$result = _$v ??
          new _$BuiltUnifiedSearchResults._(
              users: _users?.build(),
              userlastevaluatedkey: userlastevaluatedkey,
              clubs: _clubs?.build(),
              clublastevaluatedkey: clublastevaluatedkey,
              communities: _communities?.build(),
              communitylastevaluatedkey: communitylastevaluatedkey);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'users';
        _users?.build();

        _$failedField = 'clubs';
        _clubs?.build();

        _$failedField = 'communities';
        _communities?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'BuiltUnifiedSearchResults', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$BuiltInviteFormat extends BuiltInviteFormat {
  @override
  final String type;
  @override
  final BuiltList<String> invitee;

  factory _$BuiltInviteFormat(
          [void Function(BuiltInviteFormatBuilder) updates]) =>
      (new BuiltInviteFormatBuilder()..update(updates)).build();

  _$BuiltInviteFormat._({this.type, this.invitee}) : super._();

  @override
  BuiltInviteFormat rebuild(void Function(BuiltInviteFormatBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltInviteFormatBuilder toBuilder() =>
      new BuiltInviteFormatBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltInviteFormat &&
        type == other.type &&
        invitee == other.invitee;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, type.hashCode), invitee.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuiltInviteFormat')
          ..add('type', type)
          ..add('invitee', invitee))
        .toString();
  }
}

class BuiltInviteFormatBuilder
    implements Builder<BuiltInviteFormat, BuiltInviteFormatBuilder> {
  _$BuiltInviteFormat _$v;

  String _type;
  String get type => _$this._type;
  set type(String type) => _$this._type = type;

  ListBuilder<String> _invitee;
  ListBuilder<String> get invitee =>
      _$this._invitee ??= new ListBuilder<String>();
  set invitee(ListBuilder<String> invitee) => _$this._invitee = invitee;

  BuiltInviteFormatBuilder();

  BuiltInviteFormatBuilder get _$this {
    if (_$v != null) {
      _type = _$v.type;
      _invitee = _$v.invitee?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltInviteFormat other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuiltInviteFormat;
  }

  @override
  void update(void Function(BuiltInviteFormatBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuiltInviteFormat build() {
    _$BuiltInviteFormat _$result;
    try {
      _$result = _$v ??
          new _$BuiltInviteFormat._(type: type, invitee: _invitee?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'invitee';
        _invitee?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'BuiltInviteFormat', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$BuiltContacts extends BuiltContacts {
  @override
  final BuiltList<String> contacts;

  factory _$BuiltContacts([void Function(BuiltContactsBuilder) updates]) =>
      (new BuiltContactsBuilder()..update(updates)).build();

  _$BuiltContacts._({this.contacts}) : super._();

  @override
  BuiltContacts rebuild(void Function(BuiltContactsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltContactsBuilder toBuilder() => new BuiltContactsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltContacts && contacts == other.contacts;
  }

  @override
  int get hashCode {
    return $jf($jc(0, contacts.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuiltContacts')
          ..add('contacts', contacts))
        .toString();
  }
}

class BuiltContactsBuilder
    implements Builder<BuiltContacts, BuiltContactsBuilder> {
  _$BuiltContacts _$v;

  ListBuilder<String> _contacts;
  ListBuilder<String> get contacts =>
      _$this._contacts ??= new ListBuilder<String>();
  set contacts(ListBuilder<String> contacts) => _$this._contacts = contacts;

  BuiltContactsBuilder();

  BuiltContactsBuilder get _$this {
    if (_$v != null) {
      _contacts = _$v.contacts?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltContacts other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuiltContacts;
  }

  @override
  void update(void Function(BuiltContactsBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuiltContacts build() {
    _$BuiltContacts _$result;
    try {
      _$result = _$v ?? new _$BuiltContacts._(contacts: _contacts?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'contacts';
        _contacts?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'BuiltContacts', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
