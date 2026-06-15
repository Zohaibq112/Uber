import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../core/data_store.dart';
import '../../core/helpers.dart';
import '../../widgets/ride_card.dart';
import '../../widgets/section_header.dart';

class MyRidesTab extends StatefulWidget {
  final int userId;
  const MyRidesTab({super.key, required this.userId});
  @override
  State<MyRidesTab> createState() => _MyRidesTabState();
}

class _MyRidesTabState extends State<MyRidesTab> {
  Future<void> cancelRide(int id) async {
    await DataStore.updateRideStatus(id, 'Cancelled');
    if (!mounted) return;
    setState(() {});
    showSnack(context, 'Ride cancelled');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(eyebrow: 'Your history', title: 'Trips'),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: DataStore.userRides(widget.userId),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final rides = snap.data!;
                if (rides.isEmpty) return const _Empty();
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: rides.length,
                  itemBuilder: (_, i) => RideCard(
                    ride: rides[i],
                    trailing: rides[i]['status'] == 'Pending'
                        ? GestureDetector(
                            onTap: () => cancelRide(rides[i]['id']),
                            child: Text('Cancel ride',
                                style: AppText.small.copyWith(
                                    color: AppColors.danger,
                                    fontWeight: FontWeight.w600)))
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();
  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No trips yet', style: AppText.h2),
            const SizedBox(height: 8),
            Text('Your booked rides will appear here', style: AppText.muted),
          ],
        ),
      );
}
