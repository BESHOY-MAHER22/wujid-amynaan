import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AudioService {
  AudioService._();

  static final AudioService instance = AudioService._();

  final AudioPlayer _bgPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  final ValueNotifier<bool> isMuted = ValueNotifier<bool>(false);

  bool _userActivated = false;
  bool _bgStarted = false;

  bool get userActivated => _userActivated;

  Future<void> initializeFromUserAction() async {
    if (_userActivated) {
      return;
    }

    _userActivated = true;

    try {
      await _bgPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgPlayer.setPlayerMode(PlayerMode.mediaPlayer);
      await _bgPlayer.setVolume(isMuted.value ? 0.0 : 0.22);
      await _bgPlayer.play(AssetSource('audio/bg_music.mp3'));
      _bgStarted = true;
    } catch (error, stackTrace) {
      debugPrint('AudioService: failed to start background music: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> toggleMute() async {
    if (!_userActivated) {
      await initializeFromUserAction();
    }

    isMuted.value = !isMuted.value;
    final volume = isMuted.value ? 0.0 : 0.22;

    try {
      await _bgPlayer.setVolume(volume);
      if (isMuted.value) {
        await _bgPlayer.pause();
      } else if (_bgStarted) {
        await _bgPlayer.resume();
      } else {
        await _bgPlayer.play(AssetSource('audio/bg_music.mp3'));
        _bgStarted = true;
      }
    } catch (error, stackTrace) {
      debugPrint('AudioService: failed to toggle mute state: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> playClick() async {
    if (!_userActivated || isMuted.value) {
      return;
    }

    try {
      await _sfxPlayer.setVolume(0.18);
      await _sfxPlayer.play(AssetSource('audio/click_sound.mp3'));
    } catch (error, stackTrace) {
      debugPrint('AudioService: failed to play click sound: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> dispose() async {
    unawaited(_bgPlayer.stop());
    unawaited(_sfxPlayer.stop());
    await _bgPlayer.dispose();
    await _sfxPlayer.dispose();
  }
}
