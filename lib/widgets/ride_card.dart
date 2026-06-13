import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/helpers.dart';

/// Reusable card showing one ride. Used in user & admin lists.
class RideCard extends StatelessWidget {
  final Map<String, dynamic> ride;
  final Widget? trailing;
  final bool showUser;

  const RideCard(
      {super.key, required this.ride, this.trailing, this.showUser = false});

  @override
  Widget build(BuildContext context) {
    final color = statusColor(ride['status']);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.circle, size: 8, color: color),
                  const SizedBox(width: 6),
                  Text(ride['status'],
                      style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
                ]),
              ),
              const Spacer(),
              Text('Rs ${(ride['fare'] as num).toStringAsFixed(0)}',
                  style: const TextStyle(
                      color: AppColors.text,
                      fontWeight: FontWeight.w800,
                      fontSize: 17)),
            ],
          ),
          const SizedBox(height: 16),
          // Route line with connector dots.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(children: [
                Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                        color: AppColors.accent, shape: BoxShape.circle)),
                Container(
                    width: 2,
                    height: 22,
                    color: AppColors.subtext.withOpacity(0.4)),
                const Icon(Icons.location_on,
                    size: 14, color: AppColors.danger),
              ]),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ride['pickup'], style: AppText.body),
                    const SizedBox(height: 14),
                    Text(ride['dropoff'], style: AppText.body),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: Colors.white.withOpacity(0.05), height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.local_taxi,
                  size: 14, color: AppColors.subtext),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                    '${ride['vehicle']}  •  ${ride['createdAt'] ?? ''}'
                    '${showUser ? '  •  ${ride['userName'] ?? ''}' : ''}',
                    overflow: TextOverflow.ellipsis,
                    style: AppText.muted),
              ),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
        ],
      ),
    );
  }
}
