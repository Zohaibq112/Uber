import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class PageHeader extends StatelessWidget {
  final String eyebrow;
  final String title;
  final Widget? trailing;
  final EdgeInsets padding;
  const PageHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    this.trailing,
    this.padding = const EdgeInsets.fromLTRB(20, 8, 20, 14),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(width: 14, height: 2, color: AppColors.accent),
                  const SizedBox(width: 8),
                  Text(eyebrow.toUpperCase(), style: AppText.eyebrow),
                ]),
                const SizedBox(height: 10),
                Text(title, style: AppText.h1),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Compatibility shim: older driver tabs call GradientHeader(icon,title,
/// subtitle,trailing). Render it as the quiet PageHeader.
class GradientHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? trailing;
  const GradientHeader(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.icon,
      this.trailing});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: PageHeader(
        eyebrow: subtitle,
        title: title,
        trailing: trailing,
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      ),
    );
  }
}
class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final int badge;
  const CircleIconButton(
      {super.key,
      required this.icon,
      required this.onTap,
      this.color = AppColors.text,
      this.badge = 0});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(clipBehavior: Clip.none, children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.line),
          ),
          child: Icon(icon, color: color, size: 19),
        ),
        if (badge > 0)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                  color: AppColors.danger, shape: BoxShape.circle),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text('$badge',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800)),
            ),
          ),
      ]),
    );
  }
}

/// Kept for compatibility (driver requests imported BellBadge).
class BellBadge extends StatelessWidget {
  final int count;
  final VoidCallback onTap;
  const BellBadge({super.key, required this.count, required this.onTap});
  @override
  Widget build(BuildContext context) => CircleIconButton(
      icon: Icons.notifications_none_rounded,
      onTap: onTap,
      color: AppColors.subtext,
      badge: count);
}
