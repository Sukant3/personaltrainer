import 'package:flutter/material.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  double _prProgress = 0.6; // 60% to PR goal
  double _volumeProgress = 0.45;
  int _weeklyTarget = 3;
  int _completedThisWeek = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Goals')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildGoalCard(
              title: 'Weight PR',
              subtitle: 'Bench press 130kg',
              progress: _prProgress,
              color: Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildGoalCard(
              title: 'Weekly Volume Target',
              subtitle: 'Total kg lifted per week',
              progress: _volumeProgress,
              color: Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildFrequencyCard(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _simulateProgress,
              child: const Text('Simulate + Progress'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard({
    required String title,
    required String subtitle,
    required double progress,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircularProgressIndicator(
              value: progress,
              strokeWidth: 8,
              color: color,
              backgroundColor: color.withOpacity(0.15),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(subtitle),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(value: progress, color: color, backgroundColor: color.withOpacity(0.15)),
                  const SizedBox(height: 6),
                  Text('${(progress * 100).toStringAsFixed(0)}% complete'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencyCard() {
    final percent = (_completedThisWeek / _weeklyTarget).clamp(0.0, 1.0);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Training Frequency', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('$_completedThisWeek of $_weeklyTarget sessions this week'),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: percent),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() => _completedThisWeek = (_completedThisWeek - 1).clamp(0, 100));
                  },
                  child: const Text('-'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() => _completedThisWeek += 1);
                  },
                  child: const Text('+'),
                ),
                const Spacer(),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: percent >= 1.0 ? Colors.green.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: percent >= 1.0 ? Colors.green : Colors.transparent),
                  ),
                  child: Text(percent >= 1.0 ? 'Goal reached!' : 'Keep going'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _simulateProgress() {
    setState(() {
      _prProgress = (_prProgress + 0.1).clamp(0.0, 1.0);
      _volumeProgress = (_volumeProgress + 0.12).clamp(0.0, 1.0);
    });
  }
}
