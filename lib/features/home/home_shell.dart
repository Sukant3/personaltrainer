import 'package:flutter/material.dart';
import 'package:personaltrainer/core/models/exercise_model.dart';
import 'package:personaltrainer/features/goal/screens/goal_screen.dart';
import 'package:personaltrainer/features/workout/screens/workout_log_screen.dart';

import '../home/home_screen.dart';
// import '../workout/screens/workout_log_screen.dart';
import '../settings/screens/settings_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static final List<Exercise> sampleExercises = [
    Exercise(
      id: 'ex_bench',
      name: 'Barbell Bench Press',
      muscleGroup: 'Chest',
      equipment: 'Barbell',
      difficulty: 'Intermediate',
      description:
          'A classic compound movement for building chest strength and mass.',
      cues: 'Keep your back flat, lower bar slowly, and press explosively.',
      mediaUrl: 'https://media.giphy.com/media/3oKIPwoeGErMmaI43S/giphy.gif',
    ),
    Exercise(
      id: 'ex_row',
      name: 'Barbell Row',
      muscleGroup: 'Back',
      equipment: 'Barbell',
      difficulty: 'Intermediate',
      description: 'A core back exercise that builds mid and upper back muscles.',
      cues: 'Maintain a flat back and pull barbell towards your abdomen.',
      mediaUrl: 'https://media.giphy.com/media/l0HlPjezGYG5w3Xbq/giphy.gif',
    ),
    Exercise(
      id: 'ex_squat',
      name: 'Back Squat',
      muscleGroup: 'Legs',
      equipment: 'Barbell',
      difficulty: 'Intermediate',
      description:
          'Fundamental lower-body exercise that targets quads, glutes, and hamstrings.',
      cues: 'Keep your chest up and drive through your heels.',
      mediaUrl: 'https://media.giphy.com/media/26BRv0ThflsHCqDrG/giphy.gif',
    ),
    Exercise(
      id: 'ex_pushup',
      name: 'Push-Up',
      muscleGroup: 'Chest',
      equipment: 'Bodyweight',
      difficulty: 'Beginner',
      description: 'A simple yet effective upper-body bodyweight exercise.',
      cues: 'Keep your core tight and lower your chest close to the floor.',
      mediaUrl: 'https://media.giphy.com/media/26ufnwz3wDUli7GU0/giphy.gif',
    ),
    Exercise(
      id: 'ex_plank',
      name: 'Plank',
      muscleGroup: 'Core',
      equipment: 'Bodyweight',
      difficulty: 'Beginner',
      description: 'Core stabilization exercise that strengthens abs and shoulders.',
      cues: 'Keep your body in a straight line and tighten your core.',
      mediaUrl: 'https://media.giphy.com/media/l0MYt5jPR6QX5pnqM/giphy.gif',
    ),
  ];
final _pages = [
  const HomeScreen(),
  WorkoutLogScreen(exercise: sampleExercises[0]), // pass one exercise
  const GoalsScreen(),
  const SettingsScreen(),
];


  final _titles = const [
    "Home",
    "Workouts",
    "Goals",
    "Profile",
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index]),
        centerTitle: true,
        elevation: 3,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeInOut,
        child: _pages[_index],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: colorScheme.surface,
          indicatorColor: colorScheme.primary.withOpacity(0.15),
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              color: states.contains(WidgetState.selected)
                  ? colorScheme.primary
                  : Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        child: NavigationBar(
          height: 70,
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.fitness_center_outlined),
              selectedIcon: Icon(Icons.fitness_center_rounded),
              label: 'Workouts',
            ),
            NavigationDestination(
              icon: Icon(Icons.flag_outlined),
              selectedIcon: Icon(Icons.flag_rounded),
              label: 'Goals',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
