import 'package:flutter/material.dart';
import 'package:nutilog/utils/helper_function.dart';
import '../colors.dart';

// ─── SHARED ONBOARDING WIDGETS ────────────────────────────────────────────────

Widget buildProgressBar(double value) => Container(
  height: 4,
  decoration: BoxDecoration(
    color: AppColors.inputBg,
    borderRadius: BorderRadius.circular(2),
  ),
  child: FractionallySizedBox(
    alignment: Alignment.centerLeft,
    widthFactor: value,
    child: Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.greenLight, AppColors.green],
        ),
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  ),
);

Widget buildLabel(String text) => Padding(
  padding: const EdgeInsets.only(bottom: 6),
  child: Text(
    text.toUpperCase(),
    style: interTight(
      size: 11,
      weight: FontWeight.w700,
      color: AppColors.muted,
      letterSpacing: 1.0,
    ),
  ),
);

Widget buildTextField({
  required String hint,
  required ValueChanged<String> onChanged,
  String? initialValue,
  TextInputType keyboardType = TextInputType.number,
}) => TextFormField(
  initialValue: initialValue,
  onChanged: onChanged,
  keyboardType: keyboardType,
  style: interTight(size: 15, weight: FontWeight.w500),
  decoration: InputDecoration(
    hintText: hint,
    hintStyle: interTight(size: 15, color: AppColors.muted),
    filled: true,
    fillColor: AppColors.inputBg,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.green, width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),
);

Widget buildPrimaryBtn(String label, VoidCallback? onTap) => GestureDetector(
  onTap: onTap,
  child: Container(
    width: double.infinity,
    height: 54,
    decoration: BoxDecoration(
      color: onTap != null
          ? AppColors.dark
          : HelperFunction.colorWithOpacity(AppColors.dark, 0.3),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Center(
      child: Text(
        label,
        style: interTight(
          size: 15,
          weight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    ),
  ),
);

Widget buildSecondaryBtn(String label, VoidCallback onTap) => GestureDetector(
  onTap: onTap,
  child: Container(
    height: 54,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      color: AppColors.inputBg,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Center(
      child: Text(
        label,
        style: interTight(
          size: 15,
          weight: FontWeight.w600,
          color: const Color(0xFF4A453E),
        ),
      ),
    ),
  ),
);
