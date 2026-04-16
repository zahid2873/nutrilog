// ─── CALORIE MATH ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

/// Calculates Total Daily Energy Expenditure using the Mifflin-St Jeor formula.
int calcTDEE({
  required double age,
  required double weight,
  required double height,
  required String gender,
  required double workoutMinsPerDay,
}) {
  double bmr = gender == 'male'
      ? 10 * weight + 6.25 * height - 5 * age + 5
      : 10 * weight + 6.25 * height - 5 * age - 161;

  double multiplier = 1.2;
  if (workoutMinsPerDay >= 180) {
    multiplier = 1.725;
  } else if (workoutMinsPerDay >= 90) {
    multiplier = 1.55;
  } else if (workoutMinsPerDay >= 45) {
    multiplier = 1.375;
  } else if (workoutMinsPerDay >= 20) {
    multiplier = 1.3;
  }
  debugPrint(
    "Calculate Tdee: multiplier: $multiplier bmr $bmr tdee:${(bmr * multiplier).round()}",
  );
  return (bmr * multiplier).round();
}

/// Adjusts TDEE based on the user's selected goal.
int calcGoalCalories(int tdee, String goal) {
  switch (goal) {
    case 'lose_fast':
      return tdee - 750;
    case 'lose':
      return tdee - 500;
    case 'maintain':
      return tdee;
    case 'gain':
      return tdee + 300;
    case 'gain_fast':
      return tdee + 500;
    default:
      return tdee;
  }
}
