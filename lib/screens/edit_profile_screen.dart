import 'package:flutter/material.dart';
import '../colors.dart';
import '../models/user_profile.dart';
import '../onboarding/onboarding_helpers.dart';
import '../provider/change_notifier_provider.dart';
import '../state/app_state.dart';
import '../utils/helper_function.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late UserProfile _profile;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final state = context.read<AppState>();
      _profile = UserProfile.fromJson(state.profile.toJson());
    }
  }

  Future<void> _save() async {
    await _profile.save();
    if (!mounted) return;
    await context.read<AppState>().load();
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile updated', style: interTight(size: 13, color: Colors.white)),
        backgroundColor: AppColors.greenDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _genderBtn(String id, String label) {
    final active = _profile.gender == id;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _profile.gender = id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: active ? AppColors.greenBg : AppColors.inputBg,
            border: Border.all(
              color: active ? AppColors.green : Colors.transparent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              label,
              style: interTight(
                size: 14,
                weight: FontWeight.w700,
                color: active ? AppColors.greenText : AppColors.muted,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _chip(String id, String label, bool active, VoidCallback onTap) =>
      GestureDetector(
        onTap: () {
          onTap();
          setState(() {});
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.greenBg : AppColors.inputBg,
            border: Border.all(
              color: active ? AppColors.green : Colors.transparent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: interTight(
              size: 13,
              weight: FontWeight.w600,
              color: active ? AppColors.greenText : AppColors.muted,
            ),
          ),
        ),
      );

  String _fmt(double v) => v == v.roundToDouble() ? v.toInt().toString() : v.toString();

  @override
  Widget build(BuildContext context) {
    const goals = [
      ('lose_fast', '🔥 Lose Fast', '–750 kcal/day · ~0.75kg/week', AppColors.red),
      ('lose', '📉 Lose Weight', '–500 kcal/day · ~0.5kg/week', AppColors.orange),
      ('maintain', '⚖️ Maintain', 'Eat at maintenance calories', AppColors.green),
      ('gain', '📈 Gain Muscle', '+300 kcal/day · lean bulk', AppColors.purple),
      ('gain_fast', '💪 Bulk Up', '+500 kcal/day · fast gains', AppColors.greenDark),
    ];

    const workouts = [
      ('none', '🛋 Sedentary', 'Little/no exercise'),
      ('light', '🚶 Light', 'Walk/yoga'),
      ('moderate', '🏃 Moderate', 'Gym/cycling'),
      ('intense', '🔥 Intense', 'HIIT/sports'),
    ];

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.inputBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back, color: AppColors.dark, size: 20),
          ),
        ),
        title: Text(
          'Edit Profile',
          style: interTight(size: 17, weight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── PERSONAL ──────────────────────────────────────────────────
            _sectionHeader('Personal'),
            buildLabel('Gender'),
            Row(children: [
              _genderBtn('male', '♂  Male'),
              const SizedBox(width: 8),
              _genderBtn('female', '♀  Female'),
            ]),
            const SizedBox(height: 14),
            buildLabel('Age'),
            buildTextField(
              hint: 'e.g. 28',
              initialValue: _profile.age == 0 ? '' : _fmt(_profile.age),
              onChanged: (v) => _profile.age = double.tryParse(v) ?? _profile.age,
            ),
            const SizedBox(height: 14),
            buildLabel('Height (cm)'),
            buildTextField(
              hint: 'e.g. 170',
              initialValue: _profile.height == 0 ? '' : _fmt(_profile.height),
              onChanged: (v) => _profile.height = double.tryParse(v) ?? _profile.height,
            ),
            const SizedBox(height: 14),
            buildLabel('Current Weight (kg)'),
            buildTextField(
              hint: 'e.g. 70',
              initialValue: _profile.weight == 0 ? '' : _fmt(_profile.weight),
              onChanged: (v) => _profile.weight = double.tryParse(v) ?? _profile.weight,
            ),

            const SizedBox(height: 28),

            // ── WORKOUT ───────────────────────────────────────────────────
            _sectionHeader('Workout Habits'),
            buildLabel('Duration per day'),
            Row(children: [
              _chip('mins', '⏱ Minutes', _profile.workoutUnit == 'mins',
                  () => _profile.workoutUnit = 'mins'),
              const SizedBox(width: 8),
              _chip('hours', '🕐 Hours', _profile.workoutUnit == 'hours',
                  () => _profile.workoutUnit = 'hours'),
            ]),
            const SizedBox(height: 12),
            buildTextField(
              hint: _profile.workoutUnit == 'hours' ? 'e.g. 1.5' : 'e.g. 45',
              initialValue: _profile.workoutDuration == 0
                  ? ''
                  : _fmt(_profile.workoutDuration),
              onChanged: (v) =>
                  _profile.workoutDuration = double.tryParse(v) ?? _profile.workoutDuration,
            ),
            const SizedBox(height: 14),
            buildLabel('Workout type'),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.8,
              children: workouts
                  .map((w) => GestureDetector(
                        onTap: () => setState(() => _profile.workoutType = w.$1),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: _profile.workoutType == w.$1
                                ? AppColors.greenBg
                                : AppColors.inputBg,
                            border: Border.all(
                              color: _profile.workoutType == w.$1
                                  ? AppColors.green
                                  : Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                w.$2,
                                style: interTight(
                                  size: 13,
                                  weight: FontWeight.w700,
                                  color: _profile.workoutType == w.$1
                                      ? AppColors.greenText
                                      : AppColors.dark,
                                ),
                              ),
                              Text(w.$3,
                                  style: interTight(
                                      size: 10, color: AppColors.muted)),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),

            const SizedBox(height: 28),

            // ── GOAL ──────────────────────────────────────────────────────
            _sectionHeader('Goal'),
            buildLabel('Target Weight (kg)'),
            buildTextField(
              hint: 'e.g. 65',
              initialValue: _profile.targetWeight == 0
                  ? ''
                  : _fmt(_profile.targetWeight),
              onChanged: (v) =>
                  _profile.targetWeight = double.tryParse(v) ?? _profile.targetWeight,
            ),
            const SizedBox(height: 14),
            buildLabel('Goal'),
            ...goals.map(
              (g) => GestureDetector(
                onTap: () => setState(() => _profile.goal = g.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: _profile.goal == g.$1
                        ? HelperFunction.colorWithOpacity(g.$4, 0.08)
                        : AppColors.inputBg,
                    border: Border.all(
                      color: _profile.goal == g.$1
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
                                color: _profile.goal == g.$1
                                    ? g.$4
                                    : AppColors.dark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(g.$3,
                                style: interTight(
                                    size: 11, color: AppColors.muted)),
                          ],
                        ),
                      ),
                      if (_profile.goal == g.$1)
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: g.$4,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check,
                              color: Colors.white, size: 14),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
            buildPrimaryBtn('Save Changes', _save),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) => Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 14),
        child: Text(title,
            style: interTight(size: 18, weight: FontWeight.w800)),
      );
}
