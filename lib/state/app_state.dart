// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/user_profile.dart';
// import '../models/food_entry.dart';

// // ─── APP STATE ────────────────────────────────────────────────────────────────
// class AppState extends ChangeNotifier {
//   UserProfile profile = UserProfile();
//   bool onboardingDone = false;
//   List<FoodEntry> entries = [];

//   AppState() {
//     _load();
//   }

//   Future<void> _load() async {
//     final p = await UserProfile.load();
//     final prefs = await SharedPreferences.getInstance();
//     if (p != null) {
//       profile = p;
//       onboardingDone = prefs.getBool('onboarding_done') ?? false;
//     }
//     final raw = prefs.getString('entries');
//     if (raw != null) {
//       final List list = jsonDecode(raw);
//       entries = list.map((e) => FoodEntry.fromJson(e)).toList();
//     }
//     notifyListeners();
//   }

//   Future<void> completeOnboarding(UserProfile p) async {
//     profile = p;
//     onboardingDone = true;
//     await p.save();
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('onboarding_done', true);
//     notifyListeners();
//   }

//   Future<void> addEntry(FoodEntry entry) async {
//     entries.insert(0, entry);
//     await _saveEntries();
//     notifyListeners();
//   }

//   Future<void> removeEntry(String id) async {
//     entries.removeWhere((e) => e.id == id);
//     await _saveEntries();
//     notifyListeners();
//   }

//   Future<void> _saveEntries() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(
//         'entries', jsonEncode(entries.map((e) => e.toJson()).toList()));
//   }

//   int get totalCalories => entries.fold(0, (s, e) => s + e.calories.toInt());
//   int get totalProtein  => entries.fold(0, (s, e) => s + e.protein.toInt());
//   int get totalCarbs    => entries.fold(0, (s, e) => s + e.carbs.toInt());
//   int get totalFat      => entries.fold(0, (s, e) => s + e.fat.toInt());
// }

import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../models/food_entry.dart';

// ─── APP STATE ────────────────────────────────────────────────────────────────
class AppState extends ChangeNotifier {
  UserProfile profile = UserProfile();
  bool onboardingDone = false;

  /// Entries for the currently viewed date.
  List<FoodEntry> entries = [];

  /// The date currently being viewed (defaults to today).
  DateTime activeDate = _today();

  AppState() {
    _load();
  }

  // ─── HELPERS ───────────────────────────────────────────────────────────────
  static DateTime _today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  bool get isToday {
    final t = _today();
    return activeDate.year == t.year &&
        activeDate.month == t.month &&
        activeDate.day == t.day;
  }

  String get activeDateLabel {
    if (isToday) return 'Today';
    final diff = _today().difference(activeDate).inDays;
    if (diff == 1) return 'Yesterday';
    return '${activeDate.day}/${activeDate.month}/${activeDate.year}';
  }

  // ─── INIT ──────────────────────────────────────────────────────────────────
  Future<void> _load() async {
    // Load profile — check onboarding flag via UserProfile history
    final p = await UserProfile.load();
    if (p != null) {
      profile = p;
      onboardingDone = true;
    }
    // Load food entries for today
    entries = await FoodEntry.loadForDate(date: activeDate);
    notifyListeners();
  }

  Future<void> load() async {
    final p = await UserProfile.load();
    if (p != null) {
      profile = p;
    }
    notifyListeners();
  }

  // ─── ONBOARDING ────────────────────────────────────────────────────────────
  Future<void> completeOnboarding(UserProfile p) async {
    profile = p;
    onboardingDone = true;
    await p.save(); // saves under today's date key
    notifyListeners();
  }

  // ─── DATE NAVIGATION ───────────────────────────────────────────────────────
  /// Switch the active date and reload entries + profile for that day.
  Future<void> setActiveDate(DateTime date) async {
    activeDate = DateTime(date.year, date.month, date.day);

    // Reload entries for the new date
    entries = await FoodEntry.loadForDate(date: activeDate);

    // Load profile for that date (falls back to most recent saved)
    final p = await UserProfile.load();
    if (p != null) profile = p;

    notifyListeners();
  }

  void goToPreviousDay() =>
      setActiveDate(activeDate.subtract(const Duration(days: 1)));
  void goToNextDay() => setActiveDate(activeDate.add(const Duration(days: 1)));
  void goToToday() => setActiveDate(_today());

  // ─── ENTRIES ───────────────────────────────────────────────────────────────
  Future<void> addEntry(FoodEntry entry) async {
    await FoodEntry.addEntry(entry, date: activeDate);
    entries = await FoodEntry.loadForDate(date: activeDate);
    notifyListeners();
  }

  Future<void> removeEntry(String id) async {
    await FoodEntry.removeEntry(id, date: activeDate);
    entries = await FoodEntry.loadForDate(date: activeDate);
    notifyListeners();
  }

  // ─── HISTORY ───────────────────────────────────────────────────────────────
  /// All dates that have saved entries, newest first.
  Future<List<String>> entryHistory() => FoodEntry.savedDates();

  // Full history: { "yyyy-MM-dd" → List<FoodEntry> }
  Future<Map<String, List<FoodEntry>>> allEntries() => FoodEntry.loadAll();

  // ─── TOTALS (always reflect activeDate entries) ────────────────────────────
  double get totalCalories => entries.fold(0, (s, e) => s + e.calories);
  double get totalProtein => entries.fold(0, (s, e) => s + e.protein);
  double get totalCarbs => entries.fold(0, (s, e) => s + e.carbs);
  double get totalFat => entries.fold(0, (s, e) => s + e.fat);
}
