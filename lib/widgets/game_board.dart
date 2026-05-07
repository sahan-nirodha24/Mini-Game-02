import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'cell_widget.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final board = gameProvider.board;
        if (board.isEmpty) return const Center(child: CircularProgressIndicator());

        // Calculate dynamic cell size based on screen width for beginner,
        // but use a fixed size for expert/intermediate to allow panning.
        double screenWidth = MediaQuery.of(context).size.width;
        double cellSize = (screenWidth - 32) / gameProvider.difficulty.cols;
        if (cellSize < 30) cellSize = 30; // Minimum size for playability

        return InteractiveViewer(
          constrained: false, // Allows the child to be larger than the screen
          boundaryMargin: const EdgeInsets.all(20),
          minScale: 0.1,
          maxScale: 5.0,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            width: cellSize * gameProvider.difficulty.cols,
            height: cellSize * gameProvider.difficulty.rows,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gameProvider.difficulty.cols,
                childAspectRatio: 1.0,
              ),
              itemCount: gameProvider.difficulty.rows * gameProvider.difficulty.cols,
              itemBuilder: (context, index) {
                int r = index ~/ gameProvider.difficulty.cols;
                int c = index % gameProvider.difficulty.cols;
                return CellWidget(
                  cell: board[r][c],
                  onTap: () => gameProvider.openCell(r, c),
                  onLongPress: () => gameProvider.toggleFlag(r, c),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
