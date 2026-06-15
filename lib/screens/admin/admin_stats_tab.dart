import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../core/data_store.dart';
import '../../core/helpers.dart';

class AdminStatsTab extends StatelessWidget {
  const AdminStatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final s = DataStore.adminStats();
    final total = s['rides']! == 0 ? 1 : s['rides']!;
    final donePct = (s['done']! / total * 100).round();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      children: [
        // Hero: a single big number, editorial, with a progress hairline
        Text('TOTAL BOOKINGS', style: AppText.eyebrow),
        const SizedBox(height: 10),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: s['rides']!.toDouble()),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
          builder: (_, v, __) => Text(v.round().toString(),
              style: AppText.meter
                  .copyWith(fontSize: 72, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 18),
        Stack(children: [
          Container(height: 3, color: AppColors.line),
          FractionallySizedBox(
            widthFactor: s['done']! / total,
            child: Container(height: 3, color: AppColors.accent),
          ),
        ]),
        const SizedBox(height: 12),
        Text('$donePct% completed · ${s['pending']} in progress',
            style: AppText.muted),
        const SizedBox(height: 40),
        const Eyebrow('Platform'),
        const SizedBox(height: 6),
        _statRow('Riders', s['users']!, Icons.people_outline),
        _statRow('Drivers', s['drivers']!, Icons.local_taxi_outlined),
        _statRow('Pending rides', s['pending']!, Icons.schedule),
        _statRow('Completed', s['done']!, Icons.check_circle_outline,
            last: true),
      ],
    );
  }

  Widget _statRow(String label, int value, IconData icon,
      {bool last = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: last ? Colors.transparent : AppColors.line)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 19, color: AppColors.subtext),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: AppText.title)),
          Text('$value',
              style: AppText.meter.copyWith(fontSize: 18)),
        ],
      ),
    );
  }
}
