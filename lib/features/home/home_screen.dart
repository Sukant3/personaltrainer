import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:personaltrainer/features/exercise/screens/exercise_catalog_screen.dart';
import 'package:personaltrainer/features/program/screens/programs_screen.dart';

import 'package:personaltrainer/features/workout/screens/streak_screen.dart'; // add your screen path

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const darkBg = Color(0xFF0E0E10);

    return Scaffold(
      backgroundColor: darkBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- PROFILE HEADER ----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage('assets/images/profile.jpg'),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Hi, Sukant",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Welcome Back!",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none_rounded,
                        color: Colors.white, size: 26),
                    onPressed: () {},
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ---------------- PROGRESS & ANALYTICS ----------------
              _ProgressSection(),

              const SizedBox(height: 28),

              // ---------------- EXERCISE CATALOG ----------------
              _SectionHeader(
                title: "Exercise Catalog",
                onViewAll: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ExerciseCatalogScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),
              const _CategoryTabs(),
              const SizedBox(height: 12),
              const _ImageCarousel(
                images: [
                  'assets/images/exe2.jpg',
                  'assets/images/exe1.jpg',
                  'assets/images/exe3.jpg',
                ],
                titles: [
                  "Learn the Basics of Training",
                  "Core Strength Session",
                  "Upper Body Power",
                ],
              ),

              const SizedBox(height: 36),

              // ---------------- PROGRAMS SECTION ----------------
              _SectionHeader(
                title: "Programs",
                onViewAll: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProgramsScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),
              const _ImageCarousel(
                images: [
                  'assets/images/pro1.png',
                  'assets/images/pro2.png',
                ],
                titles: [
                  "Full Body Transformation",
                  "Lean Muscle Program",
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------- PROGRESS SECTION --------------------
class _ProgressSection extends StatelessWidget {
  const _ProgressSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with View All
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Recent Activity",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const StreakScreen()),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 133, 17, 159), Color.fromARGB(255, 119, 26, 170)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "View All",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Steps Chart
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Steps",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "3,246 steps",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "2.51 km | 123.2 kcal",
                    style: TextStyle(color: Colors.white38, fontSize: 13),
                  ),
                ],
              ),
              SizedBox(
                height: 60,
                width: 120,
                child: BarChart(
                  BarChartData(
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(),
                      rightTitles: const AxisTitles(),
                      topTitles: const AxisTitles(),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, _) {
                            const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                            return Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: Text(
                                days[v.toInt() % 7],
                                style: const TextStyle(
                                    color: Colors.white54, fontSize: 12),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: List.generate(
                      7,
                      (i) => BarChartGroupData(x: i, barRods: [
                        BarChartRodData(
                          toY: (4 + i % 4).toDouble(),
                          color: Colors.yellowAccent,
                          width: 10,
                          borderRadius: BorderRadius.circular(4),
                        )
                      ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Calories + Duration
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _ProgressMiniCard(
                title: "Calories",
                value: "124 kcal",
                color: Colors.orangeAccent,
              ),
              _ProgressMiniCard(
                title: "Duration",
                value: "120 min",
                color: Colors.lightBlueAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressMiniCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _ProgressMiniCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2D),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.circle, color: color, size: 10),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                      fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------- SECTION HEADER --------------------
class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;
  const _SectionHeader({required this.title, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
        GestureDetector(
          onTap: onViewAll,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color.fromARGB(255, 133, 17, 159), Color.fromARGB(255, 119, 26, 170)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              "View All",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}

// -------------------- CATEGORY TABS --------------------
class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _CategoryChip("Beginner", isActive: true),
        SizedBox(width: 10),
        _CategoryChip("Intermediate"),
        SizedBox(width: 10),
        _CategoryChip("Advanced"),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String text;
  final bool isActive;
  const _CategoryChip(this.text, {this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color.fromARGB(255, 133, 17, 159) : Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.white70,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// -------------------- IMAGE CAROUSEL --------------------
class _ImageCarousel extends StatelessWidget {
  final List<String> images;
  final List<String> titles;
  const _ImageCarousel({required this.images, required this.titles});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, i) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Image.asset(
                  images[i],
                  width: 250,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 250,
                  height: 160,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 14,
                  left: 14,
                  right: 14,
                  child: Text(
                    titles[i],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
