import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../exercise/widgets/exercise_card.dart';
import '../widgets/add_note_modal.dart';
import '../widgets/pr_toast.dart';
import '../widgets/rest_timer_modal.dart';
import '../../settings/screens/settings_screen.dart';
import 'package:personaltrainer/core/models/exercise_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';



class WorkoutLogScreen extends StatefulWidget {
  final Exercise exercise;
  const WorkoutLogScreen({Key? key, required this.exercise}) : super(key: key);

  @override
  State<WorkoutLogScreen> createState() => _WorkoutLogScreenState();
}

class _WorkoutLogScreenState extends State<WorkoutLogScreen> {
  final List<Map<String, dynamic>> sets = [
    {
      'id': 's1',
      'weight': 0.0,
      'reps': 0,
      // 'rpe': 0,
      'tempo': '2-0-1',
      'completed': false
    },
    {
      'id': 's2',
      'weight': 0.0,
      'reps': 0,
      // 'rpe': 0,
      'tempo': '2-0-1',
      'completed': false
    },
    {
      'id': 's3',
      'weight': 0.0,
      'reps': 0,
      // 'rpe': 0,
      'tempo': '2-0-1',
      'completed': false
    },
  ];

  String? exerciseNote;
  final Map<String, Map<String, num>> bests = {};

  void _addSet() {
    final id = 's${DateTime.now().millisecondsSinceEpoch}';
    setState(() {
      sets.add({
        'id': id,
        'weight': 0.0,
        'reps': 0,
        // 'rpe': 0,
        'tempo': '2-0-1',
        'completed': false
      });
    });
  }

  void _removeSet(int index) {
    if (sets.isNotEmpty) {
      setState(() {
        sets.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Set ${index + 1} removed'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _toggleComplete(int index, {bool fromSwipe = false}) {
    setState(() {
      sets[index]['completed'] = !(sets[index]['completed'] as bool);
    });

    if (fromSwipe || sets[index]['completed'] == true) {
      _checkForPrAndNotify(index);
    }

    if (fromSwipe) {
      HapticFeedback.mediumImpact();
      final exName = widget.exercise.name;
      final sn = SnackBar(
        content: Text(sets[index]['completed']
            ? 'Set ${index + 1} marked complete — $exName'
            : 'Marked incomplete — Set ${index + 1}'),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(sn);
    }
  }

  void _checkForPrAndNotify(int setIndex) {
    final s = sets[setIndex];
    final num weight = (s['weight'] is num)
        ? s['weight']
        : num.tryParse(s['weight'].toString()) ?? 0;
    final num reps = (s['reps'] is num)
        ? s['reps']
        : num.tryParse(s['reps'].toString()) ?? 0;
    final num volume = weight * reps;
    final exerciseId = widget.exercise.id;

    bests.putIfAbsent(
        exerciseId, () => {'maxWeight': 0, 'maxReps': 0, 'maxVolume': 0});
    final currentBest = bests[exerciseId]!;
    final List<String> prTypes = [];

    if (weight > (currentBest['maxWeight'] ?? 0)) {
      prTypes.add('Weight');
      currentBest['maxWeight'] = weight;
    }
    if (reps > (currentBest['maxReps'] ?? 0)) {
      prTypes.add('Reps');
      currentBest['maxReps'] = reps;
    }
    if (volume > (currentBest['maxVolume'] ?? 0)) {
      prTypes.add('Volume');
      currentBest['maxVolume'] = volume;
    }

    if (prTypes.isNotEmpty) {
      final snack = SnackBar(
        content: PRToast(
          title: 'New PR — ${prTypes.join('/')}!',
          subtitle:
              '${widget.exercise.name}: ${weight}kg × ${reps} (${volume} vol)',
          icon: Icons.emoji_events,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      );
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

  Future<void> _saveWorkoutLog() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final String exerciseName = widget.exercise.name;

    final completedSets = sets.where((s) => s['completed'] == true).toList();

    if (completedSets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No completed sets to save.')),
      );
      return;
    }

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('workoutLogs')
        .doc(today)
        .collection('exercises')
        .doc(exerciseName);

    // await docRef.set({
    //   'exerciseName': exerciseName,
    //   'date': today,
    //   'sets': completedSets, // ✅ changed here
    //   'note': exerciseNote ?? '',
    //   'timestamp': FieldValue.serverTimestamp(),
    // });

    await docRef.set({
      'userId': user.uid, // ✅ add this line for collectionGroup query
      'exerciseName': exerciseName,
      'date': today,
      'sets': completedSets,
      'note': exerciseNote ?? '',
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Workout saved for $today')),
    );
  } catch (e) {
    debugPrint('Error saving workout log: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to save: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final ex = widget.exercise;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardShadowColor = isDark
        ? Colors.white.withOpacity(0.05)
        : Colors.black.withOpacity(0.08);
    final purple = const Color(0xFF7B3FF3); // Same as your “View All” color

    return Scaffold(
      appBar: AppBar(
        title: Text(ex.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save Workout',
            onPressed: _saveWorkoutLog,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise card
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: cardShadowColor,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ExerciseCard(exercise: ex, onTap: () {}),
            ),
            if (exerciseNote != null && exerciseNote!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  exerciseNote!,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
            const SizedBox(height: 16),

            // Sets list
            Expanded(
              child: ListView.separated(
                itemCount: sets.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final s = sets[i];
                  final completed = s['completed'] as bool;

                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: completed ? 0.6 : 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: cardShadowColor,
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          children: [
                            Text('Set ${i + 1}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15)),
                            const SizedBox(width: 12),
                            _numberField(
                                value: s['weight'].toString(),
                                label: 'Kg',
                                strike: completed,
                                onChanged: (val) => setState(() => s['weight'] =
                                    double.tryParse(val) ?? s['weight'])),
                            const SizedBox(width: 8),
                            _numberField(
                                value: s['reps'].toString(),
                                label: 'Reps',
                                strike: completed,
                                onChanged: (val) => setState(() => s['reps'] =
                                    int.tryParse(val) ?? s['reps'])),
                            // const SizedBox(width: 8),
                            // _numberField(
                            //     value: s['rpe'].toString(),
                            //     label: 'RPE',
                            //     strike: completed,
                            //     onChanged: (val) => setState(() =>
                            //         s['rpe'] = int.tryParse(val) ?? s['rpe'])),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 80,
                              child: TextField(
                                controller:
                                    TextEditingController(text: s['tempo']),
                                decoration: const InputDecoration(
                                  labelText: 'Tempo',
                                  isDense: true,
                                ),
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
                              tooltip: completed
                                  ? 'Mark incomplete'
                                  : 'Mark complete',
                              onPressed: () => _toggleComplete(i),
                              icon: Icon(
                                completed
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: completed
                                    ? Colors.green
                                    : Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _addSet,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Set'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                    shadowColor: purple.withOpacity(0.4),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (_) => const RestTimerModal(initialSeconds: 60),
                    );
                  },
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
