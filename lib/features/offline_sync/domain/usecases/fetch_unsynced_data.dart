import '../entities/offline_record.dart';
import '../repositories/offline_sync_repository.dart';

class FetchUnsyncedData {
  final OfflineSyncRepository _repository;

  FetchUnsyncedData(this._repository);

  Future<List<OfflineRecord>> call() => _repository.fetchUnsynced();
}
