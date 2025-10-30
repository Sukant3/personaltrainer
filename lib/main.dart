import 'package:flutter/material.dart';
import 'package:personaltrainer/features/home/home_shell.dart';
import 'theme/theme_notifier.dart';

// Screens
import 'features/home/home_shell.dart';
import 'features/workout/screens/workout_log_screen.dart';
import 'features/workout/screens/select_split_screen.dart';
import 'features/workout/screens/exercise_list_screen.dart';
import 'core/models/exercise_model.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/subscription/screens/subscription_screen.dart';
import 'features/subscription/screens/payment_success_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeNotifier.loadSavedTheme();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeNotifier,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Gym Tracker',
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorSchemeSeed: Colors.blue,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorSchemeSeed: Colors.blue,
          ),
          themeMode: themeNotifier.themeMode,

          // 🏠 Start at HomeShell (bottom navigation)
          home: const HomeShell(),

          routes: {
            '/select_split': (context) => const SelectSplitScreen(),
            '/exercises': (context) => const ExerciseListScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/subscription': (context) => const SubscriptionScreen(),
            '/payment_success': (context) => const PaymentSuccessScreen(),
          },

          // Dynamic route for workout log (with arguments)
          onGenerateRoute: (settings) {
            if (settings.name == '/workout_log') {
              final exercise = settings.arguments as Exercise;
              return MaterialPageRoute(
                builder: (_) => WorkoutLogScreen(exercise: exercise),
              );
            }
            return null;
          },
        );
      },
    );
  }
}
