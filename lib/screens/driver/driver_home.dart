import 'package:flutter/material.dart';
import '../../core/data_store.dart';
import '../../widgets/bottom_bar.dart';
import 'driver_requests_tab.dart';
import 'driver_all_rides_tab.dart';
import 'driver_trips_tab.dart';
import 'driver_alerts_tab.dart';

class DriverHome extends StatefulWidget {
  final Map<String, dynamic> driver;
  const DriverHome({super.key, required this.driver});
  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  int tab = 0;
  int unread = 0; // badge count, loaded from the database

  @override
  void initState() {
    super.initState();
    _loadUnread();
  }

  // Read the unread notification count and refresh the badge.
  Future<void> _loadUnread() async {
    final count = await DataStore.unreadCount(widget.driver['id']);
    if (!mounted) return;
    setState(() => unread = count);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DriverRequestsTab(
          driver: widget.driver, onChanged: () => _loadUnread()),
      const DriverAllRidesTab(),
      DriverTripsTab(driverId: widget.driver['id']),
      DriverAlertsTab(
          driverId: widget.driver['id'], onRead: () => _loadUnread()),
    ];
    return Scaffold(
      body: pages[tab],
      bottomNavigationBar: BottomBar(
        index: tab,
        onTap: (i) => setState(() => tab = i),
        items: [
          const NavItem(Icons.bolt_outlined, 'Requests'),
          const NavItem(Icons.travel_explore_outlined, 'All rides'),
          const NavItem(Icons.map_outlined, 'Trips'),
          NavItem(Icons.notifications_none_rounded, 'Alerts', badge: unread),
        ],
      ),
    );
  }
}
