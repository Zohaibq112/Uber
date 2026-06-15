import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../core/data_store.dart';
import '../../core/helpers.dart';
import '../../widgets/map_preview.dart';

class BookRideTab extends StatefulWidget {
  final Map<String, dynamic> user;
  const BookRideTab({super.key, required this.user});
  @override
  State<BookRideTab> createState() => _BookRideTabState();
}

class _BookRideTabState extends State<BookRideTab> {
  final pickupC = TextEditingController();
  final dropC = TextEditingController();
  String vehicle = 'Mini';

  static const vehicles = {
    'Mini': {'icon': Icons.directions_car_outlined, 'rate': 30.0, 'eta': '3 min'},
    'Go': {'icon': Icons.local_taxi_outlined, 'rate': 45.0, 'eta': '5 min'},
    'Premium': {'icon': Icons.airport_shuttle_outlined, 'rate': 70.0, 'eta': '7 min'},
    'Bike': {'icon': Icons.two_wheeler_outlined, 'rate': 15.0, 'eta': '2 min'},
  };

  double estimateFare() {
    final rate = vehicles[vehicle]!['rate'] as double;
    final dist = ((pickupC.text.length + dropC.text.length) % 12) + 3;
    return 100 + rate * dist;
  }

  void confirmBooking() {
    if (pickupC.text.trim().isEmpty || dropC.text.trim().isEmpty) {
      showSnack(context, 'Add a pickup and drop-off first', error: true);
      return;
    }
    final fare = estimateFare();
    DataStore.bookRide({
      'userId': widget.user['id'],
      'pickup': pickupC.text.trim(),
      'dropoff': dropC.text.trim(),
      'vehicle': 'RideNow $vehicle',
      'fare': fare,
      'status': 'Pending',
      'createdAt': DateTime.now().toString().substring(0, 16),
    });
    pickupC.clear();
    dropC.clear();
    setState(() {});
    showSnack(context, 'Ride requested — finding you a driver');
  }

  @override
  Widget build(BuildContext context) {
    final hasRoute = pickupC.text.isNotEmpty && dropC.text.isNotEmpty;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Eyebrow('Hello ${widget.user['name'].toString().split(' ').first}'),
                    const SizedBox(height: 12),
                    const Text('Where to?', style: AppText.display),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.cardHi,
                child: Text(
                    widget.user['name'].toString()[0].toUpperCase(),
                    style: const TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w700,
                        fontSize: 18)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const MapPreview(),
          const SizedBox(height: 28),
          // Route inputs as clean rows with a connector
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(children: [
                  const Dot(AppColors.accent, size: 9),
                  Container(
                      width: 1.5,
                      height: 30,
                      color: AppColors.line),
                  const Icon(Icons.place, size: 15, color: AppColors.danger),
                ]),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(children: [
                  TextField(
                    controller: pickupC,
                    style: AppText.body,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(hintText: 'Pickup point'),
                  ),
                  TextField(
                    controller: dropC,
                    style: AppText.body,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(hintText: 'Destination'),
                  ),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Eyebrow('Choose a ride'),
          const SizedBox(height: 6),
          ...vehicles.entries.map((e) {
            final sel = vehicle == e.key;
            final rate = e.value['rate'] as double;
            return GestureDetector(
              onTap: () => setState(() => vehicle = e.key),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: AppColors.line))),
                child: Row(
                  children: [
                    Icon(e.value['icon'] as IconData,
                        color: sel ? AppColors.accent : AppColors.subtext,
                        size: 26),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('RideNow ${e.key}',
                              style: AppText.title.copyWith(
                                  color: sel
                                      ? AppColors.text
                                      : AppColors.text.withOpacity(0.85))),
                          Text('${e.value['eta']} away',
                              style: AppText.small),
                        ],
                      ),
                    ),
                    Text('Rs ${rate.toStringAsFixed(0)}/km',
                        style: AppText.meter.copyWith(
                            fontSize: 12.5, color: AppColors.subtext)),
                    const SizedBox(width: 12),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: sel ? AppColors.accent : AppColors.faint,
                            width: 2),
                      ),
                      child: sel
                          ? const Center(
                              child: Dot(AppColors.accent, size: 8))
                          : null,
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
          if (hasRoute)
            Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Eyebrow('Fare estimate'),
                  Money(estimateFare(), size: 24, color: AppColors.text),
                ],
              ),
            ),
          GradientButton(
              label: 'Request RideNow $vehicle',
              onTap: confirmBooking),
        ],
      ),
    );
  }
}
