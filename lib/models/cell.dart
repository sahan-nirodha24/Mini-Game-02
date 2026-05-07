class Cell {
  final int x;
  final int y;
  bool isMine;
  bool isOpened;
  bool isFlagged;
  int nearbyMines;

  Cell({
    required this.x,
    required this.y,
    this.isMine = false,
    this.isOpened = false,
    this.isFlagged = false,
    this.nearbyMines = 0,
  });

  Cell copyWith({
    bool? isMine,
    bool? isOpened,
    bool? isFlagged,
    int? nearbyMines,
  }) {
    return Cell(
      x: x,
      y: y,
      isMine: isMine ?? this.isMine,
      isOpened: isOpened ?? this.isOpened,
      isFlagged: isFlagged ?? this.isFlagged,
      nearbyMines: nearbyMines ?? this.nearbyMines,
    );
  }
}
