import '../../domain/entities/offline_record.dart';

class OfflineRecordModel extends OfflineRecord {
  const OfflineRecordModel({
    super.id,
    required super.type,
    required super.data,
    required super.isSynced,
    required super.timestamp,
  });

  factory OfflineRecordModel.fromMap(Map<String, dynamic> map) {
    return OfflineRecordModel(
      id: map['id'] as int?,
      type: OfflineRecordType.values.byName(map['type'] as String),
      data: map['data'] as String,
      isSynced: (map['isSynced'] as int) == 1,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
    );
  }

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'type': type.name,
        'data': data,
        'isSynced': isSynced ? 1 : 0,
        'timestamp': timestamp.millisecondsSinceEpoch,
      };

  OfflineRecordModel copyWithSynced() => OfflineRecordModel(
        id: id,
        type: type,
        data: data,
        isSynced: true,
        timestamp: timestamp,
      );
}
