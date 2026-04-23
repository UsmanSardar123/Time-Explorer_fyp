import 'package:flutter/material.dart';
import 'package:timeexplorer/features/learn/presentation/daily_fact_service.dart';

class DailyFactProvider extends ChangeNotifier {
  String _factText = '';
  String _factCategory = '';
  bool _isLoading = false;

  String get factText => _factText;
  String get factCategory => _factCategory;
  bool get isLoading => _isLoading;

  DailyFactProvider() {
    loadDailyFact();
  }

  Future<void> loadDailyFact() async {
    _isLoading = true;
    notifyListeners();

    try {
      await DailyFactService.initIfNeeded();
      final fact = await DailyFactService.getDailyFact();
      _factText = fact['fact'] ?? '';
      _factCategory = fact['category'] ?? '';
    } catch (e) {
      _factText = 'The Great Wall of China is approximately 21,196 km long.';
      _factCategory = 'Architecture';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
