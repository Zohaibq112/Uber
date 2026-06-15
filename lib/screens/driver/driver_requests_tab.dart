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
  // online is stored as 1/0 in SQLite.
  bool online = true;
  Map<String, dynamic> stats = {'earnings': 0.0, 'trips': 0, 'completed': 0};
  List<Map<String, dynamic>> requests = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    online = widget.driver['online'] == 1;
    _load();
  }

  // Load online state, earnings, and the request feed from the database.
  Future<void> _load() async {
    final s = await DataStore.driverStats(widget.driver['id']);
    final r = online ? await DataStore.availableRequests() : <Map<String, dynamic>>[];
    if (!mounted) return;
    setState(() {
      stats = s;
      requests = r;
      loading = false;
    });
  }

  Future<void> acceptRide(int rideId) async {
    await DataStore.acceptRide(
        rideId, widget.driver['id'], widget.driver['name']);
    if (!mounted) return;
    widget.onChanged();
    showSnack(context, 'Accepted — see it under Trips');
    _load();
  }

  Future<void> toggleOnline(bool v) async {
    await DataStore.setDriverOnline(widget.driver['id'], v);
    widget.driver['online'] = v ? 1 : 0;
    if (!mounted) return;
    setState(() => online = v);
    _load();
  }

  @override
  Widget build(BuildContext context) {
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
          // Earnings strip
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              _stat('Earnings',
                  'Rs ${(stats['earnings'] as double).toStringAsFixed(0)}'),
              _divider(),
              _stat('Trips', '${stats['trips']}'),
              _divider(),
              _stat('Done', '${stats['completed']}'),
            ]),
          ),
          const SizedBox(height: 8),
          // Online toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(children: [
              Dot(online ? AppColors.trust : AppColors.faint, size: 9),
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
                onChanged: toggleOnline,
              ),
            ]),
          ),
          Container(height: 1, color: AppColors.line),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : requests.isEmpty
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
                        itemBuilder: (_, i) => _request(requests[i]),
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
          GradientButton(
              label: 'Accept ride', onTap: () => acceptRide(r['id'])),
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
