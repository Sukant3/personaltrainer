import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/models/exercise_model.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onTap;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: exercise.mediaUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(
                Icons.broken_image,
                size: 80,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // ✅ Display muscle group + difficulty
                  Text(
                    "${exercise.muscleGroup.isNotEmpty ? exercise.muscleGroup : 'General'} • ${exercise.difficulty}",
                    style: TextStyle(color: Colors.grey[600]),
                  ),

                  const SizedBox(height: 8),

                  // ✅ Display equipment (if any)
                  if (exercise.equipment.isNotEmpty)
                    Chip(
                      label: Text(exercise.equipment),
                      backgroundColor: Colors.grey[200],
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import '../../../core/models/exercise_model.dart';

// class ExerciseCard extends StatelessWidget {
//   final Exercise exercise;
//   final VoidCallback onTap;

//   const ExerciseCard({super.key, required this.exercise, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.all(10),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CachedNetworkImage(
//               imageUrl: exercise.mediaUrl,
//               height: 180,
//               width: double.infinity,
//               fit: BoxFit.cover,
//               placeholder: (context, url) => const Center(
//                 child: CircularProgressIndicator(),
//               ),
//               errorWidget: (context, url, error) =>
//                   const Icon(Icons.broken_image, size: 80, color: Colors.grey),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     exercise.name,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 4),

//                   // ✅ Show first muscle group (or all tags)
//                   Text(
//                     "${exercise.muscleTags.isNotEmpty ? exercise.muscleTags.join(', ') : 'General'} • ${exercise.difficulty}",
//                     style: TextStyle(color: Colors.grey[600]),
//                   ),

//                   const SizedBox(height: 8),

//                   // ✅ Small chips for each tag (optional, nice UI touch)
//                   Wrap(
//                     spacing: 6,
//                     children: [
//                       ...exercise.muscleTags.map(
//                         (t) => Chip(
//                           label: Text(t),
//                           backgroundColor: Colors.grey[200],
//                           visualDensity: VisualDensity.compact,
//                         ),
//                       ),
//                       ...exercise.equipment.map(
//                         (e) => Chip(
//                           label: Text(e),
//                           backgroundColor: Colors.grey[100],
//                           visualDensity: VisualDensity.compact,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
