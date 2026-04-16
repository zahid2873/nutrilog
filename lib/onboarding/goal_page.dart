import 'package:flutter/material.dart';
import 'package:nutilog/utils/helper_function.dart';
import '../colors.dart';
import '../models/user_profile.dart';
import 'onboarding_helpers.dart';

// ─── GOAL PAGE (Step 3) ───────────────────────────────────────────────────────
class GoalPage extends StatefulWidget {
  final UserProfile profile;
  final VoidCallback onNext, onBack;
  final double progress;
  const GoalPage({
    super.key,
    required this.profile,
    required this.onNext,
    required this.onBack,
    required this.progress,
  });

  @override
  State<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  final _goals = [
    (
      'lose_fast',
      '🔥 Lose Fast',
      '–750 kcal/day · ~0.75kg/week',
      AppColors.red,
    ),
    ('lose', '📉 Lose Weight', '–500 kcal/day · ~0.5kg/week', AppColors.orange),
    ('maintain', '⚖️ Maintain', 'Eat at maintenance calories', AppColors.green),
    ('gain', '📈 Gain Muscle', '+300 kcal/day · lean bulk', AppColors.purple),
    (
      'gain_fast',
      '💪 Bulk Up',
      '+500 kcal/day · fast gains',
      AppColors.greenDark,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          buildProgressBar(widget.progress),
          const SizedBox(height: 20),
          Text(
            'Your Goal',
            style: interTight(size: 24, weight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'What are you aiming for?',
            style: interTight(size: 13, color: AppColors.muted),
          ),
          const SizedBox(height: 20),
          buildLabel('Target Weight (kg)'),
          buildTextField(
            hint: widget.profile.targetWeight == 0
                ? 'e.g. 65'
                : widget.profile.targetWeight.toString(),
            onChanged: (v) =>
                widget.profile.targetWeight = double.tryParse(v) ?? 0,
          ),
          const SizedBox(height: 20),
          buildLabel('Goal'),
          ..._goals.map(
            (g) => GestureDetector(
              onTap: () => setState(() => widget.profile.goal = g.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: widget.profile.goal == g.$1
                      ? HelperFunction.colorWithOpacity(g.$4, 0.08)
                      : AppColors.inputBg,
                  border: Border.all(
                    color: widget.profile.goal == g.$1
                        ? g.$4
                        : Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            g.$2,
                            style: interTight(
                              size: 14,
                              weight: FontWeight.w700,
                              color: widget.profile.goal == g.$1
                                  ? g.$4
                                  : AppColors.dark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            g.$3,
                            style: interTight(size: 11, color: AppColors.muted),
                          ),
                        ],
                      ),
                    ),
                    if (widget.profile.goal == g.$1)
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: g.$4,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              buildSecondaryBtn('← Back', widget.onBack),
              const SizedBox(width: 10),
              Expanded(
                child: buildPrimaryBtn(
                  'Calculate →',
                  widget.profile.goal.isNotEmpty ? widget.onNext : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
