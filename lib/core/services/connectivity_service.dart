// // lib/core/services/connectivity_service.dart
// import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';

// /// Simple wrapper around connectivity_plus to broadcast changes.
// class ConnectivityService {
//   final Connectivity _connectivity = Connectivity();
//   final StreamController<bool> _onlineCtrl = StreamController.broadcast();

//   ConnectivityService() {
//     // initial fetch
//     _connectivity.checkConnectivity().then((status) {
//       _onlineCtrl.add(_statusToOnline(status));
//     });
//     // listen changes
//     _connectivity.onConnectivityChanged.listen((status) {
//       _onlineCtrl.add(_statusToOnline(status));
//     });
//   }

//   bool _statusToOnline(ConnectivityResult s) {
//     return s == ConnectivityResult.wifi || s == ConnectivityResult.mobile;
//   }

//   Stream<bool> get onlineStream => _onlineCtrl.stream;

//   void dispose() {
//     _onlineCtrl.close();
//   }
// }
