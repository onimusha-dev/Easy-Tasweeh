# Shared Preferences Documentation

This project uses `shared_preferences` to store lightweight user settings and app state.

## Implementation File
- **Source**: `lib/core/service/settings_provider.dart`
- **Utility**: `lib/core/service/shared_preferences.dart`

## Keys and Usage

| Key | Type | Description |
| :--- | :--- | :--- |
| `morning_reminder` | `bool` | Whether the morning reminder notification is enabled. |
| `evening_reminder` | `bool` | Whether the evening reminder notification is enabled. |
| `morning_hour` | `int` | Hour for the morning reminder (0-23). Default: 8. |
| `morning_minute` | `int` | Minute for the morning reminder (0-59). Default: 0. |
| `evening_hour` | `int` | Hour for the evening reminder (0-23). Default: 20. |
| `evening_minute` | `int` | Minute for the evening reminder (0-59). Default: 0. |
| `haptic_enabled` | `bool` | Global toggle for haptic feedback. |
| `vibration_amplitude` | `int` | Amplitude for tap haptics (1-255). Default: 50. |
| `completion_vibration_amplitude` | `int` | Amplitude for completion haptics (1-255). Default: 100. |
| `keep_screen_on` | `bool` | Prevents device from sleeping during tasweeh. |
| `tap_sound` | `bool` | Plays a sound on every tap. |
| `goal_reached_sound` | `bool` | Plays a distinct sound when the target is reached. |
| `goal_haptic_pattern` | `bool` | Triggers a special haptic pattern on goal reach. |
| `after_salah_reminder` | `bool` | Reminder to perform adhkar after Salah. |
| `auto_reset_on_goal` | `bool` | Resets the counter automatically when the target is met. |
| `resume_last_session` | `bool` | Restores previous count on app launch. |
| `theme_mode` | `int` | Index of `ThemeMode` (System: 0, Light: 1, Dark: 2). |
| `color_scheme` | `int` | Index of selected `AppColorScheme`. |

## Status & Requirements

### What we have:
- [x] Comprehensive settings notifier with Riverpod.
- [x] Persistence for UI toggles and reminder times.
- [x] Theme and color scheme persistence.

### What we need:
- [ ] Grouping of related settings in the UI for better UX.
- [ ] "Reset to Defaults" functionality.
- [ ] Onboarding state tracking (e.g., `has_seen_tutorial`).
- [ ] Localization settings (if multi-language is added).
