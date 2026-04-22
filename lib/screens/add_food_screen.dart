import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:nutilog/utils/helper_function.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:google_generative_ai/google_generative_ai.dart';
import '../colors.dart';
import '../models/food_entry.dart';
import '../provider/change_notifier_provider.dart';
import '../state/app_state.dart';

enum ApiErrorType {
  badRequest, // 400 INVALID_ARGUMENT
  billingRequired, // 400 FAILED_PRECONDITION
  permissionDenied, // 403
  notFound, // 404
  rateLimit, // 429
  serverError, // 500
  unavailable, // 503
  timeout, // 504
  unknown,
}

// ─── ADD FOOD SCREEN ──────────────────────────────────────────────────────────
class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  String _meal = 'Lunch';
  final _controller = TextEditingController();
  bool _loading = false;
  Map<String, dynamic>? _result;

  static const _prefsKey = 'quick_add_suggestions';
  static const _defaultSuggestions = [
    '🥑 Avocado toast',
    '🍌 Banana smoothie',
    '🥚 2 boiled eggs',
    '🍚 Brown rice bowl',
    '🥜 Peanut butter',
    '🍎 Apple',
  ];

  List<String> _suggestions = [];
  final Set<String> _selectedSuggestions = {};
  bool _editMode = false;

  final _mealEmojis = {
    'Breakfast': '🍳',
    'Lunch': '🥗',
    'Dinner': '🍽️',
    'Snack': '🍎',
  };

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
  }

  Future<void> _loadSuggestions() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_prefsKey);
    setState(() {
      _suggestions = saved ?? List.from(_defaultSuggestions);
    });
  }

  Future<void> _saveSuggestions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, _suggestions);
  }

  void _deleteSuggestion(String s) {
    setState(() {
      _suggestions.remove(s);
      _selectedSuggestions.remove(s);
    });
    _saveSuggestions();
  }

  void _addCustomSuggestion(String text) {
    if (text.trim().isEmpty) return;
    setState(() => _suggestions.add(text.trim()));
    _saveSuggestions();
  }

  String _labelText(String s) {
    final parts = s.split(' ');
    if (parts.length > 1 && !parts[0].contains(RegExp(r'[a-zA-Z]'))) {
      return parts.skip(1).join(' ');
    }
    return s;
  }

  void _applySelected() {
    if (_selectedSuggestions.isEmpty) return;
    setState(() {
      _controller.text = _selectedSuggestions.map(_labelText).join(', ');
      _selectedSuggestions.clear();
    });
  }

  void _showAddSuggestionSheet() {
    final tc = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Quick Item',
              style: interTight(size: 16, weight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'You can include an emoji prefix, e.g. 🥗 Greek salad',
              style: interTight(size: 12, color: AppColors.muted),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: tc,
              autofocus: true,
              style: interTight(size: 14),
              decoration: InputDecoration(
                hintText: '🥗 Salad',
                hintStyle: interTight(size: 14, color: AppColors.muted),
                filled: true,
                fillColor: AppColors.inputBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
              ),
              onSubmitted: (val) {
                _addCustomSuggestion(val);
                Navigator.pop(ctx);
              },
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                _addCustomSuggestion(tc.text);
                Navigator.pop(ctx);
              },
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.dark,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    'Add',
                    style: interTight(
                      size: 14,
                      weight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> _estimate() async {
  //   if (_controller.text.trim().isEmpty) return;
  //   setState(() { _loading = true; _result = null; });
  //   try {
  //     final res = await http.post(
  //       Uri.parse('https://api.anthropic.com/v1/messages'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'anthropic-version': '2023-06-01',
  //         'x-api-key': 'YOUR_API_KEY_HERE', // 🔑 Replace with your key
  //       },
  //       body: jsonEncode({
  //         'model': 'claude-haiku-4-5-20251001',
  //         'max_tokens': 300,
  //         'system':
  //             'You are a nutrition expert. Respond ONLY with valid JSON: {"calories":<number>,"food":"<short description>","protein":<grams>,"carbs":<grams>,"fat":<grams>}. No markdown, no extra text.',
  //         'messages': [{'role': 'user', 'content': _controller.text}],
  //       }),
  //     );
  //     if (res.statusCode == 200) {
  //       final data = jsonDecode(res.body);
  //       final text = (data['content'] as List).map((b) => b['text'] ?? '').join('');
  //       setState(() { _result = jsonDecode(text); _loading = false; });
  //     } else {
  //       throw Exception('API error ${res.statusCode}');
  //     }
  //   } catch (_) {
  //     // Demo fallback — randomised estimate
  //     setState(() {
  //       _result = {
  //         'calories': 200 + Random().nextInt(300),
  //         'food': _controller.text,
  //         'protein': 12, 'carbs': 28, 'fat': 8,
  //       };
  //       _loading = false;
  //     });
  //   }
  // }

  // Future<void> _estimate() async {
  //   if (_controller.text.trim().isEmpty) return;
  //   setState(() {
  //     _loading = true;
  //     _result = null;
  //   });

  //   try {
  //     final model = GenerativeModel(
  //       model: 'gemini-1.5-flash', // or 'gemini-1.5-pro'
  //       apiKey:
  //           'AIzaSyBaKdXJqlW-oASXFh8_NHkf7AJi-iAo4tg', // 🔑 Replace with your key
  //       systemInstruction: Content.system(
  //         'You are a nutrition expert. Respond ONLY with valid JSON: '
  //         '{"calories":<number>,"food":"<short description>","protein":<grams>,'
  //         '"carbs":<grams>,"fat":<grams>}. No markdown, no extra text.',
  //       ),
  //       generationConfig: GenerationConfig(
  //         responseMimeType: 'application/json', // forces JSON output
  //         maxOutputTokens: 300,
  //       ),
  //     );

  //     final response = await model.generateContent([
  //       Content.text(_controller.text),
  //     ]);

  //     final text = response.text ?? '';
  //     setState(() {
  //       _result = jsonDecode(text);
  //       _loading = false;
  //     });
  //   } catch (e) {
  //     // Demo fallback — randomised estimate
  //     debugPrint(e.toString());
  //     setState(() {
  //       _result = {
  //         'calories': 200 + Random().nextInt(300),
  //         'food': _controller.text,
  //         'protein': 12,
  //         'carbs': 28,
  //         'fat': 8,
  //       };
  //       _loading = false;
  //     });
  //   }
  // }

  Future<void> _estimate() async {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _loading = true;
      _result = null;
    });

    try {
      final gemini = Gemini.instance;

      final response = await gemini.prompt(
        model: "gemini-2.5-flash", // or 'gemini-1.5-pro'
        parts: [
          Part.text(
            'You are a nutrition expert. Respond ONLY with valid JSON: '
            '{"calories":<number>,"food":"<short description>","protein":<grams>,'
            '"carbs":<grams>,"fat":<grams>}. No markdown, no extra text.\n\n'
            '${_controller.text}',
          ),
        ],
      );

      final text = response?.output ?? '';
      setState(() {
        _result = jsonDecode(text);
        debugPrint(_result.toString());
        _controller.clear();
        _loading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      final type = detectApiError(e.toString());
      final userMessage = getUserMessage(type);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(userMessage), backgroundColor: Colors.red),
      );
      _loading = false;
    }
  }

  ApiErrorType detectApiError(String error) {
    if (error.contains("400")) return ApiErrorType.badRequest;
    // if (error.contains("FAILED_PRECONDITION")) return ApiErrorType.billingRequired;
    if (error.contains("403")) return ApiErrorType.permissionDenied;
    if (error.contains("404")) return ApiErrorType.notFound;
    if (error.contains("429")) return ApiErrorType.rateLimit;
    if (error.contains("500")) return ApiErrorType.serverError;
    if (error.contains("503")) return ApiErrorType.unavailable;
    if (error.contains("504")) return ApiErrorType.timeout;

    return ApiErrorType.unknown;
  }

  String getUserMessage(ApiErrorType type) {
    switch (type) {
      case ApiErrorType.badRequest:
        return "Invalid input. Try simpler food description.";

      case ApiErrorType.billingRequired:
        return "Service not available. Try again later.";

      case ApiErrorType.permissionDenied:
        return "App configuration error. Please contact support.";

      case ApiErrorType.notFound:
        return "Requested data not found.";

      case ApiErrorType.rateLimit:
        return "Too many requests. Please wait a moment.";

      case ApiErrorType.serverError:
        return "Server error. Trying again may fix it.";

      case ApiErrorType.unavailable:
        return "Service is busy. Try again shortly.";

      case ApiErrorType.timeout:
        return "Request took too long. Try shorter input.";

      default:
        return "Something went wrong.";
    }
  }

  void _addEntry() {
    if (_result == null) return;
    final now = TimeOfDay.now();
    final time =
        '${now.hourOfPeriod}:${now.minute.toString().padLeft(2, '0')} ${now.period.name.toUpperCase()}';
    context.read<AppState>().addEntry(
      FoodEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        food: _result!['food'] ?? _controller.text,
        calories: (_result!['calories'] as num).toDouble(),
        meal: _meal,
        time: time,
        emoji: _mealEmojis[_meal] ?? '🍽️',
        protein: (_result!['protein'] as num).toDouble(),
        carbs: (_result!['carbs'] as num).toDouble(),
        fat: (_result!['fat'] as num).toDouble(),
      ),
    );
    setState(() {
      _result = null;
      _controller.clear();
    });
  }

  Color _mealColor(String m) {
    switch (m) {
      case 'Breakfast':
        return AppColors.breakfastDot;
      case 'Lunch':
        return AppColors.lunchDot;
      case 'Dinner':
        return AppColors.dinnerDot;
      default:
        return AppColors.snackDot;
    }
  }

  Color _mealBg(String m) {
    switch (m) {
      case 'Breakfast':
        return AppColors.breakfastBg;
      case 'Lunch':
        return AppColors.lunchBg;
      case 'Dinner':
        return AppColors.dinnerBg;
      default:
        return AppColors.snackBg;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Text(
                  'Log Food',
                  style: interTight(size: 22, weight: FontWeight.w800),
                ),
                Text(
                  'AI-powered calorie estimation',
                  style: interTight(size: 12, color: AppColors.muted),
                ),
                const SizedBox(height: 20),

                // Meal selector tabs
                Row(
                  children: ['Breakfast', 'Lunch', 'Dinner', 'Snack']
                      .map(
                        (m) => Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: m != 'Snack' ? 6 : 0,
                            ),
                            child: GestureDetector(
                              onTap: () => setState(() => _meal = m),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: _meal == m ? _mealBg(m) : Colors.white,
                                  border: Border.all(
                                    color: _meal == m
                                        ? _mealColor(m)
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: HelperFunction.colorWithOpacity(
                                        Colors.black,
                                        0.04,
                                      ),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    m,
                                    style: interTight(
                                      size: 11,
                                      weight: FontWeight.w700,
                                      color: _meal == m
                                          ? _mealColor(m)
                                          : AppColors.muted,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 14),

                // AI input card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: HelperFunction.colorWithOpacity(
                          Colors.black,
                          0.07,
                        ),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.greenLight,
                                  AppColors.greenDark,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text('✨', style: TextStyle(fontSize: 18)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'DESCRIBE WHAT YOU ATE',
                                  style: interTight(
                                    size: 11,
                                    weight: FontWeight.w600,
                                    color: AppColors.muted,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: _controller,
                                  maxLines: 3,
                                  minLines: 2,
                                  style: interTight(
                                    size: 14,
                                    weight: FontWeight.w500,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText:
                                        'e.g. 2 scrambled eggs with toast and butter...',
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Divider(color: AppColors.border, height: 1),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            if (!_loading ||
                                _controller.text.trim().isNotEmpty) {
                              _estimate();
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  _controller.text.trim().isNotEmpty &&
                                      !_loading
                                  ? AppColors.dark
                                  : AppColors.inputBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_loading)
                                  const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.muted,
                                    ),
                                  )
                                else
                                  const Text(
                                    '✦ ',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                Text(
                                  _loading
                                      ? ' Analysing...'
                                      : 'Estimate Calories',
                                  style: interTight(
                                    size: 13,
                                    weight: FontWeight.w700,
                                    color:
                                        _controller.text.trim().isNotEmpty &&
                                            !_loading
                                        ? Colors.white
                                        : AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Result card
                if (_result != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.greenBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: HelperFunction.colorWithOpacity(
                          AppColors.green,
                          0.2,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('✦ ', style: TextStyle(fontSize: 16)),
                            Text(
                              "Claude's Estimate",
                              style: interTight(
                                size: 13,
                                weight: FontWeight.w700,
                                color: AppColors.greenText,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.green,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'High confidence',
                                style: interTight(
                                  size: 10,
                                  weight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${_result!['food']}',
                                style: interTight(
                                  size: 13,
                                  weight: FontWeight.w500,
                                  color: const Color(0xFF2D6A4F),
                                ),
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${_result!['calories']}',
                                    style: interTight(
                                      size: 34,
                                      weight: FontWeight.w800,
                                      color: AppColors.greenText,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' kcal',
                                    style: interTight(
                                      size: 12,
                                      weight: FontWeight.w500,
                                      color: AppColors.greenText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _miniMacro(
                              '${_result!['protein']}g',
                              'Protein',
                              AppColors.red,
                            ),
                            const SizedBox(width: 8),
                            _miniMacro(
                              '${_result!['carbs']}g',
                              'Carbs',
                              AppColors.orange,
                            ),
                            const SizedBox(width: 8),
                            _miniMacro(
                              '${_result!['fat']}g',
                              'Fat',
                              AppColors.purple,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: _addEntry,
                          child: Container(
                            width: double.infinity,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.green,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: HelperFunction.colorWithOpacity(
                                    AppColors.green,
                                    0.35,
                                  ),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '✓  Add to Log',
                                style: interTight(
                                  size: 14,
                                  weight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Quick suggestions
                if (_result == null) ...[
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        'QUICK ADD',
                        style: interTight(
                          size: 11,
                          weight: FontWeight.w700,
                          color: AppColors.muted,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const Spacer(),
                      if (_selectedSuggestions.isNotEmpty)
                        GestureDetector(
                          onTap: _applySelected,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.dark,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Add ${_selectedSuggestions.length} selected',
                              style: interTight(
                                size: 11,
                                weight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      else ...[
                        GestureDetector(
                          onTap: () => setState(() {
                            _editMode = !_editMode;
                            _selectedSuggestions.clear();
                          }),
                          child: Icon(
                            _editMode
                                ? Icons.check_rounded
                                : Icons.edit_outlined,
                            size: 16,
                            color: AppColors.muted,
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: _showAddSuggestionSheet,
                          child: const Icon(
                            Icons.add_rounded,
                            size: 18,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _suggestions.map((s) {
                      final isSelected = _selectedSuggestions.contains(s);
                      return GestureDetector(
                        onTap: _editMode
                            ? null
                            : () => setState(() {
                                if (isSelected) {
                                  _selectedSuggestions.remove(s);
                                } else {
                                  _selectedSuggestions.add(s);
                                }
                              }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.dark : Colors.white,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.dark
                                  : AppColors.border,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                s,
                                style: interTight(
                                  size: 13,
                                  weight: FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF4A453E),
                                ),
                              ),
                              if (_editMode) ...[
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () => _deleteSuggestion(s),
                                  child: const Icon(
                                    Icons.close_rounded,
                                    size: 14,
                                    color: AppColors.muted,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _miniMacro(String val, String label, Color color) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            val,
            style: interTight(size: 14, weight: FontWeight.w800, color: color),
          ),
          Text(label, style: interTight(size: 9, color: AppColors.muted)),
        ],
      ),
    ),
  );
  @override
  dispose() {
    _controller.clear();
    super.dispose();
  }
}
