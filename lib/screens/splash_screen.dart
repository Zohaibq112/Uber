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
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
        ..forward();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
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
      body: Center(
        child: FadeTransition(
          opacity: _c,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Wordmark with a gold underscore cursor (the signature)
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('RideNow',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                          letterSpacing: -1.5)),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 9, left: 3),
                    child: Container(width: 11, height: 5, color: AppColors.accent),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text('YOUR RIDE · ON YOUR TIME',
                  style: AppText.eyebrow.copyWith(letterSpacing: 2.6)),
            ],
          ),
        ),
      ),
    );
  }
}
