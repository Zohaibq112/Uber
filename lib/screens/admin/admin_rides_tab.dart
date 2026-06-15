import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../core/data_store.dart';
import '../../core/helpers.dart';
import '../../widgets/ride_card.dart';

class AdminRidesTab extends StatefulWidget {
  const AdminRidesTab({super.key});
  @override
  State<AdminRidesTab> createState() => _AdminRidesTabState();
}

class _AdminRidesTabState extends State<AdminRidesTab> {
  static const statuses = ['Pending', 'Accepted', 'Completed', 'Cancelled'];

  void changeStatus(Map<String, dynamic> ride) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgSoft,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (ctx) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 16),
          Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                  color: AppColors.line,
                  borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 18),
          ...statuses.map((sName) => ListTile(
                leading: Dot(statusColor(sName), size: 9),
                title: Text(sName, style: AppText.body),
                onTap: () {
                  DataStore.updateRideStatus(ride['id'], sName);
                  Navigator.pop(ctx);
                  setState(() {});
                  showSnack(context, 'Marked $sName');
                },
              )),
          const SizedBox(height: 12),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rides = DataStore.allRides();
    if (rides.isEmpty) {
      return Center(child: Text('No rides yet', style: AppText.muted));
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      itemCount: rides.length,
      itemBuilder: (_, i) => RideCard(
        ride: rides[i],
        showUser: true,
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          GestureDetector(
              onTap: () => changeStatus(rides[i]),
              child: Text('Change status',
                  style: AppText.small.copyWith(
                      color: AppColors.accent, fontWeight: FontWeight.w600))),
          const SizedBox(width: 18),
          GestureDetector(
              onTap: () {
                DataStore.deleteRide(rides[i]['id']);
                setState(() {});
                showSnack(context, 'Ride deleted');
              },
              child: Text('Delete',
                  style: AppText.small.copyWith(
                      color: AppColors.danger, fontWeight: FontWeight.w600))),
        ]),
      ),
    );
  }
}
