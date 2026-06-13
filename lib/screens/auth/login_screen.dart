import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../core/data_store.dart';
import '../../core/helpers.dart';
import '../admin/admin_dashboard.dart';
import '../user/user_home.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  bool hidePass = true;
  bool loading = false;

  Future<void> doLogin() async {
    if (emailC.text.trim().isEmpty || passC.text.isEmpty) {
      showSnack(context, 'Enter email and password', error: true);
      return;
    }
    setState(() => loading = true);
    await Future.delayed(const Duration(milliseconds: 500)); // UX feel
    final user = DataStore.login(emailC.text.trim(), passC.text);
    if (!mounted) return;
    setState(() => loading = false);
    if (user == null) {
      showSnack(context, 'Invalid email or password', error: true);
    } else if (user['role'] == 'admin') {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => AdminDashboard(admin: user)));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => UserHome(user: user)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero badge
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: AppColors.brandGradient,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.local_taxi_rounded,
                    color: Colors.black, size: 30),
              ),
              const SizedBox(height: 28),
              const Text('Welcome back', style: AppText.h1),
              const SizedBox(height: 4),
              const Text('Sign in to continue your journey',
                  style: AppText.muted),
              const SizedBox(height: 36),
              _label('Email'),
              TextField(
                controller: emailC,
                keyboardType: TextInputType.emailAddress,
                style: AppText.body,
                decoration: const InputDecoration(
                    hintText: 'you@email.com',
                    prefixIcon: Icon(Icons.email_outlined)),
              ),
              const SizedBox(height: 18),
              _label('Password'),
              TextField(
                controller: passC,
                obscureText: hidePass,
                style: AppText.body,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                        hidePass ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.subtext),
                    onPressed: () => setState(() => hidePass = !hidePass),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              GradientButton(
                  label: 'Sign In',
                  icon: Icons.arrow_forward,
                  loading: loading,
                  onTap: doLogin),
              const SizedBox(height: 20),
              // Demo hint card
              GlassCard(
                padding: const EdgeInsets.all(14),
                child: Row(children: [
                  const Icon(Icons.info_outline,
                      color: AppColors.accent2, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                        'Admin demo:  admin@ridenow.com  /  admin123',
                        style: AppText.muted),
                  ),
                ]),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SignupScreen())),
                  child: const Text.rich(TextSpan(
                      text: "Don't have an account?  ",
                      style: AppText.muted,
                      children: [
                        TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w800))
                      ])),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 4),
        child: Text(t,
            style: const TextStyle(
                color: AppColors.subtext,
                fontSize: 13,
                fontWeight: FontWeight.w600)),
      );
}
