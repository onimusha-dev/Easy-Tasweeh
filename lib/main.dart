import 'package:easy_tasbeeh/core/service/backup_service.dart';
import 'package:easy_tasbeeh/core/service/notification_service.dart';
import 'package:easy_tasbeeh/core/service/package_info_provider.dart';
import 'package:easy_tasbeeh/core/service/settings/reminder_manager.dart';
import 'package:easy_tasbeeh/core/service/settings/settings_service.dart';
import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/core/service/shared_preferences.dart';
import 'package:easy_tasbeeh/core/theme/theme.dart';
import 'package:easy_tasbeeh/features/counter/screens/counter_screen.dart';
import 'package:easy_tasbeeh/features/onboarding/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == 'dailyBackup') {
      await performAutomaticBackupTask();
    }
    return true;
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final packageInfo = await PackageInfo.fromPlatform();
  await AppPreferences.init(); // Add this line

  await Workmanager().initialize(callbackDispatcher);
  await NotificationService().init(); // Initialize notifications early

  // Demo notification for testing (shows after 5 seconds)
  Future.delayed(const Duration(seconds: 5), () {
    NotificationService().showRateAppNotification();
  });

  // Only schedule periodic backup if the user has enabled it.
  final periodicEnabled = prefs.getBool('periodicBackupEnabled') ?? false;
  if (periodicEnabled && prefs.getString('backupDirectory') != null) {
    await Workmanager().registerPeriodicTask(
      '1',
      'dailyBackup',
      frequency: const Duration(days: 1),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      constraints: Constraints(requiresBatteryNotLow: true),
    );
  }

  // Set initial UI mode: Hide bottom navigation bar, keep top status bar
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top],
  );

  // Fix black background on swipe by making nav bar transparent and disabling contrast enforcement
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
      systemStatusBarContrastEnforced: false,
      statusBarColor: Colors.transparent,
    ),
  );

  // Auto-hide bottom bar after 3 seconds if it's revealed by a swipe
  SystemChrome.setSystemUIChangeCallback((bool visible) async {
    if (visible) {
      await Future.delayed(const Duration(seconds: 3));
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top],
      );
    }
  });

  runApp(
    Phoenix(
      child: ProviderScope(
        overrides: [
          settingsServiceProvider.overrideWithValue(SettingsService(prefs)),
          packageInfoProvider.overrideWithValue(packageInfo),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize managers
    ref.watch(reminderManagerProvider);

    final settings = ref.watch(settingsProvider);
    final themeMode = settings.themeMode;
    final colorScheme = settings.colorScheme;

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Easy Tasbeeh',
      theme: AppTheme.createTheme(
        AppTheme.resolveColorScheme(colorScheme, Brightness.light),
      ),
      darkTheme: AppTheme.createTheme(
        AppTheme.resolveColorScheme(colorScheme, Brightness.dark),
      ),
      themeMode: themeMode,
      home: settings.onboardingCompleted
          ? const CounterScreen()
          : const OnboardingScreen(),
    );
  }
}
