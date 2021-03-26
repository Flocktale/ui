import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';

import '../../Models/built_post.dart';
import 'built_value_converter.dart';
import 'package:built_collection/built_collection.dart';

import 'customInterceptor.dart';

part 'database_api_service.chopper.dart';

// command for build runner - flutter packages pub run build_runner watch --delete-conflicting-outputs --use-polling-watcher

@ChopperApi(baseUrl: '')
abstract class DatabaseApiService extends ChopperService {
  // ---------------------------------------------------------------------------------------------------------------------
  //                                      Get App Configs
  // ---------------------------------------------------------------------------------------------------------------------

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
  });

  /// this method is to be called when user is logging out.
  @Delete(path: '/users/{userId}/notifications/device-token')
  Future<Response> deleteFCMToken({
    @required @Path('userId') String userId,
  });

  // --------------------------------------------------------------------------------------------------------------------------
  //              Get AppConfigs, Check Username, Create User, Upload Avatar , Update User
  // ---------------------------------------------------------------------------------------------------------

  /// there will be no authorization for this api
  @Get(path: '/users/global/app-configs')
  Future<Response<AppConfigs>> getAppConfigs(
      [@Header() String noAuthRequired = 'true']);

  @Get(path: '/users/global/username-availability')
  Future<Response<UsernameAvailability>> isThisUsernameAvailable({
    @required @Query() String username,
  });

  @Post(path: '/users/global/create')
  Future<Response> createNewUser({
    @required @Body() BuiltUser body,
  });

  @Post(path: '/users/{userId}/avatar/')
  Future<Response> uploadAvatar({
    @required @Path('userId') String userId,
    @required @Body() BuiltProfileImage image,
  });

  @Patch(path: '/users/{userId}')
  Future<Response> updateUser({
    @required @Path('userId') String userId,
    @required @Body() BuiltUser body,
  });

  // ---------------------------------------------------------------------------------------------------------------------
  //                        Get User By Id or Username
  // ---------------------------------------------------------------------------------------------------------------------

  @Get(path: '/users')
  Future<Response<BuiltList<BuiltUser>>> getAllUsers();

  @Get(path: '/users/query')
  Future<Response<BuiltSearchUsers>> getUserbyUsername({
    @required @Query("username") String username,
  });

  @Get(path: '/users/{userId}')
  Future<Response<BuiltProfile>> getUserProfile({
    @required @Path('userId') String userId, // user whom profile to be fetched
    @required @Query() String primaryUserId, // current logged in user
  });

  // ---------------------------------------------------------------------------------------------------------------------
  //                        Get Notifications, Open Notification
  // ---------------------------------------------------------------------------------------------------------------------

  @Get(path: '/users/{userId}/notifications')
  Future<Response<BuiltNotificationList>> getNotifications({
    @required @Path('userId') String userId,
    @Header() String lastevaluatedkey,
  });

  @Post(path: '/users/{userId}/notifications/opened')
  Future<Response> responseToNotification({
    @required @Path('userId') String userId,
    @required @Query() String notificationId,
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
    @Header() String lastevaluatedkey,
  });

  @Get(path: '/users/{userId}/relations/object')
  Future<Response<RelationIndexObject>> getRelationIndexObject({
    @required @Path('userId') String userId,
    @required @Query('foreignUserId') String foreignUserId,
  });

  @Post(path: '/users/{userId}/relations/add?action=follow')
  Future<Response<RelationActionResponse>> follow({
    @required @Path('userId') String userId,
    @required @Query('foreignUserId') String foreignUserId,
  });

  @Post(path: '/users/{userId}/relations/add?action=send_friend_request')
  Future<Response<RelationActionResponse>> sendFriendRequest({
    @required @Path('userId') String userId,
    @required @Query('foreignUserId') String foreignUserId,
  });

  @Post(path: '/users/{userId}/relations/add?action=accept_friend_request')
  Future<Response<RelationActionResponse>> acceptFriendRequest({
    @required @Path('userId') String userId,
    @required @Query('foreignUserId') String foreignUserId,
  });

  @Post(path: '/users/{userId}/relations/remove?action=unfollow')
  Future<Response<RelationActionResponse>> unfollow({
    @required @Path('userId') String userId,
    @required @Query('foreignUserId') String foreignUserId,
  });

  @Post(path: '/users/{userId}/relations/remove?action=delete_friend_request')
  Future<Response<RelationActionResponse>> deleteFriendRequest({
    @required @Path('userId') String userId,
    @required @Query('foreignUserId') String foreignUserId,
  });

  @Post(path: '/users/{userId}/relations/remove?action=unfriend')
  Future<Response<RelationActionResponse>> unfriend({
    @required @Path('userId') String userId,
    @required @Query('foreignUserId') String foreignUserId,
  });

  // Contact Sync API

  @Post(path: '/users/global/contacts-sync')
  Future<Response<BuiltList<SummaryUser>>> syncContactsByPost(
      {@required @Body() BuiltContacts body});

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
  });

  @Post(path: 'clubs/{clubId}/avatar/')
  Future<Response> updateClubAvatar({
    @required @Path('clubId') String clubId,
    @required @Body() BuiltProfileImage image,
  });

  //---------------------------------------------------------------------------------------------
  //                           Start club for first time, Conclude Club
  //---------------------------------------------------------------------------------------------

  @Post(path: '/clubs/{clubId}/start/')
  Future<Response> startClub({
    @required @Path() String clubId,
    @required @Query() String userId,
  });

  @Post(path: '/clubs/{clubId}/conclude/')
  Future<Response> concludeClub({
    @required @Path() String clubId,
    @required @Query() String creatorId,
  });

  //---------------------------------------------------------------------------------------------
  //                            Get All Clubs, Clubs of a category, Club by Id, My Clubs (History/Organized, current/upcoming), categoryData
  //                                      Search clubs by clubName
  //---------------------------------------------------------------------------------------------

  @Get(path: '/users/{userId}/clubs/relation?socialRelation=friend')
  Future<Response<BuiltSearchClubs>> getClubsOfFriends({
    @required @Path() String userId,
    @Header() String lastevaluatedkey,
  });

  @Get(path: '/users/{userId}/clubs/relation?socialRelation=following')
  Future<Response<BuiltSearchClubs>> getClubsOfFollowings({
    @required @Path() String userId,
    @Header() String lastevaluatedkey,
  });

  @Get(path: '/clubs/global')
  Future<Response<BuiltAllClubsList>> getAllClubs();

  @Get(path: '/clubs/global')
  Future<Response<BuiltSearchClubs>> getClubsOfCategory({
    @required @Query() String category,
    @Header() String lastevaluatedkey,
  });

  @Get(path: '/clubs/global/category-data')
  Future<Response> getCategoryData();

  @Get(path: '/clubs/{clubId}')
  Future<Response<BuiltClubAndAudience>> getClubByClubId({
    @required @Path() String clubId,
    @required @Query() String userId,
  });

  @Get(path: '/myclubs/{userId}/history')
  Future<Response<BuiltSearchClubs>> getMyHistoryClubs({
    @required @Path('userId') String userId,
    @Header() String lastevaluatedkey,
  });

  @Get(path: '/myclubs/{userId}/organized')
  Future<Response<BuiltSearchClubs>> getMyOrganizedClubs({
    @required @Path('userId') String userId,
    @Header() String lastevaluatedkey,
  });

  @Get(path: '/myclubs/{userId}/organized?upcoming=true')
  Future<Response<BuiltSearchClubs>> getMyCurrentAndUpcomingClubs({
    @required @Path('userId') String userId,
  });

  @Get(path: '/clubs/query/')
  Future<Response<BuiltSearchClubs>> searchClubsByClubName({
    @required @Query() String clubName,
  });

  //---------------------------------------------------------------------------------------------
  //                    Get Participant list and audience list
  //---------------------------------------------------------------------------------------------

  @Get(path: '/clubs/{clubId}/participants/')
  Future<Response<BuiltList<AudienceData>>> getParticipantList({
    @required @Path() String clubId,
  });

  @Get(path: '/clubs/{clubId}/audience/')
  Future<Response<BuiltAudienceList>> getAudienceList({
    @required @Path() String clubId,
    @Header() String lastevaluatedkey,
  });

  //---------------------------------------------------------------------------------------------
  //                    Post Reaction , Fetch Reactions for club
  //---------------------------------------------------------------------------------------------

  @Post(path: '/clubs/{clubId}/reactions/')
  Future<Response> postReaction({
    @required @Path() String clubId,
    @required @Query() String audienceId,
    @required @Query() int indexValue,
  });

  @Get(path: '/clubs/{clubId}/reactions/')
  Future<Response<BuiltReaction>> getReaction({
    @required @Path() String clubId,
  });

  //---------------------------------------------------------------------------------------------
  //                                    Report Club
  //---------------------------------------------------------------------------------------------

  @Post(path: '/clubs/{clubId}/reports/')
  Future<Response> reportClub({
    @required @Query() String userId,
    @required @Body() ReportSummary report,
    @required @Path() String clubId,
  });

  //---------------------------------------------------------------------------------------------
  //                           -----------Join Requests APIs-----------
  //---------------------------------------------------------------------------------------------

  //---------- Post Join request, Delete Join request -------------

  @Post(path: '/clubs/{clubId}/join-request')
  Future<Response> sendJoinRequest({
    @required @Path() String clubId,
    @required @Query() String userId,
  });

  @Delete(path: '/clubs/{clubId}/join-request/')
  Future<Response> deleteJoinRequet({
    @required @Path() String clubId,
    @required @Query() String userId,
  });

  //---------Get Active Join requests, Search in Active Join requests, Respond to active join requests-----------

  @Get(path: '/clubs/{clubId}/join-request')
  Future<Response<BuiltActiveJoinRequests>> getActiveJoinRequests({
    @required @Path() String clubId,
    @Header() String lastevaluatedkey,
  });

  @Get(path: '/clubs/{clubId}/join-request/query')
  Future<Response<BuiltActiveJoinRequests>> searchInActiveJoinRequests({
    @required @Path() String clubId,
    @required @Query() String searchString,
    @Header() String lastevaluatedkey,
  });

  @Post(path: '/clubs/{clubId}/join-request/response')
  Future<Response> respondToJoinRequest({
    @required @Path() String clubId,
    @required @Query() String action, // ["accept" or "cancel"]
    @required @Query() String audienceId,
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
  });

  @Post(path: '/clubs/{clubId}/kick/')
  Future<Response> kickOutParticipant({
    @required @Path() String clubId,
    @required @Query() String audienceId,
    @required
    @Query()
        String
            isSelf, // true if panelist himself chooses to become listener only.
  });

  @Post(path: '/clubs/{clubId}/block')
  Future<Response> blockAudience({
    @required @Path() String clubId,
    @required @Query() String audienceId,
  });

  @Get(path: '/clubs/{clubId}/block')
  Future<Response<BuiltList<AudienceData>>> getAllBlockedUsers({
    @required @Path() String clubId,
  });

  @Delete(path: '/clubs/{clubId}/block')
  Future<Response> unblockUser({
    @required @Path() String clubId,
    @required @Query() String audienceId,
  });

  //---------------------------------------------------------------------------------------------
  //                    Invite All followers, invite specific participant/audience
  //---------------------------------------------------------------------------------------------

  @Post(path: '/clubs/{clubId}/invite/all-followers')
  Future<Response> inviteAllFollowers({
    @required @Path() String clubId,
    @required @Query() String sponsorId,
  });

  @Post(path: '/clubs/{clubId}/invite/')
  Future<Response> inviteUsers({
    @required @Path() String clubId,
    @required @Query() String sponsorId,
    @required @Body() BuiltInviteFormat invite,
  });

  //!---------------------------------------------------------------------------------------------
  //?                                Unified Query for User and Club
  //!---------------------------------------------------------------------------------------------

  @Get(path: '/query/')
  Future<Response<BuiltUnifiedSearchResults>> unifiedQueryRoutes({
    @required @Query() String searchString,
    @required @Query() String type, //["unified","clubs","users","communities"]
    @Header() String lastevaluatedkey,
  });

  //! ---------------------------------------------------------------------------------------
  //! ---------------------------------------------------------------------------------------
  //!                           Community APIs
  //! ---------------------------------------------------------------------------------------
  //! ---------------------------------------------------------------------------------------

  @Get(path: '/communities/global/')
  Future<Response> getAllCommunities({@Header() String lastevaluatedkey});

  @Post(path: '/communities/global/create/')
  Future<Response> createCommunity({
    @required @Body() body,
    @required @Query() creatorId,
  });

  @Get(path: '/mycommunities/{userId}?type=HOST')
  Future<Response> getMyHostedCommunities({@required @Path() String userId});

  @Get(path: '/mycommunities/{userId}?type=MEMBER')
  Future<Response> getMyMemberCommunities({
    @required @Path() String userId,
    @Header() String lastevaluatedkey,
  });

  @Get(path: '/communities/{communityId}/')
  Future<Response> getCommunityData(@Path() String communityId);

  @Patch(path: '/communities/{communityId}/')
  Future<Response> updateCommunityData(
      @Path() String communityId, @Body() body); // to update description only.

  @Get(path: '/communities/{communityId}/users')
  Future<Response> getCommunityUsers(
    @Path() String communityId, {
    @required @Query() type, //["HOST","MEMBER"]
    @Header() String lastevaluatedkey,
  });

  @Post(path: '/communities/{communityId}/users')
  Future<Response> addCommunityUser(
    @Path() String communityId, {
    @required @Query() type, //["HOST","MEMBER"]
    @required @Query() userId,
  });

  @Delete(path: '/communities/{communityId}/users')
  Future<Response> removeCommunityUser(
    @Path() String communityId, {
    @required @Query() type, //["HOST","MEMBER"]
    @required @Query() userId,
  });

  @Post(path: '/communities/{communityId}/image/')
  Future<Response> uploadCommunityImages(
    @Path() String communityId, {
    @Body() body,
  });

  /// to get live/scheduled clubs
  @Get(path: '/communities/{communityId}/clubs/')
  Future<Response> getCommunityActiveClubs(
    @Path() String communityId, {
    @Header() String lastevaluatedkey,
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
      // baseUrl: 'https://edcebf8059db.ngrok.io',
      services: [
        _$DatabaseApiService(),
      ],
      converter: BuiltValueConverter(),
      interceptors: [
        HttpLoggingInterceptor(),
        CustomInterceptor(),
      ],
    );

    return _$DatabaseApiService(client);
  }
}
