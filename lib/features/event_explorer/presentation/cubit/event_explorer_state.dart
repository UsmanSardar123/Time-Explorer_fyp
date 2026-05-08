import 'package:equatable/equatable.dart';
import '../../domain/entities/event_category.dart';
import '../../domain/entities/historical_event.dart';

abstract class EventExplorerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EventExplorerInitial extends EventExplorerState {}

class EventExplorerLoading extends EventExplorerState {}

class EventExplorerLoaded extends EventExplorerState {
  final List<HistoricalEvent> events;
  final EventCategory? selectedCategory;
  final String searchQuery;
  final Set<String> favoriteIds;

  EventExplorerLoaded({
    required this.events,
    this.selectedCategory,
    this.searchQuery = '',
    this.favoriteIds = const {},
  });

  EventExplorerLoaded copyWith({
    List<HistoricalEvent>? events,
    EventCategory? selectedCategory,
    bool clearCategory = false,
    String? searchQuery,
    Set<String>? favoriteIds,
  }) =>
      EventExplorerLoaded(
        events: events ?? this.events,
        selectedCategory:
            clearCategory ? null : selectedCategory ?? this.selectedCategory,
        searchQuery: searchQuery ?? this.searchQuery,
        favoriteIds: favoriteIds ?? this.favoriteIds,
      );

  bool isFavorite(String id) => favoriteIds.contains(id);

  @override
  List<Object?> get props => [events, selectedCategory, searchQuery, favoriteIds];
}

class EventExplorerError extends EventExplorerState {
  final String message;
  EventExplorerError(this.message);
  @override
  List<Object?> get props => [message];
}
