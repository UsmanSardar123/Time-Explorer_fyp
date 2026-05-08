class AdminStatsEntity {
  final int totalUsers;
  final int totalPlaces;
  final int totalHistoricalFacts;
  final int totalCharacters;
  final int totalEvents;
  final int totalActiveSessions;

  AdminStatsEntity({
    required this.totalUsers,
    required this.totalPlaces,
    required this.totalHistoricalFacts,
    required this.totalCharacters,
    required this.totalEvents,
    required this.totalActiveSessions,
  });

  factory AdminStatsEntity.initial() => AdminStatsEntity(
        totalUsers: 0,
        totalPlaces: 0,
        totalHistoricalFacts: 0,
        totalCharacters: 0,
        totalEvents: 0,
        totalActiveSessions: 0,
      );
}
