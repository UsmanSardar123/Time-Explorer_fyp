import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/event_category.dart';
import '../../domain/usecases/get_all_events.dart';
import '../../domain/usecases/get_events_by_category.dart';
import '../../domain/usecases/search_events.dart';
import 'event_explorer_state.dart';

class EventExplorerCubit extends Cubit<EventExplorerState> {
  final GetAllEvents _getAll;
  final GetEventsByCategory _getByCategory;
  final SearchEvents _search;

  static const _prefKey = 'event_explorer_favorites';

  EventExplorerCubit({
    required GetAllEvents getAll,
    required GetEventsByCategory getByCategory,
    required SearchEvents search,
  })  : _getAll = getAll,
        _getByCategory = getByCategory,
        _search = search,
        super(EventExplorerInitial());

  Future<void> loadAll() async {
    emit(EventExplorerLoading());
    try {
      final events = await _getAll();
      final favs = await _loadFavorites();
      emit(EventExplorerLoaded(events: events, favoriteIds: favs));
    } catch (e) {
      emit(EventExplorerError(e.toString()));
    }
  }

  Future<void> filterByCategory(EventCategory? category) async {
    try {
      final current = _current;
      final events =
          category == null ? await _getAll() : await _getByCategory(category);
      emit(EventExplorerLoaded(
        events: events,
        selectedCategory: category,
        favoriteIds: current?.favoriteIds ?? {},
      ));
    } catch (e) {
      emit(EventExplorerError(e.toString()));
    }
  }

  Future<void> searchByQuery(String query) async {
    try {
      final current = _current;
      final events = query.isEmpty ? await _getAll() : await _search(query);
      emit(EventExplorerLoaded(
        events: events,
        selectedCategory: current?.selectedCategory,
        searchQuery: query,
        favoriteIds: current?.favoriteIds ?? {},
      ));
    } catch (e) {
      emit(EventExplorerError(e.toString()));
    }
  }

  Future<void> toggleFavorite(String eventId) async {
    final current = _current;
    if (current == null) return;
    final updated = Set<String>.from(current.favoriteIds);
    updated.contains(eventId) ? updated.remove(eventId) : updated.add(eventId);
    emit(current.copyWith(favoriteIds: updated));
    await _saveFavorites(updated);
  }

  EventExplorerLoaded? get _current =>
      state is EventExplorerLoaded ? state as EventExplorerLoaded : null;

  Future<Set<String>> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_prefKey) ?? []).toSet();
  }

  Future<void> _saveFavorites(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefKey, ids.toList());
  }
}
