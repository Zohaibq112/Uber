import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../core/data_store.dart';
import '../../core/helpers.dart';

class AdminUsersTab extends StatefulWidget {
  const AdminUsersTab({super.key});
  @override
  State<AdminUsersTab> createState() => _AdminUsersTabState();
}

class _AdminUsersTabState extends State<AdminUsersTab> {
  void editUser(Map<String, dynamic> user) {
    final nameC = TextEditingController(text: user['name']);
    final phoneC = TextEditingController(text: user['phone'] ?? '');
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            20, 22, 20, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: AppColors.subtext,
                    borderRadius: BorderRadius.circular(4))),
            const SizedBox(height: 20),
            const Text('Edit User', style: AppText.title),
            const SizedBox(height: 18),
            TextField(
                controller: nameC,
                style: AppText.body,
                decoration: const InputDecoration(
                    hintText: 'Name',
                    prefixIcon: Icon(Icons.person_outline))),
            const SizedBox(height: 14),
            TextField(
                controller: phoneC,
                style: AppText.body,
                decoration: const InputDecoration(
                    hintText: 'Phone',
                    prefixIcon: Icon(Icons.phone_outlined))),
            const SizedBox(height: 22),
            GradientButton(
              label: 'Save',
              icon: Icons.check,
              onTap: () {
                DataStore.updateUser(user['id'], {
                  'name': nameC.text.trim(),
                  'phone': phoneC.text.trim()
                });
                Navigator.pop(ctx);
                setState(() {});
                showSnack(context, 'User updated');
              },
            ),
          ],
        ),
      ),
    );
  }

  void removeUser(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete user?', style: AppText.title),
        content: const Text('This will also remove all their rides.',
            style: AppText.muted),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(color: AppColors.subtext))),
          TextButton(
              onPressed: () {
                DataStore.deleteUser(id);
                Navigator.pop(ctx);
                setState(() {});
                showSnack(context, 'User deleted');
              },
              child: const Text('Delete',
                  style: TextStyle(
                      color: AppColors.danger, fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final users = DataStore.getAllUsers();
    if (users.isEmpty) {
      return const Center(
          child: Text('No users registered yet', style: AppText.muted));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (_, i) {
        final u = users[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.04)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.accent.withOpacity(0.15),
                child: Text(u['name'][0].toUpperCase(),
                    style: const TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(u['name'],
                        style: const TextStyle(
                            color: AppColors.text,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(u['email'], style: AppText.muted),
                    if ((u['phone'] ?? '').isNotEmpty)
                      Text(u['phone'], style: AppText.muted),
                  ],
                ),
              ),
              IconButton(
                  icon: const Icon(Icons.edit_outlined,
                      color: AppColors.accent2, size: 22),
                  onPressed: () => editUser(u)),
              IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: AppColors.danger, size: 22),
                  onPressed: () => removeUser(u['id'])),
            ],
          ),
        );
      },
    );
  }
}
