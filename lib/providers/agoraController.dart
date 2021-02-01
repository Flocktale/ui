import 'package:agora_handler/main.dart';
import 'package:flutter/cupertino.dart';

class AgoraController {
  AgoraHandler _agoraHandler;
  bool _isClubMuted;
  bool _isMicMuted;

  AgoraController create() {
    _agoraHandler = AgoraHandler();
    _isClubMuted = false;
    _isMicMuted = true;
    _agoraHandler.init();
    return this;
  }

  Future<void> joinAsAudience({
    @required String clubId,
    @required String token,
  }) async {
    assert(clubId != null && token != null);
    await _agoraHandler.joinClub(clubId, token);
  }

  Future<void> joinAsParticipant({
    @required String clubId,
    @required String token,
  }) async {
    assert(clubId != null && token != null);
    await _agoraHandler.joinClub(clubId, token, isHost: true);
  }

  Future<void> stop() async {
    await _agoraHandler.leaveClub();
  }

  Future<void> toggleClubMute() async {
    _isClubMuted = !_isClubMuted;
    await _agoraHandler.muteSwitchClub(_isClubMuted);
  }

  Future<void> toggleMicMute() async {
    _isMicMuted = !_isMicMuted;
    await _agoraHandler.muteSwitchMic(_isMicMuted);
  }

  Future<void> dispose() async {
    await _agoraHandler.dispose();
  }
}
