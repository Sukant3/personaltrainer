// lib/features/workout/screens/exercise_list_screen.dart
import 'package:flutter/material.dart';
import '/core/models/exercise_model.dart';
import '../widgets/exercise_card.dart';

class ExerciseListScreen extends StatelessWidget {
  const ExerciseListScreen({Key? key}) : super(key: key);

  // ✅ Sample data updated to match Exercise model
  static final List<Exercise> sampleExercises = [
    Exercise(
      id: 'ex_bench',
      name: 'Barbell Bench Press',
      muscleGroup: 'Chest',
      equipment: 'Barbell',
      difficulty: 'Intermediate',
      description: 'A compound chest exercise targeting pectorals and triceps.',
      cues: 'Keep your feet flat, back tight, and press evenly.',
      mediaUrl: 'https://media.giphy.com/media/3oKIPwoeGErMmaI43S/giphy.gif',
      isVideo: false,
      defaultReps: 8,
      defaultRest: 90,
    ),
    Exercise(
      id: 'ex_row',
      name: 'Barbell Row',
      muscleGroup: 'Back',
      equipment: 'Barbell',
      difficulty: 'Intermediate',
      description: 'A pulling exercise that strengthens the lats and rhomboids.',
      cues: 'Keep your back straight, pull towards your waist.',
      mediaUrl: 'https://media.giphy.com/media/l0HlPjezGYG5w3Xbq/giphy.gif',
      isVideo: false,
      defaultReps: 10,
      defaultRest: 90,
    ),
    Exercise(
      id: 'ex_squat',
      name: 'Back Squat',
      muscleGroup: 'Legs',
      equipment: 'Barbell',
      difficulty: 'Intermediate',
      description: 'Targets quads, glutes, and hamstrings.',
      cues: 'Keep chest up, knees out, and descend under control.',
      mediaUrl: 'https://media.giphy.com/media/26BRv0ThflsHCqDrG/giphy.gif',
      isVideo: false,
      defaultReps: 8,
      defaultRest: 120,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};
    final split = args['split'] ?? 'Split';
    final day = args['day'] ?? 1;

    return Scaffold(
      appBar: AppBar(title: Text('$split — Day $day')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: sampleExercises.length,
        itemBuilder: (context, i) {
          final ex = sampleExercises[i];
          return ExerciseCard(
            exercise: ex,
            onTap: () {
              // Navigate to workout log screen
              Navigator.pushNamed(context, '/workout_log', arguments: ex);
            },
          );
        },
      ),
    );
  }
}
