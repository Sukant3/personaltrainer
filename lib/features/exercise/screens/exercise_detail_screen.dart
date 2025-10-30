import 'package:flutter/material.dart';
import '../../../core/models/exercise_model.dart';
import '../widgets/gif_viewer.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(exercise.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MediaViewer(url: exercise.mediaUrl, isVideo: exercise.isVideo),
            const SizedBox(height: 16),
            Text("Description", style: Theme.of(context).textTheme.titleLarge),
            Text(exercise.description),
            const SizedBox(height: 16),
            Text("Cues", style: Theme.of(context).textTheme.titleLarge),
            Text(exercise.cues),
            const SizedBox(height: 16),
            Text("Defaults", style: Theme.of(context).textTheme.titleLarge),
            Text("Reps: ${exercise.defaultReps}"),
            Text("Rest: ${exercise.defaultRest} sec"),
          ],
        ),
      ),
    );
  }
}
