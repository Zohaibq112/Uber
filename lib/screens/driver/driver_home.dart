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
  @override
  Widget build(BuildContext context) {
    final unread = DataStore.unreadCount(widget.driver['id']);
    final pages = [
      DriverRequestsTab(driver: widget.driver, onChanged: () => setState(() {})),
      const DriverAllRidesTab(),
      DriverTripsTab(driverId: widget.driver['id']),
      DriverAlertsTab(
          driverId: widget.driver['id'], onRead: () => setState(() {})),
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
