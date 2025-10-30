// lib/features/subscription/screens/subscription_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/upgrade_modal.dart';


const _kIsProKey = 'user_is_pro';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool _loading = true;
  bool _isPro = false; // persisted subscription flag (for demo/testing)
  int _selectedIndex = 0; // 0 = Free view, 1 = Pro view

  final List<String> _freeBenefits = [
    'Manual logging (last 30 days)',
    'Basic exercise catalog & GIFs',
    'Basic PR detection',
    'Local-only backups',
  ];

  final List<String> _proBenefits = [
    'Unlimited history & exports',
    'Custom programs & progression suggestions',
    'Advanced analytics (PR charts, weekly volume)',
    'Audio coach customization & voice packs',
    'Cloud backup across reinstalls (same device)',
  ];

  @override
  void initState() {
    super.initState();
    _loadSubscription();
  }

  Future<void> _loadSubscription() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isPro = prefs.getBool(_kIsProKey) ?? false;
      _loading = false;
    });
  }

  Future<void> _saveSubscription(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kIsProKey, value);
    setState(() => _isPro = value);
  }

  Widget _buildSegmentedControl() {
    return ToggleButtons(
      isSelected: [_selectedIndex == 0, _selectedIndex == 1],
      onPressed: (i) => setState(() => _selectedIndex = i),
      borderRadius: BorderRadius.circular(8),
      constraints: const BoxConstraints(minHeight: 40, minWidth: 120),
      children: const [
        Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('Free')),
        Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('Pro')),
      ],
    );
  }

  Widget _buildBenefitList(List<String> items) {
    return Column(
      children: items.map((t) {
        return ListTile(
          leading: const Icon(Icons.check_circle_outline),
          title: Text(t),
        );
      }).toList(),
    );
  }

  Widget _buildComparisonCard() {
    final isProView = _selectedIndex == 1;
    final title = isProView ? 'Pro — Premium features' : 'Free — Basic features';
    final legend = isProView ? 'Monthly / Annual pricing in modal' : 'Free forever';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(legend, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            _buildBenefitList(isProView ? _proBenefits : _freeBenefits),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final isProViewSelected = _selectedIndex == 1;

    return Scaffold(
      appBar: AppBar(title: const Text('Subscription')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Current account banner
              Card(
                color: _isPro ? Colors.green.shade50 : Colors.grey.shade50,
                child: ListTile(
                  leading: Icon(_isPro ? Icons.workspace_premium : Icons.person_outline,
                      size: 36, color: _isPro ? Colors.green : Colors.grey),
                  title: Text(_isPro ? 'You are on Pro' : 'You are on Free'),
                  subtitle: Text(_isPro ? 'Pro features unlocked' : 'Upgrade for advanced features'),
                  trailing: TextButton(
                    onPressed: () async {
                      // simple toggle for dev/testing
                      await _saveSubscription(!_isPro);
                    },
                    child: Text(_isPro ? 'Revoke (dev)' : 'Simulate Pro (dev)'),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Segmented control to preview tiers
              _buildSegmentedControl(),

              // Comparison card
              _buildComparisonCard(),

              // Price / CTA area
              const Spacer(),
              if (_isPro)
                Column(
                  children: [
                    Text('Active: Pro subscription', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Open management flow — for now show a simple dialog
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Manage Subscription'),
                            content: const Text('Subscription management (cancel/restore) flow goes here.'),
                            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
                          ),
                        );
                      },
                      icon: const Icon(Icons.subscriptions),
                      label: const Text('Manage Subscription'),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    Text('Free', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     // Open "Upgrade to Pro" modal — Task 8.3 will implement a real modal
                    //     showDialog(
                    //       context: context,
                    //       builder: (_) => AlertDialog(
                    //         title: const Text('Upgrade to Pro'),
                    //         content: const Text('Tap Upgrade to simulate a Pro purchase (for dev/testing).'),
                    //         actions: [
                    //           TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                    //           ElevatedButton(
                    //             onPressed: () async {
                    //               // simulate successful purchase -> set isPro true
                    //               await _saveSubscription(true);
                    //               Navigator.pop(context);
                    //               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Upgraded to Pro (local demo)')));
                    //             },
                    //             child: const Text('Upgrade'),
                    //           ),
                    //         ],
                    //       ),
                    //     );
                    //   },
                    //   child: const Text('Upgrade to Pro'),
                    // ),

                    ElevatedButton(
                      onPressed: () {
                        // ✅ Open real upgrade modal (from upgrade_modal.dart)
                        showUpgradeModal(context);
                      },
                      child: const Text('Upgrade to Pro'),
                    ),
                    
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        // show comparison or trial info
                        showModalBottomSheet(
                          context: context,
                          builder: (_) => Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Pro Trial', style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 12),
                                const Text('7-day free trial for new users. Payment handled via platform IAP.'),
                                const SizedBox(height: 12),
                                ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))
                              ],
                            ),
                          ),
                        );
                      },
                      child: const Text('See trial & pricing'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
