import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../core/data_store.dart';
import '../../core/helpers.dart';

class BookRideTab extends StatefulWidget {
  final Map<String, dynamic> user;
  const BookRideTab({super.key, required this.user});
  @override
  State<BookRideTab> createState() => _BookRideTabState();
}

class _BookRideTabState extends State<BookRideTab> {
  final pickupC = TextEditingController();
  final dropC = TextEditingController();
  String vehicle = 'RideNow Mini';

  static const vehicles = {
    'RideNow Mini': {'icon': Icons.directions_car, 'rate': 30.0, 'eta': '3 min'},
    'RideNow Go': {'icon': Icons.local_taxi, 'rate': 45.0, 'eta': '5 min'},
    'RideNow Premium': {
      'icon': Icons.airport_shuttle,
      'rate': 70.0,
      'eta': '7 min'
    },
    'RideNow Bike': {'icon': Icons.two_wheeler, 'rate': 15.0, 'eta': '2 min'},
  };

  double estimateFare() {
    final rate = vehicles[vehicle]!['rate'] as double;
    final dist = ((pickupC.text.length + dropC.text.length) % 12) + 3;
    return 100 + rate * dist;
  }

  void confirmBooking() {
    if (pickupC.text.trim().isEmpty || dropC.text.trim().isEmpty) {
      showSnack(context, 'Enter pickup and drop-off locations', error: true);
      return;
    }
    final fare = estimateFare();
    DataStore.bookRide({
      'userId': widget.user['id'],
      'pickup': pickupC.text.trim(),
      'dropoff': dropC.text.trim(),
      'vehicle': vehicle,
      'fare': fare,
      'status': 'Pending',
      'createdAt': DateTime.now().toString().substring(0, 16),
    });
    pickupC.clear();
    dropC.clear();
    setState(() {});
    showSnack(context, 'Ride booked! Fare: Rs ${fare.toStringAsFixed(0)}');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hello, ${widget.user['name']} 👋',
                          style: AppText.h2),
                      const Text('Where are you going today?',
                          style: AppText.muted),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.accent.withOpacity(0.15),
                  child: Text(
                      widget.user['name'].toString()[0].toUpperCase(),
                      style: const TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w800,
                          fontSize: 20)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            GlassCard(
              child: Column(
                children: [
                  _locField(pickupC, 'Pickup location', Icons.my_location,
                      AppColors.accent),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Divider(color: Colors.white.withOpacity(0.06)),
                  ),
                  _locField(dropC, 'Drop-off location', Icons.location_on,
                      AppColors.danger),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Choose your ride', style: AppText.title),
            const SizedBox(height: 14),
            ...vehicles.entries.map((e) {
              final selected = vehicle == e.key;
              final rate = e.value['rate'] as double;
              return GestureDetector(
                onTap: () => setState(() => vehicle = e.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.cardHi : AppColors.card,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                        color: selected
                            ? AppColors.accent
                            : Colors.white.withOpacity(0.04),
                        width: 1.6),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.accent.withOpacity(0.15)
                              : AppColors.bgSoft,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(e.value['icon'] as IconData,
                            color: selected
                                ? AppColors.accent
                                : AppColors.subtext,
                            size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.key,
                                style: TextStyle(
                                    color: AppColors.text,
                                    fontWeight: selected
                                        ? FontWeight.w700
                                        : FontWeight.w500)),
                            Text('${e.value['eta']} away',
                                style: AppText.muted),
                          ],
                        ),
                      ),
                      Text('Rs ${rate.toStringAsFixed(0)}/km',
                          style: const TextStyle(
                              color: AppColors.subtext,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            // Fare estimate bar
            if (pickupC.text.isNotEmpty && dropC.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Estimated fare', style: AppText.muted),
                    Text('Rs ${estimateFare().toStringAsFixed(0)}',
                        style: const TextStyle(
                            color: AppColors.accent,
                            fontSize: 20,
                            fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            GradientButton(
                label: 'Confirm Booking',
                icon: Icons.check_circle_outline,
                onTap: confirmBooking),
          ],
        ),
      ),
    );
  }

  Widget _locField(
      TextEditingController c, String hint, IconData icon, Color color) {
    return TextField(
      controller: c,
      style: AppText.body,
      onChanged: (_) => setState(() {}), // live fare update
      decoration: InputDecoration(
        hintText: hint,
        filled: false,
        prefixIcon: Icon(icon, color: color),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
      ),
    );
  }
}
