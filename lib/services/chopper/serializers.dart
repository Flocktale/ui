import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:flocktale/Models/enums/audienceStatus.dart';
import 'package:flocktale/Models/enums/clubStatus.dart';
import 'package:flocktale/Models/enums/communityUserType.dart';
import 'package:flocktale/Models/enums/notificationType.dart';

import '../../Models/built_post.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  AgoraToken,
  ClubContentModel,
  BuiltCommunityAndUser,
  CommunityImageUploadBody,
  BuiltCommunityList,
  BuiltCommunityUser,
  BuiltCommunity,
  AppConfigs,
  BuiltContacts,
  UsernameAvailability,
  BuiltAudienceList,
  RelationActionResponse,
  BuiltClubAndAudience,
  BuiltNotificationList,
  BuiltFCMToken,
  BuiltProfile,
  BuiltUser,
  BuiltProfileImage,
  BuiltFollow,
  BuiltClub,
  SummaryUser,
  BuiltSearchUsers,
  BuiltSearchClubs,
  CategoryClubsList,
  BuiltAllClubsList,
  ReactionUser,
  BuiltReaction,
  ReportSummary,
  JoinRequests,
  BuiltActiveJoinRequests,
  BuiltUnifiedSearchResults,
  BuiltInviteFormat,
])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
