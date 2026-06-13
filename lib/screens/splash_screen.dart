import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import 'auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 1))
        ..forward();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bg, AppColors.bgSoft],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _c,
            child: ScaleTransition(
              scale: Tween(begin: 0.8, end: 1.0).animate(
                  CurvedAnimation(parent: _c, curve: Curves.easeOutBack)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(26),
                    decoration: BoxDecoration(
                      gradient: AppColors.brandGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.accent.withOpacity(0.4),
                            blurRadius: 36,
                            spreadRadius: 4),
                      ],
                    ),
                    child: const Icon(Icons.local_taxi_rounded,
                        size: 60, color: Colors.black),
                  ),
                  const SizedBox(height: 24),
                  const Text('RideNow',
                      style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: AppColors.text,
                          letterSpacing: 1.5)),
                  const SizedBox(height: 6),
                  const Text('Your ride, on your time',
                      style: TextStyle(color: AppColors.subtext, fontSize: 14)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
