// // lib/widgets/sync_banner.dart
// import 'package:flutter/material.dart';
// import '../core/notifiers/connectivity_notifier.dart';

// class SyncBanner extends StatelessWidget {
//   final ConnectivityNotifier notifier;
//   const SyncBanner({Key? key, required this.notifier}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: notifier,
//       builder: (context, _) {
//         if (!notifier.isOnline) {
//           return Container(
//             color: Colors.red.shade700,
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//             child: Row(
//               children: [
//                 const Icon(Icons.signal_wifi_off, color: Colors.white),
//                 const SizedBox(width: 8),
//                 const Expanded(child: Text('Offline — changes will be queued', style: TextStyle(color: Colors.white))),
//                 if (notifier.queuedCount > 0)
//                   Chip(label: Text('${notifier.queuedCount} queued', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red.shade400),
//               ],
//             ),
//           );
//         }

//         if (notifier.isSyncing) {
//           return Container(
//             color: Colors.blue.shade700,
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//             child: Row(
//               children: const [
//                 Icon(Icons.sync, color: Colors.white),
//                 SizedBox(width: 8),
//                 Expanded(child: Text('Syncing…', style: TextStyle(color: Colors.white))),
//               ],
//             ),
//           );
//         }

//         if (notifier.queuedCount > 0) {
//           return Container(
//             color: Colors.orange.shade700,
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//             child: Row(
//               children: [
//                 const Icon(Icons.hourglass_top, color: Colors.white),
//                 const SizedBox(width: 8),
//                 Expanded(child: Text('${notifier.queuedCount} changes queued — will sync when online', style: const TextStyle(color: Colors.white))),
//                 TextButton(
//                   onPressed: () {
//                     // manual sync trigger; should call your SyncService
//                     notifier.setSyncing(true);
//                     Future.delayed(const Duration(seconds: 1), () {
//                       notifier.setQueuedCount(0);
//                       notifier.setSyncing(false);
//                     });
//                   },
//                   child: const Text('Sync now', style: TextStyle(color: Colors.white)),
//                 )
//               ],
//             ),
//           );
//         }

//         // nothing to show
//         return const SizedBox.shrink();
//       },
//     );
//   }
// }
