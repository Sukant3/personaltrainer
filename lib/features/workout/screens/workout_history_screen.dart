import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WorkoutHistoryScreen extends StatelessWidget {
  const WorkoutHistoryScreen({super.key});

  Future<List<Map<String, dynamic>>> _fetchWorkoutHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final workoutLogsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('workoutLogs');

    final workoutLogsSnapshot = await workoutLogsRef.get();

    List<Map<String, dynamic>> allLogs = [];

    for (var dateDoc in workoutLogsSnapshot.docs) {
      final exercisesSnapshot =
          await workoutLogsRef.doc(dateDoc.id).collection('exercises').get();

      for (var exerciseDoc in exercisesSnapshot.docs) {
        allLogs.add({
          'date': dateDoc.id,
          'exerciseName': exerciseDoc['exerciseName'] ?? 'Unknown Exercise',
          'sets': exerciseDoc['sets'] ?? [],
          'note': exerciseDoc['note'] ?? '',
        });
      }
    }

    return allLogs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2C),
        title: const Text('Workout History', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchWorkoutHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.purpleAccent));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No workout history found.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          final logs = snapshot.data!;
          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              final sets = log['sets'] as List<dynamic>;
              return Card(
                color: const Color(0xFF1E1E2C),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        log['exerciseName'],
                        style: const TextStyle(
                          color: Colors.purpleAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Date: ${log['date']}',
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      ...sets.map((set) {
                        return Text(
                          'Set ${set['id'] ?? ''}: ${set['weight']}kg x ${set['reps']} reps (RPE: ${set['rpe']})',
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        );
                      }),
                    ],
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
