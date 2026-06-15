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
      showSnack(context, 'Fill every field — password needs 6+ characters',
          error: true);
      return;
    }
    setState(() => loading = true);
    await Future.delayed(const Duration(milliseconds: 400));
    final error = await DataStore.registerUser({
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
      showSnack(context, 'Account created — sign in to continue');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.text),
            onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Eyebrow('Get started'),
            const SizedBox(height: 14),
            const Text('Create your\naccount', style: AppText.display),
            const SizedBox(height: 40),
            _f(nameC, 'Full name'),
            const SizedBox(height: 20),
            _f(emailC, 'Email', type: TextInputType.emailAddress),
            const SizedBox(height: 20),
            _f(phoneC, 'Phone', type: TextInputType.phone),
            const SizedBox(height: 20),
            _f(passC, 'Password', obscure: true),
            const SizedBox(height: 40),
            GradientButton(
                label: 'Create account', loading: loading, onTap: doSignup),
          ],
        ),
      ),
    );
  }

  Widget _f(TextEditingController c, String label,
      {bool obscure = false, TextInputType? type}) {
    return TextField(
      controller: c,
      obscureText: obscure,
      keyboardType: type,
      style: AppText.body,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.subtext)),
    );
  }
}
