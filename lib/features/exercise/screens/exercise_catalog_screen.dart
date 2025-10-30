import 'package:flutter/material.dart';
import '../../../core/models/exercise_model.dart';
import '../widgets/exercise_card.dart';
import 'exercise_detail_screen.dart';

class ExerciseCatalogScreen extends StatefulWidget {
  const ExerciseCatalogScreen({super.key});

  @override
  State<ExerciseCatalogScreen> createState() => _ExerciseCatalogScreenState();
}

class _ExerciseCatalogScreenState extends State<ExerciseCatalogScreen> {
  String? selectedMuscle;
  String? selectedDifficulty;

  List<Exercise> exercises = [
    // --- Warm-up Exercises ---
    Exercise(
      id: 'w1',
      name: 'Jumping Jacks',
      muscleGroup: 'Warm-up',
      equipment: 'Bodyweight',
      difficulty: 'Beginner',
      description:
          'A great full-body warm-up exercise that increases heart rate and circulation.',
      cues: 'Jump while spreading arms and legs, then return to start position.',
      mediaUrl: 'assets/images/jumpping.gif'
    ),
    Exercise(
      id: 'w2',
      name: 'Arm Circles',
      muscleGroup: 'Warm-up',
      equipment: 'Bodyweight',
      difficulty: 'Beginner',
      description:
          'Loosens shoulders and improves mobility for upper-body workouts.',
      cues: 'Rotate arms forward and backward in slow, controlled circles.',
      mediaUrl: 'assets/images/armcircle.gif',
    ),
    Exercise(
      id: 'w3',
      name: 'High Knees',
      muscleGroup: 'Warm-up',
      equipment: 'Bodyweight',
      difficulty: 'Intermediate',
      description:
          'Boosts heart rate while engaging core and legs before a workout.',
      cues: 'Run in place while lifting knees up to hip height.',
      mediaUrl: 'assets/images/highknee.gif',
    ),

    // --- Main Exercises ---
    Exercise(
      id: '1',
      name: 'Push Up',
      muscleGroup: 'Chest',
      equipment: 'Bodyweight',
      difficulty: 'Beginner',
      description:
          'A bodyweight exercise that targets chest, shoulders, and triceps.',
      cues:
          'Keep your body straight, core tight, and lower until elbows are 90°.',
      mediaUrl: 'assets/images/pushup.gif',
    ),
    Exercise(
      id: '2',
      name: 'Dumbbell Curl',
      muscleGroup: 'Biceps',
      equipment: 'Dumbbell',
      difficulty: 'Beginner',
      description:
          'Isolates and strengthens the biceps with controlled arm curls.',
      cues: 'Keep elbows close to your torso and lift dumbbells slowly.',
      mediaUrl: 'assets/images/Dumbellcrul.gif',
    ),
    Exercise(
      id: '3',
      name: 'Squat',
      muscleGroup: 'Legs',
      equipment: 'Bodyweight',
      difficulty: 'Beginner',
      description: 'Builds strength in quadriceps, glutes, and hamstrings.',
      cues: 'Keep knees behind toes, chest up, and back straight.',
      mediaUrl: 'assets/images/sqat.gif',
    ),
    Exercise(
      id: '4',
      name: 'Lunges',
      muscleGroup: 'Legs',
      equipment: 'Bodyweight',
      difficulty: 'Intermediate',
      description: 'Improves leg balance and unilateral strength.',
      cues: 'Step forward, bend both knees to 90°, and push back to start.',
      mediaUrl: 'assets/images/lunges.gif',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final warmUpExercises =
        exercises.where((ex) => ex.muscleGroup == 'Warm-up').toList();

    final filteredExercises = exercises.where((ex) {
      final matchesMuscle =
          selectedMuscle == null || ex.muscleGroup == selectedMuscle;
      final matchesDifficulty =
          selectedDifficulty == null || ex.difficulty == selectedDifficulty;
      return matchesMuscle && matchesDifficulty && ex.muscleGroup != 'Warm-up';
    }).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Exercise Catalog'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E1F29), Color(0xFF2D2E3A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: kToolbarHeight + 10),
            _buildFilterChips(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildSectionTitle(' Warm-up Exercises'),
                  _buildExerciseList(warmUpExercises),
                  _buildSectionTitle(' Main Exercises'),
                  _buildExerciseList(filteredExercises),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _buildExerciseList(List<Exercise> list) {
    return Column(
      children: list.map((ex) {
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ExerciseDetailScreen(exercise: ex),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(ex.mediaUrl),
                radius: 25,
              ),
              title: Text(
                ex.name,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              subtitle: Text(
                "${ex.muscleGroup} • ${ex.difficulty}",
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.white70, size: 18),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFilterChips() {
    final muscleGroups = [
      'Warm-up',
      'Chest',
      'Biceps',
      'Legs',
      'Back',
      'Core',
      'Shoulders',
      'Triceps',
    ];

    final difficulties = ['Beginner', 'Intermediate', 'Advanced'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 6,
        alignment: WrapAlignment.center,
        children: [
          ...muscleGroups.map((m) => ChoiceChip(
                label: Text(m),
                labelStyle: TextStyle(
                  color: selectedMuscle == m ? Colors.black : Colors.white,
                ),
                selected: selectedMuscle == m,
                selectedColor: Colors.amberAccent,
                backgroundColor: Colors.white.withOpacity(0.1),
                onSelected: (sel) =>
                    setState(() => selectedMuscle = sel ? m : null),
              )),
          const SizedBox(width: 10),
          ...difficulties.map((d) => ChoiceChip(
                label: Text(d),
                labelStyle: TextStyle(
                  color: selectedDifficulty == d ? Colors.black : Colors.white,
                ),
                selected: selectedDifficulty == d,
                selectedColor: Colors.tealAccent,
                backgroundColor: Colors.white.withOpacity(0.1),
                onSelected: (sel) =>
                    setState(() => selectedDifficulty = sel ? d : null),
              )),
        ],
      ),
    );
  }
}
