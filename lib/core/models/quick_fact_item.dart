import 'package:flutter/material.dart';

class QuickFactItem {
  final String title;
  final String value;
  final IconData icon;
  final String description;
  final Color accentColor;
  final List<String> relatedFacts;
  final String? sourceUrl;
  final bool isLoading;

  const QuickFactItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.description,
    this.accentColor = const Color(0xFF4F46E5),
    this.relatedFacts = const [],
    this.sourceUrl,
    this.isLoading = false,
  });
}
