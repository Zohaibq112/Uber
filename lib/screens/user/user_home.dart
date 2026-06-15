import 'package:flutter/material.dart';
import '../../widgets/bottom_bar.dart';
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
      bottomNavigationBar: BottomBar(
        index: tab,
        onTap: (i) => setState(() => tab = i),
        items: const [
          NavItem(Icons.explore_outlined, 'Book'),
          NavItem(Icons.receipt_long_outlined, 'Trips'),
          NavItem(Icons.person_outline, 'Profile'),
        ],
      ),
    );
  }
}
