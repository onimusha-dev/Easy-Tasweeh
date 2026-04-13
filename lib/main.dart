import 'package:easy_tasweeh/core/service/settings_provider.dart';
import 'package:easy_tasweeh/screens/home_screens.dart';
import 'package:easy_tasweeh/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
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
      debugShowCheckedModeBanner: false,
      title: 'Easy Tasweeh',
      theme: AppTheme.createTheme(
        AppTheme.resolveColorScheme(colorScheme, Brightness.light),
      ),
      darkTheme: AppTheme.createTheme(
        AppTheme.resolveColorScheme(colorScheme, Brightness.dark),
      ),
      themeMode: themeMode,
      home: const HomeScreen(),
    );
  }
}
