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
  AgoraToken token;

  // this map is used for the case when remote audio state callback is fired before websocket message containing new participant
// for such case, we are saving the mute status of that user beforehand in this map.
  final Map<int, bool> remoteAudioMuteStatesWithUid = {};

// encrypted integer equivalent mapped to  their usernames
  final Map<int, String> integerUsernames = {};

  AgoraController create({bool isMuted = false}) {
    isMicMuted = isMuted;

    if (_agoraHandler != null) {
      hardMuteAction(isMicMuted);
      return this;
    }
    _agoraHandler = AgoraHandler();
    _isClubMuted = false;
    _agoraHandler.init().then((handler) async {
      agoraEventHandler = handler;
      await hardMuteAction(isMicMuted);
    });
    return this;
  }

  bool get isPlaying => club != null;

  Future<void> joinAsAudience({
    @required String clubId,
    @required AgoraToken agoraToken,
    @required String username,
  }) async {
    assert(clubId != null && agoraToken?.agoraToken != null);

    this.token = agoraToken;

    await _agoraHandler.joinClub(
      clubId,
      token.agoraToken,
      integerUsername: convertToInt(username),
    );

    // _agoraHandler._eventHandler.audioVolumeIndication = audioVolumeIndication;
  }

  Future<void> joinAsParticipant({
    @required String clubId,
    @required AgoraToken agoraToken,
    @required String username,
  }) async {
    assert(clubId != null && agoraToken?.agoraToken != null);

    this.token = agoraToken;

    await _agoraHandler.joinClub(
      clubId,
      token.agoraToken,
      isHost: true,
      integerUsername: convertToInt(username),
    );
  }

  Future<void> stop() async {
    if (club != null) {
      await _agoraHandler.leaveClub();
      club = null;
      token = null;
    }
  }

  Future<void> toggleClubMute() async {
    _isClubMuted = !_isClubMuted;
    await _agoraHandler.muteSwitchClub(_isClubMuted);
  }

  Future<void> dispose() async {
    club = null;
    // if(_agoraHandler!=null)
    await _agoraHandler?.dispose();
    _agoraHandler = null;
  }

  Future<void> hardMuteAction(bool muteAction) async {
    assert(muteAction != null);

    isMicMuted = muteAction;
    await _agoraHandler.muteSwitchMic(muteAction);
  }

  int convertToInt(String username) {
    int hash = 0;
    const int p = 53;
    const int m = 1000000009;
    int pPow = 1;
    username.runes.forEach((c) {
      hash = (hash + (c - 94 + 1) * pPow) % m;
      pPow = (pPow * p) % m;
    });
    return hash;
  }
}
