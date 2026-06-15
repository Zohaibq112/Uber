import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/helpers.dart';

/// A ride as a clean list row — leading status dot, route, meter fare,
/// hairline divider below. No boxes; relies on space + lines.
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
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Dot(color, size: 9),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${ride['pickup']}  →  ${ride['dropoff']}',
                        style: AppText.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Money(ride['fare'] as num, size: 15),
                  ],
                ),
                const SizedBox(height: 6),
                Text(_meta(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.small),
                if (trailing != null) ...[
                  const SizedBox(height: 12),
                  Align(alignment: Alignment.centerRight, child: trailing!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _meta() {
    final parts = <String>[
      ride['status'],
      ride['vehicle'],
      ride['createdAt'] ?? '',
    ];
    if (showUser && ride['userName'] != null) parts.add(ride['userName']);
    if (ride['driverName'] != null) parts.add(ride['driverName']);
    return parts.where((e) => e.toString().isNotEmpty).join('  ·  ');
  }
}
