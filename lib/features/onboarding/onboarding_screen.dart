import 'package:flutter/material.dart';
import '../home/home_shell.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  final List<_OnboardPageData> _pages = const [
    _OnboardPageData(
      icon: Icons.track_changes,
      title: "Track workouts easily",
      desc: "Log sets, reps, and weights quickly.",
    ),
    _OnboardPageData(
      icon: Icons.auto_graph,
      title: "Visualize progress",
      desc: "See your volume and PRs grow over time.",
    ),
    _OnboardPageData(
      icon: Icons.fitness_center,
      title: "Stay consistent",
      desc: "Follow your Push / Pull / Legs plan.",
    ),
  ];

  void _nextPage() {
    if (_page == _pages.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeShell()),
      );
    } else {
      _controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemCount: _pages.length,
        onPageChanged: (i) => setState(() => _page = i),
        itemBuilder: (_, i) => _OnboardPage(page: _pages[i]),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: FilledButton(
          onPressed: _nextPage,
          child: Text(_page == _pages.length - 1 ? "Get Started" : "Next"),
        ),
      ),
    );
  }
}

class _OnboardPageData {
  final IconData icon;
  final String title, desc;
  const _OnboardPageData({
    required this.icon,
    required this.title,
    required this.desc,
  });
}

class _OnboardPage extends StatelessWidget {
  final _OnboardPageData page;
  const _OnboardPage({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(page.icon,
              size: 120, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 32),
          Text(page.title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text(page.desc,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
