import 'package:flutter/material.dart';
import 'package:nutilog/utils/helper_function.dart';
import '../colors.dart';

// ─── BOTTOM NAVIGATION BAR ────────────────────────────────────────────────────
class BottomNav extends StatelessWidget {
  final int current;
  final ValueChanged<int> onTap;
  const BottomNav({super.key, required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HelperFunction.colorWithOpacity(AppColors.bg, 0.95),
        border: Border(
          top: BorderSide(
            color: HelperFunction.colorWithOpacity(Colors.black, 0.06),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _NavItem(
                icon: '⊙',
                label: 'Today',
                active: current == 0,
                onTap: () => onTap(0),
              ),
              Transform.translate(
                offset: const Offset(0, -10),
                child: GestureDetector(
                  onTap: () => onTap(1),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.greenLight, AppColors.greenDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: HelperFunction.colorWithOpacity(
                            AppColors.greenDark,
                            0.4,
                          ),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        '+',
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _NavItem(
                icon: '◈',
                label: 'Stats',
                active: current == 2,
                onTap: () => onTap(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String icon, label;
  final bool active;
  final VoidCallback onTap;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.dark : AppColors.mutedLight;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: TextStyle(fontSize: 22, color: color)),
            const SizedBox(height: 3),
            Text(
              label,
              style: interTight(
                size: 10,
                weight: FontWeight.w700,
                color: color,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
