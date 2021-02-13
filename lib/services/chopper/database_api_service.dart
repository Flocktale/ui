import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';

import '../../Models/built_post.dart';
import 'built_value_converter.dart';
import 'package:built_collection/built_collection.dart';

part 'database_api_service.chopper.dart';

// command for build runner - flutter packages pub run build_runner watch --delete-conflicting-outputs --use-polling-watcher

@ChopperApi(baseUrl: '')
abstract class DatabaseApiService extends ChopperService {
  @Get(path: '/users/{userId}')
  Future<Response<BuiltProfile>> getUserProfile(
    @Query() String primaryUserId,
    @Path('userId') String userId, {
    @required @Header() String authorization,
  });

  @Get(path: '/users')
  Future<Response<BuiltList<BuiltUser>>> getAllUsers({
    @required @Header() String authorization,
  });

  @Get(path: '/users/username-availability')
  Future<Response> isThisUsernameAvailable(
    @Query() String username, {
    @required @Header() String authorization,
  });

  @Post(path: '/users/create')
  Future<Response> createNewUser(
    @Body() BuiltUser body, {
    @required @Header() String authorization,
  });

  @Post(path: '/users/{userId}/avatar/')
  @Multipart()
  Future<Response> uploadAvatar(
    @Path('userId') String userId,
    @Body() BuiltProfileImage image, {
    @required @Header() String authorization,
  });

  @Get(path: '/users/{userId}/notifications')
  Future<Response<BuiltNotificationList>> getNotifications(
    @Path('userId') String userId,
    @Header('lastevaluatedkey') String lastevaluatedkey, {
    @required @Header() String authorization,
  });

  @Get(path: '/users/{userId}/notifications/opened')
  Future<Response<BuiltNotificationList>> responseToNotification(
    @Path('userId') String userId,
    @Query() String notificationId, {
    @required @Header() String authorization,
  });

  /// this method is to be called when user is logging in (manually either through login page or signUp page)
  @Post(path: '/users/{userId}/notifications/device-token')
  Future<Response> registerFCMToken(
    @Path('userId') String userId,
    @Body() BuiltFCMToken body, {
    @required @Header() String authorization,
  });

  /// this method is to be called when user is logging out.
  @Delete(path: '/users/{userId}/notifications/device-token')
  Future<Response> deleteFCMToken(
    @Path('userId') String userId, {
    @required @Header() String authorization,
  });

  @Post(path: '/users/{userId}/relations/add?action=follow')
  Future<Response> follow(
    @Path('userId') String userId,
    @Query('foreignUserId') String foreignUserId, {
    @required @Header() String authorization,
  });

  @Post(path: '/users/{userId}/relations/add?action=send_friend_request')
  Future<Response> sendFriendRequest(
    @Path('userId') String userId,
    @Query('foreignUserId') String foreignUserId, {
    @required @Header() String authorization,
  });

  @Post(path: '/users/{userId}/relations/add?action=accept_friend_request')
  Future<Response> acceptFriendRequest(
    @Path('userId') String userId,
    @Query('foreignUserId') String foreignUserId, {
    @required @Header() String authorization,
  });

  @Post(path: '/users/{userId}/relations/remove?action=unfollow')
  Future<Response> unfollow(
    @Path('userId') String userId,
    @Query('foreignUserId') String foreignUserId, {
    @required @Header() String authorization,
  });

  @Post(path: '/users/{userId}/relations/remove?action=delete_friend_request')
  Future<Response> deleteFriendRequest(
    @Path('userId') String userId,
    @Query('foreignUserId') String foreignUserId, {
    @required @Header() String authorization,
  });

  @Post(path: '/users/{userId}/relations/remove?action=unfriend')
  Future<Response> unfriend(
    @Path('userId') String userId,
    @Query('foreignUserId') String foreignUserId, {
    @required @Header() String authorization,
  });

  // it won't work!! We will retrieve this data when querying the object.
  @Get(path: '/users/{userId}/relations/{username}/{followingUsername}')
  Future<Response> checkFollow(
    @Path('userId') String userId,
    @Path('username') String username,
    @Path('followingUsername') String followingUsername, {
    @required @Header() String authorization,
  });

  @Get(path: '/users/{userId}/relations/')
  Future<Response<BuiltSearchUsers>> getRelations(
    @Path('userId') String userId,
    @Query('socialRelation')
        String
            socialRelation, //["followings","followers", "requests_sent", "requests_received","friends"]
    @Header('lastevaluatedkey') String lastevaluatedkey,
  );
  @Patch(path: '/users/{userId}')
  Future<Response> updateUser(
    @Path('userId') String userId,
    @Body() BuiltUser body, {
    @required @Header() String authorization,
  });

  @Get(path: '/users/query')
  Future<Response<BuiltSearchUsers>> getUserbyUsername(
    @Query("username") String username, {
    @required @Header() String authorization,
  });

  // ---------------------------------------------------------------------
  //                           Club APIs
  //----------------------------------------------------------------------

  @Get(path: '/clubs')
  Future<Response<BuiltAllClubsList>> getAllClubs({
    @required @Header() String authorization,
  });

  // ClubName and ClubCategory is required
  @Post(path: '/clubs/create/')
  Future<Response> createNewClub(
    @Body() BuiltClub body,
    @Query() String creatorId, {
    @required @Header() String authorization,
  });

  @Get(path: '/myclubs/{userId}/organized')
  Future<Response<BuiltSearchClubs>> getMyOrganizedClubs(
    @Path('userId') String userId, {
    @Header() String lastevaluatedkey,
    @required @Header() String authorization,
  });

  @Get(path: '/myclubs/{userId}/history')
  Future<Response<BuiltSearchClubs>> getMyHistoryClubs(
    @Path('userId') String userId, {
    @Header() String lastevaluatedkey,
    @required @Header() String authorization,
  });

  @Get(path: '/clubs/query/')
  Future<Response<BuiltSearchClubs>> searchClubsByClubName(
    @Query() String clubName, {
    @required @Header() String authorization,
  });

  @Get(path: '/clubs/{clubId}')
  Future<Response<BuiltClub>> getClubByClubId(
    @Path() String clubId, {
    @required @Header() String authorization,
  });

  @Post(path: 'clubs/{clubId}/avatar/')
  @Multipart()
  Future<Response> updateClubAvatar(
    @Path('clubId') String clubId,
    @Body() BuiltProfileImage image, {
    @required @Header() String authorization,
  });

  @Post(path: '/clubs/{clubId}/enter/')
  Future<Response> enterClub(
    @Path() String clubId,
    @Query() String userId, {
    @required @Header() String authorization,
  });

  //TODO

  @Post(path: '/clubs/{clubId}/reactions/')
  Future<Response> postReaction(
    @Path() String clubId,
    @Query() String audienceId,
    @Query() int indexValue, {
    @required @Header() String authorization,
  });

  @Get(path: '/clubs/{clubId}/reactions/')
  Future<Response<BuiltReaction>> getReaction(
    @Path() String clubId, {
    @required @Header() String authorization,
  });

  @Post(path: '/clubs/{clubId}/reports/')
  Future<Response> reportClub(
    @Query() String userId,
    @Body() ReportSummary report,
    @Path() String clubId, {
    @required @Header() String authorization,
  });

  @Post(path: '/clubs/{clubId}/join-request')
  Future<Response> sendJoinRequest(
    @Query() String userId,
    @Path() String clubId, {
    @required @Header() String authorization,
  });

  @Get(path: '/clubs/{clubId}/join-request')
  Future<Response<BuiltActiveJoinRequests>> getActiveJoinRequests(
    @Path() String clubId,
    @Header() String lastevaluatedkey, {
    @required @Header() String authorization,
  });

  @Get(path: '/clubs/{clubId}/join-request/query')
  Future<Response<BuiltActiveJoinRequests>> searchInActiveJoinRequests(
    @Path() String clubId,
    @Query() String searchString,
    @Header() String lastevaluatedkey, {
    @required @Header() String authorization,
  });

  @Post(path: '/clubs/{clubId}/join-request/response')
  Future<Response> respondToJoinRequest(
    @Path() String clubId,
    @Query() String action, // ["accept" or "cancel"]
    @Query() String audienceId, {
    @required @Header() String authorization,
  });

  @Delete(path: '/clubs/{clubId}/join-request/')
  Future<Response> deleteJoinRequet(
    @Path() String clubId,
    @Query() String userId, {
    @required @Header() String authorization,
  });

  @Post(path: '/clubs/{clubId}/kick/')
  Future<Response> kickAudienceId(
    @Path() String clubId,
    @Query() String audienceId, {
    @required @Header() String authorization,
  });

  // -------------- Inviting APIs----------------

  @Post(path: '/clubs/{clubId}/invite/all-followers')
  Future<Response> inviteAllFollowers(
    @Path() String clubId,
    @Query() String sponsorId, {
    @required @Header() String authorization,
  });

  @Post(path: '/clubs/{clubId}/invite/')
  Future<Response> inviteUsers(
    @Path() String clubId,
    @Query() String sponsorId,
    @Body() BuiltInviteFormat invite, {
    @required @Header() String authorization,
  });

  @Get(path: '/clubs/{clubId}/block')
  Future<Response<BuiltActiveJoinRequests>> getAllBlockedUsers(
    @Path() String clubId, {
    @required @Header() String authorization,
  });

  @Get(path: '/query/')
  Future<Response<BuiltUnifiedSearchResults>> unifiedQueryRoutes(
    @Query() String searchString,
    @Query() String type, //["unified","clubs","users"]
    @Header() String lastevaluatedkey, {
    @required @Header() String authorization,
  });

  @Post(path: '/clubs/{clubId}/agora/token/create/')
  Future<Response> generateAgoraTokenForClub(
    @Path() String clubId,
    @Query() String userId, {
    @required @Header() String authorization,
  });

  static DatabaseApiService create() {
    print("------------------initiating database----------------");
    final client = ChopperClient(
      baseUrl: 'https://863u7os9ui.execute-api.us-east-1.amazonaws.com/Stage',
      services: [
        _$DatabaseApiService(),
      ],
      converter: BuiltValueConverter(),
      interceptors: [
        HttpLoggingInterceptor(),
      ],
    );

    return _$DatabaseApiService(client);
  }
}
