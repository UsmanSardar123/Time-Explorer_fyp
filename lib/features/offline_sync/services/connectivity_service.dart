import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _controller =
      StreamController<bool>.broadcast();

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Stream<bool> get connectionStream => _controller.stream;

  ConnectivityService() {
    _subscription = _connectivity.onConnectivityChanged
        .listen(_onResultsChanged);
  }

  void _onResultsChanged(List<ConnectivityResult> results) {
    _controller.add(_hasConnection(results));
  }

  bool _hasConnection(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);

  Future<bool> get isOnline async {
    final results = await _connectivity.checkConnectivity();
    return _hasConnection(results);
  }

  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
