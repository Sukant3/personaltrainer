import 'package:flutter/material.dart';
import '../../../core/models/exercise_model.dart';
import 'workout_log_screen.dart';
import '../widgets/exercise_card.dart';

class WorkoutScreen extends StatefulWidget {
  final String category;
  const WorkoutScreen({super.key, required this.category});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  late List<Exercise> _exercises;
  late List<Exercise> _filteredExercises;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _exercises = getExercisesForCategory(widget.category);
    _filteredExercises = _exercises;

    _searchController.addListener(() {
      _filterExercises();
    });
  }

  void _filterExercises() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredExercises = _exercises.where((exercise) {
        return exercise.name.toLowerCase().contains(query) ||
            exercise.muscleGroup.any((group) => group.toLowerCase().contains(query)) ||
            exercise.equipment.toLowerCase().contains(query);
      }).toList();
    });
  }

  List<Exercise> getExercisesForCategory(String category) {
    switch (category) {
      case 'Push':
        return [
          Exercise(
            id: '101',
            name: 'Barbell Bench Press (Flat)',
            muscleGroup: ['Push','Chest'],
            equipment: 'Barbell, Bench',
            difficulty: 'Intermediate',
            description: 'A foundational movement for building overall chest mass and strength.',
            cues: ['Retract shoulder blades, lower the bar to your mid-chest, and drive up.'],
            mediaUrl: 'assets/images/Barbell Bench Press (Flat).png',
          ),
          Exercise(
            id: '102',
            name: 'Incline Dumbbell Press',
            muscleGroup: ['Push','Chest'],
            equipment: 'Dumbbells, Incline Bench',
            difficulty: 'Intermediate',
            description: 'Targets the upper chest (clavicular head) for shape and density.',
            cues: ['Control the descent, press dumbbells over the upper chest, and keep wrists straight.'],
            mediaUrl: 'assets/images/Incline Dumbbell Press.png',
          ),
          Exercise(
            id: '103',
            name: 'Push-Ups (Standard)',
            muscleGroup: ['Push','Chest'],
            equipment: 'Bodyweight',
            difficulty: 'Beginner',
            description: 'Effective bodyweight exercise for chest, shoulders, and triceps.',
            cues: ['Maintain a straight line from head to heels. Lower until chest is near the floor.'],
            mediaUrl: 'assets/images/Push-Ups (Standard).png',
          ),
          Exercise(
            id: '104',
            name: 'Cable Crossovers (Mid)',
            muscleGroup: ['Push','Chest'],
            equipment: 'Cable Machine',
            difficulty: 'Intermediate',
            description: 'Isolates the chest muscles, focusing on the inner contraction and stretch.',
            cues: ['Keep a slight bend in your elbows. Squeeze the cables together in front of your chest.'],
            mediaUrl: 'assets/images/Cable Crossovers (Mid).png',
          ),
          Exercise(
            id: '105',
            name: 'Machine Chest Press',
            muscleGroup: ['Push','Chest'],
            equipment: 'Machine',
            difficulty: 'Beginner',
            description: 'A stable press that allows for maximum isolation and less stabilizer involvement.',
            cues: ['Adjust the seat so the handles align with your mid-chest. Control the weight back slowly.'],
            mediaUrl: 'assets/images/Machine Chest Press.png',
          ),
          Exercise(
            id: '106',
            name: 'Chest Dips',
            muscleGroup: ['Push','Chest'],
            equipment: 'Dip Station',
            difficulty: 'Advanced',
            description: 'A compound bodyweight movement focusing on the lower chest and triceps.',
            cues: ['Lean torso slightly forward and flare elbows out wide to emphasize the chest.'],
            mediaUrl: 'assets/images/Chest Dips.png',
          ),

          // Shoulders
          Exercise(
            id: '107',
            name: 'Overhead Press (Barbell Standing)',
            muscleGroup: ['Push','Shoulders'],
            equipment: 'Barbell',
            difficulty: 'Advanced',
            description: 'Develops overall shoulder strength and stability, particularly the anterior deltoids.',
            cues: ['Keep core tight and back straight. Press the bar straight overhead, finishing with the bar slightly behind your head.'],
            mediaUrl: 'assets/images/Overhead Press (Barbell Standing).png',
          ),
          Exercise(
            id: '108',
            name: 'Dumbbell Lateral Raises',
            muscleGroup: ['Push','Shoulders'],
            equipment: 'Dumbbells',
            difficulty: 'Intermediate',
            description: 'Isolates the medial (side) deltoids for wider shoulders.',
            cues: ['Raise the dumbbells out to the sides until parallel to the floor. Imagine pouring water out of a pitcher.'],
            mediaUrl: 'assets/images/Dumbbell Lateral Raises.png',
          ),
          Exercise(
            id: '109',
            name: 'Dumbbell Front Raises',
            muscleGroup: ['Push','Shoulders'],
            equipment: 'Dumbbells',
            difficulty: 'Intermediate',
            description: 'Targets the anterior (front) deltoids.',
            cues: ['Lift the dumbbells straight out in front of you to shoulder height, alternating or simultaneously.'],
            mediaUrl: 'assets/images/Front_Raises_Dumbbell.png',
          ),

          // Triceps
          Exercise(
            id: '110',
            name: 'Triceps Pushdowns (Rope)',
            muscleGroup: ['Push','Triceps'],
            equipment: 'Cable Machine',
            difficulty: 'Beginner',
            description: 'A great isolation movement to target all three heads of the triceps.',
            cues: ['Keep elbows tucked tightly to your sides. Fully extend arms and squeeze the triceps at the bottom.'],
            mediaUrl: 'assets/images/Triceps Pushdowns (Rope).png',
          ),
          Exercise(
            id: '111',
            name: 'Skull Crushers (EZ Bar)',
            muscleGroup: ['Push','Triceps'],
            equipment: 'Barbell, Bench',
            difficulty: 'Advanced',
            description: 'Effectively targets the long head of the triceps for mass.',
            cues: ['Lie on a bench and lower the bar towards your forehead (or slightly behind it) by bending only your elbows.'],
            mediaUrl: 'assets/images/Skull Crushers (EZ Bar).png',
          ),
          Exercise(
            id: '112',
            name: 'Overhead Triceps Extension (Dumbbell)',
            muscleGroup: ['Push','Triceps'],
            equipment: 'Dumbbell',
            difficulty: 'Intermediate',
            description: 'Excellent for maximizing the stretch and growth of the triceps long head.',
            cues: ['Hold a single dumbbell overhead with both hands. Lower the weight behind your head, keeping upper arms fixed.'],
            mediaUrl: 'assets/images/Overhead Triceps Extension (Dumbbell).png',
          ),
        ];
      case 'Pull':
        return [
          Exercise(
            id: '201',
            name: 'Lat Pulldowns (Wide Grip)',
            muscleGroup: ['Pull','Back (Lats & Vertical)'],
            equipment: 'Cable Machine',
            difficulty: 'Beginner',
            description: 'Primary exercise for developing back width (lats).',
            cues: ['Lean back slightly. Pull the bar down to your upper chest, focusing on squeezing the lats.'],
            mediaUrl: 'assets/images/Lat Pulldowns (Wide Grip).png',
          ),
          Exercise(
            id: '202',
            name: 'Pull-Ups (Overhand)',
            muscleGroup: ['Pull','Back (Lats & Vertical)'],
            equipment: 'Pull-Up Bar',
            difficulty: 'Advanced',
            description: 'The definitive bodyweight exercise for maximizing back width and relative strength.',
            cues: ['Grip wider than shoulder-width. Pull chest towards the bar, initiating the movement with your back.'],
            mediaUrl: 'assets/images/Pull-Ups (Overhand).png',
          ),
          Exercise(
            id: '203',
            name: 'Chin-Ups (Underhand)',
            muscleGroup: ['Pull','Back (Lats & Vertical)'],
            equipment: 'Pull-Up Bar',
            difficulty: 'Intermediate',
            description: 'Similar to pull-ups, but heavily recruits the biceps and lower lats.',
            cues: ['Use an underhand, shoulder-width grip. Pull until your chin clears the bar.'],
            mediaUrl: 'assets/images/Chin-Ups (Underhand).png',
          ),

          // Back (Horizontal Pull)
          Exercise(
            id: '204',
            name: 'Barbell Rows (Bent-Over)',
            muscleGroup: ['Pull','Back (Mid-Back & Horizontal)'],
            equipment: 'Barbell',
            difficulty: 'Advanced',
            description: 'Builds thickness and density across the entire back, targeting the mid-back and lats.',
            cues: ['Bend over with a straight back, rowing the bar towards your belly button.'],
            mediaUrl: 'assets/images/Barbell Rows (Bent-Over).png',
          ),
          Exercise(
            id: '205',
            name: 'Single-Arm Dumbbell Row',
            muscleGroup: ['Pull','Back (Mid-Back & Horizontal)'],
            equipment: 'Dumbbell, Bench',
            difficulty: 'Intermediate',
            description: 'Helps correct muscle imbalances between the left and right side of the back.',
            cues: ['Keep your back parallel to the floor. Pull the dumbbell towards your hip, not your shoulder.'],
            mediaUrl: 'assets/images/Single-Arm Dumbbell Row.png',
          ),
          Exercise(
            id: '206',
            name: 'Seated Cable Rows',
            muscleGroup: ['Pull','Back (Mid-Back & Horizontal)'],
            equipment: 'Cable Machine',
            difficulty: 'Beginner',
            description: 'Excellent for isolating the mid-back and improving posture.',
            cues: ['Keep your torso upright. Drive your elbows back and squeeze your shoulder blades together.'],
            mediaUrl: 'assets/images/Seated Cable Rows.png',
          ),
          Exercise(
            id: '207',
            name: 'Shrugs (Dumbbell)',
            muscleGroup: ['Pull','Back (Mid-Back & Horizontal)'],
            equipment: 'Dumbbells',
            difficulty: 'Beginner',
            description: 'Directly targets the trapezius muscles (traps).',
            cues:[ 'Keep arms straight and lift your shoulders straight up towards your ears; do not roll them.'],
            mediaUrl: 'assets/images/Shrugs (Dumbbell).png',
          ),

          // Biceps
          Exercise(
            id: '208',
            name: 'Barbell Curls',
            muscleGroup: ['Pull','Biceps'],
            equipment: 'Barbell',
            difficulty: 'Intermediate',
            description: 'A mass builder for the entire biceps muscle.',
            cues:[ 'Keep your elbows fixed at your sides. Curl the bar up without swinging your back.'],
            mediaUrl: 'assets/images/Barbell_Curls.png',
          ),
          Exercise(
            id: '209',
            name: 'Hammer Curls',
            muscleGroup: ['Pull','Biceps'],
            equipment: 'Dumbbells',
            difficulty: 'Beginner',
            description: 'Works the biceps, brachialis (arm thickness), and forearm strength.',
            cues: ['Hold dumbbells with palms facing each other (neutral grip). Curl up towards your shoulders.'],
            mediaUrl: 'assets/images/Hammer_Curls.png',
          ),
          Exercise(
            id: '210',
            name: 'Preacher Curls',
            muscleGroup: ['Pull','Biceps'],
            equipment: 'Preacher Bench, Barbell/Dumbbell',
            difficulty: 'Intermediate',
            description: 'Forces strict form, isolating the biceps for peak development.',
            cues: ['Rest upper arms on the pad. Curl the weight up, controlling the entire range of motion.'],
            mediaUrl: 'assets/images/Preacher_Curls.png',
          ),

          // Rear Deltoids
          Exercise(
            id: '211',
            name: 'Face Pulls',
            muscleGroup: ['Pull','Rear Deltoids'],
            equipment: 'Cable Machine',
            difficulty: 'Intermediate',
            description: 'Crucial for shoulder health, targeting the rear delts and rotator cuff.',
            cues: ['Pull the rope towards your face, pulling your hands apart and squeezing your rear delts.'],
            mediaUrl: 'assets/images/Face_Pulls.png',
          ),
          Exercise(
            id: '212',
            name: 'Dumbbell Rear Delt Flyes (Bent-Over)',
            muscleGroup: ['Pull','Rear Deltoids'],
            equipment: 'Dumbbells',
            difficulty: 'Intermediate',
            description: 'Isolates the posterior (rear) deltoids.',
            cues:[ 'Bend over with a flat back, arms hanging. Lift the dumbbells out to the sides, keeping a slight elbow bend.'],
            mediaUrl: 'assets/images/Dumbbell_Rear_Delt_Flyes_(Bent-Over).png',
          ),
        ];
      case 'Legs':
        return [
          Exercise(
            id: '301',
            name: 'Barbell Back Squats',
            muscleGroup: ['Legs','Quads & Glutes'],
            equipment: 'Barbell, Squat Rack',
            difficulty: 'Advanced',
            description: 'The king of all exercises, building strength and size in the quads, glutes, and core.',
            cues:[ 'Keep chest up, descend by sitting back, and break parallel. Drive up through your heels.'],
            mediaUrl: 'assets/images/Barbell_Back_Squats.png',
          ),
          Exercise(
            id: '302',
            name: 'Front Squats',
            muscleGroup: ['Legs','Quads & Glutes'],
            equipment: 'Barbell, Squat Rack',
            difficulty: 'Advanced',
            description: 'Emphasizes the quads and core stability due to the front rack position.',
            cues: ['Maintain an upright torso. Keep elbows high and parallel to the floor.'],
            mediaUrl: 'assets/images/Front_Squats.png',
          ),
          Exercise(
            id: '303',
            name: 'Goblet Squats',
            muscleGroup: ['Legs','Quads & Glutes'],
            equipment: 'Dumbbell or Kettlebell',
            difficulty: 'Beginner',
            description: 'Great for learning squat form and improving mobility.',
            cues: ['Hold one dumbbell vertically against your chest. Squat down deep, keeping your chest up.'],
            mediaUrl: 'assets/images/Goblet_Squats.png',
          ),
          Exercise(
            id: '304',
            name: 'Lunges (Forward)',
            muscleGroup: ['Legs','Quads & Glutes'],
            equipment: 'Bodyweight or Dumbbell',
            difficulty: 'Intermediate',
            description: 'Improves unilateral leg strength, balance, and core stability.',
            cues: ['Step forward, ensure your front knee tracks over your ankle, and your back knee taps the floor gently.'],
            mediaUrl: 'assets/images/Lunges_(Forward).png',
          ),
          Exercise(
            id: '305',
            name: 'Bulgarian Split Squats',
            muscleGroup: ['Legs','Quads & Glutes'],
            equipment: 'Dumbbells, Bench',
            difficulty: 'Advanced',
            description: 'An intense single-leg movement, maximizing quad and glute hypertrophy.',
            cues: ['Place one foot back on a bench. Drop straight down, keeping the weight over your front foot.'],
            mediaUrl: 'assets/images/Bulgarian_Split_Squats.png',
          ),

          // Hamstrings & Glutes (Hip Hinge Movements)
          Exercise(
            id: '306',
            name: 'Conventional Deadlifts',
            muscleGroup: ['Legs','Hamstrings & Glutes'], // Primarily Legs/Posterior Chain
            equipment: 'Barbell',
            difficulty: 'Advanced',
            description: 'Total body exercise, maximizing strength in hamstrings, glutes, and back.',
            cues: ['Start with hips low and back straight. Push the floor away with your feet. Keep the bar close to your body.'],
            mediaUrl: 'assets/images/Conventional_Deadlifts.png',
          ),
          Exercise(
            id: '307',
            name: 'Romanian Deadlifts (RDLs)',
            muscleGroup: ['Legs','Hamstrings & Glutes'],
            equipment: 'Barbell or Dumbbell',
            difficulty: 'Intermediate',
            description: 'Excellent for hamstring and glute isolation, focusing on the stretch.',
            cues: ['Maintain a slight bend in your knees. Hinge at the hips and lower the weight until a stretch is felt in the hamstrings.'],
            mediaUrl: 'assets/images/Romanian_Deadlifts_(RDLs).png',
          ),
          Exercise(
            id: '308',
            name: 'Hip Thrusts',
            muscleGroup: ['Legs','Hamstrings & Glutes'],
            equipment: 'Barbell, Bench',
            difficulty: 'Intermediate',
            description: 'Arguably the best exercise for glute development.',
            cues: ['Rest upper back against a bench. Drive hips up, achieving full extension and squeezing the glutes at the top.'],
            mediaUrl: 'assets/images/Hip_Thrusts.png',
          ),

          // Isolation
          Exercise(
            id: '309',
            name: 'Leg Extensions',
            muscleGroup: ['Legs','Isolation'],
            equipment: 'Machine',
            difficulty: 'Beginner',
            description: 'Isolates the quadriceps for muscle definition.',
            cues: ['Point toes slightly out (or in) to adjust quad focus. Fully extend the legs and squeeze at the top.'],
            mediaUrl: 'assets/images/Leg_Extensions.png',
          ),
          Exercise(
            id: '310',
            name: 'Lying Hamstring Curls',
            muscleGroup: ['Legs','Isolation'],
            equipment: 'Machine',
            difficulty: 'Beginner',
            description: 'Isolates the hamstring muscles for better strength and flexibility.',
            cues: ['Curl the pads towards your glutes, controlling the weight on the way back up.'],
            mediaUrl: 'assets/images/Lying_Hamstring_Curls.png',
          ),
          Exercise(
            id: '311',
            name: 'Standing Calf Raises',
            muscleGroup: ['Legs','Isolation'],
            equipment: 'Machine or Dumbbells',
            difficulty: 'Beginner',
            description: 'Targets the gastrocnemius (outer) head of the calf.',
            cues:[ 'Press through the ball of your foot. Achieve a full stretch at the bottom and squeeze at the top.'],
            mediaUrl: 'assets/images/Standing_Calf_Raises.png',
          ),
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.category} Workout",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor ??
            (isDark ? Colors.black : Colors.white),
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      body: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: 'Search exercises...',
                hintStyle: TextStyle(
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                filled: true,
                fillColor: isDark ? Colors.grey[850] : Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 🏋️ Exercise List
          Expanded(
            child: _filteredExercises.isEmpty
                ? Center(
                    child: Text(
                      'No exercises found 😕',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white70 : Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredExercises.length,
                    itemBuilder: (context, index) {
                      final exercise = _filteredExercises[index];
                      return ExerciseCard(
                        exercise: exercise,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  WorkoutLogScreen(exercise: exercise),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}


