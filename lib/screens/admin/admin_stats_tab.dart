import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../core/data_store.dart';

class AdminStatsTab extends StatelessWidget {
  const AdminStatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final s = DataStore.adminStats();
    final cards = [
      ('Total Users', s['users']!, Icons.people, AppColors.accent),
      ('Total Rides', s['rides']!, Icons.directions_car, AppColors.accent2),
      ('Pending', s['pending']!, Icons.hourglass_top, AppColors.amber),
      ('Completed', s['done']!, Icons.check_circle, AppColors.accentDark),
    ];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient revenue-style hero
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: AppColors.brandGradient,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total bookings',
                    style: TextStyle(color: Colors.black87, fontSize: 14)),
                const SizedBox(height: 6),
                Text('${s['rides']}',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 42,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.trending_up, size: 16, color: Colors.black87),
                  const SizedBox(width: 6),
                  Text('${s['done']} completed • ${s['pending']} pending',
                      style: const TextStyle(
                          color: Colors.black87, fontSize: 13)),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Overview', style: AppText.title),
          const SizedBox(height: 14),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.25,
            children: cards
                .map((c) => Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.04)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: c.$4.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(c.$3, color: c.$4, size: 22),
                          ),
                          Text('${c.$2}',
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.text)),
                          Text(c.$1, style: AppText.muted),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
