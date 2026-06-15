import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../core/data_store.dart';
import '../../core/helpers.dart';
import '../../widgets/section_header.dart';
import '../auth/login_screen.dart';

class ProfileTab extends StatefulWidget {
  final Map<String, dynamic> user;
  const ProfileTab({super.key, required this.user});
  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late final nameC = TextEditingController(text: widget.user['name']);
  late final phoneC = TextEditingController(text: widget.user['phone'] ?? '');

  Future<void> saveProfile() async {
    await DataStore.updateUser(widget.user['id'],
        {'name': nameC.text.trim(), 'phone': phoneC.text.trim()});
    widget.user['name'] = nameC.text.trim();
    widget.user['phone'] = phoneC.text.trim();
    if (!mounted) return;
    setState(() {});
    showSnack(context, 'Profile saved');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        children: [
          const PageHeader(
              eyebrow: 'Account',
              title: 'Profile',
              padding: EdgeInsets.fromLTRB(0, 8, 0, 24)),
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.cardHi,
                child: Text(
                  widget.user['name'].toString().isNotEmpty
                      ? widget.user['name'][0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                      fontSize: 26,
                      color: AppColors.accent,
                      fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.user['name'], style: AppText.h2),
                    const SizedBox(height: 2),
                    Text(widget.user['email'], style: AppText.muted),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Eyebrow('Edit details'),
          const SizedBox(height: 6),
          TextField(
              controller: nameC,
              style: AppText.body,
              decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: AppColors.subtext))),
          const SizedBox(height: 18),
          TextField(
              controller: phoneC,
              style: AppText.body,
              decoration: const InputDecoration(
                  labelText: 'Phone',
                  labelStyle: TextStyle(color: AppColors.subtext))),
          const SizedBox(height: 32),
          GradientButton(label: 'Save changes', onTap: saveProfile),
          const SizedBox(height: 12),
          GhostButton(
            label: 'Log out',
            icon: Icons.logout,
            color: AppColors.danger,
            onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false),
          ),
        ],
      ),
    );
  }
}
