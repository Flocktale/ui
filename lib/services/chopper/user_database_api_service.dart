import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;

import '../../Models/built_post.dart';
import 'built_value_converter.dart';
import 'package:built_collection/built_collection.dart';

part 'user_database_api_service.chopper.dart';

// command for build runner - flutter packages pub run build_runner watch --delete-conflicting-outputs --use-polling-watcher

@ChopperApi(baseUrl: '')
abstract class UserDatabaseApiService extends ChopperService {
  @Get(path: '/users/{userId}')
  Future<Response<BuiltUser>> getUser(@Path('userId') String userId);

  @Get(path: '/users')
  Future<Response<BuiltList<BuiltUser>>> getAllUsers();

  @Post(path: '/users/create')
  Future<Response> createNewUser(@Body() BuiltUser body);

  @Post(path: '/users/{userId}/avatar/')
  @Multipart()
  Future<Response> uploadAvatar(
    @Path('userId') String userId,
    @Body() BuiltProfileImage image,
  );

  @Post(path: '/users/{userId}/uploadImage')
  Future<Response> uploadProfilePic(
      @Path('userId') String userId, @Body() BuiltProfileImage body);

  @Post(path: '/users/{userId}/relations/add?action=follow')
  Future<Response> follow(
    @Path('userId') String userId,
    @Query('foreignUserId') String foreignUserId,
  );

  @Post(path: '/users/{userId}/relations/add?action=send_friend_request')
  Future<Response> sendFriendRequest(
    @Path('userId') String userId,
    @Query('foreignUserId') String foreignUserId,
  );

  @Post(path: '/users/{userId}/relations/add?action=accept_friend_request')
  Future<Response> acceptFriendRequest(
    @Path('userId') String userId,
    @Query('foreignUserId') String foreignUserId,
  );

  @Post(path: '/users/{userId}/relations/remove?action=unfollow')
  Future<Response> unfollow(
    @Path('userId') String userId,
    @Query('foreignUserId') String foreignUserId,
  );

  @Post(path: '/users/{userId}/relations/remove?action=deleteFriendRequest')
  Future<Response> deleteFriendRequest(
    @Path('userId') String userId,
    @Query('foreignUserId') String foreignUserId,
  );

  @Post(path: '/users/{userId}/relations/remove?action=unfriend')
  Future<Response> unfriend(
    @Path('userId') String userId,
    @Query('foreignUserId') String foreignUserId,
  );

  // it won't work!! We will retrieve this data when querying the object.
  @Get(path: '/users/{userId}/relations/{username}/{followingUsername}')
  Future<Response> checkFollow(
    @Path('userId') String userId,
    @Path('username') String username,
    @Path('followingUsername') String followingUsername,
  );

  @Patch(path: '/users/{userId}')
  Future<Response> updateUser(
    @Path('userId') String userId,
    @Body() BuiltUser body,
  );

  @Get(path: '/users/query')
  Future<Response<BuiltSearchUsers>> getUserbyUsername(
      @Query("username") String username);

  // ---------------------------------------------------------------------
  //                           Club APIs
  //----------------------------------------------------------------------
  
  @Get(path: '/clubs')
  Future<Response<BuiltAllClubsList>> getAllClubs();


  // ClubName and ClubCategory is required
  @Post(path: '/clubs/create/')
  Future<Response> createNewClub(
    @Body() BuiltClub body,
    @Query() String creatorId,
  );

  @Get(path: '/myclubs/{userId}/organized')
  Future<Response<BuiltSearchClubs>> getMyOrganizedClubs(
    @Path('userId') String userId, {
    @Header() String lastevaluatedkey,
  });

  @Get(path: '/myclubs/{userId}/history')
  Future<Response<BuiltSearchClubs>> getMyHistoryClubs(
    @Path('userId') String userId, {
    @Header() String lastevaluatedkey,
  });

  @Get(path: '/clubs/query/')
  Future<Response<BuiltSearchClubs>> searchClubsByClubName(
    @Query() String clubName,
  );

  @Get(path: '/clubs/{clubId}')
  Future<Response<BuiltClub>> getClubByClubId(
    @Path() String clubId,
  );

  @Post(path: 'clubs/{clubId}/avatar/') 
  @Multipart()
  Future<Response> updateClubAvatar(
    @Path('clubId') String clubId,
    @Body() BuiltProfileImage image,
  );

  @Post(path: '/clubs/{clubId}/enter/')
  Future<Response> enterClub(
    @Path() String clubId,
    @Query() String userId
  );

  //TODO
  // @Post(path: '/clubs/{clubId}/reaction/')
  // Future<Response> reaction(
  //   @Path() String clubId,
  //   @Query() String userId
  // );

  
  //TODO
  // Get reactions


  @Post(path: '/clubs/{clubId}/reports/')
  Future<Response> reportUser(
    @Query() String userId,
    @Body() String body,
    @Path() String clubId,
  );

  



  static UserDatabaseApiService create() {
    final client = ChopperClient(
      baseUrl: 'https://863u7os9ui.execute-api.us-east-1.amazonaws.com/Prod',
      services: [
        _$UserDatabaseApiService(),
      ],
      converter: BuiltValueConverter(),
      interceptors: [
        HttpLoggingInterceptor(),
      ],
    );

    return _$UserDatabaseApiService(client);
  }
}
