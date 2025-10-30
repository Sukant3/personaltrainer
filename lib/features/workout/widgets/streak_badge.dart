import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StreakBadge extends StatelessWidget {
  final int streakDays;
  const StreakBadge({super.key, required this.streakDays});

  @override
  Widget build(BuildContext context) {
    final bool milestone = streakDays % 7 == 0; // every 7 days celebrate 🎉

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            if (milestone)
              Lottie.asset(
                'assets/animations/confetti.json', // place in assets folder
                repeat: false,
                width: 120,
                height: 120,
              ),
            CircleAvatar(
              radius: 45,
              backgroundColor: milestone
                  ? Colors.amberAccent.withOpacity(0.8)
                  : Colors.grey.shade300,
              child: Text(
                "$streakDays\nDays",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          milestone
              ? "🔥 Awesome! ${streakDays}-day streak!"
              : "Keep going strong 💪",
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
