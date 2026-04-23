# Contributing to Easy Tasbeeh 🤲

بسم الله الرحمن الرحيم

First of all — **JazakAllah Khair** for taking the time to contribute! Every improvement, no matter how small, is a chance for reward.

> *"The best of people are those who are most beneficial to people."*  
>
> — Prophet Muhammad ﷺ
>
>
This document will walk you through everything you need to know to contribute to **Easy Tasbeeh** — a free, offline, open-source dhikr counter for the Muslim community.

---

## 📋 Table of Contents

- [Code of Conduct](#-code-of-conduct)
- [How Can I Contribute?](#-how-can-i-contribute)
- [Getting Started](#-getting-started)
- [Branching & Workflow](#-branching--workflow)
- [Commit Message Guidelines](#-commit-message-guidelines)
- [Pull Request Process](#-pull-request-process)
- [Reporting Bugs](#-reporting-bugs)
- [Requesting Features](#-requesting-features)
- [Translations & Localization](#-translations--localization)
- [Non-Profit & Donation Policy](#-non-profit--donation-policy)

---

## 🕊️ Code of Conduct

This is an Islamic-values-inspired project. We ask all contributors to:

- Be **respectful and kind** in all communications
- Give **constructive** feedback, not harsh criticism
- Be **patient** — maintainers are volunteers
- Keep discussions **on-topic** and beneficial
- Remember the intention: **serving the Muslim Ummah for the sake of Allah**

Toxic, offensive, or disrespectful behavior will not be tolerated and will result in removal from the project.

---

## 💡 How Can I Contribute?

You don't have to be a developer to contribute! Here are ways everyone can help:

### 🛠️ Developers
- Fix bugs reported in [Issues](../../issues)
- Implement feature requests
- Write or improve tests
- Refactor and clean up code
- Improve performance

### 🎨 Designers
- Improve UI/UX of existing screens
- Design new icons or assets
- Create screenshots for the app store listing

### 🌍 Translators
- Add Arabic, Urdu, Turkish, Indonesian, French or other language support
- Review and correct existing translations

### 📝 Writers / Documenters
- Improve this guide or the README
- Add inline code comments
- Write wiki pages

### 🧪 Testers
- Test the app on different devices and Android/iOS versions
- Report bugs with detailed reproduction steps
- Verify that bug fixes actually work

---

## 🚀 Getting Started

### 1. Fork & Clone

```bash
# Fork via GitHub UI, then clone your fork
git clone https://github.com/<your-username>/easy_tasbeeh.git
cd easy_tasbeeh
```

### 2. Set Upstream Remote

```bash
git remote add upstream https://github.com/your-username/easy_tasbeeh.git
git fetch upstream
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Generate Code

This project uses **Drift** (SQLite ORM), **Riverpod** (state management), and **Freezed** (immutable models). After fetching packages or changing any annotated code, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

For active development, use the watcher:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

### 5. Run the App

```bash
flutter run
```

Make sure you have a connected device or emulator running.

---

## 🌿 Branching & Workflow

We follow a simple feature-branch workflow:

| Branch | Purpose |
|---|---|
| `main` | Stable, release-ready code |
| `develop` | Active development branch |
| `feature/<name>` | New features |
| `fix/<name>` | Bug fixes |
| `chore/<name>` | Refactoring, cleanup, tooling |
| `translation/<lang>` | Localization additions |

### Example

```bash
# Always branch off develop
git checkout develop
git pull upstream develop
git checkout -b feature/night-mode-toggle
```

---

## 📝 Commit Message Guidelines

Use clear, imperative commit messages. Follow this format:

```
<type>(<scope>): <short description>

[optional longer body]
[optional footer / issue reference]
```

### Types

| Type | Use when |
|---|---|
| `feat` | Adding a new feature |
| `fix` | Fixing a bug |
| `chore` | Config, tooling, no logic change |
| `refactor` | Code cleanup without behavior change |
| `docs` | Documentation only |
| `style` | Formatting, whitespace, no logic change |
| `test` | Adding or fixing tests |
| `perf` | Performance improvements |
| `translation` | Adding/updating localized strings |

### Examples

```
feat(counter): add infinite count mode with no target
fix(history): correct session time display in 12h format
docs(README): update build instructions for Windows
translation(ar): add full Arabic string support
```

---

## 🔍 Pull Request Process

1. **Check existing PRs** — make sure no one else is already working on the same thing
2. **Keep PRs focused** — one feature or fix per PR
3. **Test your changes** thoroughly before submitting
4. **Run the linter** before pushing:

   ```bash
   flutter analyze
   flutter format .
   ```

5. **Fill out the PR template** — describe what you changed and why
6. **Link any related issues** using `Closes #<issue-number>`
7. **Be patient** — reviews may take a few days

### PR Checklist

Before submitting, confirm:

- [ ] `flutter analyze` passes with no errors
- [ ] `flutter format .` has been run
- [ ] Code generation is up to date (`build_runner build`)
- [ ] No hardcoded strings (use constants or localization keys)
- [ ] No new permissions added without discussion
- [ ] The **core experience works fully offline** — no internet calls in the main counter, history, or analytics flow
- [ ] Any new network/backup code is **strictly opt-in** and clearly gated behind a user action
- [ ] No data is ever silently sent without explicit user consent
- [ ] PR description is clear and references related issues

---

## 🐛 Reporting Bugs

Found a bug? Please [open an issue](../../issues/new?template=bug_report.md) with:

1. **Device & OS version** (e.g. Samsung Galaxy S21, Android 13)
2. **Flutter version** (`flutter --version`)
3. **Steps to reproduce** — be as specific as possible
4. **Expected behaviour** — what did you expect?
5. **Actual behaviour** — what actually happened?
6. **Screenshots or screen recording** if relevant
7. **Crash logs** if available (`adb logcat` or iOS Console)

---

## 🌟 Requesting Features

Have an idea? [Open a feature request](../../issues/new?template=feature_request.md) and describe:

1. **What** you want the app to do
2. **Why** it would benefit users
3. **How** you imagine it working (rough idea is fine)

Keep features aligned with the app's core principles:

> 📴 **Offline-first** — the core dhikr experience must always work without internet.
> ☁️ **Cloud features are opt-in** — backup, sync, or restore is fine as long as users choose to enable it.
> ✨ **Clean & focused** — no feature bloat or distractions from the dhikr experience.

Features that force an internet connection or require account sign-up will not be accepted.

---

## 🌍 Translations & Localization

We would love to make Easy Tasbeeh accessible in as many languages as possible, especially:

- 🇸🇦 Arabic (ar)
- 🇵🇰 Urdu (ur)
- 🇹🇷 Turkish (tr)
- 🇮🇩 Bahasa Indonesia (id)
- 🇧🇩 Bengali (bn)
- 🇫🇷 French (fr)
- 🇲🇾 Malay (ms)

### How to Add a Translation

*(Detailed localization guide will be added when `flutter_localizations` is integrated)*

For now, open an issue tagged `translation` and include your translated strings. We'll integrate them together.

---

## 💚 Non-Profit & Donation Policy

Easy Tasbeeh is and will always be:

- ✅ **100% Free** — no paywalls, no premium tiers
- ✅ **No Ads** — ever
- ✅ **No Data Collection** — everything stays on your device
- ✅ **Open Source** — MIT licensed, fork freely

### Donations

If the app receives donations:

| Allocation | Percentage |
|---|---|
| Charity (Sadaqah / Islamic causes) | **90–100%** |
| App development costs (hosting, tools) | **0–10%** (only if needed) |

We will be fully transparent about how funds are used, published in the repository for accountability.

### Our Pledge

We will **never**:
- Monetize the app with ads or subscriptions
- Sell user data (we don't even collect it)
- Accept funding that comes with conditions on features or direction

---

## 🔐 Security

Found a security vulnerability? **Please do not open a public issue.**

Instead, contact the maintainer directly via GitHub's private security advisory feature or email (listed in the profile).

---

## ❓ Questions?

If you're unsure about anything, just [open a discussion](../../discussions) or drop a comment on a related issue. We're friendly, I promise. 😊

---

<div align="center">

**Thank you for contributing.**  
**May Allah accept it as sadaqah jariyah for all of us.**

*وما توفيقي إلا بالله*

</div>
