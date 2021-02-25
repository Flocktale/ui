import 'package:agora_handler/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:mootclub_app/Models/built_post.dart';

class AgoraController {
  AgoraHandler _agoraHandler;
  bool _isClubMuted;

  bool isMicMuted;
  BuiltClub club;

  AgoraController create() {
    if (_agoraHandler != null) return this;

    _agoraHandler = AgoraHandler();
    _isClubMuted = false;
    isMicMuted = true;
    _agoraHandler.init();
    return this;
  }

  bool get isPlaying => club != null;

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
    if (club != null) {
      await _agoraHandler.leaveClub();
      club = null;
    }
  }

  Future<void> toggleClubMute() async {
    _isClubMuted = !_isClubMuted;
    await _agoraHandler.muteSwitchClub(_isClubMuted);
  }

  Future<void> dispose() async {
    club = null;
    await _agoraHandler.dispose();
    _agoraHandler = null;
  }

  Future<void> hardMuteAction(bool muteAction) async {
    assert(muteAction != null);

    isMicMuted = muteAction;
    await _agoraHandler.muteSwitchMic(muteAction);
  }
}
