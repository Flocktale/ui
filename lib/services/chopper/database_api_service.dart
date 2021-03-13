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
  Future<Response<UsernameAvailability>> isThisUsernameAvailable({
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

  @Post(path: '/users/{userId}/notifications/opened')
  Future<Response> responseToNotification({
    @required @Path('userId') String userId,
    @required @Query() String notificationId,
    @required @Header() String authorization,
    @required @Query() String action,
  });

  // ---------------------------------------------------------------------------------------------------------------------
  //                           ----------Social Relation APIs----------
  //          Get Relation Data, relation with a user,
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

  @Get(path: '/users/{userId}/relations/object')
  Future<Response<RelationIndexObject>> getRelationIndexObject({
    @required @Path('userId') String userId,
    @required @Query('foreignUserId') String foreignUserId,
    @required @Header() String authorization,
  });

  @Post(path: '/users/{userId}/relations/add?action=follow')
  Future<Response<RelationActionResponse>> follow({
    @required @Path('userId') String userId,
    @required @Query('foreignUserId') String foreignUserId,
    @required @Header() String authorization,
  });

  @Post(path: '/users/{userId}/relations/add?action=send_friend_request')
  Future<Response<RelationActionResponse>> sendFriendRequest({
    @required @Path('userId') String userId,
    @required @Query('foreignUserId') String foreignUserId,
    @required @Header() String authorization,
  });

  @Post(path: '/users/{userId}/relations/add?action=accept_friend_request')
  Future<Response<RelationActionResponse>> acceptFriendRequest({
    @required @Path('userId') String userId,
    @required @Query('foreignUserId') String foreignUserId,
    @required @Header() String authorization,
  });

  @Post(path: '/users/{userId}/relations/remove?action=unfollow')
  Future<Response<RelationActionResponse>> unfollow({
    @required @Path('userId') String userId,
    @required @Query('foreignUserId') String foreignUserId,
    @required @Header() String authorization,
  });

  @Post(path: '/users/{userId}/relations/remove?action=delete_friend_request')
  Future<Response<RelationActionResponse>> deleteFriendRequest({
    @required @Path('userId') String userId,
    @required @Query('foreignUserId') String foreignUserId,
    @required @Header() String authorization,
  });

  @Post(path: '/users/{userId}/relations/remove?action=unfriend')
  Future<Response<RelationActionResponse>> unfriend({
    @required @Path('userId') String userId,
    @required @Query('foreignUserId') String foreignUserId,
    @required @Header() String authorization,
  });


  // Contact Sync API

  @Get(path: '/users/contacts-sync')
  Future<Response<SummaryUser>> syncContacts({
    @required @Query('contacts') BuiltList<String> contacts
  });

  @Post(path: '/users/contacts-sync')
  Future<Response> syncContactsByPost({
    @required @Body() BuiltContacts body
  });



  //! ---------------------------------------------------------------------------------------
  //! ---------------------------------------------------------------------------------------
  //!                           Club APIs
  //! ---------------------------------------------------------------------------------------
  //! ---------------------------------------------------------------------------------------

  //---------------------------------------------------------------------------------------------
  //                            Create Club , Upload Club Avatar
  //---------------------------------------------------------------------------------------------

  @Post(path: '/clubs/global/create/')
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
  //                           Start club for first time, Conclude Club
  //---------------------------------------------------------------------------------------------

  @Post(path: '/clubs/{clubId}/start/')
  Future<Response> startClub({
    @required @Path() String clubId,
    @required @Query() String userId,
    @required @Header() String authorization,
  });

  @Post(path: '/clubs/{clubId}/conclude/')
  Future<Response> concludeClub({
    @required @Path() String clubId,
    @required @Query() String creatorId,
    @required @Header() String authorization,
  });

  //---------------------------------------------------------------------------------------------
  //                            Get All Clubs, Clubs of a category, Club by Id, My Clubs (History/Organized, current/upcoming), categoryData
  //                                      Search clubs by clubName
  //---------------------------------------------------------------------------------------------

  @Get(path: '/users/{userId}/clubs/relation?socialRelation=friend')
  Future<Response<BuiltSearchClubs>> getClubsOfFriends({
    @required @Path() String userId,
    @required @Header() String authorization,
    @required @Header() String lastevaluatedkey,
  });

  @Get(path: '/users/{userId}/clubs/relation?socialRelation=following')
  Future<Response<BuiltSearchClubs>> getClubsOfFollowings({
    @required @Path() String userId,
    @required @Header() String authorization,
    @required @Header() String lastevaluatedkey,
  });

  @Get(path: '/clubs/global')
  Future<Response<BuiltAllClubsList>> getAllClubs({
    @required @Header() String authorization,
  });

  @Get(path: '/clubs/global')
  Future<Response<BuiltSearchClubs>> getClubsOfCategory({
    @required @Query() String category,
    @required @Header() String lastevaluatedkey,
    @required @Header() String authorization,
  });

  @Get(path: '/clubs/global/category-data')
  Future<Response> getCategoryData({
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

  @Get(path: '/myclubs/{userId}/organized?upcoming=true')
  Future<Response<BuiltSearchClubs>> getMyCurrentAndUpcomingClubs({
    @required @Path('userId') String userId,
    @required @Header() String authorization,
  });

  @Get(path: '/clubs/query/')
  Future<Response<BuiltSearchClubs>> searchClubsByClubName({
    @required @Query() String clubName,
    @required @Header() String authorization,
  });

  //---------------------------------------------------------------------------------------------
  //                    Get Participant list and audience list
  //---------------------------------------------------------------------------------------------

  @Get(path: '/clubs/{clubId}/participants/')
  Future<Response<BuiltList<AudienceData>>> getParticipantList({
    @required @Path() String clubId,
    @required @Header() String authorization,
  });

  @Get(path: '/clubs/{clubId}/audience/')
  Future<Response<BuiltAudienceList>> getAudienceList({
    @required @Path() String clubId,
    @required @Header() String lastevaluatedkey,
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
  Future<Response> muteActionOnParticipant({
    @required @Path() String clubId,
    @required @Query() String who, // ['all' or 'participant']
    @required @Query() String participantId,
    @required @Query() String muteAction, // ['mute' or 'unmute']
    @required @Header() String authorization,
  });

  @Post(path: '/clubs/{clubId}/kick/')
  Future<Response> kickOutParticipant({
    @required @Path() String clubId,
    @required @Query() String audienceId,
    @required
    @Query()
        String
            isSelf, // true if panelist himself chooses to become listener only.
    @required @Header() String authorization,
  });

  @Post(path: '/clubs/{clubId}/block')
  Future<Response> blockAudience({
    @required @Path() String clubId,
    @required @Query() String audienceId,
    @required @Header() String authorization,
  });

  @Get(path: '/clubs/{clubId}/block')
  Future<Response<BuiltList<AudienceData>>> getAllBlockedUsers({
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
      baseUrl: 'https://18bmot2ra5.execute-api.ap-south-1.amazonaws.com/Stage',
      // baseUrl: 'https://b0b83928c6bc.ngrok.io',
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
