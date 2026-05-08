import '../../domain/entities/daily_mission.dart';

class MissionCatalog {
  static const String taskExploreEvents = 'explore_events';
  static const String taskDiscoverPlaces = 'discover_places';
  static const String taskAnswerQuiz = 'answer_quiz';
  static const String taskViewFact = 'view_fact';

  static const List<_MissionTemplate> _templates = [
    _MissionTemplate(
      taskKey: taskExploreEvents,
      description: 'Explore 2 historical events today',
      emoji: '🏛️',
      target: 2,
      rewardXp: 30,
    ),
    _MissionTemplate(
      taskKey: taskDiscoverPlaces,
      description: 'Discover 1 new place today',
      emoji: '🗺️',
      target: 1,
      rewardXp: 30,
    ),
    _MissionTemplate(
      taskKey: taskAnswerQuiz,
      description: 'Answer 3 quiz questions today',
      emoji: '🧠',
      target: 3,
      rewardXp: 30,
    ),
    _MissionTemplate(
      taskKey: taskViewFact,
      description: 'Read today\'s "Did you know?" fact',
      emoji: '💡',
      target: 1,
      rewardXp: 20,
    ),
  ];

  /// Returns a deterministic mission for the given UTC date.
  static DailyMission missionFor(DateTime utcDate) {
    final dateKey = _dateKey(utcDate);
    final dayOfYear = int.parse(
      '${utcDate.year}${utcDate.month.toString().padLeft(2, '0')}${utcDate.day.toString().padLeft(2, '0')}',
    );
    final template = _templates[dayOfYear % _templates.length];
    return DailyMission(
      dateKey: dateKey,
      taskKey: template.taskKey,
      description: template.description,
      emoji: template.emoji,
      target: template.target,
      progress: 0,
      rewardXp: template.rewardXp,
      claimed: false,
    );
  }

  static String _dateKey(DateTime utc) {
    final y = utc.year.toString().padLeft(4, '0');
    final m = utc.month.toString().padLeft(2, '0');
    final d = utc.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static String todayKey({DateTime? now}) {
    final utc = (now ?? DateTime.now()).toUtc();
    return _dateKey(DateTime.utc(utc.year, utc.month, utc.day));
  }
}

class _MissionTemplate {
  final String taskKey;
  final String description;
  final String emoji;
  final int target;
  final int rewardXp;
  const _MissionTemplate({
    required this.taskKey,
    required this.description,
    required this.emoji,
    required this.target,
    required this.rewardXp,
  });
}
