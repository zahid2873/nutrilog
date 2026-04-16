import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nutilog/utils/helper_function.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
import '../colors.dart';
import '../models/food_entry.dart';
import '../state/app_state.dart';
import '../provider/change_notifier_provider.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

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

  final _suggestions = [
    '🥑 Avocado toast',
    '🍌 Banana smoothie',
    '🥚 2 boiled eggs',
    '🍚 Brown rice bowl',
    '🥜 Peanut butter',
    '🍎 Apple',
  ];
  final _mealEmojis = {
    'Breakfast': '🍳',
    'Lunch': '🥗',
    'Dinner': '🍽️',
    'Snack': '🍎',
  };

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
        model: "",
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

        _loading = false;
      });
    } catch (e) {
      // Demo fallback — randomised estimate
      debugPrint(e.toString());
      setState(() {
        _result = {
          'calories': 200 + Random().nextInt(300),
          'food': _controller.text,
          'protein': 12,
          'carbs': 28,
          'fat': 8,
        };
        _loading = false;
      });
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
                          padding: EdgeInsets.only(right: m != 'Snack' ? 6 : 0),
                          child: GestureDetector(
                            onTap: () => setState(() => _meal = m),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
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
                        onTap: _loading || _controller.text.trim().isEmpty
                            ? null
                            : _estimate,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color:
                                _controller.text.trim().isNotEmpty && !_loading
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
                Text(
                  'QUICK ADD',
                  style: interTight(
                    size: 11,
                    weight: FontWeight.w700,
                    color: AppColors.muted,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _suggestions
                      .map(
                        (s) => GestureDetector(
                          onTap: () => setState(
                            () => _controller.text = s
                                .split(' ')
                                .skip(1)
                                .join(' '),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              s,
                              style: interTight(
                                size: 13,
                                weight: FontWeight.w500,
                                color: const Color(0xFF4A453E),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],

              const SizedBox(height: 20),
            ],
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
}
