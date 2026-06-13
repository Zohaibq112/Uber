import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../core/data_store.dart';
import '../../core/helpers.dart';
import '../auth/login_screen.dart';

class ProfileTab extends StatefulWidget {
  final Map<String, dynamic> user;
  const ProfileTab({super.key, required this.user});
  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late final nameC = TextEditingController(text: widget.user['name']);
  late final phoneC =
      TextEditingController(text: widget.user['phone'] ?? '');

  void saveProfile() {
    DataStore.updateUser(widget.user['id'],
        {'name': nameC.text.trim(), 'phone': phoneC.text.trim()});
    widget.user['name'] = nameC.text.trim();
    widget.user['phone'] = phoneC.text.trim();
    setState(() {});
    showSnack(context, 'Profile updated');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                  gradient: AppColors.brandGradient, shape: BoxShape.circle),
              child: CircleAvatar(
                radius: 46,
                backgroundColor: AppColors.bg,
                child: Text(
                  widget.user['name'].toString().isNotEmpty
                      ? widget.user['name'][0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                      fontSize: 38,
                      color: AppColors.accent,
                      fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(widget.user['name'], style: AppText.title),
            Text(widget.user['email'], style: AppText.muted),
            const SizedBox(height: 30),
            _label('Name'),
            TextField(
                controller: nameC,
                style: AppText.body,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline))),
            const SizedBox(height: 16),
            _label('Phone'),
            TextField(
                controller: phoneC,
                style: AppText.body,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone_outlined))),
            const SizedBox(height: 28),
            GradientButton(
                label: 'Save Changes', icon: Icons.save_outlined, onTap: saveProfile),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false),
              child: Container(
                height: 54,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.danger.withOpacity(0.6)),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: AppColors.danger, size: 20),
                      SizedBox(width: 8),
                      Text('Logout',
                          style: TextStyle(
                              color: AppColors.danger,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String t) => Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 4),
          child: Text(t,
              style: const TextStyle(
                  color: AppColors.subtext,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ),
      );
}
