import 'package:equatable/equatable.dart';

enum OfflineRecordType { progress, quiz, badge, streak }

class OfflineRecord extends Equatable {
  final int? id;
  final OfflineRecordType type;
  final String data; // JSON-encoded payload
  final bool isSynced;
  final DateTime timestamp;

  const OfflineRecord({
    this.id,
    required this.type,
    required this.data,
    required this.isSynced,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, type, data, isSynced, timestamp];
}
