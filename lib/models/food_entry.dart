import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// ─── FOOD ENTRY ───────────────────────────────────────────────────────────────
class FoodEntry {
  final String id;
  final String food;
  final double calories;
  final String meal;
  final String time;
  final String emoji;
  final double protein;
  final double carbs;
  final double fat;

  FoodEntry({
    required this.id,
    required this.food,
    required this.calories,
    required this.meal,
    required this.time,
    required this.emoji,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
  });

  // ─── SERIALISATION ──────────────────────────────────────────────────────────
  Map<String, dynamic> toJson() => {
    'id': id,
    'food': food,
    'calories': calories,
    'meal': meal,
    'time': time,
    'emoji': emoji,
    'protein': protein,
    'carbs': carbs,
    'fat': fat,
  };

  factory FoodEntry.fromJson(Map<String, dynamic> j) => FoodEntry(
    id: j['id'] as String,
    food: j['food'] as String,
    calories: (j['calories'] as num).toDouble(),
    meal: j['meal'] as String,
    time: j['time'] as String,
    emoji: (j['emoji'] as String?) ?? '🍽️',
    protein: (j['protein'] as num? ?? 0).toDouble(),
    carbs: (j['carbs'] as num? ?? 0).toDouble(),
    fat: (j['fat'] as num? ?? 0).toDouble(),
  );

  // ─── DATE KEY ───────────────────────────────────────────────────────────────
  /// Consistent storage key for a date → "entries_2025-01-31"
  static String _key(DateTime date) =>
      'entries_${date.year}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  // static String get _todayKey => _key(DateTime.now());

  // ─── LOAD ───────────────────────────────────────────────────────────────────
  /// Load all entries for [date]. Returns [] if nothing saved yet.
  static Future<List<FoodEntry>> loadForDate({DateTime? date}) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(date ?? DateTime.now()));
    if (raw == null) return [];
    final List list = jsonDecode(raw);
    return list
        .map((e) => FoodEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Convenience: load today's entries.
  static Future<List<FoodEntry>> loadToday() =>
      loadForDate(date: DateTime.now());

  // ─── SAVE (full list) ───────────────────────────────────────────────────────
  /// Overwrite the entire entry list for [date].
  static Future<void> saveAll(List<FoodEntry> entries, {DateTime? date}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key(date ?? DateTime.now()),
      jsonEncode(entries.map((e) => e.toJson()).toList()),
    );
  }

  // ─── ADD ────────────────────────────────────────────────────────────────────
  /// Prepend a single entry to the saved list for [date].
  static Future<void> addEntry(FoodEntry entry, {DateTime? date}) async {
    final existing = await loadForDate(date: date);
    existing.insert(0, entry);
    await saveAll(existing, date: date);
  }

  // ─── REMOVE ─────────────────────────────────────────────────────────────────
  /// Remove a single entry by [id] from the saved list for [date].
  static Future<void> removeEntry(String id, {DateTime? date}) async {
    final existing = await loadForDate(date: date);
    existing.removeWhere((e) => e.id == id);
    await saveAll(existing, date: date);
  }

  // ─── HISTORY ────────────────────────────────────────────────────────────────
  // Full history: { "yyyy-MM-dd" → List<FoodEntry> } for every saved date.
  static Future<Map<String, List<FoodEntry>>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final result = <String, List<FoodEntry>>{};

    for (final key in prefs.getKeys()) {
      if (!key.startsWith('entries_')) continue;
      final dateStr = key.replaceFirst('entries_', '');
      try {
        final raw = prefs.getString(key);
        if (raw != null) {
          final List list = jsonDecode(raw);
          result[dateStr] = list
              .map((e) => FoodEntry.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      } catch (_) {
        // skip malformed entries
      }
    }
    return result;
  }

  /// All dates that have saved entries, sorted newest → oldest.
  static Future<List<String>> savedDates() async {
    final all = await loadAll();
    return all.keys.toList()..sort((a, b) => b.compareTo(a));
  }

  // ─── DELETE ─────────────────────────────────────────────────────────────────
  /// Delete all entries for a specific date.
  static Future<void> deleteDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(date));
  }

  /// Wipe ALL entry data across every date.
  static Future<void> deleteAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs
        .getKeys()
        .where((k) => k.startsWith('entries_'))
        .toList();
    for (final k in keys) {
      await prefs.remove(k);
    }
  }
}
