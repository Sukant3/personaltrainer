import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/program_model.dart';
import '../../../core/models/exercise_model.dart';
import '../../../data/repository/program_repository.dart';
import '../widgets/program_card.dart';
import 'program_editor_screen.dart';

class ProgramsScreen extends StatefulWidget {
  const ProgramsScreen({super.key});

  @override
  State<ProgramsScreen> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends State<ProgramsScreen> {
  final ProgramRepository _repo = ProgramRepository();
  List<ProgramModel> _programs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _programs = await _repo.loadPrograms();
    if (_programs.isEmpty) {
      _programs = _seedDefaults();
      await _repo.savePrograms(_programs);
    }
    setState(() => _loading = false);
  }

  List<ProgramModel> _seedDefaults() {
    final uuid = const Uuid();

    final benchPress = Exercise(
      id: 'e1',
      name: 'Bench Press',
      muscleGroup: ['Chest'],
      equipment: 'Barbell',
      difficulty: 'Intermediate',
      description: 'Builds chest, triceps, and shoulders.',
      cues: 'Lower bar to mid-chest, keep elbows 45°.',
      mediaUrl: 'assets/images/Barbell-Bench-Press.gif',
    );
    final squat = Exercise(
      id: 'e2',
      name: 'Squat',
      muscleGroup: ['Legs'],
      equipment: 'Barbell',
      difficulty: 'Intermediate',
      description: 'Develops lower body strength.',
      cues: 'Keep knees behind toes, chest up.',
      mediaUrl: 'assets/images/sqat.gif',
    );
    final deadlift = Exercise(
      id: 'e3',
      name: 'Deadlift',
      muscleGroup: ['Back'],
      equipment: 'Barbell',
      difficulty: 'Advanced',
      description: 'Builds total-body strength, especially posterior chain.',
      cues: 'Hinge hips, keep back neutral.',
      mediaUrl: 'assets/images/deadlift.jpg',
    );
    final pullUp = Exercise(
      id: 'e4',
      name: 'Pull Up',
      muscleGroup: ['Back'],
      equipment: 'Bodyweight',
      difficulty: 'Advanced',
      description: 'Targets lats and arms.',
      cues: 'Pull chin above bar, full control down.',
      mediaUrl: 'assets/images/Pull-up.gif',
    );
    final overheadPress = Exercise(
      id: 'e5',
      name: 'Shoulder Press',
      muscleGroup: ['Shoulders'],
      equipment: 'Dumbbell',
      difficulty: 'Intermediate',
      description: 'Develops shoulder strength and stability.',
      cues: 'Press overhead, keep core tight.',
      mediaUrl: 'assets/images/sholderpress.gif',
    );
    final curl = Exercise(
      id: 'e6',
      name: 'Dumbbell Curl',
      muscleGroup: ['Biceps'],
      equipment: 'Dumbbell',
      difficulty: 'Beginner',
      description: 'Isolates the biceps for arm strength.',
      cues: 'Elbows fixed, slow control.',
      mediaUrl: 'assets/images/Dumbellcrul.gif',
    );
    final plank = Exercise(
      id: 'e7',
      name: 'Plank',
      muscleGroup: ['Core'],
      equipment: 'Bodyweight',
      difficulty: 'Intermediate',
      description: 'Builds core endurance and stability.',
      cues: 'Maintain straight line from head to heels.',
      mediaUrl: 'assets/images/plank.gif',
    );
    final lunges = Exercise(
      id: 'e8',
      name: 'Lunges',
      muscleGroup: ['Legs'],
      equipment: 'Bodyweight',
      difficulty: 'Intermediate',
      description: 'Improves leg balance and stability.',
      cues: 'Step forward and lower both knees to 90°.',
      mediaUrl: 'assets/images/lunges.gif',
    );
    final tricepDip = Exercise(
      id: 'e9',
      name: 'Tricep Dips',
      muscleGroup: ['Triceps'],
      equipment: 'Bench',
      difficulty: 'Intermediate',
      description: 'Strengthens triceps and shoulders.',
      cues: 'Lower to 90°, elbows close to body.',
      mediaUrl: 'assets/images/triceps.gif',
    );
    final mountainClimbers = Exercise(
      id: 'e10',
      name: 'Mountain Climbers',
      muscleGroup: ['Core'],
      equipment: 'Bodyweight',
      difficulty: 'Intermediate',
      description: 'Cardio move engaging core and legs.',
      cues: 'Alternate knees quickly toward chest.',
      mediaUrl: 'assets/images/mountainclimbers.jpg',
    );

    return [
      ProgramModel(
        id: uuid.v4(),
        name: 'Beginner Push Pull Legs (PPL)',
        description:
            'A 3-day split focusing on compound movements for beginners.',
        splitType: 'PPL',
        exercises: [benchPress, pullUp, squat],
      ),
      ProgramModel(
        id: uuid.v4(),
        name: 'Intermediate Push Pull Legs',
        description:
            'Balanced 6-day intermediate strength-building PPL routine.',
        splitType: 'PPL',
        exercises: [benchPress, overheadPress, pullUp, deadlift, squat, curl],
      ),
      ProgramModel(
        id: uuid.v4(),
        name: 'Upper Lower Split',
        description:
            '4-day program alternating between upper and lower body strength.',
        splitType: 'Upper/Lower',
        exercises: [benchPress, curl, tricepDip, squat, lunges],
      ),
      ProgramModel(
        id: uuid.v4(),
        name: 'Full Body Strength',
        description: '3x per week full-body compound movement program.',
        splitType: 'Full Body',
        exercises: [benchPress, deadlift, squat, overheadPress, plank],
      ),
      ProgramModel(
        id: uuid.v4(),
        name: 'Fat Burn & Core Stability',
        description: 'High-intensity workout for fat loss and core strength.',
        splitType: 'HIIT/Core',
        exercises: [mountainClimbers, plank, lunges, tricepDip],
      ),
      ProgramModel(
        id: uuid.v4(),
        name: 'Athletic Conditioning',
        description: 'Focuses on functional strength, mobility, and endurance.',
        splitType: 'Athletic',
        exercises: [squat, pullUp, overheadPress, plank, mountainClimbers],
      ),
    ];
  }

  Future<void> _deleteProgram(String id) async {
    _programs.removeWhere((p) => p.id == id);
    await _repo.savePrograms(_programs);
    setState(() {});
  }

  void _createNew() {
    final uuid = const Uuid();
    final newProgram = ProgramModel(
      id: uuid.v4(),
      name: 'New Program',
      description: '',
      splitType: 'Custom',
      exercises: [],
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProgramEditorScreen(
          program: newProgram,
          onSave: (p) async {
            _programs.add(p);
            await _repo.savePrograms(_programs);
            setState(() {});
          },
        ),
      ),
    );
  }

  void _editProgram(ProgramModel program) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProgramEditorScreen(
          program: program,
          onSave: (updatedProgram) async {
            final index =
                _programs.indexWhere((p) => p.id == updatedProgram.id);
            if (index != -1) {
              _programs[index] = updatedProgram;
              await _repo.savePrograms(_programs);
              setState(() {});
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programs'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _createNew),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _programs.length,
              itemBuilder: (context, i) {
                final p = _programs[i];
                return ProgramCard(
                  program: p,
                  onDelete: () => _deleteProgram(p.id),
                  onEdit: () => _editProgram(p),
                );
              },
            ),
    );
  }
}
