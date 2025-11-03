import 'package:flutter/material.dart';
import 'workout_screen.dart';

class WorkoutCategoryScreen extends StatelessWidget {
  const WorkoutCategoryScreen({super.key});

  final List<Map<String, dynamic>> categories = const [
    {"name": "Push", "icon": Icons.fitness_center, "color": Colors.redAccent},
    {"name": "Pull", "icon": Icons.back_hand, "color": Colors.blueAccent},
    {"name": "Legs", "icon": Icons.directions_run, "color": Colors.green},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface, // ✅ Use theme background
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WorkoutScreen(category: category["name"]),
                  ),
                );
              },
              child: Card(
                color: colorScheme.surfaceContainerHighest, // ✅ Themed card color
                elevation: 3,
                shadowColor: colorScheme.shadow.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: category["color"].withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          category["icon"],
                          color: category["color"],
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          category["name"],
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface, // ✅ Adaptive text color
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: colorScheme.onSurfaceVariant, // ✅ Adaptive icon
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'workout_screen.dart';

// class WorkoutCategoryScreen extends StatelessWidget {
//   const WorkoutCategoryScreen({super.key});

//   final List<Map<String, dynamic>> categories = const [
//     {"name": "Push", "icon": Icons.fitness_center, "color": Colors.redAccent},
//     {"name": "Pull", "icon": Icons.back_hand, "color": Colors.blueAccent},
//     {"name": "Legs", "icon": Icons.directions_run, "color": Colors.green},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView.builder(
//         padding: const EdgeInsets.all(20),
//         itemCount: categories.length,
//         itemBuilder: (context, index) {
//           final category = categories[index];
//           return Card(
//             elevation: 4,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(14),
//             ),
//             margin: const EdgeInsets.symmetric(vertical: 12),
//             child: ListTile(
//               leading: CircleAvatar(
//                 backgroundColor: category["color"],
//                 child: Icon(category["icon"], color: Colors.white),
//               ),
//               title: Text(
//                 category["name"],
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//               trailing: const Icon(Icons.arrow_forward_ios_rounded),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => WorkoutScreen(category: category["name"]),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
