import '../entities/offline_record.dart';

abstract class OfflineSyncRepository {
  Future<int> insertRecord(OfflineRecord record);
  Future<List<OfflineRecord>> fetchUnsynced();
  Future<void> markAsSynced(int id);
  Future<void> deleteRecord(int id);
}
