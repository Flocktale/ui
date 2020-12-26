// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club_database_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$ClubDatabaseApiService extends ClubDatabaseApiService {
  _$ClubDatabaseApiService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = ClubDatabaseApiService;

  @override
  Future<Response<BuiltList<BuiltClub>>> getAllClubs() {
    final $url = '/clubs';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<BuiltList<BuiltClub>, BuiltClub>($request);
  }

  @override
  Future<Response<dynamic>> createNewClub(BuiltClub body) {
    final $url = '/clubs/create';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }
}
