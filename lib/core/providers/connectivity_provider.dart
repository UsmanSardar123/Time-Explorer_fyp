import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool _isOffline = false;
  StreamSubscription<List<ConnectivityResult>>? _sub;

  bool get isOffline => _isOffline;

  ConnectivityProvider() {
    _init();
  }

  Future<void> _init() async {
    final results = await Connectivity().checkConnectivity();
    _isOffline = _isDisconnected(results);
    notifyListeners();

    _sub = Connectivity().onConnectivityChanged.listen((results) {
      final offline = _isDisconnected(results);
      if (offline != _isOffline) {
        _isOffline = offline;
        debugPrint('[Connectivity] Status: ${offline ? "OFFLINE" : "ONLINE"}');
        notifyListeners();
      }
    });
  }

  bool _isDisconnected(List<ConnectivityResult> results) =>
      results.isEmpty ||
      results.every((r) => r == ConnectivityResult.none);

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
