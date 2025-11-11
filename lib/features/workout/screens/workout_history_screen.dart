import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkoutHistoryScreen extends StatelessWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'No user logged in.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final workoutLogsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('workoutLogs');

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2C),
        title: const Text(
          'Workout History',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<QuerySnapshot>(
  future: FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('workoutLogs')
      .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
      .collection('exercises')
      .orderBy('timestamp', descending: true)
      .get(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.purpleAccent),
      );
    }

    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return const Center(
        child: Text(
          'No workout history found for today.',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    final exercises = snapshot.data!.docs;

    return ListView.builder(
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final data = exercises[index].data() as Map<String, dynamic>;
        final sets = data['sets'] ?? [];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Card(
            color: const Color(0xFF1E1E2C),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['exerciseName'] ?? 'Unknown Exercise',
                    style: const TextStyle(
                      color: Colors.purpleAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...sets.map<Widget>((set) {
                    return Text(
                      'Set ${set['id']}: ${set['weight']}kg × ${set['reps']} reps',
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    );
                  }).toList(),
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
