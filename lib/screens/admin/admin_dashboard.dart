import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/bottom_bar.dart';
import '../../widgets/section_header.dart';
import '../auth/login_screen.dart';
import 'admin_stats_tab.dart';
import 'admin_users_tab.dart';
import 'admin_drivers_tab.dart';
import 'admin_rides_tab.dart';

class AdminDashboard extends StatefulWidget {
  final Map<String, dynamic> admin;
  const AdminDashboard({super.key, required this.admin});
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    final headers = [
      ('Console', 'Overview'),
      ('People', 'Riders'),
      ('Fleet', 'Drivers'),
      ('Activity', 'Rides'),
    ];
    final pages = [
      const AdminStatsTab(),
      const AdminUsersTab(),
      const AdminDriversTab(),
      const AdminRidesTab(),
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            PageHeader(
              eyebrow: headers[tab].$1,
              title: headers[tab].$2,
              trailing: CircleIconButton(
                icon: Icons.logout,
                color: AppColors.danger,
                onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false),
              ),
            ),
            Expanded(child: pages[tab]),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(
        index: tab,
        onTap: (i) => setState(() => tab = i),
        items: const [
          NavItem(Icons.bar_chart_rounded, 'Overview'),
          NavItem(Icons.people_outline, 'Riders'),
          NavItem(Icons.local_taxi_outlined, 'Drivers'),
          NavItem(Icons.swap_vert_rounded, 'Rides'),
        ],
      ),
    );
  }
}
