// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$DatabaseApiService extends DatabaseApiService {
  _$DatabaseApiService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = DatabaseApiService;

  @override
  Future<Response<dynamic>> registerFCMToken(
      {String userId, BuiltFCMToken body}) {
    final $url = '/users/$userId/notifications/device-token';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteFCMToken({String userId}) {
    final $url = '/users/$userId/notifications/device-token';
    final $request = Request('DELETE', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<AppConfigs>> getAppConfigs([String noAuthRequired = 'true']) {
    final $url = '/users/global/app-configs';
    final $headers = {'noAuthRequired': noAuthRequired};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<AppConfigs, AppConfigs>($request);
  }

  @override
  Future<Response<UsernameAvailability>> isThisUsernameAvailable(
      {String username}) {
    final $url = '/users/global/username-availability';
    final $params = <String, dynamic>{'username': username};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<UsernameAvailability, UsernameAvailability>($request);
  }

  @override
  Future<Response<dynamic>> createNewUser({BuiltUser body}) {
    final $url = '/users/global/create';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> uploadAvatar(
      {String userId, BuiltProfileImage image}) {
    final $url = '/users/$userId/avatar/';
    final $body = image;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateUser({String userId, BuiltUser body}) {
    final $url = '/users/$userId';
    final $body = body;
    final $request = Request('PATCH', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<BuiltList<BuiltUser>>> getAllUsers() {
    final $url = '/users';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<BuiltList<BuiltUser>, BuiltUser>($request);
  }

  @override
  Future<Response<BuiltSearchUsers>> getUserbyUsername({String username}) {
    final $url = '/users/query';
    final $params = <String, dynamic>{'username': username};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<BuiltSearchUsers, BuiltSearchUsers>($request);
  }

  @override
  Future<Response<BuiltProfile>> getUserProfile(
      {String userId, String primaryUserId}) {
    final $url = '/users/$userId';
    final $params = <String, dynamic>{'primaryUserId': primaryUserId};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<BuiltProfile, BuiltProfile>($request);
  }

  @override
  Future<Response<BuiltNotificationList>> getNotifications(
      {String userId, String lastevaluatedkey}) {
    final $url = '/users/$userId/notifications';
    final $headers = {'lastevaluatedkey': lastevaluatedkey};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<BuiltNotificationList, BuiltNotificationList>($request);
  }

  @override
  Future<Response<dynamic>> responseToNotification(
      {String userId, String notificationId, String action}) {
    final $url = '/users/$userId/notifications/opened';
    final $params = <String, dynamic>{
      'notificationId': notificationId,
      'action': action
    };
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<BuiltSearchUsers>> getRelations(
      {String userId, String socialRelation, String lastevaluatedkey}) {
    final $url = '/users/$userId/relations/';
    final $params = <String, dynamic>{'socialRelation': socialRelation};
    final $headers = {'lastevaluatedkey': lastevaluatedkey};
    final $request = Request('GET', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<BuiltSearchUsers, BuiltSearchUsers>($request);
  }

  @override
  Future<Response<RelationIndexObject>> getRelationIndexObject(
      {String userId, String foreignUserId}) {
    final $url = '/users/$userId/relations/object';
    final $params = <String, dynamic>{'foreignUserId': foreignUserId};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<RelationIndexObject, RelationIndexObject>($request);
  }

  @override
  Future<Response<RelationActionResponse>> follow(
      {String userId, String foreignUserId}) {
    final $url = '/users/$userId/relations/add?action=follow';
    final $params = <String, dynamic>{'foreignUserId': foreignUserId};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client
        .send<RelationActionResponse, RelationActionResponse>($request);
  }

  @override
  Future<Response<RelationActionResponse>> sendFriendRequest(
      {String userId, String foreignUserId}) {
    final $url = '/users/$userId/relations/add?action=send_friend_request';
    final $params = <String, dynamic>{'foreignUserId': foreignUserId};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client
        .send<RelationActionResponse, RelationActionResponse>($request);
  }

  @override
  Future<Response<RelationActionResponse>> acceptFriendRequest(
      {String userId, String foreignUserId}) {
    final $url = '/users/$userId/relations/add?action=accept_friend_request';
    final $params = <String, dynamic>{'foreignUserId': foreignUserId};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client
        .send<RelationActionResponse, RelationActionResponse>($request);
  }

  @override
  Future<Response<RelationActionResponse>> unfollow(
      {String userId, String foreignUserId}) {
    final $url = '/users/$userId/relations/remove?action=unfollow';
    final $params = <String, dynamic>{'foreignUserId': foreignUserId};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client
        .send<RelationActionResponse, RelationActionResponse>($request);
  }

  @override
  Future<Response<RelationActionResponse>> deleteFriendRequest(
      {String userId, String foreignUserId}) {
    final $url = '/users/$userId/relations/remove?action=delete_friend_request';
    final $params = <String, dynamic>{'foreignUserId': foreignUserId};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client
        .send<RelationActionResponse, RelationActionResponse>($request);
  }

  @override
  Future<Response<RelationActionResponse>> unfriend(
      {String userId, String foreignUserId}) {
    final $url = '/users/$userId/relations/remove?action=unfriend';
    final $params = <String, dynamic>{'foreignUserId': foreignUserId};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client
        .send<RelationActionResponse, RelationActionResponse>($request);
  }

  @override
  Future<Response<BuiltList<SummaryUser>>> syncContactsByPost(
      {BuiltContacts body}) {
    final $url = '/users/global/contacts-sync';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<BuiltList<SummaryUser>, SummaryUser>($request);
  }

  @override
  Future<Response<dynamic>> createNewGeneralClub(
      {String creatorId, String type = "general", BuiltClub body}) {
    final $url = '/clubs/global/create/';
    final $params = <String, dynamic>{'creatorId': creatorId, 'type': type};
    final $body = body;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> createNewCommunityClub(
      {String creatorId,
      String type = "community",
      String communityId,
      BuiltClub body}) {
    final $url = '/clubs/global/create/';
    final $params = <String, dynamic>{
      'creatorId': creatorId,
      'type': type,
      'communityId': communityId
    };
    final $body = body;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> createNewContentClub(
      {String creatorId,
      String type = "content",
      String contentUrl,
      String contentType = "news"}) {
    final $url = '/clubs/global/create/';
    final $params = <String, dynamic>{
      'creatorId': creatorId,
      'type': type,
      'contentUrl': contentUrl,
      'contentType': contentType
    };
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateClubAvatar(
      {String clubId, BuiltProfileImage image}) {
    final $url = 'clubs/$clubId/avatar/';
    final $body = image;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> startClub({String clubId, String userId}) {
    final $url = '/clubs/$clubId/start/';
    final $params = <String, dynamic>{'userId': userId};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> concludeClub({String clubId, String creatorId}) {
    final $url = '/clubs/$clubId/conclude/';
    final $params = <String, dynamic>{'creatorId': creatorId};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<BuiltSearchClubs>> getClubsOfFriends(
      {String userId, String lastevaluatedkey}) {
    final $url = '/users/$userId/clubs/relation?socialRelation=friend';
    final $headers = {'lastevaluatedkey': lastevaluatedkey};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<BuiltSearchClubs, BuiltSearchClubs>($request);
  }

  @override
  Future<Response<BuiltSearchClubs>> getClubsOfFollowings(
      {String userId, String lastevaluatedkey}) {
    final $url = '/users/$userId/clubs/relation?socialRelation=following';
    final $headers = {'lastevaluatedkey': lastevaluatedkey};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<BuiltSearchClubs, BuiltSearchClubs>($request);
  }

  @override
  Future<Response<BuiltAllClubsList>> getAllClubs() {
    final $url = '/clubs/global';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<BuiltAllClubsList, BuiltAllClubsList>($request);
  }

  @override
  Future<Response<BuiltSearchClubs>> getClubsOfCategory(
      {String category, String lastevaluatedkey}) {
    final $url = '/clubs/global';
    final $params = <String, dynamic>{'category': category};
    final $headers = {'lastevaluatedkey': lastevaluatedkey};
    final $request = Request('GET', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<BuiltSearchClubs, BuiltSearchClubs>($request);
  }

  @override
  Future<Response<BuiltSearchClubs>> getClubsOfContent(
      {String contentUrl, String lastevaluatedkey}) {
    final $url = '/clubs/global';
    final $params = <String, dynamic>{'contentUrl': contentUrl};
    final $headers = {'lastevaluatedkey': lastevaluatedkey};
    final $request = Request('GET', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<BuiltSearchClubs, BuiltSearchClubs>($request);
  }

  @override
  Future<Response<dynamic>> getCategoryData() {
    final $url = '/clubs/global/category-data';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<BuiltList<ClubContentModel>>> getContentData(
      {String type = "news"}) {
    final $url = '/clubs/global/content-data';
    final $params = <String, dynamic>{'type': type};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<BuiltList<ClubContentModel>, ClubContentModel>($request);
  }

  @override
  Future<Response<BuiltClubAndAudience>> getClubByClubId(
      {String clubId, String userId}) {
    final $url = '/clubs/$clubId';
    final $params = <String, dynamic>{'userId': userId};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<BuiltClubAndAudience, BuiltClubAndAudience>($request);
  }

  @override
  Future<Response<AgoraToken>> getAgoraToken({String clubId, int uid}) {
    final $url = '/clubs/$clubId/token';
    final $params = <String, dynamic>{'uid': uid};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<AgoraToken, AgoraToken>($request);
  }

  @override
  Future<Response<BuiltSearchClubs>> getMyHistoryClubs(
      {String userId, String lastevaluatedkey}) {
    final $url = '/myclubs/$userId/history';
    final $headers = {'lastevaluatedkey': lastevaluatedkey};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<BuiltSearchClubs, BuiltSearchClubs>($request);
  }

  @override
  Future<Response<BuiltSearchClubs>> getMyOrganizedClubs(
      {String userId, String lastevaluatedkey}) {
    final $url = '/myclubs/$userId/organized';
    final $headers = {'lastevaluatedkey': lastevaluatedkey};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<BuiltSearchClubs, BuiltSearchClubs>($request);
  }

  @override
  Future<Response<BuiltSearchClubs>> getMyCurrentAndUpcomingClubs(
      {String userId}) {
    final $url = '/myclubs/$userId/organized?upcoming=true';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<BuiltSearchClubs, BuiltSearchClubs>($request);
  }

  @override
  Future<Response<BuiltSearchClubs>> searchClubsByClubName({String clubName}) {
    final $url = '/clubs/query/';
    final $params = <String, dynamic>{'clubName': clubName};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<BuiltSearchClubs, BuiltSearchClubs>($request);
  }

  @override
  Future<Response<BuiltList<AudienceData>>> getParticipantList(
      {String clubId}) {
    final $url = '/clubs/$clubId/participants/';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<BuiltList<AudienceData>, AudienceData>($request);
  }

  @override
  Future<Response<BuiltAudienceList>> getAudienceList(
      {String clubId, String lastevaluatedkey}) {
    final $url = '/clubs/$clubId/audience/';
    final $headers = {'lastevaluatedkey': lastevaluatedkey};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<BuiltAudienceList, BuiltAudienceList>($request);
  }

  @override
  Future<Response<dynamic>> postReaction(
      {String clubId, String audienceId, int indexValue}) {
    final $url = '/clubs/$clubId/reactions/';
    final $params = <String, dynamic>{
      'audienceId': audienceId,
      'indexValue': indexValue
    };
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<BuiltReaction>> getReaction({String clubId}) {
    final $url = '/clubs/$clubId/reactions/';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<BuiltReaction, BuiltReaction>($request);
  }

  @override
  Future<Response<dynamic>> reportClub(
      {String userId, ReportSummary report, String clubId}) {
    final $url = '/clubs/$clubId/reports/';
    final $params = <String, dynamic>{'userId': userId};
    final $body = report;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> sendJoinRequest({String clubId, String userId}) {
    final $url = '/clubs/$clubId/join-request';
    final $params = <String, dynamic>{'userId': userId};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteJoinRequet({String clubId, String userId}) {
    final $url = '/clubs/$clubId/join-request/';
    final $params = <String, dynamic>{'userId': userId};
    final $request =
        Request('DELETE', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<BuiltActiveJoinRequests>> getActiveJoinRequests(
      {String clubId, String lastevaluatedkey}) {
    final $url = '/clubs/$clubId/join-request';
    final $headers = {'lastevaluatedkey': lastevaluatedkey};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client
        .send<BuiltActiveJoinRequests, BuiltActiveJoinRequests>($request);
  }

  @override
  Future<Response<BuiltActiveJoinRequests>> searchInActiveJoinRequests(
      {String clubId, String searchString, String lastevaluatedkey}) {
    final $url = '/clubs/$clubId/join-request/query';
    final $params = <String, dynamic>{'searchString': searchString};
    final $headers = {'lastevaluatedkey': lastevaluatedkey};
    final $request = Request('GET', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client
        .send<BuiltActiveJoinRequests, BuiltActiveJoinRequests>($request);
  }

  @override
  Future<Response<dynamic>> respondToJoinRequest(
      {String clubId, String action, String audienceId}) {
    final $url = '/clubs/$clubId/join-request/response';
    final $params = <String, dynamic>{
      'action': action,
      'audienceId': audienceId
    };
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> muteActionOnParticipant(
      {String clubId, String who, String participantId, String muteAction}) {
    final $url = '/clubs/$clubId/mute/';
    final $params = <String, dynamic>{
      'who': who,
      'participantId': participantId,
      'muteAction': muteAction
    };
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> kickOutParticipant(
      {String clubId, String audienceId, String isSelf}) {
    final $url = '/clubs/$clubId/kick/';
    final $params = <String, dynamic>{
      'audienceId': audienceId,
      'isSelf': isSelf
    };
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> blockAudience({String clubId, String audienceId}) {
    final $url = '/clubs/$clubId/block';
    final $params = <String, dynamic>{'audienceId': audienceId};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<BuiltList<AudienceData>>> getAllBlockedUsers(
      {String clubId}) {
    final $url = '/clubs/$clubId/block';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<BuiltList<AudienceData>, AudienceData>($request);
  }

  @override
  Future<Response<dynamic>> unblockUser({String clubId, String audienceId}) {
    final $url = '/clubs/$clubId/block';
    final $params = <String, dynamic>{'audienceId': audienceId};
    final $request =
        Request('DELETE', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> inviteAllFollowers(
      {String clubId, String sponsorId}) {
    final $url = '/clubs/$clubId/invite/all-followers';
    final $params = <String, dynamic>{'sponsorId': sponsorId};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> inviteUsers(
      {String clubId, String sponsorId, BuiltInviteFormat invite}) {
    final $url = '/clubs/$clubId/invite/';
    final $params = <String, dynamic>{'sponsorId': sponsorId};
    final $body = invite;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<BuiltUnifiedSearchResults>> unifiedQueryRoutes(
      {String searchString, String type, String lastevaluatedkey}) {
    final $url = '/query/';
    final $params = <String, dynamic>{
      'searchString': searchString,
      'type': type
    };
    final $headers = {'lastevaluatedkey': lastevaluatedkey};
    final $request = Request('GET', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client
        .send<BuiltUnifiedSearchResults, BuiltUnifiedSearchResults>($request);
  }

  @override
  Future<Response<BuiltCommunityList>> getAllCommunities(
      {String lastevaluatedkey}) {
    final $url = '/communities/global/';
    final $headers = {'lastevaluatedkey': lastevaluatedkey};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<BuiltCommunityList, BuiltCommunityList>($request);
  }

  @override
  Future<Response<dynamic>> createCommunity(
      {BuiltCommunity body, dynamic creatorId}) {
    final $url = '/communities/global/create/';
    final $params = <String, dynamic>{'creatorId': creatorId};
    final $body = body;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<BuiltCommunityList>> getMyHostedCommunities({String userId}) {
    final $url = '/mycommunities/$userId?type=HOST';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<BuiltCommunityList, BuiltCommunityList>($request);
  }

  @override
  Future<Response<BuiltCommunityList>> getMyMemberCommunities(
      {String userId, String lastevaluatedkey}) {
    final $url = '/mycommunities/$userId?type=MEMBER';
    final $headers = {'lastevaluatedkey': lastevaluatedkey};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<BuiltCommunityList, BuiltCommunityList>($request);
  }

  @override
  Future<Response<BuiltCommunityAndUser>> getCommunityByCommunityId(
      String communityId,
      {String userId}) {
    final $url = '/communities/$communityId/';
    final $params = <String, dynamic>{'userId': userId};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<BuiltCommunityAndUser, BuiltCommunityAndUser>($request);
  }

  @override
  Future<Response<dynamic>> updateCommunityData(
      String communityId, BuiltCommunity body) {
    final $url = '/communities/$communityId/';
    final $body = body;
    final $request = Request('PATCH', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<BuiltSearchUsers>> getCommunityUsers(String communityId,
      {dynamic type, String lastevaluatedkey}) {
    final $url = '/communities/$communityId/users';
    final $params = <String, dynamic>{'type': type};
    final $headers = {'lastevaluatedkey': lastevaluatedkey};
    final $request = Request('GET', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<BuiltSearchUsers, BuiltSearchUsers>($request);
  }

  @override
  Future<Response<BuiltSearchUsers>> seachCommunityMember(String communityId,
      {String searchString, String lastevaluatedkey}) {
    final $url = '/communities/$communityId/users?type=MEMBER';
    final $params = <String, dynamic>{'searchString': searchString};
    final $headers = {'lastevaluatedkey': lastevaluatedkey};
    final $request = Request('GET', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<BuiltSearchUsers, BuiltSearchUsers>($request);
  }

  @override
  Future<Response<dynamic>> joinCommunityAsMember(String communityId,
      {dynamic userId}) {
    final $url = '/communities/$communityId/users';
    final $params = <String, dynamic>{'userId': userId};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> inviteCommunityMemberToBecomeHost(
      String communityId,
      {dynamic memberId}) {
    final $url = '/communities/$communityId/users/invite';
    final $params = <String, dynamic>{'memberId': memberId};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<BuiltCommunityUser>> acceptHostCommunityInvitation(
      String communityId,
      {dynamic memberId}) {
    final $url =
        '/communities/$communityId/users/invite/response?response=accept';
    final $params = <String, dynamic>{'memberId': memberId};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<BuiltCommunityUser, BuiltCommunityUser>($request);
  }

  @override
  Future<Response<dynamic>> cancelHostCommunityInvitation(String communityId,
      {dynamic memberId}) {
    final $url =
        '/communities/$communityId/users/invite/response?response=cancel';
    final $params = <String, dynamic>{'memberId': memberId};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> removeCommunityUser(String communityId,
      {dynamic type, dynamic userId}) {
    final $url = '/communities/$communityId/users';
    final $params = <String, dynamic>{'type': type, 'userId': userId};
    final $request =
        Request('DELETE', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> uploadCommunityImages(String communityId,
      {CommunityImageUploadBody body}) {
    final $url = '/communities/$communityId/image/';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<BuiltSearchClubs>> getCommunityActiveClubs(String communityId,
      {String lastevaluatedkey}) {
    final $url = '/communities/$communityId/clubs/';
    final $headers = {'lastevaluatedkey': lastevaluatedkey};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<BuiltSearchClubs, BuiltSearchClubs>($request);
  }
}
