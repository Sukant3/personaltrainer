import 'package:flutter/material.dart';
import '../../../theme/theme_notifier.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ThemeMode _selectedMode = themeNotifier.themeMode;

  void _updateTheme(ThemeMode mode) {
    setState(() => _selectedMode = mode);
    themeNotifier.setTheme(mode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Column(
        children: [
          RadioListTile<ThemeMode>(
            title: const Text("Light"),
            value: ThemeMode.light,
            groupValue: _selectedMode,
            onChanged: (v) => _updateTheme(v!),
          ),
          RadioListTile<ThemeMode>(
            title: const Text("Dark"),
            value: ThemeMode.dark,
            groupValue: _selectedMode,
            onChanged: (v) => _updateTheme(v!),
          ),
          RadioListTile<ThemeMode>(
            title: const Text("System"),
            value: ThemeMode.system,
            groupValue: _selectedMode,
            onChanged: (v) => _updateTheme(v!),
          ),
        ],
      ),
    );
  }
}
