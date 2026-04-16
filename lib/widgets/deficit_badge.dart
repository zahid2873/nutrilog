import 'package:flutter/material.dart';
import 'package:nutilog/utils/helper_function.dart';
import '../colors.dart';

// ─── DEFICIT BADGE ────────────────────────────────────────────────────────────
class DeficitBadge extends StatelessWidget {
  final int consumed, goalCal;
  const DeficitBadge({
    super.key,
    required this.consumed,
    required this.goalCal,
  });

  @override
  Widget build(BuildContext context) {
    final diff = consumed - goalCal;
    final isDeficit = diff < 0;
    final isSurplus = diff > 0;
    final abs = diff.abs();

    final color = isDeficit
        ? AppColors.green
        : isSurplus
        ? AppColors.red
        : AppColors.orange;
    final bg = isDeficit
        ? AppColors.greenBg
        : isSurplus
        ? AppColors.redBg
        : AppColors.orangeBg;
    final icon = isDeficit
        ? '📉'
        : isSurplus
        ? '📈'
        : '⚖️';
    final label = isDeficit
        ? 'DEFICIT'
        : isSurplus
        ? 'SURPLUS'
        : 'ON TRACK';
    final msg = isDeficit
        ? '$abs kcal below goal — great progress!'
        : isSurplus
        ? '$abs kcal above goal — dial it back'
        : 'Perfect — right on your goal!';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: HelperFunction.colorWithOpacity(color, 0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: HelperFunction.colorWithOpacity(color, 0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      label,
                      style: interTight(
                        size: 13,
                        weight: FontWeight.w800,
                        color: color,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (abs > 0)
                      Text(
                        '$abs kcal',
                        style: interTight(
                          size: 16,
                          weight: FontWeight.w800,
                          color: color,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  msg,
                  style: interTight(size: 12, color: const Color(0xFF7A7060)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
