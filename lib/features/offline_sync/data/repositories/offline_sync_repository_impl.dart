import '../../domain/entities/offline_record.dart';
import '../../domain/repositories/offline_sync_repository.dart';
import '../local/offline_local_data_source.dart';

class OfflineSyncRepositoryImpl implements OfflineSyncRepository {
  final OfflineLocalDataSource _local;

  OfflineSyncRepositoryImpl(this._local);

  @override
  Future<int> insertRecord(OfflineRecord record) => _local.insertData(record);

  @override
  Future<List<OfflineRecord>> fetchUnsynced() => _local.fetchUnsyncedData();

  @override
  Future<void> markAsSynced(int id) => _local.markAsSynced(id);

  @override
  Future<void> deleteRecord(int id) => _local.deleteRecord(id);
}
