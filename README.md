<div align="center">

<img src="assets/images/logo.png" alt="Easy Tasweeh Logo" width="120" />

# Easy Tasweeh — تسبيح

**A clean and simple dhikr counter designed for Muslims who want to stay consistent with their daily tasbeeh.**

Works fully offline — no sign-up required. Optional cloud backup to keep your data safe across devices.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![Non-Profit](https://img.shields.io/badge/Non--Profit-100%25_Free-gold?style=for-the-badge)](#-non-profit--charity)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey?style=for-the-badge&logo=android&logoColor=white)](https://flutter.dev/multi-platform)

</div>

---

## ✨ Features

| Feature | Description |
|---|---|
| 📿 **Tap to Count** | Satisfying haptic feedback on every tap |
| 🎯 **Custom Goals** | Set targets — 33, 99, or any custom number |
| 🔄 **Round Tracking** | Rounds auto-increment when your goal is reached |
| 🤲 **Dhikr Selection** | SubhanAllah, Alhamdulillah, Allahu Akbar & more |
| 📊 **Session History** | View today's completed sessions at a glance |
| 📈 **Analytics** | Lifetime stats, streaks & daily breakdowns |
| 🔔 **Daily Reminders** | Optional notifications to keep your dhikr consistent |
| 📴 **Offline-First** | Full functionality with zero internet — always |
| ☁️ **Cloud Backup** *(optional)* | Back up your sessions & history — restore anytime |
| 🌙 **Dark Mode UI** | Clean matte-tactical dark interface |
| 🔐 **Private & Secure** | Core data stays local; backup is opt-in only |

---

## 📸 Screenshots

> *(Screenshots will be added once the first public release is live)*

---

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `^3.11.4`
- [Dart SDK](https://dart.dev/get-dart) `^3.11.4`
- [Android Studio](https://developer.android.com/studio) or [Xcode](https://developer.apple.com/xcode/) (for iOS)
- A connected device or emulator

### 🔧 Build from Source

1. **Clone the repository**

   ```bash
   git clone https://github.com/your-username/easy_tasweeh.git
   cd easy_tasweeh
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Generate code** *(Drift DB, Riverpod, Freezed)*

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**

   ```bash
   # Debug mode
   flutter run

   # Release mode (Android)
   flutter run --release

   # Specific device
   flutter run -d <device-id>
   ```

5. **Build an APK / IPA**

   ```bash
   # Android APK
   flutter build apk --release

   # Android App Bundle (for Play Store)
   flutter build appbundle --release

   # iOS (macOS required)
   flutter build ios --release
   ```

### 🗄️ Database & Code Generation

This project uses [Drift](https://drift.simonbinder.eu/) for local SQLite storage and [Riverpod](https://riverpod.dev/) with code generation. Whenever you modify database tables or annotated providers, regenerate:

```bash
dart run build_runner build --delete-conflicting-outputs
```

For continuous watching during development:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

### ☁️ Cloud Backup (Optional Setup)

Cloud backup is **opt-in** — the app runs perfectly without it. To enable backup during development:

1. Set up your backend of choice (e.g. Firebase, Supabase, or a self-hosted REST API)
2. Add your config to the appropriate environment file or `secrets/` (never commit credentials!)
3. Backup features include:
   - Full session history export/restore
   - Scheduled auto-backup (daily/weekly)
   - Manual one-tap backup from Settings
   - Import backup from another device

> ⚠️ The app must function 100% without internet. Cloud features are always optional and clearly labelled as such in the UI.

---

## 🏗️ Project Structure

```
easy_tasweeh/
├── lib/
│   ├── main.dart                  # App entry point
│   ├── core/                      # Theme, constants, utilities
│   ├── database/                  # Drift DB tables, DAOs & generated files
│   ├── features/
│   │   └── home/                  # Counter, dhikr picker, session logic
│   └── screens/                   # Analytics, History, Settings screens
├── assets/
│   └── images/                    # App logo & assets
├── android/                       # Android platform files
├── ios/                           # iOS platform files
├── pubspec.yaml                   # Dependencies & config
└── test/                          # Unit & widget tests
```

---

## 📦 Tech Stack

### Core (Always Active)

| Package | Purpose |
|---|---|
| `flutter_riverpod` + `riverpod_generator` | State management |
| `drift` + `drift_flutter` | Local SQLite database |
| `freezed` | Immutable data models |
| `flutter_animate` | Smooth UI animations |
| `fl_chart` | Analytics bar charts |
| `flutter_local_notifications` | Daily reminders |
| `shared_preferences` | Lightweight key-value storage |
| `workmanager` | Background task scheduling |
| `vibration` | Haptic feedback |
| `permission_handler` | Runtime permissions |
| `local_auth` | Biometric security (optional) |
| `flutter_secure_storage` | Encrypted local storage |
| `archive` | Session data export/import (ZIP) |
| `file_picker` | Import backup files from device |

### Backup & Connectivity (Opt-in Only)

| Package | Purpose |
|---|---|
| `http` | REST API calls for cloud backup |
| `uuid` | Unique IDs for sessions & backup entries |

> 💡 The `http` package is only invoked when the user explicitly triggers a backup or restore. It is never called in the background without user consent.

---

## 🔒 Data & Privacy

| What | How |
|---|---|
| **Session data** | Stored locally in SQLite — never leaves device by default |
| **Cloud backup** | Opt-in only; user controls when & where data is sent |
| **Analytics / telemetry** | None. Zero. We don't track anything. |
| **Credentials** | Backup tokens stored in `flutter_secure_storage` (encrypted) |
| **No account required** | Use the full app forever without signing up for anything |

Backup data is encrypted before transmission and only you hold the restore key.

---

## 🤝 Contributing

We welcome contributions from the community! Whether it's a bug fix, UI improvement, new dhikr phrase, or a language translation — every bit helps.

Please read our **[CONTRIBUTING.md](CONTRIBUTING.md)** to get started.

---

## 💚 Non-Profit & Charity

**Easy Tasweeh is 100% free. No ads. No subscriptions. No data collection.**

This is a non-profit project built purely for the benefit of the Muslim community.

> *"Whoever guides someone to do good will have a reward like that of the one who does it."*
> — Prophet Muhammad ﷺ (Muslim)

### If you'd like to support us:

All donations go directly to **charity**. We keep only **5–10%** for app development costs when needed — otherwise **100% goes to charity** or is reinvested into building other free apps for the community.

You are free to:
- ✅ Use the app for free, forever
- ✅ Fork and modify for personal use
- ✅ Redistribute under the MIT license
- ✅ Build on top of this project

<!-- Donation links will be added here once set up -->
> 💛 *Donation link coming soon — all proceeds to verified charities (Sadaqah/Zakat eligible)*

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025 Easy Tasweeh Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

---

## 🙏 Acknowledgements

- Built with ❤️ for the Muslim Ummah
- Inspired by the Sunnah of consistent dhikr
- Open-source forever. Barakallahu feekum.

---

<div align="center">

**Made with love. May it be a sadaqah jariyah for all who contributed.**

*سبحان الله وبحمده، سبحان الله العظيم*

</div>
