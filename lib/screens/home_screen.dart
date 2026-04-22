// import 'dart:math';
// import 'package:flutter/material.dart';
// import '../colors.dart';
// import '../state/app_state.dart';
// import '../provider/change_notifier_provider.dart';
// import '../widgets/deficit_badge.dart';
// import '../widgets/calorie_ring_painter.dart';

// // ─── HOME SCREEN ──────────────────────────────────────────────────────────────
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   Color _mealDot(String meal) {
//     switch (meal) {
//       case 'Breakfast':
//         return AppColors.breakfastDot;
//       case 'Lunch':
//         return AppColors.lunchDot;
//       case 'Dinner':
//         return AppColors.dinnerDot;
//       default:
//         return AppColors.snackDot;
//     }
//   }

//   Color _mealBg(String meal) {
//     switch (meal) {
//       case 'Breakfast':
//         return AppColors.breakfastBg;
//       case 'Lunch':
//         return AppColors.lunchBg;
//       case 'Dinner':
//         return AppColors.dinnerBg;
//       default:
//         return AppColors.snackBg;
//     }
//   }

//   Color _mealText(String meal) {
//     switch (meal) {
//       case 'Breakfast':
//         return AppColors.breakfastText;
//       case 'Lunch':
//         return AppColors.lunchText;
//       case 'Dinner':
//         return AppColors.dinnerText;
//       default:
//         return AppColors.snackText;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AppState>(
//       builder: (ctx, state, _) {
//         final total = state.totalCalories;
//         final goal = state.profile.goalCalories;
//         final pct = goal > 0 ? total / goal : 0.0;
//         final over = total > goal;
//         final ringColor = over
//             ? AppColors.red
//             : pct > 0.85
//             ? AppColors.orange
//             : AppColors.green;

//         final mealGroups = ['Breakfast', 'Lunch', 'Dinner', 'Snack']
//             .map((m) {
//               final items = state.entries.where((e) => e.meal == m).toList();
//               return (
//                 m,
//                 items,
//                 items.fold(0, (s, e) => s + e.calories.toInt()),
//               );
//             })
//             .where((g) => g.$2.isNotEmpty)
//             .toList();

//         return Scaffold(
//           backgroundColor: AppColors.bg,
//           body: SafeArea(
//             child: CustomScrollView(
//               slivers: [
//                 // Header
//                 SliverToBoxAdapter(
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Good morning 🌿',
//                               style: interTight(
//                                 size: 12,
//                                 weight: FontWeight.w500,
//                                 color: AppColors.muted,
//                               ),
//                             ),
//                             Text(
//                               "Today's Log",
//                               style: interTight(
//                                 size: 22,
//                                 weight: FontWeight.w800,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Container(
//                           width: 40,
//                           height: 40,
//                           decoration: BoxDecoration(
//                             gradient: const LinearGradient(
//                               colors: [
//                                 AppColors.greenLight,
//                                 AppColors.greenDark,
//                               ],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                             borderRadius: BorderRadius.circular(13),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: AppColors.greenDark.withOpacity(0.35),
//                                 blurRadius: 12,
//                                 offset: const Offset(0, 4),
//                               ),
//                             ],
//                           ),
//                           child: const Center(
//                             child: Text('🌱', style: TextStyle(fontSize: 20)),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 // Calorie ring card
//                 SliverToBoxAdapter(
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
//                     child: Container(
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           colors: [AppColors.dark, AppColors.dark2],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         borderRadius: BorderRadius.circular(26),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.25),
//                             blurRadius: 40,
//                             offset: const Offset(0, 12),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Consumed',
//                                   style: interTight(
//                                     size: 11,
//                                     weight: FontWeight.w600,
//                                     color: const Color(0xFF5A5040),
//                                     letterSpacing: 1.2,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   '$total',
//                                   style: interTight(
//                                     size: 44,
//                                     weight: FontWeight.w800,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 Text(
//                                   'of $goal kcal goal',
//                                   style: interTight(
//                                     size: 13,
//                                     color: const Color(0xFF7A7060),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 14),
//                                 Row(
//                                   children: [
//                                     _darkStatCard(
//                                       '${max(goal - total, 0)}',
//                                       'Remaining',
//                                       AppColors.greenLight,
//                                     ),
//                                     const SizedBox(width: 8),
//                                     _darkStatCard(
//                                       '320',
//                                       'Burned',
//                                       AppColors.orange,
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             width: 110,
//                             height: 110,
//                             child: TweenAnimationBuilder<double>(
//                               tween: Tween(
//                                 begin: 0,
//                                 end: pct.clamp(0, 1.2).toDouble(),
//                               ),
//                               duration: const Duration(milliseconds: 1200),
//                               curve: Curves.easeOutBack,
//                               builder: (ctx, v, _) => CustomPaint(
//                                 painter: CalorieRingPainter(v, ringColor),
//                                 child: Center(
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         '${(min(pct, 1.0) * 100).round()}%',
//                                         style: interTight(
//                                           size: 22,
//                                           weight: FontWeight.w800,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                       Text(
//                                         'of goal',
//                                         style: interTight(
//                                           size: 11,
//                                           color: const Color(0xFF5A5040),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),

//                 // Deficit badge
//                 SliverToBoxAdapter(
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
//                     child: DeficitBadge(consumed: total, goalCal: goal),
//                   ),
//                 ),

//                 // Macro row
//                 SliverToBoxAdapter(
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
//                     child: Row(
//                       children: [
//                         _macroMiniCard(
//                           '🥩',
//                           'Protein',
//                           state.totalProtein,
//                           (state.profile.weight *
//                                   proteinPerKg(state.profile.goal))
//                               .round(),
//                           AppColors.red,
//                         ),
//                         const SizedBox(width: 8),
//                         _macroMiniCard(
//                           '🌾',
//                           'Carbs',
//                           state.totalCarbs,
//                           ((goal * 0.45) / 4).round(),
//                           AppColors.orange,
//                         ),
//                         const SizedBox(width: 8),
//                         _macroMiniCard(
//                           '🥑',
//                           'Fat',
//                           state.totalFat,
//                           ((goal * 0.25) / 9).round(),
//                           AppColors.purple,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 // Meals header
//                 SliverToBoxAdapter(
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//                     child: Text(
//                       "Today's Meals",
//                       style: interTight(size: 15, weight: FontWeight.w800),
//                     ),
//                   ),
//                 ),

//                 // Empty state
//                 if (mealGroups.isEmpty)
//                   SliverToBoxAdapter(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 40),
//                       child: Column(
//                         children: [
//                           const Text('🍽️', style: TextStyle(fontSize: 32)),
//                           const SizedBox(height: 8),
//                           Text(
//                             'No meals yet — tap + to log your first meal',
//                             style: interTight(
//                               size: 13,
//                               color: AppColors.mutedLight,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                 // Meal groups
//                 for (final group in mealGroups) ...[
//                   SliverToBoxAdapter(
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
//                       child: Row(
//                         children: [
//                           Container(
//                             width: 7,
//                             height: 7,
//                             decoration: BoxDecoration(
//                               color: _mealDot(group.$1),
//                               shape: BoxShape.circle,
//                             ),
//                           ),
//                           const SizedBox(width: 6),
//                           Text(
//                             group.$1.toUpperCase(),
//                             style: interTight(
//                               size: 11,
//                               weight: FontWeight.w700,
//                               color: AppColors.muted,
//                               letterSpacing: 0.8,
//                             ),
//                           ),
//                           const Spacer(),
//                           Text(
//                             '${group.$3} kcal',
//                             style: interTight(
//                               size: 11,
//                               weight: FontWeight.w600,
//                               color: AppColors.muted,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SliverList(
//                     delegate: SliverChildBuilderDelegate((ctx, i) {
//                       final entry = group.$2[i];
//                       return Padding(
//                         padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 14,
//                             vertical: 12,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(16),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
//                                 blurRadius: 8,
//                               ),
//                             ],
//                           ),
//                           child: Row(
//                             children: [
//                               Container(
//                                 width: 38,
//                                 height: 38,
//                                 decoration: BoxDecoration(
//                                   color: _mealBg(entry.meal),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     entry.emoji,
//                                     style: const TextStyle(fontSize: 18),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 10),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       entry.food,
//                                       style: interTight(
//                                         size: 13,
//                                         weight: FontWeight.w600,
//                                       ),
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                     Text(
//                                       entry.time,
//                                       style: interTight(
//                                         size: 10,
//                                         color: AppColors.mutedLight,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 10,
//                                   vertical: 4,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: _mealBg(entry.meal),
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child: RichText(
//                                   text: TextSpan(
//                                     children: [
//                                       TextSpan(
//                                         text: '${entry.calories}',
//                                         style: interTight(
//                                           size: 13,
//                                           weight: FontWeight.w800,
//                                           color: _mealText(entry.meal),
//                                         ),
//                                       ),
//                                       TextSpan(
//                                         text: ' kcal',
//                                         style: interTight(
//                                           size: 9,
//                                           color: _mealText(entry.meal),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 4),
//                               GestureDetector(
//                                 onTap: () => state.removeEntry(entry.id),
//                                 child: const Padding(
//                                   padding: EdgeInsets.all(4),
//                                   child: Icon(
//                                     Icons.close,
//                                     size: 16,
//                                     color: AppColors.mutedLight,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }, childCount: group.$2.length),
//                   ),
//                 ],

//                 const SliverToBoxAdapter(child: SizedBox(height: 20)),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _darkStatCard(String val, String label, Color color) => Container(
//     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//     decoration: BoxDecoration(
//       color: Colors.white.withOpacity(0.06),
//       borderRadius: BorderRadius.circular(12),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           val,
//           style: interTight(size: 16, weight: FontWeight.w800, color: color),
//         ),
//         Text(
//           label,
//           style: interTight(size: 10, color: const Color(0xFF5A5040)),
//         ),
//       ],
//     ),
//   );

//   Widget _macroMiniCard(
//     String emoji,
//     String label,
//     int val,
//     int goal,
//     Color color,
//   ) => Expanded(
//     child: Container(
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
//         ],
//       ),
//       child: Column(
//         children: [
//           Text(emoji, style: const TextStyle(fontSize: 14)),
//           const SizedBox(height: 2),
//           Text(
//             //'${val}g / ${goal}g',
//             '${val}g',
//             style: interTight(size: 14, weight: FontWeight.w800),
//           ),
//           const SizedBox(height: 4),
//           // Progress bar
//           Stack(
//             children: [
//               // Background bar
//               Container(
//                 height: 6,
//                 decoration: BoxDecoration(
//                   color: AppColors.inputBg,
//                   borderRadius: BorderRadius.circular(3),
//                 ),
//               ),
//               // Filled portion
//               LayoutBuilder(
//                 builder: (context, constraints) {
//                   double progress = 0;
//                   if (goal > 0) {
//                     progress = (val / goal).clamp(0.0, 1.0);
//                   }
//                   return Container(
//                     width: constraints.maxWidth * progress,
//                     height: 6,
//                     decoration: BoxDecoration(
//                       color: color,
//                       borderRadius: BorderRadius.circular(3),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 4),
//           Text(label, style: interTight(size: 9, color: AppColors.muted)),
//         ],
//       ),
//     ),
//   );

//   double proteinPerKg(String goal) {
//     switch (goal) {
//       case 'lose_fast':
//         return 2.2; // higher protein to preserve muscle
//       case 'lose':
//         return 2.0;
//       case 'maintain':
//         return 1.6;
//       case 'gain':
//         return 1.8;
//       case 'gain_fast':
//         return 2.0;
//       default:
//         return 1.6;
//     }
//   }
// }

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nutilog/utils/helper_function.dart';

import '../colors.dart';
import '../provider/change_notifier_provider.dart';
import '../state/app_state.dart';
import '../widgets/calorie_ring_painter.dart';
import '../widgets/deficit_badge.dart';
import 'edit_profile_screen.dart';

// ─── HOME SCREEN ──────────────────────────────────────────────────────────────
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Color _mealDot(String meal) {
    switch (meal) {
      case 'Breakfast':
        return AppColors.breakfastDot;
      case 'Lunch':
        return AppColors.lunchDot;
      case 'Dinner':
        return AppColors.dinnerDot;
      default:
        return AppColors.snackDot;
    }
  }

  Color _mealBg(String meal) {
    switch (meal) {
      case 'Breakfast':
        return AppColors.breakfastBg;
      case 'Lunch':
        return AppColors.lunchBg;
      case 'Dinner':
        return AppColors.dinnerBg;
      default:
        return AppColors.snackBg;
    }
  }

  Color _mealText(String meal) {
    switch (meal) {
      case 'Breakfast':
        return AppColors.breakfastText;
      case 'Lunch':
        return AppColors.lunchText;
      case 'Dinner':
        return AppColors.dinnerText;
      default:
        return AppColors.snackText;
    }
  }

  double proteinPerKg(String goal) {
    switch (goal) {
      case 'lose_fast':
        return 2.2;
      case 'lose':
        return 2.0;
      case 'maintain':
        return 1.6;
      case 'gain':
        return 1.8;
      case 'gain_fast':
        return 2.0;
      default:
        return 1.6;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (ctx, state, _) {
        final total = state.totalCalories;
        final goal = state.profile.goalCalories;
        final pct = goal > 0 ? total / goal : 0.0;
        final over = total > goal;
        final ringColor = over
            ? AppColors.red
            : pct > 0.85
            ? AppColors.orange
            : AppColors.green;

        final mealGroups = ['Breakfast', 'Lunch', 'Dinner', 'Snack']
            .map((m) {
              final items = state.entries.where((e) => e.meal == m).toList();
              return (
                m,
                items,
                items.fold(0, (s, e) => s + e.calories.toInt()),
              );
            })
            .where((g) => g.$2.isNotEmpty)
            .toList();

        // ── greeting based on time of day ──────────────────────────────────────
        final hour = DateTime.now().hour;
        final greeting = hour < 12
            ? 'Good morning 🌿'
            : hour < 17
            ? 'Good afternoon ☀️'
            : 'Good evening 🌙';

        return Scaffold(
          backgroundColor: AppColors.bg,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                // ── HEADER with date navigation ─────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left: greeting + date label
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.isToday ? greeting : '📅 Viewing past log',
                              style: interTight(
                                size: 12,
                                weight: FontWeight.w500,
                                color: AppColors.muted,
                              ),
                            ),
                            Text(
                              state.isToday
                                  ? "Today's Log"
                                  : state.activeDateLabel,
                              style: interTight(
                                size: 22,
                                weight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),

                        // Right: profile icon + prev / today-dot / next arrows
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(ctx).push(
                                MaterialPageRoute(
                                  builder: (_) => const EditProfileScreen(),
                                ),
                              ),
                              child: Container(
                                width: 32,
                                height: 32,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.inputBg,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.person_outline,
                                  size: 18,
                                  color: AppColors.dark,
                                ),
                              ),
                            ),
                            _navArrow(
                              icon: Icons.chevron_left,
                              onTap: state.goToPreviousDay,
                            ),
                            GestureDetector(
                              onTap: state.isToday ? null : state.goToToday,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: state.isToday
                                      ? AppColors.green
                                      : AppColors.mutedLight,
                                ),
                              ),
                            ),
                            _navArrow(
                              icon: Icons.chevron_right,
                              onTap: state.isToday ? null : state.goToNextDay,
                              disabled: state.isToday,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // ── CALORIE RING CARD ───────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.dark, AppColors.dark2],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: HelperFunction.colorWithOpacity(
                              Colors.black,
                              0.25,
                            ),
                            blurRadius: 40,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Consumed',
                                  style: interTight(
                                    size: 11,
                                    weight: FontWeight.w600,
                                    color: const Color(0xFF5A5040),
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${total.toInt()}',
                                  style: interTight(
                                    size: 44,
                                    weight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'of $goal kcal goal',
                                  style: interTight(
                                    size: 13,
                                    color: const Color(0xFF7A7060),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    _darkStatCard(
                                      '${max(goal - total, 0).toInt()}',
                                      'Remaining',
                                      AppColors.greenLight,
                                    ),
                                    const SizedBox(width: 8),
                                    _darkStatCard(
                                      '320',
                                      'Burned',
                                      AppColors.orange,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 110,
                            height: 110,
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(
                                begin: 0,
                                end: pct.clamp(0, 1.2).toDouble(),
                              ),
                              duration: const Duration(milliseconds: 1200),
                              curve: Curves.easeOutBack,
                              builder: (ctx, v, _) => CustomPaint(
                                painter: CalorieRingPainter(v, ringColor),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${(min(pct, 1.0) * 100).round()}%',
                                        style: interTight(
                                          size: 22,
                                          weight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'of goal',
                                        style: interTight(
                                          size: 11,
                                          color: const Color(0xFF5A5040),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── DEFICIT BADGE ───────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: DeficitBadge(consumed: total.toInt(), goalCal: goal),
                  ),
                ),

                // ── MACRO ROW ───────────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: Row(
                      children: [
                        _macroMiniCard(
                          '🥩',
                          'Protein',
                          state.totalProtein.toInt(),
                          (state.profile.weight *
                                  proteinPerKg(state.profile.goal))
                              .round(),
                          AppColors.red,
                        ),
                        const SizedBox(width: 8),
                        _macroMiniCard(
                          '🌾',
                          'Carbs',
                          state.totalCarbs.toInt(),
                          ((goal * 0.45) / 4).round(),
                          AppColors.orange,
                        ),
                        const SizedBox(width: 8),
                        _macroMiniCard(
                          '🥑',
                          'Fat',
                          state.totalFat.toInt(),
                          ((goal * 0.25) / 9).round(),
                          AppColors.purple,
                        ),
                      ],
                    ),
                  ),
                ),

                // ── MEALS HEADER ────────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          state.isToday
                              ? "Today's Meals"
                              : "${state.activeDateLabel}'s Meals",
                          style: interTight(size: 15, weight: FontWeight.w800),
                        ),
                        // Show "past" pill when browsing history
                        if (!state.isToday)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.orangeBg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: HelperFunction.colorWithOpacity(
                                  AppColors.orange,
                                  0.3,
                                ),
                              ),
                            ),
                            child: Text(
                              '📅 Past log',
                              style: interTight(
                                size: 10,
                                weight: FontWeight.w700,
                                color: AppColors.amber,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // ── EMPTY STATE ─────────────────────────────────────────────────
                if (mealGroups.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          const Text('🍽️', style: TextStyle(fontSize: 32)),
                          const SizedBox(height: 8),
                          Text(
                            state.isToday
                                ? 'No meals yet — tap + to log your first meal'
                                : 'No meals were logged on this day',
                            style: interTight(
                              size: 13,
                              color: AppColors.mutedLight,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                // ── MEAL GROUPS ─────────────────────────────────────────────────
                for (final group in mealGroups) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
                      child: Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: _mealDot(group.$1),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            group.$1.toUpperCase(),
                            style: interTight(
                              size: 11,
                              weight: FontWeight.w700,
                              color: AppColors.muted,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${group.$3} kcal',
                            style: interTight(
                              size: 11,
                              weight: FontWeight.w600,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((ctx, i) {
                      final entry = group.$2[i];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: HelperFunction.colorWithOpacity(
                                  Colors.black,
                                  0.05,
                                ),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: _mealBg(entry.meal),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    entry.emoji,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.food,
                                      style: interTight(
                                        size: 13,
                                        weight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      entry.time,
                                      style: interTight(
                                        size: 10,
                                        color: AppColors.mutedLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _mealBg(entry.meal),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${entry.calories.toInt()}',
                                        style: interTight(
                                          size: 13,
                                          weight: FontWeight.w800,
                                          color: _mealText(entry.meal),
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' kcal',
                                        style: interTight(
                                          size: 9,
                                          color: _mealText(entry.meal),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              // Only allow deletion on today's log
                              if (state.isToday)
                                GestureDetector(
                                  onTap: () => state.removeEntry(entry.id),
                                  child: const Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.close,
                                      size: 16,
                                      color: AppColors.mutedLight,
                                    ),
                                  ),
                                )
                              else
                                const SizedBox(
                                  width: 24,
                                ), // spacer to preserve layout
                            ],
                          ),
                        ),
                      );
                    }, childCount: group.$2.length),
                  ),
                ],

                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── PRIVATE WIDGETS ─────────────────────────────────────────────────────────

  Widget _navArrow({
    required IconData icon,
    required VoidCallback? onTap,
    bool disabled = false,
  }) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: disabled
            ? HelperFunction.colorWithOpacity(AppColors.inputBg, 0.5)
            : AppColors.inputBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        size: 18,
        color: disabled ? AppColors.mutedLight : AppColors.dark,
      ),
    ),
  );

  Widget _darkStatCard(String val, String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: HelperFunction.colorWithOpacity(Colors.white, 0.06),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          val,
          style: interTight(size: 16, weight: FontWeight.w800, color: color),
        ),
        Text(
          label,
          style: interTight(size: 10, color: const Color(0xFF5A5040)),
        ),
      ],
    ),
  );

  Widget _macroMiniCard(
    String emoji,
    String label,
    int val,
    int goal,
    Color color,
  ) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: HelperFunction.colorWithOpacity(Colors.black, 0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 2),
          Text('${val}g', style: interTight(size: 14, weight: FontWeight.w800)),
          const SizedBox(height: 4),
          Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.inputBg,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  final progress = goal > 0
                      ? (val / goal).clamp(0.0, 1.0)
                      : 0.0;
                  return Container(
                    width: constraints.maxWidth * progress,
                    height: 6,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(label, style: interTight(size: 9, color: AppColors.muted)),
        ],
      ),
    ),
  );
}
