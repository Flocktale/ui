import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import '../../Models/built_post.dart';

part 'serializers.g.dart';

@SerializersFor(const [
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
