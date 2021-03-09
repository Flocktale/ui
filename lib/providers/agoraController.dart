import 'package:agora_handler/main.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flocktale/Models/built_post.dart';

class AgoraController {
  AgoraHandler _agoraHandler;

  /// use this handler to listen to various callbacks related to agora.
  RtcEngineEventHandler agoraEventHandler;

  bool _isClubMuted;

  bool isMicMuted;
  BuiltClub club;

  AgoraController create() {
    if (_agoraHandler != null) return this;

    _agoraHandler = AgoraHandler();
    _isClubMuted = false;
    isMicMuted = true;
    _agoraHandler.init().then((handler) => agoraEventHandler = handler);
    return this;
  }

  bool get isPlaying => club != null;

  Future<void> joinAsAudience({
    @required String clubId,
    @required String token,
    @required int intergerUsername,
  }) async {
    assert(clubId != null && token != null);
    await _agoraHandler.joinClub(clubId, token,
        integerUsername: intergerUsername ?? 0);
  }

  Future<void> joinAsParticipant({
    @required String clubId,
    @required String token,
    @required int intergerUsername,
  }) async {
    assert(clubId != null && token != null);
    await _agoraHandler.joinClub(clubId, token,
        isHost: true, integerUsername: intergerUsername ?? 0);
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
