// lib/features/workout/screens/workout_log_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../exercise/widgets/exercise_card.dart';
import '../widgets/add_note_modal.dart';
import '../widgets/pr_toast.dart';
import '../widgets/rest_timer_modal.dart';
import '../../settings/screens/settings_screen.dart';
import '../widgets/mini_rest_timer.dart';
import 'package:personaltrainer/core/models/exercise_model.dart';

// import '../../widgets/sync_banner.dart'; // for 9.1 task
// import '../../../core/notifiers/connectivity_notifier.dart';
// import '../../../main.dart'; // where connectivityNotifier is defined


class WorkoutLogScreen extends StatefulWidget {
  final Exercise exercise;
  const WorkoutLogScreen({Key? key, required this.exercise}) : super(key: key);

  @override
  State<WorkoutLogScreen> createState() => _WorkoutLogScreenState();
}

class _WorkoutLogScreenState extends State<WorkoutLogScreen> {
  final List<Map<String, dynamic>> sets = [
    {'id': 's1', 'weight': 50.0, 'reps': 10, 'rpe': 7, 'tempo': '2-0-1', 'completed': false},
    {'id': 's2', 'weight': 50.0, 'reps': 8, 'rpe': 8, 'tempo': '2-0-1', 'completed': false},
  ];

  String? exerciseNote;

  /// In-memory bests table. In a real app this should be persisted per user/exercise.
  /// Structure: bests[exerciseId] = {'maxWeight': num, 'maxReps': num, 'maxVolume': num}
  final Map<String, Map<String, num>> bests = {};

  void _addSet() {
    final id = 's${DateTime.now().millisecondsSinceEpoch}';
    setState(() {
      sets.add({'id': id, 'weight': 0.0, 'reps': 0, 'rpe': 6, 'tempo': '2-0-1', 'completed': false});
    });
  }

  void _toggleComplete(int index, {bool fromSwipe = false}) {
    setState(() {
      sets[index]['completed'] = !(sets[index]['completed'] as bool);
    });

    if (fromSwipe || sets[index]['completed'] == true) {
      // If from swipe OR the set is now completed (manual toggle), check PR.
      _checkForPrAndNotify(index);
    }

    if (fromSwipe) {
      HapticFeedback.mediumImpact();
      final exName = widget.exercise.name;
      final sn = SnackBar(
        content: Text(sets[index]['completed']
            ? 'Set ${index + 1} marked complete — $exName'
            : 'Marked incomplete — Set ${index + 1}'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() => sets[index]['completed'] = !(sets[index]['completed'] as bool));
          },
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(sn);
    }
  }

  /// Compute PR candidates and show notification if new record hit.
  void _checkForPrAndNotify(int setIndex) {
    final s = sets[setIndex];
    final num weight = (s['weight'] is num) ? s['weight'] : num.tryParse(s['weight'].toString()) ?? 0;
    final num reps = (s['reps'] is num) ? s['reps'] : num.tryParse(s['reps'].toString()) ?? 0;
    final num volume = weight * reps;
    final exerciseId = widget.exercise.id;

    // Ensure bests entry exists
    bests.putIfAbsent(exerciseId, () => {'maxWeight': 0, 'maxReps': 0, 'maxVolume': 0});

    final currentBest = bests[exerciseId]!;
    final List<String> prTypes = [];

    // Detect PR by weight
    if (weight > (currentBest['maxWeight'] ?? 0)) {
      prTypes.add('Weight');
      currentBest['maxWeight'] = weight;
    }

    // Detect PR by reps (at any weight)
    if (reps > (currentBest['maxReps'] ?? 0)) {
      prTypes.add('Reps');
      currentBest['maxReps'] = reps;
    }

    // Detect PR by volume (weight * reps)
    if (volume > (currentBest['maxVolume'] ?? 0)) {
      // If volume is higher, we treat as PR even if weight/reps individually are not.
      if (!prTypes.contains('Volume')) prTypes.add('Volume');
      currentBest['maxVolume'] = volume;
    }

    if (prTypes.isNotEmpty) {
      // Build a user-friendly subtitle, e.g. "Bench Press — 80kg x 5 (400kg)"
      final title = 'New PR — ${prTypes.join('/') }!';
      final subtitle = '${widget.exercise.name}: ${weight}kg × ${reps} (${volume} vol)';

      // Show a styled toast using PRToast widget inside a SnackBar
      final snack = SnackBar(
        content: PRToast(title: title, subtitle: subtitle, icon: Icons.emoji_events),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            // Undo: revert the bests update(s) related to this set (best-effort)
            // For simplicity, we reset the stored bests for exercise to 0 — in production you would store previous values to revert precisely
            setState(() {
              bests[exerciseId] = {'maxWeight': 0, 'maxReps': 0, 'maxVolume': 0};
            });
          },
        ),
      );

      // play a short chime (optional). See notes below for adding just_audio.
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(snack);
    }
  }

  void _openAddNoteModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddNoteModal(
        exerciseId: widget.exercise.id,
        onSave: (note) {
          setState(() => exerciseNote = note);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Note added for ${widget.exercise.name}')),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ex = widget.exercise;

    return Scaffold(
      appBar: AppBar(
        title: Text(ex.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.workspace_premium_outlined),
            onPressed: () => Navigator.pushNamed(context, '/subscription'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.note_add_outlined),
            tooltip: 'Add Note',
            onPressed: _openAddNoteModal,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ExerciseCard(exercise: ex, onTap: () {}),
            if (exerciseNote != null && exerciseNote!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Text(
                  exerciseNote!,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: sets.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final s = sets[i];
                  final completed = s['completed'] as bool;
                  return Dismissible(
                    key: ValueKey(s['id']),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) async {
                      _toggleComplete(i, fromSwipe: true);
                      return false;
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.check, color: Colors.white),
                    ),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 250),
                      opacity: completed ? 0.6 : 1.0,
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Text('Set ${i + 1}', style: const TextStyle(fontWeight: FontWeight.w600)),
                              const SizedBox(width: 12),
                              _numberField(
                                value: s['weight'].toString(),
                                label: 'Kg',
                                onChanged: (val) => setState(() => s['weight'] = double.tryParse(val) ?? s['weight']),
                                strike: completed,
                              ),
                              const SizedBox(width: 8),
                              _numberField(
                                value: s['reps'].toString(),
                                label: 'Reps',
                                onChanged: (val) => setState(() => s['reps'] = int.tryParse(val) ?? s['reps']),
                                strike: completed,
                              ),
                              const SizedBox(width: 8),
                              _numberField(
                                value: s['rpe'].toString(),
                                label: 'RPE',
                                onChanged: (val) => setState(() => s['rpe'] = int.tryParse(val) ?? s['rpe']),
                                strike: completed,
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 80,
                                child: TextField(
                                  controller: TextEditingController(text: s['tempo']),
                                  decoration: const InputDecoration(labelText: 'Tempo', isDense: true),
                                  onChanged: (v) => s['tempo'] = v,
                                  style: TextStyle(
                                    decoration: completed
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                tooltip: completed ? 'Mark incomplete' : 'Mark complete',
                                onPressed: () => _toggleComplete(i),
                                icon: Icon(
                                  completed ? Icons.check_circle : Icons.radio_button_unchecked,
                                  color: completed ? Colors.green : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _addSet,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Set'),
                ),
                GestureDetector(
                  // actual rest timer window with customization 
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (_) => RestTimerModal(
                        initialSeconds: 60, // 1-minute timer
                        onAudioCueRequested: (cueId) {
                          // This is just a UI trigger for now; actual sound integration later
                          debugPrint('Audio cue requested: $cueId');
                        },
                      ),
                    );
                  },

                  // for mini rest timer floating circular window with no customization
                  // onTap: () {
                  //   // show overlay mini timer for 60 seconds and start immediately
                  //   MiniRestTimer.show(context, seconds: 60, startImmediately: true, onFinish: () {
                  //     // called when mini timer finishes (UI-only)
                  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Rest finished')));
                  //   });
                  // },
                  child: Column(
                    children: const [
                      Icon(Icons.timer, size: 28),
                      SizedBox(height: 4),
                      Text('Rest'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _numberField({
    required String value,
    required String label,
    required Function(String) onChanged,
    bool strike = false,
  }) {
    return SizedBox(
      width: 64,
      child: TextField(
        controller: TextEditingController(text: value),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(labelText: label, isDense: true),
        onChanged: onChanged,
        style: TextStyle(
          decoration: strike ? TextDecoration.lineThrough : TextDecoration.none,
        ),
      ),
    );
  }
}

// after note is displayed below exercise name when saving
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import '../../../core/models/exercise_model.dart';
// import '../../exercise/widgets/exercise_card.dart';
// import '../widgets/add_note_modal.dart';

// class WorkoutLogScreen extends StatefulWidget {
//   final Exercise exercise;
//   const WorkoutLogScreen({Key? key, required this.exercise}) : super(key: key);

//   @override
//   State<WorkoutLogScreen> createState() => _WorkoutLogScreenState();
// }

// class _WorkoutLogScreenState extends State<WorkoutLogScreen> {
//   final List<Map<String, dynamic>> sets = [
//     {'id': 's1', 'weight': 50.0, 'reps': 10, 'rpe': 7, 'tempo': '2-0-1', 'completed': false},
//     {'id': 's2', 'weight': 50.0, 'reps': 8, 'rpe': 8, 'tempo': '2-0-1', 'completed': false},
//   ];

//   String? exerciseNote; // <-- Added

//   void _addSet() {
//     final id = 's${DateTime.now().millisecondsSinceEpoch}';
//     setState(() {
//       sets.add({'id': id, 'weight': 0.0, 'reps': 0, 'rpe': 6, 'tempo': '2-0-1', 'completed': false});
//     });
//   }

//   void _toggleComplete(int index, {bool fromSwipe = false}) {
//     setState(() {
//       sets[index]['completed'] = !(sets[index]['completed'] as bool);
//     });

//     if (fromSwipe) {
//       HapticFeedback.mediumImpact();
//       final exName = widget.exercise.name;
//       final sn = SnackBar(
//         content: Text(sets[index]['completed']
//             ? 'Set ${index + 1} marked complete — $exName'
//             : 'Marked incomplete — Set ${index + 1}'),
//         action: SnackBarAction(
//           label: 'Undo',
//           onPressed: () {
//             setState(() => sets[index]['completed'] = !(sets[index]['completed'] as bool));
//           },
//         ),
//         duration: const Duration(seconds: 3),
//         behavior: SnackBarBehavior.floating,
//       );
//       ScaffoldMessenger.of(context).hideCurrentSnackBar();
//       ScaffoldMessenger.of(context).showSnackBar(sn);
//     }
//   }

//   void _openAddNoteModal() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) => AddNoteModal(
//         exerciseId: widget.exercise.id,
//         onSave: (note) {
//           setState(() => exerciseNote = note);
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Note added for ${widget.exercise.name}')),
//           );
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ex = widget.exercise;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(ex.name),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.note_add_outlined),
//             tooltip: 'Add Note',
//             onPressed: _openAddNoteModal,
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           children: [
//             ExerciseCard(exercise: ex, onTap: () {}),
//             if (exerciseNote != null && exerciseNote!.isNotEmpty) ...[
//               const SizedBox(height: 8),
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.amber.shade50,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.amber.shade200),
//                 ),
//                 child: Text(
//                   exerciseNote!,
//                   style: const TextStyle(fontSize: 14, color: Colors.black87),
//                 ),
//               ),
//             ],
//             const SizedBox(height: 12),

//             // Sets list
//             Expanded(
//               child: ListView.separated(
//                 itemCount: sets.length,
//                 separatorBuilder: (_, __) => const SizedBox(height: 8),
//                 itemBuilder: (context, i) {
//                   final s = sets[i];
//                   final completed = s['completed'] as bool;
//                   return Dismissible(
//                     key: ValueKey(s['id']),
//                     direction: DismissDirection.endToStart,
//                     confirmDismiss: (direction) async {
//                       _toggleComplete(i, fromSwipe: true);
//                       return false;
//                     },
//                     background: Container(
//                       alignment: Alignment.centerRight,
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       decoration: BoxDecoration(
//                         color: Colors.green.shade600,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: const Icon(Icons.check, color: Colors.white),
//                     ),
//                     child: AnimatedOpacity(
//                       duration: const Duration(milliseconds: 250),
//                       opacity: completed ? 0.6 : 1.0,
//                       child: Card(
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                         margin: const EdgeInsets.symmetric(horizontal: 2),
//                         child: Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Row(
//                             children: [
//                               Text('Set ${i + 1}', style: const TextStyle(fontWeight: FontWeight.w600)),
//                               const SizedBox(width: 12),
//                               _numberField(
//                                 value: s['weight'].toString(),
//                                 label: 'Kg',
//                                 onChanged: (val) => setState(() => s['weight'] = double.tryParse(val) ?? s['weight']),
//                                 strike: completed,
//                               ),
//                               const SizedBox(width: 8),
//                               _numberField(
//                                 value: s['reps'].toString(),
//                                 label: 'Reps',
//                                 onChanged: (val) => setState(() => s['reps'] = int.tryParse(val) ?? s['reps']),
//                                 strike: completed,
//                               ),
//                               const SizedBox(width: 8),
//                               _numberField(
//                                 value: s['rpe'].toString(),
//                                 label: 'RPE',
//                                 onChanged: (val) => setState(() => s['rpe'] = int.tryParse(val) ?? s['rpe']),
//                                 strike: completed,
//                               ),
//                               const SizedBox(width: 8),
//                               SizedBox(
//                                 width: 80,
//                                 child: TextField(
//                                   controller: TextEditingController(text: s['tempo']),
//                                   decoration: const InputDecoration(labelText: 'Tempo', isDense: true),
//                                   onChanged: (v) => s['tempo'] = v,
//                                   style: TextStyle(
//                                     decoration: completed
//                                         ? TextDecoration.lineThrough
//                                         : TextDecoration.none,
//                                   ),
//                                 ),
//                               ),
//                               const Spacer(),
//                               IconButton(
//                                 tooltip: completed ? 'Mark incomplete' : 'Mark complete',
//                                 onPressed: () => _toggleComplete(i),
//                                 icon: Icon(
//                                   completed ? Icons.check_circle : Icons.radio_button_unchecked,
//                                   color: completed ? Colors.green : Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),

//             const SizedBox(height: 12),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: _addSet,
//                   icon: const Icon(Icons.add),
//                   label: const Text('Add Set'),
//                 ),
//                 Column(
//                   children: const [
//                     Icon(Icons.timer),
//                     SizedBox(height: 4),
//                     Text('Rest'),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _numberField({
//     required String value,
//     required String label,
//     required Function(String) onChanged,
//     bool strike = false,
//   }) {
//     return SizedBox(
//       width: 64,
//       child: TextField(
//         controller: TextEditingController(text: value),
//         keyboardType: const TextInputType.numberWithOptions(decimal: true),
//         decoration: InputDecoration(labelText: label, isDense: true),
//         onChanged: onChanged,
//         style: TextStyle(
//           decoration: strike ? TextDecoration.lineThrough : TextDecoration.none,
//         ),
//       ),
//     );
//   }
// }

// before note dispaly below exercise name
// lib/features/workout/screens/workout_log_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; // for HapticFeedback
// import '../../../core/models/exercise_model.dart';
// import '../../exercise/widgets/exercise_card.dart';
// import '../widgets/add_note_modal.dart';

// class WorkoutLogScreen extends StatefulWidget {
//   final Exercise exercise;
//   const WorkoutLogScreen({Key? key, required this.exercise}) : super(key: key);

//   @override
//   State<WorkoutLogScreen> createState() => _WorkoutLogScreenState();
// }

// class _WorkoutLogScreenState extends State<WorkoutLogScreen> {
//   // Using a simple map for each set. 'completed' indicates swipe-complete state.
//   final List<Map<String, dynamic>> sets = [
//     {'id': 's1', 'weight': 50.0, 'reps': 10, 'rpe': 7, 'tempo': '2-0-1', 'completed': false},
//     {'id': 's2', 'weight': 50.0, 'reps': 8, 'rpe': 8, 'tempo': '2-0-1', 'completed': false},
//   ];

//   void _addSet() {
//     final id = 's${DateTime.now().millisecondsSinceEpoch}';
//     setState(() {
//       sets.add({'id': id, 'weight': 0.0, 'reps': 0, 'rpe': 6, 'tempo': '2-0-1', 'completed': false});
//     });
//   }

//   void _toggleComplete(int index, {bool fromSwipe = false}) {
//     setState(() {
//       sets[index]['completed'] = !(sets[index]['completed'] as bool);
//     });

//     if (fromSwipe) {
//       // feedback + snackbar
//       HapticFeedback.mediumImpact();
//       final exName = widget.exercise.name;
//       final sn = SnackBar(
//         content: Text(sets[index]['completed']
//             ? 'Set ${index + 1} marked complete — $exName'
//             : 'Marked incomplete — Set ${index + 1}'),
//         action: SnackBarAction(
//           label: 'Undo',
//           onPressed: () {
//             // undo
//             setState(() => sets[index]['completed'] = !(sets[index]['completed'] as bool));
//           },
//         ),
//         duration: const Duration(seconds: 3),
//         behavior: SnackBarBehavior.floating,
//       );
//       ScaffoldMessenger.of(context).hideCurrentSnackBar();
//       ScaffoldMessenger.of(context).showSnackBar(sn);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ex = widget.exercise;

//     return Scaffold(
//       // appBar: AppBar(title: Text(ex.name)),
//       appBar: AppBar(
//   title: Text(ex.name),
//   actions: [
//     IconButton(
//       icon: const Icon(Icons.note_add_outlined),
//       tooltip: 'Add Note',
//       onPressed: () {
//         showModalBottomSheet(
//           context: context,
//           isScrollControlled: true,
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           builder: (_) => AddNoteModal(
//             exerciseId: ex.id,
//             onSave: (note) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Note added for ${ex.name}')),
//               );
//             },
//           ),
//         );
//       },
//     ),
//   ],
// ),

//       body: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           children: [
//             ExerciseCard(exercise: ex, onTap: () {}),
//             const SizedBox(height: 12),
//             Expanded(
//               child: ListView.separated(
//                 itemCount: sets.length,
//                 separatorBuilder: (_, __) => const SizedBox(height: 8),
//                 itemBuilder: (context, i) {
//                   final s = sets[i];
//                   final completed = s['completed'] as bool;
//                   return Dismissible(
//                     key: ValueKey(s['id']),
//                     direction: DismissDirection.endToStart, // swipe right-to-left
//                     confirmDismiss: (direction) async {
//                       // We'll treat swipe as "mark complete". Do not remove the item.
//                       _toggleComplete(i, fromSwipe: true);
//                       return false; // returning false prevents dismissal (keeps list intact)
//                     },
//                     background: Container(
//                       alignment: Alignment.centerRight,
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       decoration: BoxDecoration(
//                         color: Colors.green.shade600,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: const Icon(Icons.check, color: Colors.white),
//                     ),
//                     child: AnimatedOpacity(
//                       duration: const Duration(milliseconds: 250),
//                       opacity: completed ? 0.6 : 1.0,
//                       child: Card(
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                         margin: const EdgeInsets.symmetric(horizontal: 2),
//                         child: Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Row(
//                             children: [
//                               Text('Set ${i + 1}', style: TextStyle(fontWeight: FontWeight.w600)),
//                               const SizedBox(width: 12),

//                               // Weight
//                               _numberField(
//                                 value: s['weight'].toString(),
//                                 label: 'Kg',
//                                 onChanged: (val) => setState(() => s['weight'] = double.tryParse(val) ?? s['weight']),
//                                 strike: completed,
//                               ),
//                               const SizedBox(width: 8),

//                               // Reps
//                               _numberField(
//                                 value: s['reps'].toString(),
//                                 label: 'Reps',
//                                 onChanged: (val) => setState(() => s['reps'] = int.tryParse(val) ?? s['reps']),
//                                 strike: completed,
//                               ),
//                               const SizedBox(width: 8),

//                               // RPE
//                               _numberField(
//                                 value: s['rpe'].toString(),
//                                 label: 'RPE',
//                                 onChanged: (val) => setState(() => s['rpe'] = int.tryParse(val) ?? s['rpe']),
//                                 strike: completed,
//                               ),
//                               const SizedBox(width: 8),

//                               // Tempo
//                               SizedBox(
//                                 width: 80,
//                                 child: TextField(
//                                   controller: TextEditingController(text: s['tempo']),
//                                   decoration: const InputDecoration(labelText: 'Tempo', isDense: true),
//                                   onChanged: (v) => s['tempo'] = v,
//                                   style: TextStyle(decoration: completed ? TextDecoration.lineThrough : TextDecoration.none),
//                                 ),
//                               ),

//                               const Spacer(),

//                               // Manual complete toggle
//                               IconButton(
//                                 tooltip: completed ? 'Mark incomplete' : 'Mark complete',
//                                 onPressed: () => _toggleComplete(i),
//                                 icon: Icon(completed ? Icons.check_circle : Icons.radio_button_unchecked,
//                                     color: completed ? Colors.green : Colors.grey),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),

//             const SizedBox(height: 12),

//             // Add-set + timer row (timer widget placeholder)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: _addSet,
//                   icon: const Icon(Icons.add),
//                   label: const Text('Add Set'),
//                 ),
//                 // Simple rest timer placeholder. Replace with your RestTimer widget if present.
//                 const SizedBox(width: 8),
//                 Column(
//                   children: const [
//                     // Use your existing RestTimer if you have it; placeholder shown here
//                     // RestTimer(initialSeconds: 60),
//                     Icon(Icons.timer),
//                     SizedBox(height: 4),
//                     Text('Rest'),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _numberField({
//     required String value,
//     required String label,
//     required Function(String) onChanged,
//     bool strike = false,
//   }) {
//     // Using controller each build — fine for small prototype. Replace with TextEditingController management for production.
//     return SizedBox(
//       width: 64,
//       child: TextField(
//         controller: TextEditingController(text: value),
//         keyboardType: TextInputType.numberWithOptions(decimal: true),
//         decoration: InputDecoration(labelText: label, isDense: true),
//         onChanged: onChanged,
//         style: TextStyle(decoration: strike ? TextDecoration.lineThrough : TextDecoration.none),
//       ),
//     );
//   }
// }


