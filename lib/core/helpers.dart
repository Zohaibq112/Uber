import 'package:flutter/material.dart';
import 'app_theme.dart';

Color statusColor(String status) {
  switch (status) {
    case 'Completed':
      return AppColors.trust;
    case 'Accepted':
      return const Color(0xFF3B82F6);
    case 'Cancelled':
      return AppColors.danger;
    default:
      return AppColors.accent2; // Pending
  }
}

void showSnack(BuildContext context, String msg, {bool error = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Row(children: [
        Icon(error ? Icons.error_outline : Icons.check_circle,
            color: error ? Colors.white : AppColors.trust, size: 19),
        const SizedBox(width: 10),
        Expanded(
            child: Text(msg,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5))),
      ]),
      backgroundColor: error ? AppColors.danger : AppColors.ink,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      elevation: 0,
      duration: const Duration(seconds: 2),
    ));
}

/// Primary action — solid ink (black), white label. (Name kept stable.)
class GradientButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool loading;
  const GradientButton(
      {super.key,
      required this.label,
      this.icon,
      this.onTap,
      this.loading = false});
  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  double _s = 1;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _s = 0.98),
      onTapUp: (_) => setState(() => _s = 1),
      onTapCancel: () => setState(() => _s = 1),
      onTap: widget.loading ? null : widget.onTap,
      child: AnimatedScale(
        scale: _s,
        duration: const Duration(milliseconds: 110),
        child: Container(
          height: 54,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.ink,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: widget.loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.2, color: Colors.white))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                      ],
                      Text(widget.label,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Secondary — outlined, no fill.
class GhostButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final VoidCallback? onTap;
  const GhostButton(
      {super.key,
      required this.label,
      this.icon,
      this.color = AppColors.text,
      this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.line, width: 1.4),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label,
                  style: TextStyle(
                      color: color,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class Eyebrow extends StatelessWidget {
  final String text;
  const Eyebrow(this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 14, height: 2, color: AppColors.accent),
      const SizedBox(width: 8),
      Text(text.toUpperCase(), style: AppText.eyebrow),
    ]);
  }
}

class Money extends StatelessWidget {
  final num amount;
  final double size;
  final Color color;
  const Money(this.amount,
      {super.key, this.size = 15, this.color = AppColors.text});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text('Rs',
          style: TextStyle(
              color: color.withOpacity(0.5),
              fontSize: size * 0.62,
              fontWeight: FontWeight.w600)),
      const SizedBox(width: 3),
      Text(amount.toStringAsFixed(0),
          style: AppText.meter.copyWith(color: color, fontSize: size)),
    ]);
  }
}

class Dot extends StatelessWidget {
  final Color color;
  final double size;
  const Dot(this.color, {super.key, this.size = 8});
  @override
  Widget build(BuildContext context) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle));
}

/// Trust signal: a green verified pill.
class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.trust.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.verified, size: 13, color: AppColors.trust),
        const SizedBox(width: 4),
        Text('Verified',
            style: TextStyle(
                color: AppColors.trust,
                fontSize: 11,
                fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

/// Trust signal: a star rating.
class Rating extends StatelessWidget {
  final double value;
  const Rating(this.value, {super.key});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.star_rounded, size: 15, color: AppColors.accent),
      const SizedBox(width: 3),
      Text(value.toStringAsFixed(1),
          style: const TextStyle(
              color: AppColors.text,
              fontSize: 12.5,
              fontWeight: FontWeight.w700)),
    ]);
  }
}
