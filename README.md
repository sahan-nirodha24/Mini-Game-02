# 💣 Modern Minesweeper

<p align="left">
  <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" />
  <img src="https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white" />
</p>

A sleek, minimalist, and high-performance Minesweeper mobile application built using **Flutter**. This project demonstrates modern development practices, including clean architecture, reactive state management with Provider, and a polished user experience.

---

## 📸 Screenshots

**🏠 Main Menu**  
<img src="https://github.com/user-attachments/assets/127a5300-dcee-4296-ba1e-406592f9d827" width="100%" />

**⚙️ Settings**  
<img src="https://github.com/user-attachments/assets/f113018b-4964-4bd1-be9f-016ab5b9a99b" width="100%" />

**🟢 Beginner Mode**  
<img src="https://github.com/user-attachments/assets/affe6c0f-b7c4-4dcf-91ca-74b0c9a80c7a" width="100%" />

**🟡 Intermediate Mode**  
<img src="https://github.com/user-attachments/assets/18f7c455-39f0-4f1e-91e2-929f2015caf4" width="100%" />

**🔴 Expert Mode**  
<img src="https://github.com/user-attachments/assets/7611dc48-3cca-4d3c-8682-890154ac6408" width="100%" />

---

## 🌟 Key Features

### 🎮 Gameplay Excellence
*   **Smart First Move**: Guaranteed safe start. The board is generated only after your first tap to ensure you never hit a mine on move one.
*   **Advanced Algorithms**: Efficient Flood Fill for instant opening of empty cells.
*   **Dynamic Difficulty**: Beginner (9x9), Intermediate (16x16), and Expert (30x16) with Pan & Zoom.
*   **Scoring System**: Real-time tracking and local High Score persistence.

### 🛠 User Customization
*   **Control Modes**: Toggle between *Long-press* or *Tap to Flag*.
*   **Theme Engine**: Full support for Light, Dark, and System themes.
*   **Haptics & Audio**: Immersive feedback for a better gaming experience.
*   **Fluid UI**: Built with `InteractiveViewer` for seamless interaction.

---

## 🚀 Tech Stack

*   **Framework:** [Flutter](https://flutter.dev) | **Language:** [Dart](https://dart.dev)
*   **State:** [Provider](https://pub.dev/packages/provider) | **Storage:** [Shared Preferences](https://pub.dev/packages/shared_preferences)
*   **Audio:** [Audioplayers](https://pub.dev/packages/audioplayers)

---

## 📂 Project Architecture

```text
lib/
├── models/         # Data structures
├── providers/      # State management
├── services/       # Core logic (Audio, Storage)
├── screens/        # UI Views
└── widgets/        # Reusable components
```

---

## 🛠 Setup & Run

```bash
git clone https://github.com/your-username/mini_game_02.git
flutter pub get
flutter run
```

---

Developed with ❤️ by **Sahan Nirodha**
