import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import 'book_ride_tab.dart';
import 'my_rides_tab.dart';
import 'profile_tab.dart';

class UserHome extends StatefulWidget {
  final Map<String, dynamic> user;
  const UserHome({super.key, required this.user});
  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      BookRideTab(user: widget.user),
      MyRidesTab(userId: widget.user['id']),
      ProfileTab(user: widget.user),
    ];
    return Scaffold(
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
                  icon: Icon(Icons.directions_car_outlined),
                  selectedIcon:
                      Icon(Icons.directions_car, color: AppColors.accent),
                  label: 'Book'),
              NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon:
                      Icon(Icons.receipt_long, color: AppColors.accent),
                  label: 'My Rides'),
              NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person, color: AppColors.accent),
                  label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}
