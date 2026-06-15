import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../core/data_store.dart';
import '../../widgets/section_header.dart';

class DriverAlertsTab extends StatefulWidget {
  final int driverId;
  final VoidCallback onRead;
  const DriverAlertsTab(
      {super.key, required this.driverId, required this.onRead});
  @override
  State<DriverAlertsTab> createState() => _DriverAlertsTabState();
}

class _DriverAlertsTabState extends State<DriverAlertsTab> {
  @override
  void initState() {
    super.initState();
    // Opening alerts marks them read, then refreshes the badge.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await DataStore.markNotificationsRead(widget.driverId);
      widget.onRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(eyebrow: 'Inbox', title: 'Alerts'),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: DataStore.driverNotifications(widget.driverId),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final notifs = snap.data!;
                if (notifs.isEmpty) {
                  return Center(
                      child: Text("You'll be alerted on new requests",
                          style: AppText.muted));
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: notifs.length,
                  itemBuilder: (_, i) {
                    final n = notifs[i];
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: AppColors.line))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 3),
                            child: Icon(Icons.bolt,
                                color: AppColors.accent, size: 18),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(n['text'], style: AppText.body),
                                const SizedBox(height: 3),
                                Text(n['time'], style: AppText.small),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
