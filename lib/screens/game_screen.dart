import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_board.dart';
import '../widgets/top_bar.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _dialogShowing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Minesweeper'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.pause),
            onPressed: () => _showPauseMenu(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: TopBar(),
            ),
            const Expanded(
              child: Center(
                child: GameBoard(),
              ),
            ),
            _buildStatusListener(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusListener() {
    return Consumer<GameProvider>(
      builder: (context, provider, child) {
        if ((provider.status == GameStatus.won || provider.status == GameStatus.lost) && !_dialogShowing) {
          _dialogShowing = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (provider.status == GameStatus.won) {
              _showGameEndDialog(context, 'Victory!', Icons.emoji_events, Colors.orange);
            } else {
              _showGameEndDialog(context, 'Game Over', Icons.close, Colors.red);
            }
          });
        } else if (provider.status == GameStatus.playing) {
          _dialogShowing = false;
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _showGameEndDialog(BuildContext context, String title, IconData icon, Color color) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Icon(icon, color: color, size: 60),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'Would you like to play again?',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to home
            },
            child: const Text('Home'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              Provider.of<GameProvider>(context, listen: false).startGame();
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    ).then((_) {
      // If dialog is dismissed via other means (not likely with barrierDismissible: false)
      // but good for safety if we ever change it.
    });
  }

  void _showPauseMenu(BuildContext context) {
    final provider = Provider.of<GameProvider>(context, listen: false);
    provider.pauseGame();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Paused'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              provider.resumeGame();
            },
            child: const Text('Resume'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Quit'),
          ),
        ],
      ),
    );
  }
}
