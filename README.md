# 💣 Modern Minesweeper - Flutter

A sleek, minimalist, and fully-featured Minesweeper mobile game built with Flutter. This project follows modern development practices, including clean architecture and reactive state management.

## 🚀 Features

### **Gameplay**
- **Dynamic Board Generation**: Mines are placed randomly only after the first click to ensure a fair start.
- **Safe First Click**: Guaranteed that your first move will never hit a mine and will always open a safe area.
- **Flood Fill Algorithm**: Automatically opens empty adjacent cells to speed up gameplay.
- **Flagging System**: Long-press on any cell to place or remove a flag.
- **Difficulty Levels**:
    - **Beginner**: 9x9 Grid, 10 Mines.
    - **Intermediate**: 16x16 Grid, 40 Mines.
    - **Expert**: 30x16 Grid, 99 Mines (with Panning & Zooming support).

### **User Experience**
- **Settings Mode**: Customize your experience with toggles for sound effects and haptic feedback.
- **Responsive UI**: Works perfectly on all screen sizes using a zoomable `InteractiveViewer` for larger boards.
- **Animations**: Smooth scale-up animations for cell reveals and a "chain reaction" blast effect when game is lost.
- **Audio Effects**: High-quality sound effects for explosions and victory.
- **Haptic Feedback**: Tactile vibrations for tapping and flagging.
- **Dark Mode Support**: Automatically switches between light and dark themes based on system settings.
- **High Scores**: Saves your best time for each difficulty level locally using `SharedPreferences`.

## 🛠 Tech Stack

- **Framework**: [Flutter](https://flutter.dev)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Local Storage**: [Shared Preferences](https://pub.dev/packages/shared_preferences)
- **Audio**: [Audioplayers](https://pub.dev/packages/audioplayers)

## 📂 Project Structure
```text
lib/
├── models/         # Data models (Cell, Difficulty)
├── providers/      # State Management (Game Logic & UI State)
├── services/       # Business Logic (Board Generation, Audio Service)
├── screens/        # UI Screens (Home, Game)
├── widgets/        # Reusable UI components (Cell, TopBar, Board)
└── main.dart       # Entry point
```

## 📦 Installation & Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/mini_game_02.git
   ```
   
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
   
3. **Add Assets:**
   Ensure you have the following files in `assets/sounds/`:
   - `explosion.mp3`
   - `win.mp3`

4. **Run the app:**
   ```bash
   flutter run
   ```
   
## 🎮 How to Play

1. **Tap**: Open a cell.
2. **Long Press**: Place a flag on a suspected mine.
3. **Goal**: Open all cells that do not contain mines.
4. **Win**: All safe cells are opened.
5. **Lose**: You tap on a mine!

---
Developed with ❤️ by Sahan Nirodha
