import '../entities/historical_event.dart';
import '../repositories/event_repository.dart';

class GetAllEvents {
  final EventRepository _repository;
  GetAllEvents(this._repository);
  Future<List<HistoricalEvent>> call() => _repository.getAllEvents();
}
