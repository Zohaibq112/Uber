import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../core/data_store.dart';
import '../../core/helpers.dart';
import '../../widgets/ride_card.dart';
import '../../widgets/section_header.dart';

class DriverTripsTab extends StatefulWidget {
  final int driverId;
  const DriverTripsTab({super.key, required this.driverId});
  @override
  State<DriverTripsTab> createState() => _DriverTripsTabState();
}

class _DriverTripsTabState extends State<DriverTripsTab> {
  Future<void> complete(int id) async {
    await DataStore.updateRideStatus(id, 'Completed');
    if (!mounted) return;
    setState(() {});
    showSnack(context, 'Trip completed');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(eyebrow: 'Accepted', title: 'My trips'),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: DataStore.driverRides(widget.driverId),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final trips = snap.data!;
                if (trips.isEmpty) {
                  return Center(
                      child: Text('Accept a request to start driving',
                          style: AppText.muted));
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: trips.length,
                  itemBuilder: (_, i) => RideCard(
                    ride: trips[i],
                    showUser: true,
                    trailing: trips[i]['status'] == 'Accepted'
                        ? GestureDetector(
                            onTap: () => complete(trips[i]['id']),
                            child: Text('Mark completed',
                                style: AppText.small.copyWith(
                                    color: AppColors.accent,
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
