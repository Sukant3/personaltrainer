import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/program_model.dart';
import '../../../core/models/exercise_model.dart';

class ProgramEditorScreen extends StatefulWidget {
  final ProgramModel program;
  final ValueChanged<ProgramModel>? onSave;

  const ProgramEditorScreen({super.key, required this.program, this.onSave});

  @override
  State<ProgramEditorScreen> createState() => _ProgramEditorScreenState();
}

class _ProgramEditorScreenState extends State<ProgramEditorScreen> {
  late ProgramModel _program;
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();

  final List<String> _splitOptions = const [
    'PPL',
    'Push',
    'Pull',
    'Legs',
    'Full',
    'Upper',
    'Lower',
    'Upper/Lower',
    'Custom',
    'HIIT/Core',
    'Athletic',
  ];

  final List<Exercise> _catalog = [
    Exercise(
      id: 'e1',
      name: 'Bench Press',
      muscleGroup: 'Chest',
      equipment: 'Barbell',
      difficulty: 'Intermediate',
      description: '',
      cues: '',
      mediaUrl: 'assets/images/Barbell-Bench-Press.gif',
    ),
    Exercise(
      id: 'e2',
      name: 'Deadlift',
      muscleGroup: 'Back',
      equipment: 'Barbell',
      difficulty: 'Advanced',
      description: '',
      cues: '',
      mediaUrl: 'assets/images/deadlift.jpg',
    ),
    Exercise(
      id: 'e3',
      name: 'Squat',
      muscleGroup: 'Legs',
      equipment: 'Barbell',
      difficulty: 'Intermediate',
      description: '',
      cues: '',
      mediaUrl: 'assets/images/sqat.gif',
    ),
    Exercise(
      id: 'e4',
      name: 'Overhead Press',
      muscleGroup: 'Shoulders',
      equipment: 'Barbell',
      difficulty: 'Intermediate',
      description: '',
      cues: '',
      mediaUrl: 'assets/images/sholderpress.gif',
    ),
    Exercise(
      id: 'e5',
      name: 'Barbell Row',
      muscleGroup: 'Back',
      equipment: 'Barbell',
      difficulty: 'Intermediate',
      description: '',
      cues: '',
      mediaUrl: 'assets/images/deadlift.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _program = ProgramModel(
      id: widget.program.id,
      name: widget.program.name,
      description: widget.program.description,
      splitType: widget.program.splitType,
      exercises: List.from(widget.program.exercises),
    );

    if (!_splitOptions.contains(_program.splitType)) {
      _program.splitType = 'Custom';
    }

    _nameCtrl.text = _program.name;
    _descCtrl.text = _program.description;
  }

  void _addExercise(Exercise ex) {
    setState(() {
      _program.exercises.add(
        Exercise(
          id: const Uuid().v4(),
          name: ex.name,
          muscleGroup: ex.muscleGroup,
          equipment: ex.equipment,
          difficulty: ex.difficulty,
          description: ex.description,
          cues: ex.cues,
          mediaUrl: ex.mediaUrl,
          isVideo: ex.isVideo,
        ),
      );
    });
  }

  void _removeAt(int index) {
    setState(() => _program.exercises.removeAt(index));
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _program.exercises.removeAt(oldIndex);
      _program.exercises.insert(newIndex, item);
    });
  }

  void _save() {
    _program.name =
        _nameCtrl.text.trim().isEmpty ? 'Untitled' : _nameCtrl.text.trim();
    _program.description = _descCtrl.text.trim();

    widget.onSave?.call(_program);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Program'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: 'Program name'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _descCtrl,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Split:'),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      value: _program.splitType,
                      items: _splitOptions
                          .map(
                            (s) =>
                                DropdownMenuItem(value: s, child: Text(s)),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() => _program.splitType = v);
                      },
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () => _showCatalogPicker(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Exercise'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Exercises'),
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              onReorder: _onReorder,
              itemCount: _program.exercises.length,
              itemBuilder: (context, index) {
                final ex = _program.exercises[index];
                return Dismissible(
                  key: ValueKey(ex.id),
                  background: Container(color: Colors.redAccent),
                  onDismissed: (_) => _removeAt(index),
                  child: ListTile(
                    key: ValueKey('tile_${ex.id}'),
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(ex.mediaUrl),
                    ),
                    title: Text(ex.name),
                    subtitle: Text('${ex.muscleGroup} • ${ex.equipment}'),
                    trailing: const Icon(Icons.drag_handle),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCatalogPicker(BuildContext ctx) async {
    await showModalBottomSheet(
      context: ctx,
      builder: (context) {
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemBuilder: (c, i) {
            final ex = _catalog[i];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(ex.mediaUrl),
              ),
              title: Text(ex.name),
              subtitle: Text('${ex.muscleGroup} • ${ex.difficulty}'),
              onTap: () {
                Navigator.pop(context);
                _addExercise(ex);
              },
            );
          },
          separatorBuilder: (_, __) => const Divider(),
          itemCount: _catalog.length,
        );
      },
    );
  }
}
