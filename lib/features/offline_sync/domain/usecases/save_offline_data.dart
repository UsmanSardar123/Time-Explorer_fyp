import 'dart:convert';

import '../entities/offline_record.dart';
import '../repositories/offline_sync_repository.dart';

class SaveOfflineData {
  final OfflineSyncRepository _repository;

  SaveOfflineData(this._repository);

  Future<int> call({
    required OfflineRecordType type,
    required Map<String, dynamic> data,
  }) {
    return _repository.insertRecord(
      OfflineRecord(
        type: type,
        data: jsonEncode(data),
        isSynced: false,
        timestamp: DateTime.now(),
      ),
    );
  }
}
