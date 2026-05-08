import '../entities/historical_event.dart';
import '../repositories/event_repository.dart';

class SearchEvents {
  final EventRepository _repository;
  SearchEvents(this._repository);
  Future<List<HistoricalEvent>> call(String query) =>
      _repository.searchEvents(query);
}
