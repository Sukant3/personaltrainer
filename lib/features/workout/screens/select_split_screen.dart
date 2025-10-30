import 'package:flutter/material.dart';

class SelectSplitScreen extends StatelessWidget {
  const SelectSplitScreen({Key? key}) : super(key: key);

  // Define your splits and optional days per split here.
  final List<_Split> _splits = const [
    _Split(name: 'Push', description: 'Chest, Shoulders, Triceps', days: 3),
    _Split(name: 'Pull', description: 'Back, Biceps', days: 2),
    _Split(name: 'Legs', description: 'Quads, Hamstrings, Glutes, Calves', days: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Split / Day')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: _splits.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,     // 2 columns
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (context, index) {
            final split = _splits[index];
            return _SplitCard(split: split);
          },
        ),
      ),
    );
  }
}

class _Split {
  final String name;
  final String description;
  final int days;
  const _Split({required this.name, required this.description, this.days = 1});
}

class _SplitCard extends StatelessWidget {
  final _Split split;
  const _SplitCard({required this.split, Key? key}) : super(key: key);

  void _openDayPicker(BuildContext context) {
    // If split has more than 1 day, show the Day selection; otherwise navigate with day 1.
    if (split.days <= 1) {
      Navigator.pushNamed(context, '/exercises', arguments: {'split': split.name, 'day': 1});
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('${split.name} — Select Day', style: Theme.of(ctx).textTheme.headlineSmall),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(split.days, (i) {
                  final day = i + 1;
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx); // close sheet
                      Navigator.pushNamed(context, '/exercises', arguments: {'split': split.name, 'day': day});
                    },
                    child: Text('Day $day'),
                  );
                }),
              ),
              const SizedBox(height: 12),
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel'))
            ]),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _openDayPicker(context),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                child: Icon(
                  split.name == 'Push'
                      ? Icons.bolt
                      : split.name == 'Pull'
                          ? Icons.arrow_back
                          : Icons.fitness_center,
                  size: 22,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(split.name, style: Theme.of(context).textTheme.titleLarge)),
            ]),
            const SizedBox(height: 10),
            Text(split.description, style: Theme.of(context).textTheme.bodyMedium),
            const Spacer(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('${split.days} ${split.days > 1 ? "days" : "day"}', style: Theme.of(context).textTheme.bodySmall),
              TextButton(onPressed: () => _openDayPicker(context), child: const Text('Open'))
            ])
          ]),
        ),
      ),
    );
  }
}
