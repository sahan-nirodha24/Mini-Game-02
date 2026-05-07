import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  final AudioPlayer _explosionPlayer = AudioPlayer();
  final AudioPlayer _winPlayer = AudioPlayer();

  AudioService() {
    _init();
  }

  void _init() {
    // Basic initialization without complex global context
    _explosionPlayer.setReleaseMode(ReleaseMode.stop);
    _winPlayer.setReleaseMode(ReleaseMode.stop);
  }

  Future<void> playExplosion() async {
    try {
      // Direct play is often more reliable across minor version updates
      await _explosionPlayer.stop();
      await _explosionPlayer.play(AssetSource('sounds/explosion.mp3'));
    } catch (e) {
      debugPrint('Audio Error (Explosion): $e');
    }
  }

  Future<void> playWin() async {
    try {
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
