import 'package:flutter/material.dart';
import '../../../core/models/exercise_model.dart';
import 'workout_log_screen.dart';
import '../widgets/exercise_card.dart';

class WorkoutScreen extends StatelessWidget {
  final String category;
  const WorkoutScreen({super.key, required this.category});

  // Example exercises for each category
  List<Exercise> getExercisesForCategory(String category) {
    switch (category) {
      case 'Push':
        return [
          Exercise(
            id: 'ex_bench',
            name: 'Barbell Bench Press',
            muscleGroup: ['Chest'],
            equipment: 'Barbell',
            difficulty: 'Intermediate',
            description: 'Build your chest and triceps.',
            cues: 'Keep your back flat, lower bar slowly, press explosively.',
            mediaUrl: 'assets/images/Barbell-Bench-Press.gif',
          ),
          Exercise(
            id: 'ex_shoulder',
            name: 'Overhead Shoulder Press',
            muscleGroup: ['Shoulders'],
            equipment: 'Dumbbells',
            difficulty: 'Intermediate',
            description: 'Strengthens shoulders and triceps.',
            cues: 'Avoid arching your back.',
            mediaUrl: 'https://media.giphy.com/media/26BRuo6sLetdllPAQ/giphy.gif',
          ),
        ];
      case 'Pull':
        return [
          Exercise(
            id: 'ex_row',
            name: 'Barbell Row',
            muscleGroup: ['Back'],
            equipment: 'Barbell',
            difficulty: 'Intermediate',
            description: 'Targets the middle and upper back.',
            cues: 'Keep your back straight and pull towards the abdomen.',
            mediaUrl: 'https://media.giphy.com/media/l0HlPjezGYG5w3Xbq/giphy.gif',
          ),
          Exercise(
            id: 'ex_pullup',
            name: 'Pull-Up',
            muscleGroup: ['Back'],
            equipment: 'Bodyweight',
            difficulty: 'Intermediate',
            description: 'Strengthens lats and biceps.',
            cues: 'Pull chest to bar and control the descent.',
            mediaUrl: 'https://media.giphy.com/media/3o6Zt8MgUuvSbkZYWc/giphy.gif',
          ),
        ];
      case 'Legs':
        return [
          Exercise(
            id: 'ex_squat',
            name: 'Back Squat',
            muscleGroup: ['Legs'],
            equipment: 'Barbell',
            difficulty: 'Intermediate',
            description: 'Builds quads, glutes, and hamstrings.',
            cues: 'Keep chest up and drive through heels.',
            mediaUrl: 'https://media.giphy.com/media/26BRv0ThflsHCqDrG/giphy.gif',
          ),
          Exercise(
            id: 'ex_lunge',
            name: 'Lunges',
            muscleGroup: ['Legs'],
            equipment: 'Bodyweight',
            difficulty: 'Beginner',
            description: 'Improves balance and leg strength.',
            cues: 'Step forward and keep torso upright.',
            mediaUrl: 'https://media.giphy.com/media/3oEjI6SIIHBdRxXI40/giphy.gif',
          ),
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercises = getExercisesForCategory(category);

    return Scaffold(
      appBar: AppBar(
        title: Text("$category Workout"),
      ),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return ExerciseCard(
            exercise: exercise,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WorkoutLogScreen(exercise: exercise),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
