import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../auth/login_screen.dart';
import 'admin_stats_tab.dart';
import 'admin_users_tab.dart';
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
    final titles = ['Dashboard', 'Manage Users', 'Manage Rides'];
    final pages = [
      const AdminStatsTab(),
      const AdminUsersTab(),
      const AdminRidesTab(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[tab]),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.danger),
            onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false),
          )
        ],
      ),
      body: pages[tab],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          border:
              Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: Colors.transparent,
            indicatorColor: AppColors.accent.withOpacity(0.16),
            labelTextStyle: WidgetStateProperty.all(
                const TextStyle(fontSize: 12, color: AppColors.subtext)),
          ),
          child: NavigationBar(
            selectedIndex: tab,
            height: 68,
            onDestinationSelected: (i) => setState(() => tab = i),
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon:
                      Icon(Icons.dashboard, color: AppColors.accent),
                  label: 'Overview'),
              NavigationDestination(
                  icon: Icon(Icons.people_outline),
                  selectedIcon: Icon(Icons.people, color: AppColors.accent),
                  label: 'Users'),
              NavigationDestination(
                  icon: Icon(Icons.directions_car_outlined),
                  selectedIcon:
                      Icon(Icons.directions_car, color: AppColors.accent),
                  label: 'Rides'),
            ],
          ),
        ),
      ),
    );
  }
}
