import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../state/app_state.dart';
import '../provider/change_notifier_provider.dart';
import 'welcome_page.dart';
import 'personal_page.dart';
import 'workout_page.dart';
import 'goal_page.dart';
import 'result_page.dart';

// ─── ONBOARDING FLOW ──────────────────────────────────────────────────────────
class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key, this.isUpdateProfile = false});
  final bool isUpdateProfile;

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _step = 0;
  final UserProfile _profile = UserProfile();
  final _pageController = PageController();

  void _next() {
    if (_step < 4) {
      setState(() => _step++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.read<AppState>().completeOnboarding(_profile);
    }
  }

  void _back() {
    if (_step > 0) {
      setState(() => _step--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<AppState>().load();
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EE),
      body: SafeArea(
        child: Consumer<AppState>(
          builder: (context, controller, child) {
            return PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                WelcomePage(onNext: _next),
                PersonalPage(
                  profile: widget.isUpdateProfile
                      ? controller.profile
                      : _profile,
                  onNext: _next,
                  onBack: _back,
                  progress: 0.25,
                ),
                WorkoutPage(
                  profile: widget.isUpdateProfile
                      ? controller.profile
                      : _profile,
                  onNext: _next,
                  onBack: _back,
                  progress: 0.50,
                ),
                GoalPage(
                  profile: widget.isUpdateProfile
                      ? controller.profile
                      : _profile,
                  onNext: _next,
                  onBack: _back,
                  progress: 0.75,
                ),
                ResultPage(
                  profile: widget.isUpdateProfile
                      ? controller.profile
                      : _profile,
                  onNext: _next,
                  onBack: _back,
                  progress: 1.0,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}



// age =
// 0
// gender =
// "male"
// goal =
// "maintain"
// goalCalories =
// 6
// hashCode =
// 293471241
// height =
// 0
// runtimeType =
// Type (UserProfile)
// targetWeight =
// 0
// tdee =
// 6
// weight =
// 0
// workoutDuration =
// 0



// weight =
// 0
// workoutDuration =
// 0
// workoutMins =
// 0
// workoutType =
// "light"
// workoutUnit =
// "mins"