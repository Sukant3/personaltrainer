import 'package:flutter/material.dart';
import '../../../core/models/exercise_model.dart';

class ExerciseTile extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const ExerciseTile({
    super.key,
    required this.exercise,
    this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 56,
        height: 56,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            exercise.mediaUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: Colors.grey[300]),
          ),
        ),
      ),
      title: Text(exercise.name),
      subtitle: Text('${exercise.muscleGroup} • ${exercise.equipment}'),
      trailing: onRemove != null
          ? IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onRemove,
            )
          : null,
      onTap: onTap,
    );
  }
}
