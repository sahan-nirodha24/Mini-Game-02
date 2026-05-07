import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  final AudioPlayer _explosionPlayer = AudioPlayer();
  final AudioPlayer _winPlayer = AudioPlayer();

  AudioService() {
    _init();
  }

  void _init() async {
    _explosionPlayer.setReleaseMode(ReleaseMode.stop);
    _winPlayer.setReleaseMode(ReleaseMode.stop);
    
    // Ensure audio plays even if the phone is in silent mode (for some devices)
    try {
      await AudioPlayer.global.setAudioContext(AudioContextConfig(
        stayAwake: true,
      ).build());
    } catch (e) {
      debugPrint('Audio Context Error: $e');
    }
  }

  Future<void> playExplosion() async {
    try {
      debugPrint('Attempting to play: assets/sounds/boom.mp3');
      await _explosionPlayer.stop();
      await _explosionPlayer.setVolume(1.0);
      // Try with the full path if the shorthand doesn't work
      await _explosionPlayer.play(AssetSource('sounds/boom.mp3'));
    } catch (e) {
      debugPrint('AUDIO ERROR (Explosion): $e');
    }
  }

  Future<void> playWin() async {
    try {
      debugPrint('Playing Win Sound...');
      await _winPlayer.stop();
      await _winPlayer.play(AssetSource('sounds/win.mp3'));
    } catch (e) {
      debugPrint('Audio Error (Win): $e');
    }
  }

  void dispose() {
    _explosionPlayer.dispose();
    _winPlayer.dispose();
  }
}
