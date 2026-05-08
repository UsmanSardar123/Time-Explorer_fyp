import '../entities/event_category.dart';
import '../entities/historical_event.dart';
import '../repositories/event_repository.dart';

class GetEventsByCategory {
  final EventRepository _repository;
  GetEventsByCategory(this._repository);
  Future<List<HistoricalEvent>> call(EventCategory category) =>
      _repository.getEventsByCategory(category);
}
