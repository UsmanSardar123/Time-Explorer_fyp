import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeexplorer/features/learn/data/facts_data.dart';
import 'dart:math';

class DailyFactService {
  static const String _lastShownDateKey = 'last_fact_date';
  static const String _currentFactIndexKey = 'current_fact_index';

  static Future<Map<String, String>> getDailyFact() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _todayKey();
    final lastShownDate = prefs.getString(_lastShownDateKey);

    // 1. Fetch from Firebase
    List<Map<String, String>> availableFacts = [];
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('facts').get();
      
      if (querySnapshot.docs.isNotEmpty) {
        availableFacts = querySnapshot.docs.map((doc) {
          final json = doc.data();
          return {
            'fact': json['fact']?.toString() ?? '',
            'category': json['category']?.toString() ?? 'General',
          };
        }).toList();
      }
    } catch (e) {
      // Ignored, will drop down to local list.
    }

    // Fallback to local
    if (availableFacts.isEmpty) {
      availableFacts = historicalFacts;
    }

    int currentIndex = prefs.getInt(_currentFactIndexKey) ?? 0;

    // Make sure index is within bounds (in case backend data shrunk)
    if (currentIndex >= availableFacts.length) {
      currentIndex = 0;
    }

    if (lastShownDate != today) {
      // 24 hours (a new day) have passed — advance to next fact
      currentIndex = (currentIndex + 1) % availableFacts.length;
      await prefs.setString(_lastShownDateKey, today);
      await prefs.setInt(_currentFactIndexKey, currentIndex);
    }

    return availableFacts[currentIndex];
  }

  static Future<void> initIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _todayKey();

    if (!prefs.containsKey(_lastShownDateKey)) {
      // First launch — pick a pseudo-random seed index
      final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
      final startIndex = (dayOfYear % max(1, historicalFacts.length)).toInt();
      await prefs.setString(_lastShownDateKey, today);
      await prefs.setInt(_currentFactIndexKey, startIndex);
    }
  }

  static String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
