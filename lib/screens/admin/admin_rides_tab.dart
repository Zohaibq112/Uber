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
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: AppColors.subtext,
                    borderRadius: BorderRadius.circular(4))),
            const SizedBox(height: 16),
            const Text('Update Status', style: AppText.title),
            const SizedBox(height: 8),
            ...statuses.map((s) => ListTile(
                  leading: Icon(Icons.circle, size: 12, color: statusColor(s)),
                  title: Text(s, style: AppText.body),
                  onTap: () {
                    DataStore.updateRideStatus(ride['id'], s);
                    Navigator.pop(ctx);
                    setState(() {});
                    showSnack(context, 'Status updated to $s');
                  },
                )),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void deleteRide(int id) {
    DataStore.deleteRide(id);
    setState(() {});
    showSnack(context, 'Ride deleted');
  }

  @override
  Widget build(BuildContext context) {
    final rides = DataStore.allRides();
    if (rides.isEmpty) {
      return const Center(
          child: Text('No rides booked yet', style: AppText.muted));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rides.length,
      itemBuilder: (_, i) => RideCard(
        ride: rides[i],
        showUser: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                icon: const Icon(Icons.swap_horiz,
                    color: AppColors.accent2, size: 22),
                tooltip: 'Change status',
                onPressed: () => changeStatus(rides[i])),
            IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: AppColors.danger, size: 22),
                onPressed: () => deleteRide(rides[i]['id'])),
          ],
        ),
      ),
    );
  }
}
