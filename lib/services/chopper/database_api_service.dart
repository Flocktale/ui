import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';

import '../../Models/built_post.dart';
import 'built_value_converter.dart';
import 'package:built_collection/built_collection.dart';

part 'database_api_service.chopper.dart';

// command for build runner - flutter packages pub run build_runner watch --delete-conflicting-outputs --use-polling-watcher

@ChopperApi(baseUrl: '')
abstract class DatabaseApiService extends ChopperService {
  //! ---------------------------------------------------------------------------------------
  //! ---------------------------------------------------------------------------------------
  //!                                       User APIs
  //! ---------------------------------------------------------------------------------------
  //! ---------------------------------------------------------------------------------------

  // ---------------------------------------------------------------------------------------------------------------------
  //                         Post and Delete Device Token
  // ---------------------------------------------------------------------------------------------------------------------

  /// this method is to be called when user is logging in (manually either through login page or signUp page)
  @Post(path: '/users/{userId}/notifications/device-token')
  Future<Response> registerFCMToken({
    @required @Path('userId') String userId,
    @required @Body() BuiltFCMToken body,
    @required @Header() String authorization,
  });

  /// this method is to be called when user is logging out.
  @Delete(path: '/users/{userId}/notifications/device-token')
  Future<Response> deleteFCMToken({
    @required @Path('userId') String userId,
    @required @Header() String authorization,
  });

  // --------------------------------------------------------------------------------------------------------------------------
  //        Check Username, Create User, Upload Avatar , Update User
  // ---------------------------------------------------------------------------------------------------------

  @Get(path: '/users/username-availability')
  Future<Response> isThisUsernameAvailable({
    @required @Query() String username,
    @required @Header() String authorization,
  });

  @Post(path: '/users/create')
  Future<Response> createNewUser({
    @required @Body() BuiltUser body,
    @required @Header() String authorization,
  });

  @Post(path: '/users/{userId}/avatar/')
  Future<Response> uploadAvatar({
    @required @Path('userId') String userId,
    @required @Body() BuiltProfileImage image,
    @required @Header() String authorization,
  });

  @Patch(path: '/users/{userId}')
  Future<Response> updateUser({
    @required @Path('userId') String userId,
    @required @Body() BuiltUser body,
    @required @Header() String authorization,
  });

  // ---------------------------------------------------------------------------------------------------------------------
  //                        Get User By Id or Username
  // ---------------------------------------------------------------------------------------------------------------------

  @Get(path: '/users')
  Future<Response<BuiltList<BuiltUser>>> getAllUsers({
    @required @Header() String authorization,
  });

  @Get(path: '/users/query')
  Future<Response<BuiltSearchUsers>> getUserbyUsername({
    @required @Query("username") String username,
    @required @Header() String authorization,
  });

  @Get(path: '/users/{userId}')
  Future<Response<BuiltProfile>> getUserProfile({
    @required @Path('userId') String userId, // user whom profile to be fetched
    @required @Query() String primaryUserId, // current logged in user
    @required @Header() String authorization,
  });

  // ---------------------------------------------------------------------------------------------------------------------
  //                        Get Notifications, Open Notification
  // ---------------------------------------------------------------------------------------------------------------------

  @Get(path: '/users/{userId}/notifications')
  Future<Response<BuiltNotificationList>> getNotifications({
    @required @Path('userId') String userId,
    @required @Header('lastevaluatedkey') String lastevaluatedkey,
    @required @Header() String authorization,
  });

  @Get(path: '/users/{userId}/notifications/opened')
  Future<Response<BuiltNotificationList>> responseToNotification({
    @required @Path('userId') String userId,
    @required @Query() String notificationId,
    @required @Header() String authorization,
  });

  // ---------------------------------------------------------------------------------------------------------------------
  //                           ----------Social Relation APIs----------
  //          Get Relation Data
  //          Follow, Send Friend Request, Accept Friend Request, Unfollow, Delete Friend Request, Unfriend
  // ---------------------------------------------------------------------------------------------------------------------

  @Get(path: '/users/{userId}/relations/')
  Future<Response<BuiltSearchUsers>> getRelations({
    @required @Path('userId') String userId,
    @required
    @Query('socialRelation')
        String
            socialRelation, //["followings","followers", "requests_sent", "requests_received","friends"]
    @required @Header('lastevaluatedkey') String lastevaluatedkey,
    @required @Header() String authorization,
  });

  @Post(path: '/users/{userId}/relations/add?action=follow')
  Future<Response> follow({
    @required @Path('userId') String userId,
    @required @Query('foreignUserId') String foreignUserId,
    @required @Header() String authorization,
  });

  @Post(path: '/users/{userId}/relations/add?action=send_friend_request')
  Future<Response> sendFriendRequest({
    @required @Path('userId') String userId,
    @required @Query('foreignUserId') String foreignUserId,
    @required @Header() String authorization,
  });

  @Post(path: '/users/{userId}/relations/add?action=accept_friend_request')
  Future<Response> acceptFriendRequest({
    @required @Path('userId') String userId,
    @required @Query('foreignUserId') String foreignUserId,
    @required @Header() String authorization,
  });

  @Post(path: '/users/{userId}/relations/remove?action=unfollow')
  Future<Response> unfollow({
    @required @Path('userId') String userId,
    @required @Query('foreignUserId') String foreignUserId,
    @required @Header() String authorization,
  });

  @Post(path: '/users/{userId}/relations/remove?action=delete_friend_request')
  Future<Response> deleteFriendRequest({
    @required @Path('userId') String userId,
    @required @Query('foreignUserId') String foreignUserId,
    @required @Header() String authorization,
  });

  @Post(path: '/users/{userId}/relations/remove?action=unfriend')
  Future<Response> unfriend({
    @required @Path('userId') String userId,
    @required @Query('foreignUserId') String foreignUserId,
    @required @Header() String authorization,
  });

  //! ---------------------------------------------------------------------------------------
  //! ---------------------------------------------------------------------------------------
  //!                           Club APIs
  //! ---------------------------------------------------------------------------------------
  //! ---------------------------------------------------------------------------------------

  //---------------------------------------------------------------------------------------------
  //                            Create Club , Upload Club Avatar
  //---------------------------------------------------------------------------------------------

  @Post(path: '/clubs/create/')
  Future<Response> createNewClub({
    @required @Body() BuiltClub body,
    @required @Query() String creatorId,
    @required @Header() String authorization,
  });

  @Post(path: 'clubs/{clubId}/avatar/')
  Future<Response> updateClubAvatar({
    @required @Path('clubId') String clubId,
    @required @Body() BuiltProfileImage image,
    @required @Header() String authorization,
  });

  //---------------------------------------------------------------------------------------------
  //                          Generate Agora Token to start club
  //---------------------------------------------------------------------------------------------

  @Post(path: '/clubs/{clubId}/agora/token/create/')
  Future<Response> generateAgoraTokenForClub({
    @required @Path() String clubId,
    @required @Query() String userId,
    @required @Header() String authorization,
  });

  //---------------------------------------------------------------------------------------------
  //                            Get Clubs, Club by Id, My Clubs (History/Organized)
  //                                      Search clubs by clubName
  //---------------------------------------------------------------------------------------------

  @Get(path: '/clubs')
  Future<Response<BuiltAllClubsList>> getAllClubs({
    @required @Header() String authorization,
  });

  @Get(path: '/clubs/{clubId}')
  Future<Response<BuiltClubAndAudience>> getClubByClubId({
    @required @Path() String clubId,
    @required @Query() String userId,
    @required @Header() String authorization,
  });

  @Get(path: '/myclubs/{userId}/history')
  Future<Response<BuiltSearchClubs>> getMyHistoryClubs({
    @required @Path('userId') String userId,
    @required @Header() String lastevaluatedkey,
    @required @Header() String authorization,
  });

  @Get(path: '/myclubs/{userId}/organized')
  Future<Response<BuiltSearchClubs>> getMyOrganizedClubs({
    @required @Path('userId') String userId,
    @required @Header() String lastevaluatedkey,
    @required @Header() String authorization,
  });

  @Get(path: '/clubs/query/')
  Future<Response<BuiltSearchClubs>> searchClubsByClubName({
    @required @Query() String clubName,
    @required @Header() String authorization,
  });

  //---------------------------------------------------------------------------------------------
  //                    Post Reaction , Fetch Reactions for club
  //---------------------------------------------------------------------------------------------

  @Post(path: '/clubs/{clubId}/reactions/')
  Future<Response> postReaction({
    @required @Path() String clubId,
    @required @Query() String audienceId,
    @required @Query() int indexValue,
    @required @Header() String authorization,
  });

  @Get(path: '/clubs/{clubId}/reactions/')
  Future<Response<BuiltReaction>> getReaction({
    @required @Path() String clubId,
    @required @Header() String authorization,
  });

  //---------------------------------------------------------------------------------------------
  //                                    Report Club
  //---------------------------------------------------------------------------------------------

  @Post(path: '/clubs/{clubId}/reports/')
  Future<Response> reportClub({
    @required @Query() String userId,
    @required @Body() ReportSummary report,
    @required @Path() String clubId,
    @required @Header() String authorization,
  });

  //---------------------------------------------------------------------------------------------
  //                           -----------Join Requests APIs-----------
  //---------------------------------------------------------------------------------------------

  //---------- Post Join request, Delete Join request -------------

  @Post(path: '/clubs/{clubId}/join-request')
  Future<Response> sendJoinRequest({
    @required @Path() String clubId,
    @required @Query() String userId,
    @required @Header() String authorization,
  });

  @Delete(path: '/clubs/{clubId}/join-request/')
  Future<Response> deleteJoinRequet({
    @required @Path() String clubId,
    @required @Query() String userId,
    @required @Header() String authorization,
  });

  //---------Get Active Join requests, Search in Active Join requests, Respond to active join requests-----------

  @Get(path: '/clubs/{clubId}/join-request')
  Future<Response<BuiltActiveJoinRequests>> getActiveJoinRequests({
    @required @Path() String clubId,
    @required @Header() String lastevaluatedkey,
    @required @Header() String authorization,
  });

  @Get(path: '/clubs/{clubId}/join-request/query')
  Future<Response<BuiltActiveJoinRequests>> searchInActiveJoinRequests({
    @required @Path() String clubId,
    @required @Query() String searchString,
    @required @Header() String lastevaluatedkey,
    @required @Header() String authorization,
  });

  @Post(path: '/clubs/{clubId}/join-request/response')
  Future<Response> respondToJoinRequest({
    @required @Path() String clubId,
    @required @Query() String action, // ["accept" or "cancel"]
    @required @Query() String audienceId,
    @required @Header() String authorization,
  });

  //---------------------------------------------------------------------------------------------
  //                     Mute , Kick, Block Panelist , All blocked users, Unblock user
  //---------------------------------------------------------------------------------------------

  @Post(path: '/clubs/{clubId}/mute/')
  Future<Response> muteParticipant({
    @required @Path() String clubId,
    @required @Query() String who, // ['all' or 'participant']
    @required @Query() String participantId,
    @required @Header() String authorization,
  });

  @Post(path: '/clubs/{clubId}/kick/')
  Future<Response> kickAudienceId({
    @required @Path() String clubId,
    @required @Query() String audienceId,
    @required @Header() String authorization,
  });

  @Post(path: '/clubs/{clubId}/block')
  Future<Response> blockPanelist({
    @required @Path() String clubId,
    @required @Query() String audienceId,
    @required @Header() String authorization,
  });

  @Get(path: '/clubs/{clubId}/block')
  Future<Response<BuiltActiveJoinRequests>> getAllBlockedUsers({
    @required @Path() String clubId,
    @required @Header() String authorization,
  });

  @Delete(path: '/clubs/{clubId}/block')
  Future<Response> unblockUser({
    @required @Path() String clubId,
    @required @Query() String audienceId,
    @required @Header() String authorization,
  });

  //---------------------------------------------------------------------------------------------
  //                    Invite All followers, invite specific participant/audience
  //---------------------------------------------------------------------------------------------

  @Post(path: '/clubs/{clubId}/invite/all-followers')
  Future<Response> inviteAllFollowers({
    @required @Path() String clubId,
    @required @Query() String sponsorId,
    @required @Header() String authorization,
  });

  @Post(path: '/clubs/{clubId}/invite/')
  Future<Response> inviteUsers({
    @required @Path() String clubId,
    @required @Query() String sponsorId,
    @required @Body() BuiltInviteFormat invite,
    @required @Header() String authorization,
  });

  //!---------------------------------------------------------------------------------------------
  //?                                Unified Query for User and Club
  //!---------------------------------------------------------------------------------------------

  @Get(path: '/query/')
  Future<Response<BuiltUnifiedSearchResults>> unifiedQueryRoutes({
    @required @Query() String searchString,
    @required @Query() String type, //["unified","clubs","users"]
    @required @Header() String lastevaluatedkey,
    @required @Header() String authorization,
  });

  //!---------------------------------------------------------------------------------------------
  //!---------------------------------------------------------------------------------------------
  //!---------------------------------------------------------------------------------------------
  //!---------------------------------------------------------------------------------------------
  //!---------------------------------------------------------------------------------------------
  //!---------------------------------------------------------------------------------------------

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
