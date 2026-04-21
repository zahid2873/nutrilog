// import 'package:flutter/material.dart';
// import 'package:nutilog/utils/helper_function.dart';
// import '../colors.dart';

// // ─── DEFICIT BADGE ────────────────────────────────────────────────────────────
// class DeficitBadge extends StatelessWidget {
//   final int consumed, goalCal;
//   const DeficitBadge({
//     super.key,
//     required this.consumed,
//     required this.goalCal,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final diff = consumed - goalCal;
//     final isDeficit = diff < 0;
//     final isSurplus = diff > 0;
//     final abs = diff.abs();

//     final color = isDeficit
//         ? AppColors.green
//         : isSurplus
//         ? AppColors.red
//         : AppColors.orange;
//     final bg = isDeficit
//         ? AppColors.greenBg
//         : isSurplus
//         ? AppColors.redBg
//         : AppColors.orangeBg;
//     final icon = isDeficit
//         ? '📉'
//         : isSurplus
//         ? '📈'
//         : '⚖️';
//     final label = isDeficit
//         ? 'DEFICIT'
//         : isSurplus
//         ? 'SURPLUS'
//         : 'ON TRACK';
//     final msg = isDeficit
//         ? '$abs kcal below goal — great progress!'
//         : isSurplus
//         ? '$abs kcal above goal — dial it back'
//         : 'Perfect — right on your goal!';

//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(
//           color: HelperFunction.colorWithOpacity(color, 0.2),
//           width: 1.5,
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 44,
//             height: 44,
//             decoration: BoxDecoration(
//               color: color,
//               borderRadius: BorderRadius.circular(14),
//               boxShadow: [
//                 BoxShadow(
//                   color: HelperFunction.colorWithOpacity(color, 0.35),
//                   blurRadius: 14,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Center(
//               child: Text(icon, style: const TextStyle(fontSize: 22)),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       label,
//                       style: interTight(
//                         size: 13,
//                         weight: FontWeight.w800,
//                         color: color,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     if (abs > 0)
//                       Text(
//                         '$abs kcal',
//                         style: interTight(
//                           size: 16,
//                           weight: FontWeight.w800,
//                           color: color,
//                         ),
//                       ),
//                   ],
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   msg,
//                   style: interTight(size: 12, color: const Color(0xFF7A7060)),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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

    // ── Contextual message based on magnitude ──
    final String msg;
    if (isDeficit) {
      if (abs <= 100) {
        msg = 'Almost there — just $abs kcal shy of your goal';
      } else if (abs <= 300) {
        msg = 'Good restraint — $abs kcal under your target';
      } else if (abs <= 600) {
        msg = 'Solid deficit — you\'re burning through it today';
      } else {
        msg = 'Big deficit — make sure you\'re eating enough';
      }
    } else if (isSurplus) {
      if (abs <= 100) {
        msg = 'Barely over — a short walk will sort this out';
      } else if (abs <= 300) {
        msg = 'Slightly over — ease up on the next meal';
      } else if (abs <= 600) {
        msg = '$abs kcal over — time to cut back for the day';
      } else {
        msg = 'Well over budget — skip the snacks tonight';
      }
    } else {
      msg = 'Spot on — you\'ve nailed your calorie goal today';
    }

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
