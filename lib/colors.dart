import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── COLORS ───────────────────────────────────────────────────────────────────
class AppColors {
  static const bg = Color(0xFFF7F3EE);
  static const surface = Colors.white;
  static const dark = Color(0xFF1A1814);
  static const dark2 = Color(0xFF2D2A26);
  static const dark3 = Color(0xFF3D3830);
  static const muted = Color(0xFF9B8E80);
  static const mutedLight = Color(0xFFB0A898);
  static const border = Color(0xFFEDE8E0);
  static const inputBg = Color(0xFFF0EDE8);

  static const green = Color(0xFF4CAF7D);
  static const greenLight = Color(0xFFA8C5A0);
  static const greenDark = Color(0xFF6B9E63);
  static const greenBg = Color(0xFFE8F5E9);
  static const greenText = Color(0xFF1B6B3A);

  static const orange = Color(0xFFFFB74D);
  static const orangeBg = Color(0xFFFFF8E1);
  static const red = Color(0xFFE8607A);
  static const redBg = Color(0xFFFCE4EC);
  static const purple = Color(0xFF7C5CBF);
  static const purpleBg = Color(0xFFEDE7F6);
  static const amber = Color(0xFFFF8C42);

  static const breakfastBg = Color(0xFFFFF3E0);
  static const breakfastDot = Color(0xFFFF8C42);
  static const breakfastText = Color(0xFFBF5A00);
  static const lunchBg = Color(0xFFE8F5E9);
  static const lunchDot = Color(0xFF4CAF7D);
  static const lunchText = Color(0xFF1B6B3A);
  static const dinnerBg = Color(0xFFEDE7F6);
  static const dinnerDot = Color(0xFF7C5CBF);
  static const dinnerText = Color(0xFF3D1F8C);
  static const snackBg = Color(0xFFFCE4EC);
  static const snackDot = Color(0xFFE8607A);
  static const snackText = Color(0xFF8C1A2E);
}

// ─── TEXT STYLE HELPER ────────────────────────────────────────────────────────
TextStyle interTight({
  double size = 14,
  FontWeight weight = FontWeight.w400,
  Color color = AppColors.dark,
  double? letterSpacing,
  double? height,
}) =>
    GoogleFonts.interTight(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
