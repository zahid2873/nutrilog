import 'package:flutter/material.dart';
import '../colors.dart';
import '../models/user_profile.dart';
import 'onboarding_helpers.dart';

// ─── WORKOUT PAGE (Step 2) ────────────────────────────────────────────────────
class WorkoutPage extends StatefulWidget {
  final UserProfile profile;
  final VoidCallback onNext, onBack;
  final double progress;
  const WorkoutPage({
    super.key,
    required this.profile,
    required this.onNext,
    required this.onBack,
    required this.progress,
  });

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  Widget _chip(String id, String label, bool active, VoidCallback onTap) =>
      GestureDetector(
        onTap: () { onTap(); setState(() {}); },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.greenBg : AppColors.inputBg,
            border: Border.all(color: active ? AppColors.green : Colors.transparent, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(label,
              style: interTight(
                  size: 13,
                  weight: FontWeight.w600,
                  color: active ? AppColors.greenText : AppColors.muted)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final workouts = [
      ('none',     '🛋 Sedentary', 'Little/no exercise'),
      ('light',    '🚶 Light',     'Walk/yoga'),
      ('moderate', '🏃 Moderate',  'Gym/cycling'),
      ('intense',  '🔥 Intense',   'HIIT/sports'),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 16),
        buildProgressBar(widget.progress),
        const SizedBox(height: 20),
        Text('Workout Habits', style: interTight(size: 24, weight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text('How much do you exercise per day on average?',
            style: interTight(size: 13, color: AppColors.muted)),
        const SizedBox(height: 28),
        buildLabel('Duration per day'),
        Row(children: [
          _chip('mins', '⏱ Minutes', widget.profile.workoutUnit == 'mins',
              () => widget.profile.workoutUnit = 'mins'),
          const SizedBox(width: 8),
          _chip('hours', '🕐 Hours', widget.profile.workoutUnit == 'hours',
              () => widget.profile.workoutUnit = 'hours'),
        ]),
        const SizedBox(height: 12),
        buildTextField(
          hint: widget.profile.workoutUnit == 'hours' ? 'e.g. 1.5' : 'e.g. 45',
          onChanged: (v) => widget.profile.workoutDuration = double.tryParse(v) ?? 0,
        ),
        const SizedBox(height: 20),
        buildLabel('Workout type'),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2.8,
          children: workouts.map((w) => GestureDetector(
            onTap: () => setState(() => widget.profile.workoutType = w.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: widget.profile.workoutType == w.$1 ? AppColors.greenBg : AppColors.inputBg,
                border: Border.all(
                    color: widget.profile.workoutType == w.$1 ? AppColors.green : Colors.transparent,
                    width: 2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(w.$2,
                      style: interTight(
                          size: 13,
                          weight: FontWeight.w700,
                          color: widget.profile.workoutType == w.$1 ? AppColors.greenText : AppColors.dark)),
                  Text(w.$3, style: interTight(size: 10, color: AppColors.muted)),
                ],
              ),
            ),
          )).toList(),
        ),
        const SizedBox(height: 32),
        Row(children: [
          buildSecondaryBtn('← Back', widget.onBack),
          const SizedBox(width: 10),
          Expanded(child: buildPrimaryBtn('Continue →', widget.onNext)),
        ]),
      ]),
    );
  }
}
