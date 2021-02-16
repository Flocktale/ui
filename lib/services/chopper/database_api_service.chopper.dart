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
      {String userId, BuiltFCMToken body, String authorization}) {
    final $url = '/users/$userId/notifications/device-token';
    final $headers = {'authorization': authorization};
    final $body = body;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteFCMToken(
      {String userId, String authorization}) {
    final $url = '/users/$userId/notifications/device-token';
    final $headers = {'authorization': authorization};
    final $request = Request('DELETE', $url, client.baseUrl, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> isThisUsernameAvailable(
      {String username, String authorization}) {
    final $url = '/users/username-availability';
    final $params = <String, dynamic>{'username': username};
    final $headers = {'authorization': authorization};
    final $request = Request('GET', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> createNewUser(
      {BuiltUser body, String authorization}) {
    final $url = '/users/create';
    final $headers = {'authorization': authorization};
    final $body = body;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> uploadAvatar(
      {String userId, BuiltProfileImage image, String authorization}) {
    final $url = '/users/$userId/avatar/';
    final $headers = {'authorization': authorization};
    final $body = image;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateUser(
      {String userId, BuiltUser body, String authorization}) {
    final $url = '/users/$userId';
    final $headers = {'authorization': authorization};
    final $body = body;
    final $request =
        Request('PATCH', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<BuiltList<BuiltUser>>> getAllUsers({String authorization}) {
    final $url = '/users';
    final $headers = {'authorization': authorization};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<BuiltList<BuiltUser>, BuiltUser>($request);
  }

  @override
  Future<Response<BuiltSearchUsers>> getUserbyUsername(
      {String username, String authorization}) {
    final $url = '/users/query';
    final $params = <String, dynamic>{'username': username};
    final $headers = {'authorization': authorization};
    final $request = Request('GET', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<BuiltSearchUsers, BuiltSearchUsers>($request);
  }

  @override
  Future<Response<BuiltProfile>> getUserProfile(
      {String userId, String primaryUserId, String authorization}) {
    final $url = '/users/$userId';
    final $params = <String, dynamic>{'primaryUserId': primaryUserId};
    final $headers = {'authorization': authorization};
    final $request = Request('GET', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<BuiltProfile, BuiltProfile>($request);
  }

  @override
  Future<Response<BuiltNotificationList>> getNotifications(
      {String userId, String lastevaluatedkey, String authorization}) {
    final $url = '/users/$userId/notifications';
    final $headers = {
      'lastevaluatedkey': lastevaluatedkey,
      'authorization': authorization
    };
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<BuiltNotificationList, BuiltNotificationList>($request);
  }

  @override
  Future<Response<BuiltNotificationList>> responseToNotification(
      {String userId, String notificationId, String authorization}) {
    final $url = '/users/$userId/notifications/opened';
    final $params = <String, dynamic>{'notificationId': notificationId};
    final $headers = {'authorization': authorization};
    final $request = Request('GET', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<BuiltNotificationList, BuiltNotificationList>($request);
  }

  @override
  Future<Response<BuiltSearchUsers>> getRelations(
      {String userId,
      String socialRelation,
      String lastevaluatedkey,
      String authorization}) {
    final $url = '/users/$userId/relations/';
    final $params = <String, dynamic>{'socialRelation': socialRelation};
    final $headers = {
      'lastevaluatedkey': lastevaluatedkey,
      'authorization': authorization
    };
    final $request = Request('GET', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<BuiltSearchUsers, BuiltSearchUsers>($request);
  }

  @override
  Future<Response<dynamic>> follow(
      {String userId, String foreignUserId, String authorization}) {
    final $url = '/users/$userId/relations/add?action=follow';
    final $params = <String, dynamic>{'foreignUserId': foreignUserId};
    final $headers = {'authorization': authorization};
    final $request = Request('POST', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> sendFriendRequest(
      {String userId, String foreignUserId, String authorization}) {
    final $url = '/users/$userId/relations/add?action=send_friend_request';
    final $params = <String, dynamic>{'foreignUserId': foreignUserId};
    final $headers = {'authorization': authorization};
    final $request = Request('POST', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> acceptFriendRequest(
      {String userId, String foreignUserId, String authorization}) {
    final $url = '/users/$userId/relations/add?action=accept_friend_request';
    final $params = <String, dynamic>{'foreignUserId': foreignUserId};
    final $headers = {'authorization': authorization};
    final $request = Request('POST', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> unfollow(
      {String userId, String foreignUserId, String authorization}) {
    final $url = '/users/$userId/relations/remove?action=unfollow';
    final $params = <String, dynamic>{'foreignUserId': foreignUserId};
    final $headers = {'authorization': authorization};
    final $request = Request('POST', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteFriendRequest(
      {String userId, String foreignUserId, String authorization}) {
    final $url = '/users/$userId/relations/remove?action=delete_friend_request';
    final $params = <String, dynamic>{'foreignUserId': foreignUserId};
    final $headers = {'authorization': authorization};
    final $request = Request('POST', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> unfriend(
      {String userId, String foreignUserId, String authorization}) {
    final $url = '/users/$userId/relations/remove?action=unfriend';
    final $params = <String, dynamic>{'foreignUserId': foreignUserId};
    final $headers = {'authorization': authorization};
    final $request = Request('POST', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> createNewClub(
      {BuiltClub body, String creatorId, String authorization}) {
    final $url = '/clubs/create/';
    final $params = <String, dynamic>{'creatorId': creatorId};
    final $headers = {'authorization': authorization};
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl,
        body: $body, parameters: $params, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateClubAvatar(
      {String clubId, BuiltProfileImage image, String authorization}) {
    final $url = 'clubs/$clubId/avatar/';
    final $headers = {'authorization': authorization};
    final $body = image;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> generateAgoraTokenForClub(
      {String clubId, String userId, String authorization}) {
    final $url = '/clubs/$clubId/agora/token/create/';
    final $params = <String, dynamic>{'userId': userId};
    final $headers = {'authorization': authorization};
    final $request = Request('POST', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<BuiltAllClubsList>> getAllClubs({String authorization}) {
    final $url = '/clubs';
    final $headers = {'authorization': authorization};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<BuiltAllClubsList, BuiltAllClubsList>($request);
  }

  @override
  Future<Response<BuiltClubAndAudience>> getClubByClubId(
      {String clubId, String userId, String authorization}) {
    final $url = '/clubs/$clubId';
    final $params = <String, dynamic>{'userId': userId};
    final $headers = {'authorization': authorization};
    final $request = Request('GET', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<BuiltClubAndAudience, BuiltClubAndAudience>($request);
  }

  @override
  Future<Response<BuiltSearchClubs>> getMyHistoryClubs(
      {String userId, String lastevaluatedkey, String authorization}) {
    final $url = '/myclubs/$userId/history';
    final $headers = {
      'lastevaluatedkey': lastevaluatedkey,
      'authorization': authorization
    };
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<BuiltSearchClubs, BuiltSearchClubs>($request);
  }

  @override
  Future<Response<BuiltSearchClubs>> getMyOrganizedClubs(
      {String userId, String lastevaluatedkey, String authorization}) {
    final $url = '/myclubs/$userId/organized';
    final $headers = {
      'lastevaluatedkey': lastevaluatedkey,
      'authorization': authorization
    };
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<BuiltSearchClubs, BuiltSearchClubs>($request);
  }

  @override
  Future<Response<BuiltSearchClubs>> searchClubsByClubName(
      {String clubName, String authorization}) {
    final $url = '/clubs/query/';
    final $params = <String, dynamic>{'clubName': clubName};
    final $headers = {'authorization': authorization};
    final $request = Request('GET', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<BuiltSearchClubs, BuiltSearchClubs>($request);
  }

  @override
  Future<Response<dynamic>> postReaction(
      {String clubId,
      String audienceId,
      int indexValue,
      String authorization}) {
    final $url = '/clubs/$clubId/reactions/';
    final $params = <String, dynamic>{
      'audienceId': audienceId,
      'indexValue': indexValue
    };
    final $headers = {'authorization': authorization};
    final $request = Request('POST', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<BuiltReaction>> getReaction(
      {String clubId, String authorization}) {
    final $url = '/clubs/$clubId/reactions/';
    final $headers = {'authorization': authorization};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<BuiltReaction, BuiltReaction>($request);
  }

  @override
  Future<Response<dynamic>> reportClub(
      {String userId,
      ReportSummary report,
      String clubId,
      String authorization}) {
    final $url = '/clubs/$clubId/reports/';
    final $params = <String, dynamic>{'userId': userId};
    final $headers = {'authorization': authorization};
    final $body = report;
    final $request = Request('POST', $url, client.baseUrl,
        body: $body, parameters: $params, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> sendJoinRequest(
      {String clubId, String userId, String authorization}) {
    final $url = '/clubs/$clubId/join-request';
    final $params = <String, dynamic>{'userId': userId};
    final $headers = {'authorization': authorization};
    final $request = Request('POST', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteJoinRequet(
      {String clubId, String userId, String authorization}) {
    final $url = '/clubs/$clubId/join-request/';
    final $params = <String, dynamic>{'userId': userId};
    final $headers = {'authorization': authorization};
    final $request = Request('DELETE', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<BuiltActiveJoinRequests>> getActiveJoinRequests(
      {String clubId, String lastevaluatedkey, String authorization}) {
    final $url = '/clubs/$clubId/join-request';
    final $headers = {
      'lastevaluatedkey': lastevaluatedkey,
      'authorization': authorization
    };
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client
        .send<BuiltActiveJoinRequests, BuiltActiveJoinRequests>($request);
  }

  @override
  Future<Response<BuiltActiveJoinRequests>> searchInActiveJoinRequests(
      {String clubId,
      String searchString,
      String lastevaluatedkey,
      String authorization}) {
    final $url = '/clubs/$clubId/join-request/query';
    final $params = <String, dynamic>{'searchString': searchString};
    final $headers = {
      'lastevaluatedkey': lastevaluatedkey,
      'authorization': authorization
    };
    final $request = Request('GET', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client
        .send<BuiltActiveJoinRequests, BuiltActiveJoinRequests>($request);
  }

  @override
  Future<Response<dynamic>> respondToJoinRequest(
      {String clubId, String action, String audienceId, String authorization}) {
    final $url = '/clubs/$clubId/join-request/response';
    final $params = <String, dynamic>{
      'action': action,
      'audienceId': audienceId
    };
    final $headers = {'authorization': authorization};
    final $request = Request('POST', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> muteParticipant(
      {String clubId, String who, String participantId, String authorization}) {
    final $url = '/clubs/$clubId/mute/';
    final $params = <String, dynamic>{
      'who': who,
      'participantId': participantId
    };
    final $headers = {'authorization': authorization};
    final $request = Request('POST', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> kickAudienceId(
      {String clubId, String audienceId, String authorization}) {
    final $url = '/clubs/$clubId/kick/';
    final $params = <String, dynamic>{'audienceId': audienceId};
    final $headers = {'authorization': authorization};
    final $request = Request('POST', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> blockPanelist(
      {String clubId, String audienceId, String authorization}) {
    final $url = '/clubs/$clubId/block';
    final $params = <String, dynamic>{'audienceId': audienceId};
    final $headers = {'authorization': authorization};
    final $request = Request('POST', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<BuiltActiveJoinRequests>> getAllBlockedUsers(
      {String clubId, String authorization}) {
    final $url = '/clubs/$clubId/block';
    final $headers = {'authorization': authorization};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client
        .send<BuiltActiveJoinRequests, BuiltActiveJoinRequests>($request);
  }

  @override
  Future<Response<dynamic>> unblockUser(
      {String clubId, String audienceId, String authorization}) {
    final $url = '/clubs/$clubId/block';
    final $params = <String, dynamic>{'audienceId': audienceId};
    final $headers = {'authorization': authorization};
    final $request = Request('DELETE', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> inviteAllFollowers(
      {String clubId, String sponsorId, String authorization}) {
    final $url = '/clubs/$clubId/invite/all-followers';
    final $params = <String, dynamic>{'sponsorId': sponsorId};
    final $headers = {'authorization': authorization};
    final $request = Request('POST', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> inviteUsers(
      {String clubId,
      String sponsorId,
      BuiltInviteFormat invite,
      String authorization}) {
    final $url = '/clubs/$clubId/invite/';
    final $params = <String, dynamic>{'sponsorId': sponsorId};
    final $headers = {'authorization': authorization};
    final $body = invite;
    final $request = Request('POST', $url, client.baseUrl,
        body: $body, parameters: $params, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<BuiltUnifiedSearchResults>> unifiedQueryRoutes(
      {String searchString,
      String type,
      String lastevaluatedkey,
      String authorization}) {
    final $url = '/query/';
    final $params = <String, dynamic>{
      'searchString': searchString,
      'type': type
    };
    final $headers = {
      'lastevaluatedkey': lastevaluatedkey,
      'authorization': authorization
    };
    final $request = Request('GET', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client
        .send<BuiltUnifiedSearchResults, BuiltUnifiedSearchResults>($request);
  }
}
