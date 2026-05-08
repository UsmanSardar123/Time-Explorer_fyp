import '../../domain/entities/event_category.dart';
import '../../domain/entities/historical_event.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/event_static_data_source.dart';

class EventRepositoryImpl implements EventRepository {
  final EventStaticDataSource _dataSource;
  EventRepositoryImpl(this._dataSource);

  @override
  Future<List<HistoricalEvent>> getAllEvents() => _dataSource.fetchAll();

  @override
  Future<List<HistoricalEvent>> getEventsByCategory(EventCategory category) =>
      _dataSource.fetchByCategory(category);

  @override
  Future<List<HistoricalEvent>> searchEvents(String query) =>
      _dataSource.search(query);
}
