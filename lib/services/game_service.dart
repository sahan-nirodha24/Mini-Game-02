import 'dart:math';
import '../models/cell.dart';
import '../models/difficulty.dart';

class GameService {
  // Renamed back to generateBoard to keep it simple and avoid analyzer confusion
  List<List<Cell>> generateBoard(Difficulty difficulty) {
    return List.generate(
      difficulty.rows,
      (r) => List.generate(
        difficulty.cols,
        (c) => Cell(x: r, y: c),
      ),
    );
  }

  void placeMines(List<List<Cell>> board, Difficulty difficulty, int safeR, int safeC) {
    int rows = difficulty.rows;
    int cols = difficulty.cols;
    int totalMines = difficulty.mines;
    Random random = Random();
    int minesPlaced = 0;

    while (minesPlaced < totalMines) {
      int r = random.nextInt(rows);
      int c = random.nextInt(cols);

      // Check if the spot is already a mine
      if (board[r][c].isMine) continue;

      // Ensure a 3x3 safe zone around the first click
      bool isSafeZone = (r >= safeR - 1 && r <= safeR + 1) && 
                        (c >= safeC - 1 && c <= safeC + 1);
      
      if (isSafeZone) continue;

      board[r][c].isMine = true;
      minesPlaced++;
    }

    // Calculate nearby mines for all cells
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (!board[r][c].isMine) {
          board[r][c].nearbyMines = _countNearbyMines(board, r, c);
        }
      }
    }
  }

  int _countNearbyMines(List<List<Cell>> board, int row, int col) {
    int count = 0;
    int rows = board.length;
    int cols = board[0].length;

    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        int r = row + i;
        int c = col + j;

        if (r >= 0 && r < rows && c >= 0 && c < cols) {
          if (board[r][c].isMine) count++;
        }
      }
    }
    return count;
  }

  void openCell(List<List<Cell>> board, int row, int col) {
    if (row < 0 || row >= board.length || col < 0 || col >= board[0].length) return;
    
    Cell cell = board[row][col];
    if (cell.isOpened || cell.isFlagged) return;

    // IMPORTANT: Create a NEW cell object instead of mutating for proper UI updates
    board[row][col] = cell.copyWith(isOpened: true);

    if (board[row][col].nearbyMines == 0 && !board[row][col].isMine) {
      for (int i = -1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
          openCell(board, row + i, col + j);
        }
      }
    }
  }
}
