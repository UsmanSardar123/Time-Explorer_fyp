import 'package:equatable/equatable.dart';

class LeaderboardUser extends Equatable {
  final String id;
  final String name;
  final int xp;
  final int level;
  final String? photoUrl;
  final DateTime? createdAt;
  final int placesExploredCount;

  const LeaderboardUser({
    required this.id,
    required this.name,
    required this.xp,
    required this.level,
    this.photoUrl,
    this.createdAt,
    this.placesExploredCount = 0,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        xp,
        level,
        photoUrl,
        createdAt,
        placesExploredCount,
      ];
}
