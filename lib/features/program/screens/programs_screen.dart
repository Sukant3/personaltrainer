import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/program_model.dart';
import '../../../core/models/exercise_model.dart';
import '../repository/program_firestore_repository.dart';
import '../widgets/program_card.dart';
import 'program_editor_screen.dart';

class ProgramsScreen extends StatefulWidget {
  const ProgramsScreen({super.key});

  @override
  State<ProgramsScreen> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends State<ProgramsScreen> {
  final ProgramFirestoreRepository _repo = ProgramFirestoreRepository();
  List<ProgramModel> _programs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPrograms();
  }

  Future<void> _loadPrograms() async {
    setState(() => _loading = true);
    final data = await _repo.loadPrograms();

    if (data.isEmpty) {
      // ✅ Only seed once (for first-time users)
      final defaults = _seedDefaults();
      await _repo.savePrograms(defaults);
      _programs = defaults;
    } else {
      _programs = data;
    }

    setState(() => _loading = false);
  }

  // ✅ Generate default sample programs
  List<ProgramModel> _seedDefaults() {
    final uuid = const Uuid();

    final bench = Exercise(
      id: 'e1',
      name: 'Bench Press',
      muscleGroup: ['Chest'],
      equipment: 'Barbell',
      difficulty: 'Intermediate',
      description: 'Builds chest, triceps, and shoulders.',
      cues: ['Lower to chest', 'Press evenly'],
      mediaUrl: 'assets/images/Barbell-Bench-Press.gif',
    );

    final squat = Exercise(
      id: 'e2',
      name: 'Squat',
      muscleGroup: ['Legs'],
      equipment: 'Barbell',
      difficulty: 'Intermediate',
      description: 'Develops leg strength.',
      cues: ['Keep knees behind toes'],
      mediaUrl: 'assets/images/sqat.gif',
    );

    return [
      ProgramModel(
        id: uuid.v4(),
        name: 'Full Body Starter',
        description: 'A simple 2-exercise full body routine.',
        splitType: 'Full Body',
        exercises: [bench, squat],
      ),
    ];
  }

  // ✅ Create new (doesn’t save until “Save” pressed)
  void _createNewProgram() {
    final uuid = const Uuid();
    final newProgram = ProgramModel(
      id: uuid.v4(),
      name: '',
      description: '',
      splitType: 'Custom',
      exercises: [],
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProgramEditorScreen(
          program: newProgram,
          onSave: (savedProgram) async {
            // Save only after user clicks Save
            _programs.add(savedProgram);
            await _repo.saveProgram(savedProgram);
            setState(() {});
          },
        ),
      ),
    );
  }

  Future<void> _editProgram(ProgramModel program) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProgramEditorScreen(
          program: program,
          onSave: (updatedProgram) async {
            final index =
                _programs.indexWhere((p) => p.id == updatedProgram.id);
            if (index != -1) {
              _programs[index] = updatedProgram;
              await _repo.saveProgram(updatedProgram);
              setState(() {});
            }
          },
        ),
      ),
    );
  }

  Future<void> _deleteProgram(String id) async {
    await _repo.deleteProgram(id);
    _programs.removeWhere((p) => p.id == id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programs'),
        actions: [
          IconButton(onPressed: _createNewProgram, icon: const Icon(Icons.add))
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _programs.isEmpty
              ? const Center(child: Text('No programs found'))
              : ListView.builder(
                  itemCount: _programs.length,
                  itemBuilder: (context, index) {
                    final p = _programs[index];
                    return ProgramCard(
                      program: p,
                      onEdit: () => _editProgram(p),
                      onDelete: () => _deleteProgram(p.id),
                    );
                  },
                ),
    );
  }
}
