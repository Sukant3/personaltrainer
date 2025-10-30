// lib/features/workout/widgets/pr_toast.dart
import 'package:flutter/material.dart';

class PRToast extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const PRToast({
    Key? key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.emoji_events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // A compact card-like toast suitable for SnackBar content
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade600,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white24),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ]),
            ),
            // small chevron to dismiss if desired
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                // nothing here — SnackBar's action handles undo/dismiss
              },
              child: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white30),
            )
          ],
        ),
      ),
    );
  }
}
