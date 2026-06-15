import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../core/data_store.dart';
import '../../core/helpers.dart';
import '../admin/admin_dashboard.dart';
import '../driver/driver_home.dart';
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
      showSnack(context, 'Enter your email and password', error: true);
      return;
    }
    setState(() => loading = true);
    await Future.delayed(const Duration(milliseconds: 450));
    final user = DataStore.login(emailC.text.trim(), passC.text);
    if (!mounted) return;
    setState(() => loading = false);
    if (user == null) {
      showSnack(context, 'Those details don’t match an account', error: true);
    } else if (user['role'] == 'admin') {
      _go(AdminDashboard(admin: user));
    } else if (user['role'] == 'driver') {
      _go(DriverHome(driver: user));
    } else {
      _go(UserHome(user: user));
    }
  }

  void _go(Widget page) => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('RideNow',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                          letterSpacing: -1)),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6, left: 2),
                    child: Container(
                        width: 8, height: 4, color: AppColors.accent),
                  ),
                ],
              ),
              const SizedBox(height: 64),
              const Eyebrow('Welcome back'),
              const SizedBox(height: 14),
              const Text('Sign in to\nyour account', style: AppText.display),
              const SizedBox(height: 44),
              TextField(
                controller: emailC,
                keyboardType: TextInputType.emailAddress,
                style: AppText.body,
                decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: AppColors.subtext)),
              ),
              const SizedBox(height: 22),
              TextField(
                controller: passC,
                obscureText: hidePass,
                style: AppText.body,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: AppColors.subtext),
                  suffixIcon: IconButton(
                    icon: Icon(
                        hidePass
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.faint,
                        size: 20),
                    onPressed: () => setState(() => hidePass = !hidePass),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              GradientButton(
                  label: 'Sign in',
                  loading: loading,
                  onTap: doLogin),
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SignupScreen())),
                  child: const Text.rich(TextSpan(
                      text: 'New here?  ',
                      style: AppText.muted,
                      children: [
                        TextSpan(
                            text: 'Create an account',
                            style: TextStyle(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w600))
                      ])),
                ),
              ),
              const SizedBox(height: 36),
              // Demo logins — quiet, monospace, no box
              Container(
                padding: const EdgeInsets.only(top: 18),
                decoration: const BoxDecoration(
                    border:
                        Border(top: BorderSide(color: AppColors.line))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DEMO ACCESS', style: AppText.eyebrow),
                    const SizedBox(height: 12),
                    _demo('Admin', 'admin@ridenow.com', 'admin123'),
                    const SizedBox(height: 8),
                    _demo('Driver', 'driver@ridenow.com', 'driver123'),
                    const SizedBox(height: 8),
                    _demo('Rider', 'ayesha@gmail.com', '123456'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _demo(String role, String email, String pass) {
    return GestureDetector(
      onTap: () {
        emailC.text = email;
        passC.text = pass;
      },
      child: Row(
        children: [
          SizedBox(
              width: 54,
              child: Text(role,
                  style: const TextStyle(
                      color: AppColors.subtext,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600))),
          Expanded(
            child: Text('$email · $pass',
                style: AppText.meter
                    .copyWith(fontSize: 12, color: AppColors.faint)),
          ),
          const Icon(Icons.north_west, size: 13, color: AppColors.faint),
        ],
      ),
    );
  }
}
