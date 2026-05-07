enum Difficulty {
  beginner,
  intermediate,
  expert;

  int get rows {
    switch (this) {
      case Difficulty.beginner:
        return 9;
      case Difficulty.intermediate:
        return 16;
      case Difficulty.expert:
        return 30;
    }
  }

  int get cols {
    switch (this) {
      case Difficulty.beginner:
        return 9;
      case Difficulty.intermediate:
        return 16;
      case Difficulty.expert:
        return 16;
    }
  }

  int get mines {
    switch (this) {
      case Difficulty.beginner:
        return 10;
      case Difficulty.intermediate:
        return 40;
      case Difficulty.expert:
        return 99;
    }
  }

  String get name {
    switch (this) {
      case Difficulty.beginner:
        return 'Beginner';
      case Difficulty.intermediate:
        return 'Intermediate';
      case Difficulty.expert:
        return 'Expert';
    }
  }
}
