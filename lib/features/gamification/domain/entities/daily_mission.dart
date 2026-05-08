import 'package:equatable/equatable.dart';

class DailyMission extends Equatable {
  final String dateKey; // YYYY-MM-DD UTC
  final String taskKey;
  final String description;
  final String emoji;
  final int target;
  final int progress;
  final int rewardXp;
  final bool claimed;

  const DailyMission({
    required this.dateKey,
    required this.taskKey,
    required this.description,
    required this.emoji,
    required this.target,
    required this.progress,
    required this.rewardXp,
    required this.claimed,
  });

  bool get completed => progress >= target;
  double get ratio => target == 0 ? 0 : (progress / target).clamp(0.0, 1.0);

  DailyMission copyWith({
    int? progress,
    bool? claimed,
  }) {
    return DailyMission(
      dateKey: dateKey,
      taskKey: taskKey,
      description: description,
      emoji: emoji,
      target: target,
      progress: progress ?? this.progress,
      rewardXp: rewardXp,
      claimed: claimed ?? this.claimed,
    );
  }

  Map<String, dynamic> toJson() => {
        'dateKey': dateKey,
        'taskKey': taskKey,
        'description': description,
        'emoji': emoji,
        'target': target,
        'progress': progress,
        'rewardXp': rewardXp,
        'claimed': claimed,
      };

  factory DailyMission.fromJson(Map<String, dynamic> json) => DailyMission(
        dateKey: json['dateKey'] as String,
        taskKey: json['taskKey'] as String,
        description: json['description'] as String? ?? '',
        emoji: json['emoji'] as String? ?? '🎯',
        target: (json['target'] as num?)?.toInt() ?? 1,
        progress: (json['progress'] as num?)?.toInt() ?? 0,
        rewardXp: (json['rewardXp'] as num?)?.toInt() ?? 20,
        claimed: json['claimed'] as bool? ?? false,
      );

  @override
  List<Object?> get props =>
      [dateKey, taskKey, target, progress, rewardXp, claimed];
}
