// // lib/core/notifiers/connectivity_notifier.dart
// import 'dart:async';
// import 'package:flutter/material.dart';
// import '../services/connectivity_service.dart';

// class ConnectivityNotifier extends ChangeNotifier {
//   final ConnectivityService _svc;
//   late StreamSubscription<bool> _sub;

//   bool _isOnline = true;
//   bool get isOnline => _isOnline;

//   // Whether a sync process is currently running
//   bool _isSyncing = false;
//   bool get isSyncing => _isSyncing;

//   // Count of queued (unsynced) items
//   int _queued = 0;
//   int get queuedCount => _queued;

//   ConnectivityNotifier(this._svc) {
//     _sub = _svc.onlineStream.listen((online) {
//       _isOnline = online;
//       notifyListeners();
//       // Optionally start sync when back online
//       if (_isOnline) _triggerAutoSync();
//     });
//   }

//   void setQueuedCount(int c) {
//     _queued = c;
//     notifyListeners();
//   }

//   void setSyncing(bool v) {
//     _isSyncing = v;
//     notifyListeners();
//   }

//   Future<void> _triggerAutoSync() async {
//     // placeholder: you can call your SyncService here
//     if (_queued > 0 && !_isSyncing) {
//       setSyncing(true);
//       // simulate work
//       await Future.delayed(const Duration(seconds: 1));
//       // after successful sync:
//       setQueuedCount(0);
//       setSyncing(false);
//     }
//   }

//   @override
//   void dispose() {
//     _sub.cancel();
//     super.dispose();
//   }
// }
