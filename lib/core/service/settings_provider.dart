import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings/settings_notifier.dart';
import 'settings/settings_state.dart';

export 'settings/settings_notifier.dart';
export 'settings/settings_state.dart';
import 'settings/settings_service.dart';

final settingsServiceProvider = Provider<SettingsService>((ref) {
  throw UnimplementedError('Override this in ProviderScope with SharedPreferences instance');
});

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(() {
  return SettingsNotifier();
});
