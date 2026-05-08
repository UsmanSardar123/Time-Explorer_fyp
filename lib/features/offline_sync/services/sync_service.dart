import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/remote/offline_remote_data_source.dart';
import '../domain/entities/offline_record.dart';
import '../domain/repositories/offline_sync_repository.dart';
import 'connectivity_service.dart';

class SyncService {
  final OfflineSyncRepository _repository;
  final OfflineRemoteDataSource _remote;
  final ConnectivityService _connectivity;

  bool _isSyncing = false;
  StreamSubscription<bool>? _sub;

  SyncService({
    required OfflineSyncRepository repository,
    required OfflineRemoteDataSource remote,
    required ConnectivityService connectivity,
  })  : _repository = repository,
        _remote = remote,
        _connectivity = connectivity;

  // Call once from app startup (e.g. main.dart or app widget initState).
  void initialize() {
    _sub = _connectivity.connectionStream.listen((isOnline) {
      if (isOnline) syncNow();
    });
  }

  // Can also be called manually (e.g. after saving a record while online).
  Future<void> syncNow() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final records = await _repository.fetchUnsynced();
      for (final record in records) {
        await _syncRecord(record);
      }
    } catch (e) {
      debugPrint('[SyncService] Unexpected error: $e');
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _syncRecord(OfflineRecord record) async {
    try {
      await _uploadByType(record);
      // Only delete after confirmed upload — prevents data loss on failure.
      await _repository.markAsSynced(record.id!);
      await _repository.deleteRecord(record.id!);
    } catch (e) {
      debugPrint('[SyncService] Failed record id=${record.id}: $e');
      // Leave record unsynced; will retry on next connectivity event.
    }
  }

  Future<void> _uploadByType(OfflineRecord record) {
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

  void dispose() {
    _sub?.cancel();
    _connectivity.dispose();
  }
}
