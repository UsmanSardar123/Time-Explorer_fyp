import '../../data/remote/offline_remote_data_source.dart';
import '../entities/offline_record.dart';

class SyncToFirebase {
  final OfflineRemoteDataSource _remote;

  SyncToFirebase(this._remote);

  Future<void> call(OfflineRecord record) {
    switch (record.type) {
      case OfflineRecordType.progress:
        return _remote.uploadProgress(record);
      case OfflineRecordType.quiz:
        return _remote.uploadQuizzes(record);
      case OfflineRecordType.badge:
        return _remote.uploadBadges(record);
      case OfflineRecordType.streak:
        return _remote.uploadStreaks(record);
    }
  }
}
