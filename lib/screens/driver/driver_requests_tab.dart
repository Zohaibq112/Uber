import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../core/data_store.dart';
import '../../core/helpers.dart';
import '../../widgets/section_header.dart';
import '../auth/login_screen.dart';

class DriverRequestsTab extends StatefulWidget {
  final Map<String, dynamic> driver;
  final VoidCallback onChanged;
  const DriverRequestsTab(
      {super.key, required this.driver, required this.onChanged});
  @override
  State<DriverRequestsTab> createState() => _DriverRequestsTabState();
}

class _DriverRequestsTabState extends State<DriverRequestsTab> {
  bool get online => widget.driver['online'] == true;

  void acceptRide(int rideId) {
    DataStore.acceptRide(rideId, widget.driver['id'], widget.driver['name']);
    setState(() {});
    widget.onChanged();
    showSnack(context, 'Accepted — see it under Trips');
  }

  @override
  Widget build(BuildContext context) {
    final requests = online ? DataStore.availableRequests() : [];
    final stats = DataStore.driverStats(widget.driver['id']);
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            eyebrow: widget.driver['vehicle'] ?? 'Driver',
            title: 'Hi, ${widget.driver['name'].toString().split(' ').first}',
            trailing: CircleIconButton(
              icon: Icons.logout,
              color: AppColors.danger,
              onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false),
            ),
          ),
          // Earnings strip — figures only, divided, no boxes
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              _stat('Earnings', 'Rs ${(stats['earnings'] as double).toStringAsFixed(0)}'),
              _divider(),
              _stat('Trips', '${stats['trips']}'),
              _divider(),
              _stat('Done', '${stats['completed']}'),
            ]),
          ),
          const SizedBox(height: 8),
          // Online toggle row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(children: [
              Dot(online ? AppColors.accent : AppColors.faint, size: 9),
              const SizedBox(width: 10),
              Expanded(
                child: Text(online ? 'Online · taking rides' : 'Offline',
                    style: AppText.title),
              ),
              Switch(
                value: online,
                activeColor: Colors.white,
                activeTrackColor: AppColors.trust,
                inactiveTrackColor: AppColors.cardHi,
                onChanged: (v) {
                  DataStore.setDriverOnline(widget.driver['id'], v);
                  widget.driver['online'] = v;
                  setState(() {});
                },
              ),
            ]),
          ),
          Container(height: 1, color: AppColors.line),
          Expanded(
            child: requests.isEmpty
                ? Center(
                    child: Text(
                        online
                            ? 'No requests right now'
                            : 'Go online to receive rides',
                        style: AppText.muted),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    itemCount: requests.length,
                    itemBuilder: (_, i) =>
                        _request(requests[i] as Map<String, dynamic>),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _request(Map<String, dynamic> r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: AppDeco.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.cardHi,
              child: Text(r['userName'][0].toUpperCase(),
                  style: const TextStyle(
                      color: AppColors.ink, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r['userName'], style: AppText.title),
                  const SizedBox(height: 2),
                  const Rating(4.8),
                ],
              ),
            ),
            Money(r['fare'] as num, size: 16),
          ]),
          const SizedBox(height: 16),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Column(children: [
                const Dot(AppColors.trust, size: 8),
                Container(width: 1.5, height: 18, color: AppColors.line),
                const Icon(Icons.place, size: 13, color: AppColors.danger),
              ]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r['pickup'], style: AppText.body),
                  const SizedBox(height: 10),
                  Text(r['dropoff'], style: AppText.body),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 16),
          GradientButton(label: 'Accept ride', onTap: () => acceptRide(r['id'])),
        ],
      ),
    );
  }

  Widget _stat(String label, String value) => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                  child: Text(value,
                      style: AppText.meter.copyWith(fontSize: 17))),
              const SizedBox(height: 4),
              Text(label.toUpperCase(), style: AppText.eyebrow),
            ],
          ),
        ),
      );

  Widget _divider() =>
      Container(width: 1, height: 34, color: AppColors.line);
}
