import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class NavItem {
  final IconData icon;
  final String label;
  final int badge;
  const NavItem(this.icon, this.label, {this.badge = 0});
}

/// Minimal bottom navigation — icon + tiny label, gold on active,
/// a 3px gold marker above the active item. Hairline top border.
class BottomBar extends StatelessWidget {
  final List<NavItem> items;
  final int index;
  final ValueChanged<int> onTap;
  const BottomBar(
      {super.key,
      required this.items,
      required this.index,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(items.length, (i) {
              final it = items[i];
              final sel = i == index;
              final color = sel ? AppColors.ink : AppColors.faint;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 3,
                        child: sel
                            ? Center(
                                child: Container(
                                    width: 18,
                                    height: 3,
                                    decoration: BoxDecoration(
                                        color: AppColors.accent,
                                        borderRadius:
                                            BorderRadius.circular(2))))
                            : null,
                      ),
                      const SizedBox(height: 9),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(it.icon, color: color, size: 23),
                          if (it.badge > 0)
                            Positioned(
                              right: -7,
                              top: -5,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                    color: AppColors.danger,
                                    shape: BoxShape.circle),
                                constraints: const BoxConstraints(
                                    minWidth: 16, minHeight: 16),
                                child: Text('${it.badge}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800)),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(it.label,
                          style: TextStyle(
                              color: color,
                              fontSize: 10.5,
                              fontWeight:
                                  sel ? FontWeight.w700 : FontWeight.w500,
                              letterSpacing: 0.2)),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
