import 'package:flutter/material.dart';
import '/core/models/program_model.dart';

class ProgramCard extends StatelessWidget {
  final ProgramModel program;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const ProgramCard({
    super.key,
    required this.program,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onEdit, // ✅ Tapping the card also opens edit
      borderRadius: BorderRadius.circular(12),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // ✅ Icon/avatar for program type
              CircleAvatar(
                backgroundColor: Colors.blueAccent.withOpacity(0.1),
                radius: 24,
                child: Icon(
                  Icons.fitness_center,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(width: 16),

              // ✅ Program details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program.name.isEmpty ? 'Untitled Program' : program.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${program.splitType} • ${program.exercises.length} exercises',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              // ✅ Edit & Delete actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: "Edit Program",
                    onPressed: onEdit,
                  ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      tooltip: "Delete Program",
                      onPressed: onDelete,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
