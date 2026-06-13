import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../core/data_store.dart';
import '../../core/helpers.dart';
import '../../widgets/ride_card.dart';

class MyRidesTab extends StatefulWidget {
  final int userId;
  const MyRidesTab({super.key, required this.userId});
  @override
  State<MyRidesTab> createState() => _MyRidesTabState();
}

class _MyRidesTabState extends State<MyRidesTab> {
  void cancelRide(int id) {
    DataStore.updateRideStatus(id, 'Cancelled');
    setState(() {});
    showSnack(context, 'Ride cancelled');
  }

  @override
  Widget build(BuildContext context) {
    final rides = DataStore.userRides(widget.userId);
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Text('My Rides', style: AppText.h2),
          ),
          Expanded(
            child: rides.isEmpty
                ? _empty()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: rides.length,
                    itemBuilder: (_, i) => RideCard(
                      ride: rides[i],
                      trailing: rides[i]['status'] == 'Pending'
                          ? GestureDetector(
                              onTap: () => cancelRide(rides[i]['id']),
                              child: const Text('Cancel',
                                  style: TextStyle(
                                      color: AppColors.danger,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13)))
                          : null,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _empty() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined,
                size: 64, color: AppColors.subtext.withOpacity(0.5)),
            const SizedBox(height: 16),
            const Text('No rides yet', style: AppText.title),
            const SizedBox(height: 4),
            const Text('Book your first ride to see it here',
                style: AppText.muted),
          ],
        ),
      );
}
