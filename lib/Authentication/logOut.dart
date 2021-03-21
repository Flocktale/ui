import 'package:flocktale/providers/agoraController.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/providers/webSocket.dart';
import 'package:flocktale/services/SecureStorage.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

logOutUser(context) async {
  final _storage = SecureStorage();
  final _userId = Provider.of<UserData>(context, listen: false).userId;

  await Future.wait([
    _storage.logout(),
    Provider.of<AgoraController>(context, listen: false).dispose(),
    Provider.of<DatabaseApiService>(context, listen: false)
        .deleteFCMToken(userId: _userId),
    Provider.of<MySocket>(context, listen: false).closeConnection(),
  ]);

  Phoenix.rebirth(context);
}
