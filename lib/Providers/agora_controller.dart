import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:talkitup/Models/room.dart';
import 'package:talkitup/Services/agora_handler.dart';

class AgoraController {
  AgoraHandler? _agoraHandler;

  /// use this handler to listen to various callbacks related to agora.
  RtcEngineEventHandler? agoraEventHandler;

  late bool isMicMuted;
  Room? room;
  String? token;

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
    _agoraHandler?.init().then((handler) async {
      agoraEventHandler = handler;
      await hardMuteAction(isMicMuted);
    });
    return this;
  }

  Future<void> joinAsAudience({
    required String roomId,
    required String token,
    required String username,
  }) async {
    this.token = token;

    await _agoraHandler?.joinRoom(
      roomId,
      token: token,
      integerUsername: convertToInt(username),
    );

    // _agoraHandler._eventHandler.audioVolumeIndication = audioVolumeIndication;
  }

  Future<void> joinAsParticipant({
    required String roomId,
    required String token,
    required String username,
  }) async {
    this.token = token;

    await _agoraHandler?.joinRoom(
      roomId,
      token: token,
      isHost: true,
      integerUsername: convertToInt(username),
    );
    await hardMuteAction(true);
  }

  Future<void> stop() async {
    await _agoraHandler?.leaveRoom();
    room = null;
    token = null;
  }

  Future<void> dispose() async {
    room = null;
    // if(_agoraHandler!=null)
    await _agoraHandler?.dispose();
    _agoraHandler = null;
  }

  Future<void> hardMuteAction(bool muteAction) async {
    isMicMuted = muteAction;
    await _agoraHandler?.muteSwitchMic(muteAction);
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
