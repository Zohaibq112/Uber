import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../core/data_store.dart';
import '../../widgets/ride_card.dart';
import '../../widgets/section_header.dart';

class DriverAllRidesTab extends StatefulWidget {
  const DriverAllRidesTab({super.key});
  @override
  State<DriverAllRidesTab> createState() => _DriverAllRidesTabState();
}

class _DriverAllRidesTabState extends State<DriverAllRidesTab> {
  String filter = 'All';
  static const filters = ['All', 'Pending', 'Accepted', 'Completed', 'Cancelled'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(eyebrow: 'Platform', title: 'All rides'),
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 22),
              itemBuilder: (_, i) {
                final f = filters[i];
                final sel = filter == f;
                return GestureDetector(
                  onTap: () => setState(() => filter = f),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(f,
                          style: TextStyle(
                              color:
                                  sel ? AppColors.text : AppColors.subtext,
                              fontSize: 14,
                              fontWeight:
                                  sel ? FontWeight.w700 : FontWeight.w500)),
                      const SizedBox(height: 6),
                      Container(
                          width: 18,
                          height: 2,
                          color: sel ? AppColors.accent : Colors.transparent),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(height: 1, color: AppColors.line),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: DataStore.allRides(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                var rides = snap.data!;
                if (filter != 'All') {
                  rides =
                      rides.where((r) => r['status'] == filter).toList();
                }
                if (rides.isEmpty) {
                  return Center(
                      child: Text('No $filter rides', style: AppText.muted));
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  itemCount: rides.length,
                  itemBuilder: (_, i) =>
                      RideCard(ride: rides[i], showUser: true),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
