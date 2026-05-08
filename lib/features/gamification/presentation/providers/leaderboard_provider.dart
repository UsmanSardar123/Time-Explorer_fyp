import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../data/services/leaderboard_service.dart';
import '../../domain/entities/leaderboard_user.dart';

class LeaderboardProvider extends ChangeNotifier {
  final LeaderboardService _service;
  StreamSubscription<List<LeaderboardUser>>? _subscription;

  LeaderboardProvider({LeaderboardService? service})
      : _service = service ?? LeaderboardService();

  List<LeaderboardUser> _users = [];
  bool _isLoading = false;
  String? _error;

  List<LeaderboardUser> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void listenToLeaderboard() {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _subscription?.cancel();
    _subscription = _service.getLeaderboardStream().listen(
      (users) {
        _users = users;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _isLoading = false;
        _error = e.toString();
        notifyListeners();
      },
    );
  }

  Future<void> loadLeaderboard() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _users = await _service.getLeaderboardData();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Helper to get positional label (e.g., 1st, 2nd, 3rd)
  String getPositionLabel(int index) {
    int position = index + 1;
    if (position == 1) return '1st';
    if (position == 2) return '2nd';
    if (position == 3) return '3rd';
    return '${position}th';
  }
}
