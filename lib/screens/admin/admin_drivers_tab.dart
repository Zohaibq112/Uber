import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../core/data_store.dart';
import '../../core/helpers.dart';

class AdminDriversTab extends StatefulWidget {
  const AdminDriversTab({super.key});
  @override
  State<AdminDriversTab> createState() => _AdminDriversTabState();
}

class _AdminDriversTabState extends State<AdminDriversTab> {
  void addDriverSheet() {
    final nameC = TextEditingController();
    final emailC = TextEditingController();
    final phoneC = TextEditingController();
    final vehicleC = TextEditingController();
    final passC = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgSoft,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            22, 18, 22, MediaQuery.of(ctx).viewInsets.bottom + 26),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                    color: AppColors.line,
                    borderRadius: BorderRadius.circular(4))),
            const SizedBox(height: 22),
            const Align(
                alignment: Alignment.centerLeft,
                child: Eyebrow('New driver')),
            const SizedBox(height: 16),
            _f(nameC, 'Full name'),
            _f(emailC, 'Email', type: TextInputType.emailAddress),
            _f(phoneC, 'Phone', type: TextInputType.phone),
            _f(vehicleC, 'Vehicle & plate'),
            _f(passC, 'Password', obscure: true),
            const SizedBox(height: 24),
            GradientButton(
              label: 'Add driver',
              onTap: () {
                if (nameC.text.trim().isEmpty ||
                    emailC.text.trim().isEmpty ||
                    passC.text.length < 6) {
                  showSnack(context, 'Fill every field — password 6+ chars',
                      error: true);
                  return;
                }
                final err = DataStore.addDriver({
                  'name': nameC.text.trim(),
                  'email': emailC.text.trim(),
                  'phone': phoneC.text.trim(),
                  'vehicle': vehicleC.text.trim(),
                  'password': passC.text,
                });
                if (err != null) {
                  showSnack(context, err, error: true);
                  return;
                }
                Navigator.pop(ctx);
                setState(() {});
                showSnack(context, 'Driver added');
              },
            ),
          ]),
        ),
      ),
    );
  }

  void removeDriver(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgSoft,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Remove driver?', style: AppText.h2),
        content: const Text(
            'Their active rides return to the request pool.',
            style: AppText.muted),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(color: AppColors.subtext))),
          TextButton(
              onPressed: () {
                DataStore.deleteDriver(id);
                Navigator.pop(ctx);
                setState(() {});
                showSnack(context, 'Driver removed');
              },
              child: const Text('Remove',
                  style: TextStyle(
                      color: AppColors.danger, fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final drivers = DataStore.getAllDrivers();
    return Stack(
      children: [
        if (drivers.isEmpty)
          Center(child: Text('No drivers yet', style: AppText.muted))
        else
          ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 90),
            itemCount: drivers.length,
            itemBuilder: (_, i) {
              final d = drivers[i];
              final online = d['online'] == true;
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: const BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: AppColors.line))),
                child: Row(
                  children: [
                    Stack(children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.cardHi,
                        child: const Icon(Icons.local_taxi_outlined,
                            color: AppColors.accent, size: 20),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color:
                                online ? AppColors.accent : AppColors.faint,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.bg, width: 2),
                          ),
                        ),
                      ),
                    ]),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(d['name'], style: AppText.title),
                          const SizedBox(height: 2),
                          Text(
                              '${d['vehicle']?.toString().isNotEmpty == true ? d['vehicle'] : 'No vehicle'}  ·  ${online ? 'Online' : 'Offline'}',
                              style: AppText.small,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: AppColors.danger, size: 20),
                        onPressed: () => removeDriver(d['id'])),
                  ],
                ),
              );
            },
          ),
        Positioned(
          right: 20,
          bottom: 20,
          child: GestureDetector(
            onTap: addDriverSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.add, color: Colors.black, size: 19),
                SizedBox(width: 6),
                Text('Add driver',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w700)),
              ]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _f(TextEditingController c, String label,
      {bool obscure = false, TextInputType? type}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: TextField(
        controller: c,
        obscureText: obscure,
        keyboardType: type,
        style: AppText.body,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
