import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';
import 'state/app_state.dart';
import 'provider/change_notifier_provider.dart';
import 'onboarding/onboarding_flow.dart';
import 'screens/home_screen.dart';
import 'screens/add_food_screen.dart';
import 'screens/stats_screen.dart';
import 'widgets/bottom_nav.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  await dotenv.load(fileName: ".env");

  String apiKey = dotenv.env['api_key'] ?? "";
  Gemini.init(apiKey: apiKey);

  runApp(const NutriLogApp());
}

// ─── APP ROOT ─────────────────────────────────────────────────────────────────
class NutriLogApp extends StatelessWidget {
  const NutriLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'NutriLog',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.green),
          scaffoldBackgroundColor: AppColors.bg,
          textTheme: GoogleFonts.interTightTextTheme(),
          useMaterial3: true,
        ),
        home: const AppRouter(),
      ),
    );
  }
}

// ─── APP ROUTER ───────────────────────────────────────────────────────────────
class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (ctx, state, _) {
        if (!state.onboardingDone) return const OnboardingFlow();
        return const MainShell();
      },
    );
  }
}

// ─── MAIN SHELL ───────────────────────────────────────────────────────────────
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      const AddFoodScreen(),
      const StatsScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: screens[_tab],
      bottomNavigationBar: BottomNav(
        current: _tab,
        onTap: (i) => setState(() => _tab = i),
      ),
    );
  }
}
