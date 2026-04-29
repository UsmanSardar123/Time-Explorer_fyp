import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum EpochCategory { ancient, discovery, modern, global }

enum DifficultyLevel { easy, medium, hard }

class QuizTopic extends Equatable {
  final String title;
  final EpochCategory epochCategory;
  final DifficultyLevel difficultyLevel;
  final String imageUrl;
  final String description;
  final IconData icon;
  final Color color;

  const QuizTopic({
    required this.title,
    required this.epochCategory,
    required this.difficultyLevel,
    required this.imageUrl,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  List<Object?> get props => [title, epochCategory, difficultyLevel];
}

const List<QuizTopic> allTopics = [
  QuizTopic(
    title: 'Ancient Egypt',
    epochCategory: EpochCategory.ancient,
    difficultyLevel: DifficultyLevel.easy,
    imageUrl: 'assets/images/egypt.png',
    description: 'Pyramids, Pharaohs & Mysteries',
    icon: Icons.architecture,
    color: Color(0xFFFF9800),
  ),
  QuizTopic(
    title: 'Ancient Rome',
    epochCategory: EpochCategory.ancient,
    difficultyLevel: DifficultyLevel.medium,
    imageUrl: 'assets/images/rome.png',
    description: 'Empire, Gladiators & Conquests',
    icon: Icons.account_balance,
    color: Color(0xFFE91E63),
  ),
  QuizTopic(
    title: 'Indus Valley',
    epochCategory: EpochCategory.ancient,
    difficultyLevel: DifficultyLevel.hard,
    imageUrl: 'assets/images/indus.png',
    description: 'Mohenjo-daro, Trade & Urban Planning',
    icon: Icons.location_city,
    color: Color(0xFF795548),
  ),
  QuizTopic(
    title: 'The Renaissance',
    epochCategory: EpochCategory.discovery,
    difficultyLevel: DifficultyLevel.medium,
    imageUrl: 'assets/images/renaissance.png',
    description: 'Art, Science & Rebirth of Ideas',
    icon: Icons.palette,
    color: Color(0xFF9C27B0),
  ),
  QuizTopic(
    title: 'Science & Nature',
    epochCategory: EpochCategory.discovery,
    difficultyLevel: DifficultyLevel.easy,
    imageUrl: 'assets/images/science.png',
    description: 'Animals, Space & Discoveries',
    icon: Icons.science,
    color: Color(0xFF4CAF50),
  ),
  QuizTopic(
    title: 'The Space Race',
    epochCategory: EpochCategory.modern,
    difficultyLevel: DifficultyLevel.medium,
    imageUrl: 'assets/images/space_race.png',
    description: 'NASA, Sputnik & Moon Landings',
    icon: Icons.rocket_launch,
    color: Color(0xFF002366),
  ),
  QuizTopic(
    title: 'Meiji Restoration',
    epochCategory: EpochCategory.global,
    difficultyLevel: DifficultyLevel.hard,
    imageUrl: 'assets/images/meiji.png',
    description: 'Japan\'s Transformation & Modernisation',
    icon: Icons.temple_buddhist,
    color: Color(0xFF708090),
  ),
];

extension DifficultyLevelLabel on DifficultyLevel {
  String get label => switch (this) {
    DifficultyLevel.easy   => 'Beginner',
    DifficultyLevel.medium => 'Enthusiast',
    DifficultyLevel.hard   => 'Expert',
  };
}
