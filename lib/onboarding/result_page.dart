import 'package:flutter/material.dart';
import 'package:nutilog/utils/helper_function.dart';
import '../colors.dart';
import '../models/user_profile.dart';
import 'onboarding_helpers.dart';

// ─── RESULT PAGE (Step 4) ─────────────────────────────────────────────────────
class ResultPage extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback onNext, onBack;
  final double progress;
  const ResultPage({
    super.key,
    required this.profile,
    required this.onNext,
    required this.onBack,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final tdee = profile.tdee;
    final goalCal = profile.goalCalories;
    final diff = goalCal - tdee;
    final isDeficit = diff < 0;
    final isMaintain = diff == 0;
    final diffColor = isMaintain
        ? AppColors.green
        : isDeficit
        ? AppColors.red
        : AppColors.purple;
    final diffLabel = isMaintain
        ? 'Maintenance'
        : isDeficit
        ? '$diff deficit'
        : '+$diff surplus';

    final protein =
        (profile.weight * (profile.goal.contains('gain') ? 2.2 : 1.8)).round();
    final carbs = ((goalCal * 0.45) / 4).round();
    final fat = ((goalCal * 0.25) / 9).round();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          buildProgressBar(progress),
          const SizedBox(height: 20),

          Center(
            child: Column(
              children: [
                const Text('🎯', style: TextStyle(fontSize: 36)),
                const SizedBox(height: 8),
                Text(
                  'Your Plan is Ready!',
                  style: interTight(size: 22, weight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  'Based on your profile',
                  style: interTight(size: 13, color: AppColors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Big calorie card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.dark, AppColors.dark2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Text(
                  'Daily Calorie Goal',
                  style: interTight(
                    size: 11,
                    weight: FontWeight.w600,
                    color: const Color(0xFF7A7060),
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$goalCal',
                  style: interTight(
                    size: 56,
                    weight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'kcal / day',
                  style: interTight(size: 13, color: const Color(0xFF7A7060)),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: HelperFunction.colorWithOpacity(diffColor, 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: HelperFunction.colorWithOpacity(diffColor, 0.3),
                    ),
                  ),
                  child: Text(
                    '$diffLabel from maintenance ($tdee kcal)',
                    style: interTight(
                      size: 12,
                      weight: FontWeight.w700,
                      color: diffColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Macros row
          Row(
            children: [
              _macroCard('🥩', 'Protein', '${protein}g', AppColors.red),
              const SizedBox(width: 8),
              _macroCard('🌾', 'Carbs', '${carbs}g', AppColors.orange),
              const SizedBox(width: 8),
              _macroCard('🥑', 'Fat', '${fat}g', AppColors.purple),
            ],
          ),
          const SizedBox(height: 12),

          // Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: HelperFunction.colorWithOpacity(Colors.black, 0.05),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              children: [
                _summaryRow('Maintenance (TDEE)', '$tdee kcal'),
                _summaryRow('Your goal', '$goalCal kcal'),
                _summaryRow(
                  'Target weight',
                  profile.targetWeight > 0 ? '${profile.targetWeight} kg' : '—',
                ),
                _summaryRow(
                  'Current weight',
                  '${profile.weight} kg',
                  last: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          buildPrimaryBtn('Start Tracking 🚀', onNext),
        ],
      ),
    );
  }

  Widget _macroCard(String emoji, String label, String val, Color color) =>
      Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: HelperFunction.colorWithOpacity(Colors.black, 0.05),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 4),
              Text(
                val,
                style: interTight(
                  size: 16,
                  weight: FontWeight.w800,
                  color: color,
                ),
              ),
              Text(label, style: interTight(size: 10, color: AppColors.muted)),
            ],
          ),
        ),
      );

  Widget _summaryRow(String label, String val, {bool last = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: interTight(size: 12, color: AppColors.muted)),
            Text(val, style: interTight(size: 13, weight: FontWeight.w700)),
          ],
        ),
        if (!last) const SizedBox(height: 8),
        if (!last) Divider(color: AppColors.border, height: 1),
      ],
    ),
  );
}
