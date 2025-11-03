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
    // Detect theme
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Determine image source (local or network)
    final localImageMap = {
      'Barbell Bench Press': 'assets/images/Barbell-Bench-Press.gif',
      'Squat': 'assets/images/Squat.gif',
      'Deadlift': 'assets/images/Deadlift.gif',
    };

    final localImagePath = localImageMap[exercise.name];

    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 4,
      shadowColor: isDark ? Colors.white10 : Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Local GIF if available, else network image
            localImagePath != null
                ? Image.asset(
                    localImagePath,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : CachedNetworkImage(
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
                  Text(
                    "${exercise.muscleGroup.isNotEmpty ? exercise.muscleGroup : 'General'} • ${exercise.difficulty}",
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[700],
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    exercise.equipment,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.deepPurpleAccent,
                      fontWeight: FontWeight.w600,
                    ),
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

//   const ExerciseCard({
//     super.key,
//     required this.exercise,
//     required this.onTap,
//   });

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
//               errorWidget: (context, url, error) => const Icon(
//                 Icons.broken_image,
//                 size: 80,
//                 color: Colors.grey,
//               ),
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

//                   // ✅ Display muscle group + difficulty
//                   Text(
//                     "${exercise.muscleGroup.isNotEmpty ? exercise.muscleGroup : 'General'} • ${exercise.difficulty}",
//                     style: TextStyle(color: Colors.grey[600]),
//                   ),

//                   const SizedBox(height: 8),

//                   // ✅ Display equipment (if any)
//                   Text(
//                     exercise.equipment,
//                     style: const TextStyle(
//                       fontSize: 13,
//                       color: Colors.deepPurpleAccent,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }