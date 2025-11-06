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
  bool _isPro = false;
  int _selectedIndex = 0;

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

  Widget _buildBenefitList(List<String> items, Color textColor) {
    return Column(
      children: items.map((t) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(t, style: TextStyle(color: textColor))),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isProView = _selectedIndex == 1;

    // Dynamic colors depending on theme
    final bgColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;
    final textPrimary = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final textSecondary = theme.textTheme.bodyMedium?.color?.withOpacity(0.7) ?? Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor ?? (isDark ? Colors.black : Colors.white),
        title: Text("Subscription", style: TextStyle(color: textPrimary)),
        iconTheme: IconThemeData(color: textPrimary),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 🔹 Membership header
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFB8860B), Color(0xFFFFD700)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.workspace_premium_rounded, size: 48, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isPro ? "Pro Member" : "Free Member",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            _isPro
                                ? "All premium features unlocked"
                                : "Upgrade for exclusive benefits",
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () async => await _saveSubscription(!_isPro),
                      child: Text(
                        _isPro ? "Revoke (dev)" : "Simulate Pro (dev)",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 🔸 Toggle control
              Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ToggleButtons(
                  isSelected: [_selectedIndex == 0, _selectedIndex == 1],
                  onPressed: (i) => setState(() => _selectedIndex = i),
                  borderRadius: BorderRadius.circular(10),
                  fillColor: Colors.amber,
                  selectedColor: Colors.black,
                  color: textPrimary,
                  constraints: const BoxConstraints(minHeight: 40, minWidth: 120),
                  children: const [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('Free')),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('Pro')),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Benefits card
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.amber, width: 1),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isProView ? 'Pro — Premium features' : 'Free — Basic features',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isProView ? 'Monthly / Annual pricing in modal' : 'Free forever',
                      style: TextStyle(color: textSecondary),
                    ),
                    const SizedBox(height: 12),
                    _buildBenefitList(isProView ? _proBenefits : _freeBenefits, textSecondary),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 🔸 CTA Section
              if (_isPro)
                Column(
                  children: [
                    Text("Active: Pro Subscription",
                        style: TextStyle(color: textSecondary, fontSize: 16)),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: cardColor,
                            title: Text('Manage Subscription', style: TextStyle(color: textPrimary)),
                            content: Text(
                              'Subscription management flow goes here.',
                              style: TextStyle(color: textSecondary),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK', style: TextStyle(color: Colors.amber)),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.subscriptions, color: Colors.black),
                      label: const Text('Manage Subscription'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade700,
                        foregroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    Text("Free Plan", style: TextStyle(color: textSecondary, fontSize: 16)),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => showUpgradeModal(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Upgrade to Pro'),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: cardColor,
                          builder: (_) => Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Pro Trial',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber,
                                        fontSize: 18)),
                                const SizedBox(height: 12),
                                Text(
                                  '7-day free trial for new users.\nPayment handled via platform IAP.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: textSecondary),
                                ),
                                const SizedBox(height: 12),
                              ],
                            ),
                          ),
                        );
                      },
                      child: const Text('See trial & pricing',
                          style: TextStyle(color: Colors.amber)),
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



// // lib/features/subscription/screens/subscription_screen.dart
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../widgets/upgrade_modal.dart';


// const _kIsProKey = 'user_is_pro';

// class SubscriptionScreen extends StatefulWidget {
//   const SubscriptionScreen({Key? key}) : super(key: key);

//   @override
//   State<SubscriptionScreen> createState() => _SubscriptionScreenState();
// }

// class _SubscriptionScreenState extends State<SubscriptionScreen> {
//   bool _loading = true;
//   bool _isPro = false; // persisted subscription flag (for demo/testing)
//   int _selectedIndex = 0; // 0 = Free view, 1 = Pro view

//   final List<String> _freeBenefits = [
//     'Manual logging (last 30 days)',
//     'Basic exercise catalog & GIFs',
//     'Basic PR detection',
//     'Local-only backups',
//   ];

//   final List<String> _proBenefits = [
//     'Unlimited history & exports',
//     'Custom programs & progression suggestions',
//     'Advanced analytics (PR charts, weekly volume)',
//     'Audio coach customization & voice packs',
//     'Cloud backup across reinstalls (same device)',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadSubscription();
//   }

//   Future<void> _loadSubscription() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _isPro = prefs.getBool(_kIsProKey) ?? false;
//       _loading = false;
//     });
//   }

//   Future<void> _saveSubscription(bool value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool(_kIsProKey, value);
//     setState(() => _isPro = value);
//   }

//   Widget _buildSegmentedControl() {
//     return ToggleButtons(
//       isSelected: [_selectedIndex == 0, _selectedIndex == 1],
//       onPressed: (i) => setState(() => _selectedIndex = i),
//       borderRadius: BorderRadius.circular(8),
//       constraints: const BoxConstraints(minHeight: 40, minWidth: 120),
//       children: const [
//         Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('Free')),
//         Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('Pro')),
//       ],
//     );
//   }

//   Widget _buildBenefitList(List<String> items) {
//     return Column(
//       children: items.map((t) {
//         return ListTile(
//           leading: const Icon(Icons.check_circle_outline),
//           title: Text(t),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildComparisonCard() {
//     final isProView = _selectedIndex == 1;
//     final title = isProView ? 'Pro — Premium features' : 'Free — Basic features';
//     final legend = isProView ? 'Monthly / Annual pricing in modal' : 'Free forever';

//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       margin: const EdgeInsets.symmetric(vertical: 12),
//       child: Padding(
//         padding: const EdgeInsets.all(14.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(title, style: Theme.of(context).textTheme.titleLarge),
//             const SizedBox(height: 6),
//             Text(legend, style: Theme.of(context).textTheme.bodySmall),
//             const SizedBox(height: 12),
//             _buildBenefitList(isProView ? _proBenefits : _freeBenefits),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

//     final isProViewSelected = _selectedIndex == 1;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Subscription'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               // Current account banner
//               Card(
//                 color: _isPro ? Colors.green.shade50 : Colors.grey.shade50,
//                 child: ListTile(
//                   leading: Icon(_isPro ? Icons.workspace_premium : Icons.person_outline,
//                       size: 36, color: _isPro ? Colors.green : Colors.grey),
//                   title: Text(_isPro ? 'You are on Pro' : 'You are on Free'),
//                   subtitle: Text(_isPro ? 'Pro features unlocked' : 'Upgrade for advanced features'),
//                   trailing: TextButton(
//                     onPressed: () async {
//                       // simple toggle for dev/testing
//                       await _saveSubscription(!_isPro);
//                     },
//                     child: Text(_isPro ? 'Revoke (dev)' : 'Simulate Pro (dev)'),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 12),

//               // Segmented control to preview tiers
//               _buildSegmentedControl(),

//               // Comparison card
//               _buildComparisonCard(),

//               // Price / CTA area
//               const Spacer(),
//               if (_isPro)
//                 Column(
//                   children: [
//                     Text('Active: Pro subscription', style: Theme.of(context).textTheme.bodyMedium),
//                     const SizedBox(height: 8),
//                     ElevatedButton.icon(
//                       onPressed: () {
//                         // Open management flow — for now show a simple dialog
//                         showDialog(
//                           context: context,
//                           builder: (_) => AlertDialog(
//                             title: const Text('Manage Subscription'),
//                             content: const Text('Subscription management (cancel/restore) flow goes here.'),
//                             actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
//                           ),
//                         );
//                       },
//                       icon: const Icon(Icons.subscriptions),
//                       label: const Text('Manage Subscription'),
//                     ),
//                   ],
//                 )
//               else
//                 Column(
//                   children: [
//                     Text('Free', style: Theme.of(context).textTheme.bodyMedium),
//                     const SizedBox(height: 8),
//                     // ElevatedButton(
//                     //   onPressed: () {
//                     //     // Open "Upgrade to Pro" modal — Task 8.3 will implement a real modal
//                     //     showDialog(
//                     //       context: context,
//                     //       builder: (_) => AlertDialog(
//                     //         title: const Text('Upgrade to Pro'),
//                     //         content: const Text('Tap Upgrade to simulate a Pro purchase (for dev/testing).'),
//                     //         actions: [
//                     //           TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
//                     //           ElevatedButton(
//                     //             onPressed: () async {
//                     //               // simulate successful purchase -> set isPro true
//                     //               await _saveSubscription(true);
//                     //               Navigator.pop(context);
//                     //               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Upgraded to Pro (local demo)')));
//                     //             },
//                     //             child: const Text('Upgrade'),
//                     //           ),
//                     //         ],
//                     //       ),
//                     //     );
//                     //   },
//                     //   child: const Text('Upgrade to Pro'),
//                     // ),

//                     ElevatedButton(
//                       onPressed: () {
//                         // ✅ Open real upgrade modal (from upgrade_modal.dart)
//                         showUpgradeModal(context);
//                       },
//                       child: const Text('Upgrade to Pro'),
//                     ),
                    
//                     const SizedBox(height: 8),
//                     TextButton(
//                       onPressed: () {
//                         // show comparison or trial info
//                         showModalBottomSheet(
//                           context: context,
//                           builder: (_) => Padding(
//                             padding: const EdgeInsets.all(16),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 const Text('Pro Trial', style: TextStyle(fontWeight: FontWeight.bold)),
//                                 const SizedBox(height: 12),
//                                 const Text('7-day free trial for new users. Payment handled via platform IAP.'),
//                                 const SizedBox(height: 12),
//                                 ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                       child: const Text('See trial & pricing'),
//                     ),
//                   ],
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
