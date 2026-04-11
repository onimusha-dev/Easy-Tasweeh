import 'package:easy_tasweeh/screens/home_screens.dart';
import 'package:easy_tasweeh/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(Phoenix(child: ProviderScope(child: const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Easy Tasweeh',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
