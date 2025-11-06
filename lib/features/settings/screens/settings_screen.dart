import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:personaltrainer/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:personaltrainer/features/auth/screens/login_screen.dart';
import 'package:personaltrainer/features/subscription/screens/subscription_screen.dart';
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
    final auth = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      // appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Settings",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 20),

            const Text(
              "Theme Preferences",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),

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

            const Spacer(),

            // 🟢 Subscription Button (restored)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SubscriptionScreen()),
                );
              },
              icon: const Icon(Icons.workspace_premium_rounded),
              label: const Text("Subscription"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade600,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 🔒 Logout Button
            ElevatedButton.icon(
              onPressed: () async {
                await auth.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout_rounded),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 226, 55, 55),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
