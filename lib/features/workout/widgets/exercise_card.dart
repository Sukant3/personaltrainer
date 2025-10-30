import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/core/models/exercise_model.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback? onTap;

  const ExerciseCard({required this.exercise, this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // ✅ Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 96,
                  height: 64,
                  child: CachedNetworkImage(
                    imageUrl: exercise.mediaUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: Colors.grey[200]),
                    errorWidget: (_, __, ___) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, size: 28),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // ✅ Exercise Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),

                    // ✅ Tags row (muscle group, equipment, difficulty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        if (exercise.muscleGroup.isNotEmpty)
                          _tagChip(exercise.muscleGroup),
                        if (exercise.equipment.isNotEmpty)
                          _tagChip(exercise.equipment),
                        _tagChip(exercise.difficulty),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // ✅ Chevron
              Icon(Icons.chevron_right, color: Colors.grey[600]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tagChip(String text) => Chip(
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        label: Text(
          text,
          style: const TextStyle(fontSize: 12),
        ),
      );
}
