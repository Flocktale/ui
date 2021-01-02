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
  Future<Response<BuiltProfile>> getUserProfile(String userId) {
    final $url = '/users/$userId';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<BuiltProfile, BuiltProfile>($request);
  }

  @override
  Future<Response<BuiltList<BuiltUser>>> getAllUsers() {
    final $url = '/users';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<BuiltList<BuiltUser>, BuiltUser>($request);
  }

  @override
  Future<Response<dynamic>> createNewUser(BuiltUser body) {
    final $url = '/users/create';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> uploadAvatar(
      String userId, BuiltProfileImage image) {
    final $url = '/users/$userId/avatar/';
    final $body = image;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> uploadProfilePic(
      String userId, BuiltProfileImage body) {
    final $url = '/users/$userId/uploadImage';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> follow(String userId, String foreignUserId) {
    final $url = '/users/$userId/relations/add?action=follow';
    final $params = <String, dynamic>{'foreignUserId': foreignUserId};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> sendFriendRequest(
      String userId, String foreignUserId) {
    final $url = '/users/$userId/relations/add?action=send_friend_request';
    final $params = <String, dynamic>{'foreignUserId': foreignUserId};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> acceptFriendRequest(
      String userId, String foreignUserId) {
    final $url = '/users/$userId/relations/add?action=accept_friend_request';
    final $params = <String, dynamic>{'foreignUserId': foreignUserId};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> unfollow(String userId, String foreignUserId) {
    final $url = '/users/$userId/relations/remove?action=unfollow';
    final $params = <String, dynamic>{'foreignUserId': foreignUserId};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteFriendRequest(
      String userId, String foreignUserId) {
    final $url = '/users/$userId/relations/remove?action=deleteFriendRequest';
    final $params = <String, dynamic>{'foreignUserId': foreignUserId};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> unfriend(String userId, String foreignUserId) {
    final $url = '/users/$userId/relations/remove?action=unfriend';
    final $params = <String, dynamic>{'foreignUserId': foreignUserId};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> checkFollow(
      String userId, String username, String followingUsername) {
    final $url = '/users/$userId/relations/$username/$followingUsername';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateUser(String userId, BuiltUser body) {
    final $url = '/users/$userId';
    final $body = body;
    final $request = Request('PATCH', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<BuiltSearchUsers>> getUserbyUsername(String username) {
    final $url = '/users/query';
    final $params = <String, dynamic>{'username': username};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<BuiltSearchUsers, BuiltSearchUsers>($request);
  }

  @override
  Future<Response<BuiltAllClubsList>> getAllClubs() {
    final $url = '/clubs';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<BuiltAllClubsList, BuiltAllClubsList>($request);
  }

  @override
  Future<Response<dynamic>> createNewClub(BuiltClub body, String creatorId) {
    final $url = '/clubs/create/';
    final $params = <String, dynamic>{'creatorId': creatorId};
    final $body = body;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<BuiltSearchClubs>> getMyOrganizedClubs(String userId,
      {String lastevaluatedkey}) {
    final $url = '/myclubs/$userId/organized';
    final $headers = {'lastevaluatedkey': lastevaluatedkey};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<BuiltSearchClubs, BuiltSearchClubs>($request);
  }

  @override
  Future<Response<BuiltSearchClubs>> getMyHistoryClubs(String userId,
      {String lastevaluatedkey}) {
    final $url = '/myclubs/$userId/history';
    final $headers = {'lastevaluatedkey': lastevaluatedkey};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<BuiltSearchClubs, BuiltSearchClubs>($request);
  }

  @override
  Future<Response<BuiltSearchClubs>> searchClubsByClubName(String clubName) {
    final $url = '/clubs/query/';
    final $params = <String, dynamic>{'clubName': clubName};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<BuiltSearchClubs, BuiltSearchClubs>($request);
  }

  @override
  Future<Response<BuiltClub>> getClubByClubId(String clubId) {
    final $url = '/clubs/$clubId';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<BuiltClub, BuiltClub>($request);
  }

  @override
  Future<Response<dynamic>> updateClubAvatar(
      String clubId, BuiltProfileImage image) {
    final $url = 'clubs/$clubId/avatar/';
    final $body = image;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> enterClub(String clubId, String userId) {
    final $url = '/clubs/$clubId/enter/';
    final $params = <String, dynamic>{'userId': userId};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> reportUser(
      String userId, String body, String clubId) {
    final $url = '/clubs/$clubId/reports/';
    final $params = <String, dynamic>{'userId': userId};
    final $body = body;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }
}
