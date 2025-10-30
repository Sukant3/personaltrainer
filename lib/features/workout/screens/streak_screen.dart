import 'package:flutter/material.dart';
import '../widgets/pr_chart.dart';
import '../widgets/volume_chart.dart';
import '../widgets/streak_badge.dart';

class StreakScreen extends StatelessWidget {
  const StreakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress & Analytics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "🏋️ Weekly Volume by Muscle",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const VolumeChart(),
            const SizedBox(height: 24),

            const Text(
              "🔥 Personal Record (PR) History",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const PRChart(),
            const SizedBox(height: 24),

            const Text(
              "⭐ Streak Tracker",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const StreakBadge(streakDays: 14), // sample
          ],
        ),
      ),
    );
  }
}
