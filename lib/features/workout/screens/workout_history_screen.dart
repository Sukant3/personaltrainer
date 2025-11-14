import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:async/async.dart'; // for StreamZip

class WorkoutHistoryScreen extends StatefulWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  State<WorkoutHistoryScreen> createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  DateTime? selectedDate;

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // ✅ Main stream function (handles both filtered and all-date view)
  Stream<List<QuerySnapshot>> _combinedWorkoutStream() async* {
  // get uid in a null-safe way
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) {
    // no signed-in user — emit empty list and return
    yield [];
    return;
  }

  final firestore = FirebaseFirestore.instance;
  final logsRef = firestore.collection('users').doc(uid).collection('workoutLogs');

  // If date selected, fetch only that day's exercises
  if (selectedDate != null) {
    final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate!);
    final exercisesStream = logsRef
        .doc(dateStr)
        .collection('exercises')
        .orderBy('timestamp', descending: true)
        .snapshots();

    await for (final snapshot in exercisesStream) {
      yield [snapshot];
    }
    return;
  }

  // Else, fetch ALL workoutLogs and combine their exercise subcollections
  final logDocs = await logsRef.get();

  if (logDocs.docs.isEmpty) {
    yield [];
    return;
  }

  final streams = logDocs.docs
      .map((doc) =>
          doc.reference.collection('exercises').orderBy('timestamp', descending: true).snapshots())
      .toList();

  // combine all subcollection streams
  await for (final snapshots in StreamZip(streams)) {
    yield snapshots;
  }
}

  Future<void> _deleteExercise(DocumentSnapshot doc) async {
    try {
      await doc.reference.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workout deleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('No user logged in.', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2C),
        title: const Text('Workout History', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () => _pickDate(context),
          ),
          if (selectedDate != null)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.redAccent),
              tooltip: 'Clear date filter',
              onPressed: () => setState(() => selectedDate = null),
            ),
        ],
      ),
      body: StreamBuilder<List<QuerySnapshot>>(
        stream: _combinedWorkoutStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.purpleAccent),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                selectedDate == null
                    ? 'No workout history found.'
                    : 'No workouts on ${DateFormat('yyyy-MM-dd').format(selectedDate!)}',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          // 🧠 Combine all exercise docs from all QuerySnapshots
          final allDocs = snapshot.data!.expand((qs) => qs.docs).toList();

          if (allDocs.isEmpty) {
            return const Center(
              child: Text('No workout history found.',
                  style: TextStyle(color: Colors.white70, fontSize: 16)),
            );
          }

          // 🗓️ Group by date
          final grouped = <String, List<DocumentSnapshot>>{};
          for (var doc in allDocs) {
            final data = doc.data() as Map<String, dynamic>? ?? {};
            final date = data['date']?.toString() ?? 'Unknown';
            grouped.putIfAbsent(date, () => []).add(doc);
          }

          final sortedDates = grouped.keys.toList()
            ..sort((a, b) => b.compareTo(a)); // latest first

          return ListView.builder(
            itemCount: sortedDates.length,
            itemBuilder: (context, index) {
              final date = sortedDates[index];
              final exercises = grouped[date]!;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  color: const Color(0xFF1E1E2C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🗓️ $date',
                          style: const TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...exercises.map((exerciseDoc) {
                          final data =
                              exerciseDoc.data() as Map<String, dynamic>? ?? {};
                          final sets = data['sets'] ?? [];
                          final exerciseName =
                              data['exerciseName'] ?? 'Unknown Exercise';
                          final note = data['note'] ?? '';

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      exerciseName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.blueAccent,
                                          ),
                                          onPressed: () {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Edit feature coming soon!'),
                                            ));
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.redAccent,
                                          ),
                                          onPressed: () =>
                                              _deleteExercise(exerciseDoc),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                if (note.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Text(
                                      '📝 Note: $note',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ...sets.map<Widget>((set) {
                                  final setId = set['id'] ?? '';
                                  final weight = set['weight'] ?? '-';
                                  final reps = set['reps'] ?? '-';
                                  final rpe = set['rpe'] ?? '-';
                                  return Text(
                                    'Set $setId: ${weight}kg × ${reps} reps (RPE: $rpe)',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}




// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class WorkoutHistoryScreen extends StatefulWidget {
//   const WorkoutHistoryScreen({super.key});

//   @override
//   State<WorkoutHistoryScreen> createState() => _WorkoutHistoryScreenState();
// }

// class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
//   DateTime? selectedDate;

//   Future<void> _pickDate(BuildContext context) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2024, 1, 1),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }

//   Stream<QuerySnapshot> _workoutStream() {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       return const Stream.empty();
//     }

//     final query = FirebaseFirestore.instance
//         .collectionGroup('exercises')
//         .where('userId', isEqualTo: user.uid)
//         .orderBy('date', descending: true);

//     return query.snapshots();
//   }

//   Future<void> _deleteExercise(DocumentSnapshot doc) async {
//     try {
//       await doc.reference.delete();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Workout deleted')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to delete: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     if (user == null) {
//       return const Scaffold(
//         body: Center(
//           child: Text(
//             'No user logged in.',
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//       );
//     }

//     return Scaffold(
//       backgroundColor: const Color(0xFF0E0E12),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1E1E2C),
//         title: const Text(
//           'Workout History',
//           style: TextStyle(color: Colors.white),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.calendar_today, color: Colors.white),
//             onPressed: () => _pickDate(context),
//           ),
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _workoutStream(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(color: Colors.purpleAccent),
//             );
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text(
//                 'No workout history found.',
//                 style: TextStyle(color: Colors.white70, fontSize: 16),
//               ),
//             );
//           }

//           final allDocs = snapshot.data!.docs;

//           // Filter by selected date (if any)
//           final filteredDocs = selectedDate == null
//               ? allDocs
//               : allDocs.where((doc) {
//                   final data = doc.data() as Map<String, dynamic>?;
//                   final docDate = data?['date'];
//                   if (docDate == null) return false;
//                   return docDate == DateFormat('yyyy-MM-dd').format(selectedDate!);
//                 }).toList();

//           // Group by date
//           final grouped = <String, List<DocumentSnapshot>>{};
//           for (var doc in filteredDocs) {
//             final data = doc.data() as Map<String, dynamic>?;
//             final date = data?['date'] ?? 'Unknown';
//             grouped.putIfAbsent(date, () => []).add(doc);
//           }

//           final sortedDates = grouped.keys.toList()
//             ..sort((a, b) => b.compareTo(a)); // latest first

//           return ListView.builder(
//             itemCount: sortedDates.length,
//             itemBuilder: (context, index) {
//               final date = sortedDates[index];
//               final exercises = grouped[date]!;

//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 child: Card(
//                   color: const Color(0xFF1E1E2C),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           '🗓️ $date',
//                           style: const TextStyle(
//                             color: Colors.purpleAccent,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         ...exercises.map((exerciseDoc) {
//                           final data =
//                               exerciseDoc.data() as Map<String, dynamic>? ?? {};
//                           final sets = data['sets'] ?? [];
//                           final exerciseName =
//                               data['exerciseName'] ?? 'Unknown Exercise';

//                           return Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 8),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       exerciseName,
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     Row(
//                                       children: [
//                                         IconButton(
//                                           icon: const Icon(Icons.edit,
//                                               color: Colors.blueAccent),
//                                           onPressed: () {
//                                             ScaffoldMessenger.of(context)
//                                                 .showSnackBar(const SnackBar(
//                                                     content: Text(
//                                                         'Edit feature coming soon!')));
//                                           },
//                                         ),
//                                         IconButton(
//                                           icon: const Icon(Icons.delete,
//                                               color: Colors.redAccent),
//                                           onPressed: () =>
//                                               _deleteExercise(exerciseDoc),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 ...sets.map<Widget>((set) {
//                                   return Text(
//                                     'Set ${set['id'] ?? ''}: ${set['weight']}kg × ${set['reps']} reps (RPE: ${set['rpe']})',
//                                     style: const TextStyle(
//                                       color: Colors.white70,
//                                       fontSize: 14,
//                                     ),
//                                   );
//                                 }).toList(),
//                               ],
//                             ),
//                           );
//                         }),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }




// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class WorkoutHistoryScreen extends StatelessWidget {
//   const WorkoutHistoryScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       return const Scaffold(
//         body: Center(
//           child: Text(
//             'No user logged in.',
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//       );
//     }

//     final workoutLogsRef = FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .collection('workoutLogs');

//     return Scaffold(
//       backgroundColor: const Color(0xFF0E0E12),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1E1E2C),
//         title: const Text(
//           'Workout History',
//           style: TextStyle(color: Colors.white),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: FutureBuilder<QuerySnapshot>(
//   future: FirebaseFirestore.instance
//       .collection('users')
//       .doc(user.uid)
//       .collection('workoutLogs')
//       .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
//       .collection('exercises')
//       .orderBy('timestamp', descending: true)
//       .get(),
//   builder: (context, snapshot) {
//     if (snapshot.connectionState == ConnectionState.waiting) {
//       return const Center(
//         child: CircularProgressIndicator(color: Colors.purpleAccent),
//       );
//     }

//     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//       return const Center(
//         child: Text(
//           'No workout history found for today.',
//           style: TextStyle(color: Colors.white70, fontSize: 16),
//         ),
//       );
//     }

//     final exercises = snapshot.data!.docs;

//     return ListView.builder(
//       itemCount: exercises.length,
//       itemBuilder: (context, index) {
//         final data = exercises[index].data() as Map<String, dynamic>;
//         final sets = data['sets'] ?? [];
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           child: Card(
//             color: const Color(0xFF1E1E2C),
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12)),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     data['exerciseName'] ?? 'Unknown Exercise',
//                     style: const TextStyle(
//                       color: Colors.purpleAccent,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   ...sets.map<Widget>((set) {
//                     return Text(
//                       'Set ${set['id']}: ${set['weight']}kg × ${set['reps']} reps',
//                       style: const TextStyle(color: Colors.white70, fontSize: 14),
//                     );
//                   }).toList(),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   },
// ),

//     );
//   }
// }
