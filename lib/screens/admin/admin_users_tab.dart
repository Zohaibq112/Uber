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
    _sheet(
      title: 'Edit rider',
      children: [
        TextField(
            controller: nameC,
            style: AppText.body,
            decoration: const InputDecoration(labelText: 'Name')),
        const SizedBox(height: 16),
        TextField(
            controller: phoneC,
            style: AppText.body,
            decoration: const InputDecoration(labelText: 'Phone')),
        const SizedBox(height: 24),
        GradientButton(
          label: 'Save',
          onTap: () {
            DataStore.updateUser(user['id'],
                {'name': nameC.text.trim(), 'phone': phoneC.text.trim()});
            Navigator.pop(context);
            setState(() {});
            showSnack(context, 'Rider updated');
          },
        ),
      ],
    );
  }

  void removeUser(int id) => _confirm(
        'Delete rider?',
        'Their trips will be removed too.',
        () {
          DataStore.deleteUser(id);
          setState(() {});
          showSnack(context, 'Rider deleted');
        },
      );

  @override
  Widget build(BuildContext context) {
    final users = DataStore.getAllUsers();
    if (users.isEmpty) return const _Empty('No riders yet');
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      itemCount: users.length,
      itemBuilder: (_, i) {
        final u = users[i];
        return _PersonRow(
          initial: u['name'][0].toUpperCase(),
          name: u['name'],
          sub: '${u['email']}${(u['phone'] ?? '').isNotEmpty ? '  ·  ${u['phone']}' : ''}',
          onEdit: () => editUser(u),
          onDelete: () => removeUser(u['id']),
        );
      },
    );
  }

  void _sheet({required String title, required List<Widget> children}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgSoft,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            22, 18, 22, MediaQuery.of(ctx).viewInsets.bottom + 26),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                  color: AppColors.line,
                  borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 22),
          Align(alignment: Alignment.centerLeft, child: Eyebrow(title)),
          const SizedBox(height: 18),
          ...children,
        ]),
      ),
    );
  }

  void _confirm(String title, String body, VoidCallback onYes) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgSoft,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(title, style: AppText.h2),
        content: Text(body, style: AppText.muted),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(color: AppColors.subtext))),
          TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                onYes();
              },
              child: const Text('Delete',
                  style: TextStyle(
                      color: AppColors.danger, fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }
}

class _PersonRow extends StatelessWidget {
  final String initial, name, sub;
  final Widget? leadingDot;
  final VoidCallback onEdit, onDelete;
  const _PersonRow(
      {required this.initial,
      required this.name,
      required this.sub,
      required this.onEdit,
      required this.onDelete,
      this.leadingDot});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.line))),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.cardHi,
            child: Text(initial,
                style: const TextStyle(
                    color: AppColors.accent, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppText.title),
                const SizedBox(height: 2),
                Text(sub,
                    style: AppText.small,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          IconButton(
              icon: const Icon(Icons.edit_outlined,
                  color: AppColors.subtext, size: 20),
              onPressed: onEdit),
          IconButton(
              icon: const Icon(Icons.delete_outline,
                  color: AppColors.danger, size: 20),
              onPressed: onDelete),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  final String msg;
  const _Empty(this.msg);
  @override
  Widget build(BuildContext context) =>
      Center(child: Text(msg, style: AppText.muted));
}
