import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:personaltrainer/theme/theme_notifier.dart';
import 'features/auth/viewmodels/auth_viewmodel.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/home/home_shell.dart';
import 'features/workout/screens/select_split_screen.dart';
import 'features/workout/screens/exercise_list_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/subscription/screens/subscription_screen.dart';
import 'features/subscription/screens/payment_success_screen.dart';
import 'core/models/exercise_model.dart';
import 'features/workout/screens/workout_log_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeNotifier.loadSavedTheme();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context);

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

          // 🧠 Check login state
          home: auth.isLoggedIn ? const HomeShell() : const LoginScreen(),

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
