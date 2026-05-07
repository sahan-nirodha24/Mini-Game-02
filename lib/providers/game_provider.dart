import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cell.dart';
import '../models/difficulty.dart';
import '../services/game_service.dart';
import '../services/audio_service.dart';

enum GameStatus { playing, won, lost, paused }

class GameProvider with ChangeNotifier {
  final GameService _gameService = GameService();
  final AudioService _audioService = AudioService();
  
  Difficulty _difficulty = Difficulty.beginner;
  List<List<Cell>> _board = [];
  GameStatus _status = GameStatus.playing;
  int _secondsElapsed = 0;
  Timer? _timer;
  int _flagsUsed = 0;
  int? _bestScore;
  bool _isFirstMove = true;
  bool _isSoundEnabled = true;
  bool _isHapticEnabled = true;
  bool _isTapToFlag = false;
  ThemeMode _themeMode = ThemeMode.system;

  Difficulty get difficulty => _difficulty;
  List<List<Cell>> get board => _board;
  GameStatus get status => _status;
  int get secondsElapsed => _secondsElapsed;
  int get flagsRemaining => _difficulty.mines - _flagsUsed;
  int? get bestScore => _bestScore;
  bool get isSoundEnabled => _isSoundEnabled;
  bool get isHapticEnabled => _isHapticEnabled;
  bool get isTapToFlag => _isTapToFlag;
  ThemeMode get themeMode => _themeMode;

  int get currentScore {
    int count = 0;
    for (var row in _board) {
      for (var cell in row) {
        if (cell.isOpened && !cell.isMine) count++;
      }
    }
    return count * 10; // Each safe cell is 10 points
  }

  GameProvider() {
    _loadSettings();
    _loadBestScore();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isSoundEnabled = prefs.getBool('sound_enabled') ?? true;
    _isHapticEnabled = prefs.getBool('haptic_enabled') ?? true;
    _isTapToFlag = prefs.getBool('tap_to_flag') ?? false;
    
    final savedTheme = prefs.getString('theme_mode');
    if (savedTheme != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (e) => e.toString() == savedTheme,
        orElse: () => ThemeMode.system,
      );
    }
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', mode.toString());
    notifyListeners();
  }

  Future<void> toggleSound() async {
    _isSoundEnabled = !_isSoundEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_enabled', _isSoundEnabled);
    notifyListeners();
  }

  Future<void> toggleHaptic() async {
    _isHapticEnabled = !_isHapticEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('haptic_enabled', _isHapticEnabled);
    notifyListeners();
  }

  Future<void> toggleTapToFlag() async {
    _isTapToFlag = !_isTapToFlag;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tap_to_flag', _isTapToFlag);
    notifyListeners();
  }

  Future<void> resetHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    for (var d in Difficulty.values) {
      await prefs.remove('best_score_${d.name}');
    }
    _bestScore = null;
    notifyListeners();
  }

  Future<void> _loadBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    _bestScore = prefs.getInt('best_score_${_difficulty.name}');
    notifyListeners();
  }

  Future<void> _saveBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    if (_bestScore == null || _secondsElapsed < _bestScore!) {
      _bestScore = _secondsElapsed;
      await prefs.setInt('best_score_${_difficulty.name}', _secondsElapsed);
    }
  }

  void setDifficulty(Difficulty difficulty) {
    _difficulty = difficulty;
    _loadBestScore();
    startGame();
  }

  void startGame() {
    _board = _gameService.generateBoard(_difficulty);
    _status = GameStatus.playing;
    _secondsElapsed = 0;
    _flagsUsed = 0;
    _isFirstMove = true;
    _timer?.cancel();
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_status == GameStatus.playing) {
        _secondsElapsed++;
        notifyListeners();
      }
    });
  }

  void openCell(int r, int c) {
    if (_status != GameStatus.playing || _board[r][c].isFlagged) return;

    if (_isFirstMove) {
      _isFirstMove = false;
      _gameService.placeMines(_board, _difficulty, r, c);
      _startTimer();
    }

    if (_board[r][c].isMine) {
      _loseGame();
    } else {
      _gameService.openCell(_board, r, c);
      if (_checkWin()) {
        _winGame();
      }
    }
    notifyListeners();
  }

  void toggleFlag(int r, int c) {
    if (_status != GameStatus.playing || _board[r][c].isOpened) return;

    final cell = _board[r][c];
    final newFlaggedStatus = !cell.isFlagged;
    
    if (newFlaggedStatus && flagsRemaining <= 0) return;

    _board[r][c] = cell.copyWith(isFlagged: newFlaggedStatus);
    _flagsUsed += newFlaggedStatus ? 1 : -1;
    notifyListeners();
  }

  bool _checkWin() {
    for (var row in _board) {
      for (var cell in row) {
        if (!cell.isMine && !cell.isOpened) {
          return false;
        }
      }
    }
    return true;
  }

  void _winGame() {
    _status = GameStatus.won;
    _timer?.cancel();
    _saveBestScore();
    if (_isSoundEnabled) {
      _audioService.playWin();
    }
  }

  void _loseGame() async {
    _status = GameStatus.lost;
    _timer?.cancel();
    
    if (_isSoundEnabled) {
      _audioService.playExplosion().catchError((e) {
        debugPrint('Explosion sound failed: $e');
      });
    }

    for (int r = 0; r < _board.length; r++) {
      for (int c = 0; c < _board[0].length; c++) {
        if (_board[r][c].isMine) {
          _board[r][c] = _board[r][c].copyWith(isOpened: true);
          notifyListeners();
          await Future.delayed(const Duration(milliseconds: 50));
        }
      }
    }
  }

  void pauseGame() {
    if (_status == GameStatus.playing) {
      _status = GameStatus.paused;
      _timer?.cancel();
      notifyListeners();
    }
  }

  void resumeGame() {
    if (_status == GameStatus.paused && !_isFirstMove) {
      _status = GameStatus.playing;
      _startTimer();
      notifyListeners();
    } else if (_status == GameStatus.paused && _isFirstMove) {
      _status = GameStatus.playing;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioService.dispose();
    super.dispose();
  }
}
