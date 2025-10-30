import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:personaltrainer/features/goal/screens/goal_screen.dart';
import 'package:personaltrainer/features/program/screens/programs_screen.dart';
import '../exercise/screens/exercise_catalog_screen.dart';
import '../workout/screens/streak_screen.dart';

// You can move these to a separate file as needed.
final List<_FeatureTile> _tiles = [
  _FeatureTile(
    title: "Exercise Catalog",
    icon: Icons.fitness_center_rounded,
    color: Colors.deepPurpleAccent,
    pageBuilder: (_) => const ExerciseCatalogScreen(),
  ),
  _FeatureTile(
    title: "Progress & Analytics",
    icon: Icons.show_chart_rounded,
    color: Colors.blueAccent,
    pageBuilder: (_) => const StreakScreen(),
  ),
  _FeatureTile(
    title: "Workouts",
    icon: Icons.sports_handball_rounded,
    color: Colors.greenAccent,
    onTap: (context) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Workouts screen coming soon!")),
      );
    },
  ),
  _FeatureTile(
    title: "Programs",
    icon: Icons.track_changes_rounded,
    color: Colors.pinkAccent,
    pageBuilder: (_) => const ProgramsScreen(),
  ),
  _FeatureTile(
    title: "Goals",
    icon: Icons.flag_rounded,
    color: Colors.orangeAccent,
    pageBuilder: (_) => const GoalsScreen(),
  ),
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final darkBg = [
      const Color(0xFF17181A),
      const Color(0xFF1F2232),
      const Color(0xFF252839),
    ];
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: darkBg[0],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ShaderMask(
          shaderCallback: (rect) => const RadialGradient(
            colors: [Color(0xFF8F94FB), Color(0xFF4E54C8), Color.fromARGB(255, 89, 161, 197)],
            center: Alignment.centerLeft,
            radius: 1.5,
          ).createShader(rect),
          child: const Text(
            "Focused Tracker",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.4,
              fontSize: 25,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
              child: _HomeCardGrid(tiles: _tiles),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Animated Home Grid ---
class _HomeCardGrid extends StatelessWidget {
  final List<_FeatureTile> tiles;
  const _HomeCardGrid({required this.tiles});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.93,
      ),
      itemCount: tiles.length,
      itemBuilder: (context, i) {
        final tile = tiles[i];
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 400 + i * 70),
          tween: Tween(begin: 0.87, end: 1),
          curve: Curves.easeOutBack,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: _ModernDarkCard(tile: tile),
        );
      },
    );
  }
}

// --- Card Content Describer ---
class _FeatureTile {
  final String title;
  final IconData icon;
  final Color color;
  final Widget Function(BuildContext)? pageBuilder;
  final void Function(BuildContext)? onTap;
  const _FeatureTile({
    required this.title,
    required this.icon,
    required this.color,
    this.pageBuilder,
    this.onTap,
  });
}

// --- Modern Dark Card Widget ---
class _ModernDarkCard extends StatelessWidget {
  final _FeatureTile tile;
  const _ModernDarkCard({required this.tile});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        if (tile.onTap != null) return tile.onTap!(context);
        if (tile.pageBuilder != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => tile.pageBuilder!(ctx)),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          // Slight frosted glass effect
          color: Colors.white.withOpacity(0.04),
          border: Border.all(color: tile.color.withOpacity(0.35), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: tile.color.withOpacity(0.10),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 12,
              offset: const Offset(0, 2),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: Alignment.topLeft,
                    radius: 0.83,
                    colors: [
                      tile.color.withOpacity(0.46),
                      tile.color.withOpacity(0.23),
                      Colors.transparent,
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Icon(tile.icon,
                    color: tile.color, size: 42),
              ),
              const SizedBox(height: 15),
              Text(
                tile.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white.withOpacity(0.93),
                      letterSpacing: 0.7,
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
