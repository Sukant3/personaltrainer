// lib/features/subscription/widgets/upgrade_modal.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kIsProKey = 'user_is_pro';

Future<void> showUpgradeModal(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => const _UpgradeModal(),
  );
}

class _UpgradeModal extends StatefulWidget {
  const _UpgradeModal();

  @override
  State<_UpgradeModal> createState() => _UpgradeModalState();
}

class _UpgradeModalState extends State<_UpgradeModal> {
  bool _isProcessing = false;

  Future<void> _simulatePayment() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 2)); // fake delay

    // Save locally as "Pro"
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kIsProKey, true);

    if (!mounted) return;
    Navigator.pop(context); // close modal
    Navigator.pushReplacementNamed(context, '/payment_success');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Center(
            child: Text('Upgrade to Pro',
                style: Theme.of(context).textTheme.headlineSmall),
          ),
          const SizedBox(height: 16),
          const Text(
            'Unlock all premium features:',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const ListTile(
            leading: Icon(Icons.workspace_premium_outlined),
            title: Text('Advanced analytics & unlimited logs'),
          ),
          const ListTile(
            leading: Icon(Icons.cloud_outlined),
            title: Text('Cloud backup & sync'),
          ),
          const ListTile(
            leading: Icon(Icons.graphic_eq_outlined),
            title: Text('Audio coach & custom voice packs'),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: _isProcessing ? null : _simulatePayment,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: _isProcessing
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Upgrade Now'),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    );
  }
}
