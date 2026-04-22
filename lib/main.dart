import 'package:easy_tasweeh/core/service/settings_provider.dart';
import 'package:easy_tasweeh/core/theme/theme.dart';
import 'package:easy_tasweeh/features/counter/screens/counter_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set initial UI mode: Hide bottom navigation bar, keep top status bar
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top],
  );

  // Fix black background on swipe by making nav bar transparent and disabling contrast enforcement
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarContrastEnforced: false,
    systemStatusBarContrastEnforced: false,
    statusBarColor: Colors.transparent,
  ));

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

  runApp(Phoenix(child: ProviderScope(child: const MyApp())));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final themeMode = settings.themeMode;
    final colorScheme = settings.colorScheme;

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Easy Tasweeh',
      theme: AppTheme.createTheme(
        AppTheme.resolveColorScheme(colorScheme, Brightness.light),
      ),
      darkTheme: AppTheme.createTheme(
        AppTheme.resolveColorScheme(colorScheme, Brightness.dark),
      ),
      themeMode: themeMode,
      home: const CounterScreen(),
    );
  }
}
