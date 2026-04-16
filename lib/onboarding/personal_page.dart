import 'package:flutter/material.dart';
import '../colors.dart';
import '../models/user_profile.dart';
import 'onboarding_helpers.dart';

// ─── PERSONAL PAGE (Step 1) ───────────────────────────────────────────────────
class PersonalPage extends StatefulWidget {
  final UserProfile profile;
  final VoidCallback onNext, onBack;
  final double progress;
  const PersonalPage({
    super.key,
    required this.profile,
    required this.onNext,
    required this.onBack,
    required this.progress,
  });

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  bool get _canContinue =>
      widget.profile.age > 0 &&
      widget.profile.height > 0 &&
      widget.profile.weight > 0;

  Widget _genderBtn(String id, String label) {
    final active = widget.profile.gender == id;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => widget.profile.gender = id),
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
            'About You',
            style: interTight(size: 24, weight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'We use this to calculate your metabolic rate',
            style: interTight(size: 13, color: AppColors.muted),
          ),
          const SizedBox(height: 28),
          buildLabel('Gender'),
          Row(
            children: [
              _genderBtn('male', '♂  Male'),
              const SizedBox(width: 8),
              _genderBtn('female', '♀  Female'),
            ],
          ),
          const SizedBox(height: 16),
          buildLabel('Age'),
          buildTextField(
            hint: widget.profile.age == 0
                ? 'e.g. 28'
                : widget.profile.age.toString(),
            onChanged: (v) =>
                setState(() => widget.profile.age = double.tryParse(v) ?? 0),
          ),
          const SizedBox(height: 16),
          buildLabel('Height (cm)'),
          buildTextField(
            hint: widget.profile.height == 0
                ? 'e.g. 170'
                : widget.profile.height.toString(),
            onChanged: (v) =>
                setState(() => widget.profile.height = double.tryParse(v) ?? 0),
          ),
          const SizedBox(height: 16),
          buildLabel('Current Weight (kg)'),
          buildTextField(
            hint: widget.profile.weight == 0
                ? 'e.g. 70'
                : widget.profile.weight.toString(),
            onChanged: (v) =>
                setState(() => widget.profile.weight = double.tryParse(v) ?? 0),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              buildSecondaryBtn('← Back', widget.onBack),
              const SizedBox(width: 10),
              Expanded(
                child: buildPrimaryBtn(
                  'Continue →',
                  _canContinue ? widget.onNext : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
