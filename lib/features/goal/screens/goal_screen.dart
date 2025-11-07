import 'package:flutter/material.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  double _weightGoal = 130;
  double _currentWeight = 0;

  double _volumeGoal = 20000;
  double _currentVolume = 0;

  int _weeklyTarget = 4;
  int _completedThisWeek = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final weightProgress = (_currentWeight / _weightGoal).clamp(0.0, 1.0);
    final volumeProgress = (_currentVolume / _volumeGoal).clamp(0.0, 1.0);
    final freqProgress = (_completedThisWeek / _weeklyTarget).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Goals'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openGoalSetupDialog,
        icon: const Icon(Icons.edit_rounded),
        label: const Text("Set Goals"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildGoalCard(
              context,
              icon: Icons.fitness_center_rounded,
              title: "Weight PR Goal",
              subtitle: "Bench Press ${_weightGoal.toStringAsFixed(0)} kg",
              progress: weightProgress,
              color: Colors.orange,
              progressLabel:
                  "${_currentWeight.toStringAsFixed(0)} / ${_weightGoal.toStringAsFixed(0)} kg",
              onIncrement: () => setState(() => _currentWeight += 5),
            ),
            const SizedBox(height: 16),
            _buildGoalCard(
              context,
              icon: Icons.timeline_rounded,
              title: "Weekly Volume Goal",
              subtitle: "Total kg lifted",
              progress: volumeProgress,
              color: Colors.blue,
              progressLabel:
                  "${_currentVolume.toStringAsFixed(0)} / ${_volumeGoal.toStringAsFixed(0)} kg",
              onIncrement: () => setState(() => _currentVolume += 1000),
            ),
            const SizedBox(height: 16),
            _buildFrequencyCard(context, freqProgress),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required double progress,
    required Color color,
    required String progressLabel,
    required VoidCallback onIncrement,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 3,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 68,
                  height: 68,
                  child: CircularProgressIndicator(
                    value: progress,
                    color: color,
                    backgroundColor: color.withOpacity(0.15),
                    strokeWidth: 7,
                  ),
                ),
                Icon(icon, size: 32, color: color),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: theme.hintColor)),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: progress,
                    color: color,
                    backgroundColor: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(progressLabel,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: theme.hintColor)),
                      const Spacer(),
                      IconButton(
                        onPressed: onIncrement,
                        icon: const Icon(Icons.add_circle_outline),
                        color: color,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencyCard(BuildContext context, double percent) {
    final theme = Theme.of(context);
    final isGoalReached = percent >= 1.0;

    return Card(
      elevation: 3,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Weekly Frequency",
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(
              "$_completedThisWeek of $_weeklyTarget sessions this week",
              style:
                  theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: percent,
              color: isGoalReached ? Colors.green : Colors.amber,
              backgroundColor: theme.dividerColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  onPressed: () => setState(() =>
                      _completedThisWeek = (_completedThisWeek - 1).clamp(0, 10)),
                  icon: const Icon(Icons.remove_circle_outline),
                  color: theme.colorScheme.primary,
                ),
                IconButton(
                  onPressed: () =>
                      setState(() => _completedThisWeek += 1),
                  icon: const Icon(Icons.add_circle_outline),
                  color: theme.colorScheme.primary,
                ),
                const Spacer(),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isGoalReached
                        ? Colors.green.withOpacity(0.15)
                        : Colors.amber.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isGoalReached ? Colors.green : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    isGoalReached ? "Goal reached!" : "Keep going!",
                    style: TextStyle(
                        color: isGoalReached ? Colors.green : Colors.amber),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openGoalSetupDialog() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: const Text("Set Your Goals"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNumberInput("Weight Goal (kg)", _weightGoal, (v) {
              _weightGoal = v;
            }),
            const SizedBox(height: 10),
            _buildNumberInput("Weekly Volume Goal (kg)", _volumeGoal, (v) {
              _volumeGoal = v;
            }),
            const SizedBox(height: 10),
            _buildNumberInput("Weekly Sessions Target", _weeklyTarget.toDouble(),
                (v) {
              _weeklyTarget = v.toInt();
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberInput(
      String label, double currentValue, Function(double) onChanged) {
    final controller = TextEditingController(text: currentValue.toStringAsFixed(0));
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      onChanged: (v) {
        final parsed = double.tryParse(v);
        if (parsed != null) onChanged(parsed);
      },
    );
  }
}
