import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../core/app_theme.dart';

/// Real interactive map via flutter_map + OpenStreetMap tiles.
/// No API key, no billing. Needs internet at runtime to load tiles.
/// Shows a demo pickup→drop route around the Islamabad/Rawalpindi area.
class MapPreview extends StatelessWidget {
  final double height;
  const MapPreview({super.key, this.height = 200});

  @override
  Widget build(BuildContext context) {
    // Demo coordinates (Rawalpindi -> Islamabad).
    final pickup = const LatLng(33.5973, 73.0479); // Saddar, Rawalpindi
    final drop = const LatLng(33.7180, 73.0560); // F-7, Islamabad
    final mid = LatLng(
      (pickup.latitude + drop.latitude) / 2,
      (pickup.longitude + drop.longitude) / 2,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.line),
        ),
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: mid,
                initialZoom: 12.2,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.ridenow.app',
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [pickup, const LatLng(33.6450, 73.0500), drop],
                      strokeWidth: 4,
                      color: AppColors.ink,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: pickup,
                      width: 26,
                      height: 26,
                      child: _pin(AppColors.trust),
                    ),
                    Marker(
                      point: drop,
                      width: 26,
                      height: 26,
                      child: _pin(AppColors.danger),
                    ),
                  ],
                ),
              ],
            ),
            // Floating ETA chip
            Positioned(
              left: 12,
              top: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: AppDeco.cardShadow,
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                          color: AppColors.trust, shape: BoxShape.circle)),
                  const SizedBox(width: 7),
                  const Text('3 drivers nearby',
                      style: TextStyle(
                          color: AppColors.ink,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pin(Color color) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 4),
          boxShadow: AppDeco.cardShadow,
        ),
      );
}
