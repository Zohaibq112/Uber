import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'core/data_store.dart';
import 'screens/splash_screen.dart';

void main() {
  // Seed demo data once at startup (pure in-memory, runs anywhere).
  DataStore.seed();
  runApp(const RideNowApp());
}

class RideNowApp extends StatelessWidget {
  const RideNowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RideNow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const SplashScreen(),
    );
  }
}
