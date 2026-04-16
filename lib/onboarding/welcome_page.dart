import 'package:flutter/material.dart';
import 'package:nutilog/utils/helper_function.dart';
import '../colors.dart';
import 'onboarding_helpers.dart';

// ─── WELCOME PAGE (Step 0) ────────────────────────────────────────────────────
class WelcomePage extends StatelessWidget {
  final VoidCallback onNext;
  const WelcomePage({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          const Text('🌿', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 20),
          Text(
            'Welcome to',
            style: interTight(
              size: 13,
              weight: FontWeight.w600,
              color: AppColors.muted,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'NutriLog',
            style: interTight(size: 42, weight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          Text(
            'Your AI-powered calorie tracker. Tell us about yourself so we can calculate your personal calorie goal.',
            style: interTight(size: 15, color: AppColors.muted, height: 1.6),
          ),
          const SizedBox(height: 32),
          ...[
            '📊  Personalised calorie targets',
            '🤖  AI-powered food logging',
            '📉  Track deficit & surplus daily',
          ].map(
            (f) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: HelperFunction.colorWithOpacity(Colors.black, 0.05),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(f.split('  ')[0], style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Text(
                    f.split('  ')[1],
                    style: interTight(
                      size: 13,
                      weight: FontWeight.w500,
                      color: const Color(0xFF4A453E),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          buildPrimaryBtn('Get Started →', onNext),
        ],
      ),
    );
  }
}
