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
  void complete(int id) {
    DataStore.updateRideStatus(id, 'Completed');
    setState(() {});
    showSnack(context, 'Trip completed');
  }

  @override
  Widget build(BuildContext context) {
    final trips = DataStore.driverRides(widget.driverId);
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(eyebrow: 'Accepted', title: 'My trips'),
          Expanded(
            child: trips.isEmpty
                ? Center(
                    child: Text('Accept a request to start driving',
                        style: AppText.muted))
                : ListView.builder(
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
                  ),
          ),
        ],
      ),
    );
  }
}
