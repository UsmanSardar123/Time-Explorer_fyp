import '../entities/event_category.dart';
import '../entities/historical_event.dart';

abstract class EventRepository {
  Future<List<HistoricalEvent>> getAllEvents();
  Future<List<HistoricalEvent>> getEventsByCategory(EventCategory category);
  Future<List<HistoricalEvent>> searchEvents(String query);
}
