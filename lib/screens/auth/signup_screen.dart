import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../core/data_store.dart';
import '../../core/helpers.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final phoneC = TextEditingController();
  final passC = TextEditingController();
  bool loading = false;

  Future<void> doSignup() async {
    if (nameC.text.trim().isEmpty ||
        emailC.text.trim().isEmpty ||
        passC.text.length < 6) {
      showSnack(context, 'Fill all fields (password min 6 chars)', error: true);
      return;
    }
    setState(() => loading = true);
    await Future.delayed(const Duration(milliseconds: 400));
    final error = DataStore.registerUser({
      'name': nameC.text.trim(),
      'email': emailC.text.trim(),
      'phone': phoneC.text.trim(),
      'password': passC.text,
    });
    if (!mounted) return;
    setState(() => loading = false);
    if (error != null) {
      showSnack(context, error, error: true);
    } else {
      showSnack(context, 'Account created! Please sign in.');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Join RideNow', style: AppText.h2),
            const SizedBox(height: 4),
            const Text('Create an account to start booking rides',
                style: AppText.muted),
            const SizedBox(height: 28),
            _field(nameC, 'Full Name', Icons.person_outline),
            const SizedBox(height: 16),
            _field(emailC, 'Email', Icons.email_outlined,
                type: TextInputType.emailAddress),
            const SizedBox(height: 16),
            _field(phoneC, 'Phone', Icons.phone_outlined,
                type: TextInputType.phone),
            const SizedBox(height: 16),
            _field(passC, 'Password', Icons.lock_outline, obscure: true),
            const SizedBox(height: 32),
            GradientButton(
                label: 'Create Account',
                icon: Icons.person_add_alt,
                loading: loading,
                onTap: doSignup),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String hint, IconData icon,
      {bool obscure = false, TextInputType? type}) {
    return TextField(
      controller: c,
      obscureText: obscure,
      keyboardType: type,
      style: AppText.body,
      decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon)),
    );
  }
}
