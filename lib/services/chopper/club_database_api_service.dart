import 'package:chopper/chopper.dart';

import '../../Models/built_post.dart';
import 'built_value_converter.dart';
import 'package:built_collection/built_collection.dart';

part 'club_database_api_service.chopper.dart';

// command for build runner - flutter packages pub run build_runner watch --delete-conflicting-outputs --use-polling-watcher

@ChopperApi(baseUrl: '')
abstract class ClubDatabaseApiService extends ChopperService {
  @Get(path: '/clubs')
  Future<Response<BuiltList<BuiltClub>>> getAllClubs();

  @Post(path: '/clubs/create')
  Future<Response> createNewClub(@Body() BuiltClub body);

  static ClubDatabaseApiService create() {
    final client = ChopperClient(
      baseUrl: 'https://0qbzcl7di6.execute-api.us-east-1.amazonaws.com/Prod',
      services: [
        _$ClubDatabaseApiService(),
      ],
      converter: BuiltValueConverter(),
      interceptors: [
        HttpLoggingInterceptor(),
      ],
    );

    return _$ClubDatabaseApiService(client);
  }
}
