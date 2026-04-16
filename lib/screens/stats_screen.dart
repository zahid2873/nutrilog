// import 'dart:math';
// import 'package:flutter/material.dart';
// import '../colors.dart';
// import '../state/app_state.dart';
// import '../provider/change_notifier_provider.dart';
// import '../widgets/deficit_badge.dart';

// // ─── STATS SCREEN ─────────────────────────────────────────────────────────────
// class StatsScreen extends StatelessWidget {
//   const StatsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AppState>(
//       builder: (ctx, state, _) {
//         final total = state.totalCalories;
//         final goal = state.profile.goalCalories;

//         final weekData = [
//           (1820, 'Mon'),
//           (2100, 'Tue'),
//           (1650, 'Wed'),
//           (1980, 'Thu'),
//           (2200, 'Fri'),
//           (1750, 'Sat'),
//           (total, 'Sun'),
//         ];
//         final maxCal = weekData.map((d) => d.$1).reduce(max);

//         final macros = [
//           (
//             '🥩',
//             'Protein',
//             state.totalProtein,
//             (state.profile.weight * 1.8).round(),
//             AppColors.red,
//           ),
//           (
//             '🌾',
//             'Carbs',
//             state.totalCarbs,
//             ((goal * 0.45) / 4).round(),
//             AppColors.orange,
//           ),
//           (
//             '🥑',
//             'Fat',
//             state.totalFat,
//             ((goal * 0.25) / 9).round(),
//             AppColors.purple,
//           ),
//           ('🥦', 'Fiber', 18, 25, AppColors.green),
//         ];

//         return Scaffold(
//           backgroundColor: AppColors.bg,
//           body: SafeArea(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 12),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 4),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'OVERVIEW',
//                           style: interTight(
//                             size: 11,
//                             weight: FontWeight.w700,
//                             color: AppColors.muted,
//                             letterSpacing: 1.5,
//                           ),
//                         ),
//                         const SizedBox(height: 2),
//                         Text(
//                           'Weekly Stats',
//                           style: interTight(size: 22, weight: FontWeight.w800),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 12),

//                   DeficitBadge(consumed: total.toInt(), goalCal: goal),
//                   const SizedBox(height: 10),

//                   // Bar chart card
//                   Container(
//                     padding: const EdgeInsets.all(18),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(22),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.06),
//                           blurRadius: 20,
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'This week',
//                               style: interTight(
//                                 size: 14,
//                                 weight: FontWeight.w800,
//                               ),
//                             ),
//                             Text(
//                               'goal: $goal kcal',
//                               style: interTight(
//                                 size: 11,
//                                 color: AppColors.muted,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         SizedBox(
//                           height: 120,
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: weekData.asMap().entries.map((entry) {
//                               final isToday = entry.key == 6;
//                               final cal = entry.value.$1;
//                               final day = entry.value.$2;
//                               final barH = maxCal > 0
//                                   ? (cal / maxCal * 80).clamp(4.0, 80.0)
//                                   : 4.0;
//                               final over = cal > goal;
//                               return Expanded(
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 3,
//                                   ),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       if (isToday || over)
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                             bottom: 3,
//                                           ),
//                                           child: Text(
//                                             '$cal',
//                                             style: interTight(
//                                               size: 8,
//                                               weight: FontWeight.w700,
//                                               color: isToday
//                                                   ? AppColors.green
//                                                   : AppColors.red,
//                                             ),
//                                           ),
//                                         ),
//                                       AnimatedContainer(
//                                         duration: const Duration(
//                                           milliseconds: 800,
//                                         ),
//                                         curve: Curves.easeOutBack,
//                                         height: barH,
//                                         decoration: BoxDecoration(
//                                           gradient: LinearGradient(
//                                             colors: over
//                                                 ? [
//                                                     AppColors.red,
//                                                     const Color(0xFFC04060),
//                                                   ]
//                                                 : isToday
//                                                 ? [
//                                                     AppColors.greenLight,
//                                                     AppColors.greenDark,
//                                                   ]
//                                                 : [
//                                                     const Color(0xFFD4CFC8),
//                                                     AppColors.greenLight,
//                                                   ],
//                                             begin: Alignment.topCenter,
//                                             end: Alignment.bottomCenter,
//                                           ),
//                                           borderRadius: BorderRadius.circular(
//                                             7,
//                                           ),
//                                           boxShadow: isToday
//                                               ? [
//                                                   BoxShadow(
//                                                     color: AppColors.greenDark
//                                                         .withOpacity(0.3),
//                                                     blurRadius: 12,
//                                                     offset: const Offset(0, 4),
//                                                   ),
//                                                 ]
//                                               : null,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 6),
//                                       Text(
//                                         day,
//                                         style: interTight(
//                                           size: 10,
//                                           weight: isToday
//                                               ? FontWeight.w700
//                                               : FontWeight.w400,
//                                           color: isToday
//                                               ? AppColors.green
//                                               : AppColors.mutedLight,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Divider(color: AppColors.border),
//                         const SizedBox(height: 6),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               '🟢 under  🔴 over',
//                               style: interTight(
//                                 size: 10,
//                                 color: AppColors.mutedLight,
//                               ),
//                             ),
//                             Text(
//                               '4/7 on track ✓',
//                               style: interTight(
//                                 size: 10,
//                                 weight: FontWeight.w700,
//                                 color: AppColors.green,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 10),

//                   // Summary grid
//                   GridView.count(
//                     crossAxisCount: 2,
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     mainAxisSpacing: 8,
//                     crossAxisSpacing: 8,
//                     childAspectRatio: 1.7,
//                     children: [
//                       _statCard(
//                         'Streak',
//                         '5 🔥',
//                         'days logged',
//                         AppColors.orange,
//                         AppColors.orangeBg,
//                       ),
//                       _statCard(
//                         'Best Streak',
//                         '12 ⭐',
//                         'personal record',
//                         AppColors.purple,
//                         AppColors.purpleBg,
//                       ),
//                       _statCard(
//                         'Avg Daily',
//                         '1,831',
//                         'kcal this week',
//                         AppColors.green,
//                         AppColors.greenBg,
//                       ),
//                       _statCard(
//                         'Total Meals',
//                         '${state.entries.length}',
//                         'logged today',
//                         AppColors.red,
//                         AppColors.redBg,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),

//                   // Macro breakdown
//                   Container(
//                     padding: const EdgeInsets.all(18),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(22),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.06),
//                           blurRadius: 20,
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Today's Macros",
//                           style: interTight(size: 14, weight: FontWeight.w800),
//                         ),
//                         const SizedBox(height: 16),
//                         ...macros.map(
//                           (m) => Padding(
//                             padding: const EdgeInsets.only(bottom: 14),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Text(
//                                       m.$1,
//                                       style: const TextStyle(fontSize: 14),
//                                     ),
//                                     const SizedBox(width: 6),
//                                     Text(
//                                       m.$2,
//                                       style: interTight(
//                                         size: 13,
//                                         weight: FontWeight.w700,
//                                       ),
//                                     ),
//                                     const Spacer(),
//                                     Text(
//                                       '${m.$3}g / ${m.$4}g',
//                                       style: interTight(
//                                         size: 12,
//                                         weight: FontWeight.w500,
//                                         color: AppColors.muted,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 5),
//                                 Container(
//                                   height: 7,
//                                   decoration: BoxDecoration(
//                                     color: AppColors.inputBg,
//                                     borderRadius: BorderRadius.circular(4),
//                                   ),
//                                   child: FractionallySizedBox(
//                                     alignment: Alignment.centerLeft,
//                                     widthFactor: m.$4 > 0
//                                         ? (m.$3 / m.$4).clamp(0.0, 1.0)
//                                         : 0.0,
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         color: m.$5,
//                                         borderRadius: BorderRadius.circular(4),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: m.$5.withOpacity(0.5),
//                                             blurRadius: 6,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _statCard(
//     String label,
//     String val,
//     String sub,
//     Color color,
//     Color bg,
//   ) => Container(
//     padding: const EdgeInsets.all(14),
//     decoration: BoxDecoration(
//       color: bg,
//       borderRadius: BorderRadius.circular(18),
//       border: Border.all(color: color.withOpacity(0.15)),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           label.toUpperCase(),
//           style: interTight(
//             size: 10,
//             weight: FontWeight.w700,
//             color: AppColors.muted,
//             letterSpacing: 0.8,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(val, style: interTight(size: 22, weight: FontWeight.w800)),
//         const SizedBox(height: 2),
//         Text(
//           sub,
//           style: interTight(size: 11, weight: FontWeight.w500, color: color),
//         ),
//       ],
//     ),
//   );
// }

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nutilog/utils/helper_function.dart';
import '../colors.dart';
import '../models/food_entry.dart';
import '../state/app_state.dart';
import '../provider/change_notifier_provider.dart';
import '../widgets/deficit_badge.dart';

// ─── STATS SCREEN ─────────────────────────────────────────────────────────────
class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  // Real weekly data loaded from storage
  List<(int calories, String day, DateTime date)> _weekData = [];
  bool _loadingWeek = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadWeek();
  }

  Future<void> _loadWeek() async {
    final allEntries = await FoodEntry.loadAll();
    final today = DateTime.now();

    final data = List.generate(7, (i) {
      final date = today.subtract(Duration(days: 6 - i));
      final key =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final dayEntries = allEntries[key] ?? [];
      final cals = dayEntries.fold(0.0, (s, e) => s + e.calories).toInt();
      final label = [
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
        'Sun',
      ][date.weekday - 1];
      return (cals, label, date);
    });

    //  if (mounted)
    setState(() {
      _weekData = data;
      _loadingWeek = false;
    });
  }

  // ── streak helpers ─────────────────────────────────────────────────────────
  int _calcStreak(Map<String, List<FoodEntry>> all) {
    int streak = 0;
    final today = DateTime.now();
    for (int i = 0; i < 365; i++) {
      final d = today.subtract(Duration(days: i));
      final key =
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      if ((all[key]?.isNotEmpty) ?? false) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  int _calcBestStreak(Map<String, List<FoodEntry>> all) {
    final dates = all.keys.toList()..sort();
    int best = 0, current = 0;
    DateTime? prev;
    for (final key in dates) {
      if (all[key]?.isEmpty ?? true) continue;
      final parts = key.split('-').map(int.parse).toList();
      final d = DateTime(parts[0], parts[1], parts[2]);
      if (prev != null && d.difference(prev).inDays == 1) {
        current++;
      } else {
        current = 1;
      }
      if (current > best) best = current;
      prev = d;
    }
    return best;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (ctx, state, _) {
        final total = state.totalCalories;
        final goal = state.profile.goalCalories;

        // ── week stats ──────────────────────────────────────────────────────────
        final maxCal = _weekData.isEmpty
            ? 1
            : _weekData.map((d) => d.$1).reduce(max).clamp(1, 99999);

        final weekAvg = _weekData.isEmpty
            ? 0
            : (_weekData.map((d) => d.$1).reduce((a, b) => a + b) /
                      _weekData.where((d) => d.$1 > 0).length.clamp(1, 7))
                  .round();

        final onTrackCount = _weekData
            .where((d) => d.$1 > 0 && d.$1 <= goal)
            .length;

        // ── macro targets ───────────────────────────────────────────────────────
        final macros = [
          (
            '🥩',
            'Protein',
            state.totalProtein.toInt(),
            (state.profile.weight * 1.8).round(),
            AppColors.red,
          ),
          (
            '🌾',
            'Carbs',
            state.totalCarbs.toInt(),
            ((goal * 0.45) / 4).round(),
            AppColors.orange,
          ),
          (
            '🥑',
            'Fat',
            state.totalFat.toInt(),
            ((goal * 0.25) / 9).round(),
            AppColors.purple,
          ),
          // ('🥦', 'Fiber', 18, 25, AppColors.green),
        ];

        return Scaffold(
          backgroundColor: AppColors.bg,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: _loadWeek,
              color: AppColors.green,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // ── header ──────────────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'OVERVIEW',
                            style: interTight(
                              size: 11,
                              weight: FontWeight.w700,
                              color: AppColors.muted,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Weekly Stats',
                            style: interTight(
                              size: 22,
                              weight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── deficit badge (today) ────────────────────────────────────
                    DeficitBadge(consumed: total.toInt(), goalCal: goal),
                    const SizedBox(height: 10),

                    // ── bar chart ────────────────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: HelperFunction.colorWithOpacity(
                              Colors.black,
                              0.06,
                            ),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'This week',
                                style: interTight(
                                  size: 14,
                                  weight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                'goal: $goal kcal',
                                style: interTight(
                                  size: 11,
                                  color: AppColors.muted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          _loadingWeek
                              ? const SizedBox(
                                  height: 120,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.green,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 120,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: _weekData.asMap().entries.map((
                                      entry,
                                    ) {
                                      final isToday = entry.key == 6;
                                      final cal = entry.value.$1;
                                      final day = entry.value.$2;
                                      final barH = cal == 0
                                          ? 4.0
                                          : (cal / maxCal * 80).clamp(
                                              4.0,
                                              80.0,
                                            );
                                      final over = cal > goal;
                                      final isEmpty = cal == 0;

                                      return Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 3,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              // calorie label above bar
                                              if (cal > 0)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 3,
                                                      ),
                                                  child: Text(
                                                    '$cal',
                                                    style: interTight(
                                                      size: 8,
                                                      weight: FontWeight.w700,
                                                      color: isToday
                                                          ? AppColors.green
                                                          : over
                                                          ? AppColors.red
                                                          : AppColors
                                                                .mutedLight,
                                                    ),
                                                  ),
                                                ),
                                              AnimatedContainer(
                                                duration: const Duration(
                                                  milliseconds: 800,
                                                ),
                                                curve: Curves.easeOutBack,
                                                height: barH,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: isEmpty
                                                        ? [
                                                            AppColors.inputBg,
                                                            AppColors.inputBg,
                                                          ]
                                                        : over
                                                        ? [
                                                            AppColors.red,
                                                            const Color(
                                                              0xFFC04060,
                                                            ),
                                                          ]
                                                        : isToday
                                                        ? [
                                                            AppColors
                                                                .greenLight,
                                                            AppColors.greenDark,
                                                          ]
                                                        : [
                                                            const Color(
                                                              0xFFD4CFC8,
                                                            ),
                                                            AppColors
                                                                .greenLight,
                                                          ],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                  boxShadow: isToday
                                                      ? [
                                                          BoxShadow(
                                                            color:
                                                                HelperFunction.colorWithOpacity(
                                                                  AppColors
                                                                      .greenDark,
                                                                  0.3,
                                                                ),
                                                            blurRadius: 12,
                                                            offset:
                                                                const Offset(
                                                                  0,
                                                                  4,
                                                                ),
                                                          ),
                                                        ]
                                                      : null,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                day,
                                                style: interTight(
                                                  size: 10,
                                                  weight: isToday
                                                      ? FontWeight.w700
                                                      : FontWeight.w400,
                                                  color: isToday
                                                      ? AppColors.green
                                                      : AppColors.mutedLight,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),

                          const SizedBox(height: 10),
                          Divider(color: AppColors.border),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '🟢 under  🔴 over',
                                style: interTight(
                                  size: 10,
                                  color: AppColors.mutedLight,
                                ),
                              ),
                              Text(
                                '$onTrackCount/7 on track ✓',
                                style: interTight(
                                  size: 10,
                                  weight: FontWeight.w700,
                                  color: AppColors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ── stat grid (real data) ────────────────────────────────────
                    FutureBuilder<Map<String, List<FoodEntry>>>(
                      future: FoodEntry.loadAll(),
                      builder: (ctx, snap) {
                        final all = snap.data ?? {};
                        final streak = _calcStreak(all);
                        final best = _calcBestStreak(all);
                        final avg = weekAvg;

                        return GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 1.7,
                          children: [
                            _statCard(
                              'Streak',
                              '$streak 🔥',
                              'days logged',
                              AppColors.orange,
                              AppColors.orangeBg,
                            ),
                            _statCard(
                              'Best Streak',
                              '$best ⭐',
                              'personal record',
                              AppColors.purple,
                              AppColors.purpleBg,
                            ),
                            _statCard(
                              'Avg Daily',
                              avg > 0 ? _fmt(avg) : '—',
                              'kcal this week',
                              AppColors.green,
                              AppColors.greenBg,
                            ),
                            _statCard(
                              'Total Meals',
                              '${state.entries.length}',
                              'logged today',
                              AppColors.red,
                              AppColors.redBg,
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 10),

                    // ── macro breakdown ──────────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: HelperFunction.colorWithOpacity(
                              Colors.black,
                              0.06,
                            ),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Today's Macros",
                            style: interTight(
                              size: 14,
                              weight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...macros.map(
                            (m) => Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        m.$1,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        m.$2,
                                        style: interTight(
                                          size: 13,
                                          weight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 7,
                                          decoration: BoxDecoration(
                                            //color: AppColors.inputBg,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: FractionallySizedBox(
                                            alignment: Alignment.centerLeft,
                                            widthFactor: m.$4 > 0
                                                ? (m.$3 / m.$4).clamp(0.0, 1.0)
                                                : 0.0,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: m.$5,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                        HelperFunction.colorWithOpacity(
                                                          m.$5,
                                                          0.5,
                                                        ),
                                                    blurRadius: 6,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // const Spacer(),
                                      const SizedBox(width: 10),
                                      Text(
                                        '${m.$3}g / ${m.$4}g',
                                        style: interTight(
                                          size: 12,
                                          weight: FontWeight.w500,
                                          color: AppColors.muted,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  // Container(
                                  //   height: 7,
                                  //   //width: 20,
                                  //   decoration: BoxDecoration(
                                  //     color: AppColors.inputBg,
                                  //     borderRadius: BorderRadius.circular(4),
                                  //   ),
                                  //   child: FractionallySizedBox(
                                  //     alignment: Alignment.centerLeft,
                                  //     widthFactor: m.$4 > 0
                                  //         ? (m.$3 / m.$4).clamp(0.0, 1.0)
                                  //         : 0.0,
                                  //     child: Container(
                                  //       decoration: BoxDecoration(
                                  //         color: m.$5,
                                  //         borderRadius: BorderRadius.circular(
                                  //           4,
                                  //         ),
                                  //         boxShadow: [
                                  //           BoxShadow(
                                  //             color:
                                  //                 HelperFunction.colorWithOpacity(
                                  //                   m.$5,
                                  //                   0.5,
                                  //                 ),
                                  //             blurRadius: 6,
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ── helpers ──────────────────────────────────────────────────────────────────
  String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';

  Widget _statCard(
    String label,
    String val,
    String sub,
    Color color,
    Color bg,
  ) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: HelperFunction.colorWithOpacity(color, 0.15)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label.toUpperCase(),
          style: interTight(
            size: 10,
            weight: FontWeight.w700,
            color: AppColors.muted,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 4),
        Text(val, style: interTight(size: 22, weight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(
          sub,
          style: interTight(size: 11, weight: FontWeight.w500, color: color),
        ),
      ],
    ),
  );
}
