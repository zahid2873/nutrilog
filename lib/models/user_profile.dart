import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../math.dart';

// ─── USER PROFILE ─────────────────────────────────────────────────────────────
class UserProfile {
  String gender;
  double age;
  double weight;
  double height;
  double targetWeight;
  String workoutUnit;
  double workoutDuration;
  String workoutType;
  String goal;

  UserProfile({
    this.gender = 'male',
    this.age = 0,
    this.weight = 0,
    this.height = 0,
    this.targetWeight = 0,
    this.workoutUnit = 'mins',
    this.workoutDuration = 0,
    this.workoutType = 'light',
    this.goal = 'maintain',
  });

  double get workoutMins =>
      workoutUnit == 'hours' ? workoutDuration * 60 : workoutDuration;

  int get tdee => calcTDEE(
        age: age,
        weight: weight,
        height: height,
        gender: gender,
        workoutMinsPerDay: workoutMins,
      );

  int get goalCalories => calcGoalCalories(tdee, goal);

  Map<String, dynamic> toJson() => {
        'gender': gender,
        'age': age,
        'weight': weight,
        'height': height,
        'targetWeight': targetWeight,
        'workoutUnit': workoutUnit,
        'workoutDuration': workoutDuration,
        'workoutType': workoutType,
        'goal': goal,
      };

  factory UserProfile.fromJson(Map<String, dynamic> j) => UserProfile(
        gender: j['gender'] ?? 'male',
        age: (j['age'] ?? 0).toDouble(),
        weight: (j['weight'] ?? 0).toDouble(),
        height: (j['height'] ?? 0).toDouble(),
        targetWeight: (j['targetWeight'] ?? 0).toDouble(),
        workoutUnit: j['workoutUnit'] ?? 'mins',
        workoutDuration: (j['workoutDuration'] ?? 0).toDouble(),
        workoutType: j['workoutType'] ?? 'light',
        goal: j['goal'] ?? 'maintain',
      );

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile', jsonEncode(toJson()));
  }

  static Future<UserProfile?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString('profile');
    if (s == null) return null;
    return UserProfile.fromJson(jsonDecode(s));
  }
}
