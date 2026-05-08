// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'historical_event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimelinePointAdapter extends TypeAdapter<TimelinePoint> {
  @override
  final int typeId = 21;

  @override
  TimelinePoint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimelinePoint(
      date: fields[0] as String,
      description: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TimelinePoint obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimelinePointAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HistoricalEventAdapter extends TypeAdapter<HistoricalEvent> {
  @override
  final int typeId = 22;

  @override
  HistoricalEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoricalEvent(
      id: fields[0] as String,
      title: fields[1] as String,
      category: fields[2] as EventCategory,
      period: fields[3] as String,
      location: fields[4] as String,
      description: fields[5] as String,
      timeline: (fields[6] as List).cast<TimelinePoint>(),
      imageUrl: fields[7] as dynamic,
      importanceLevel: fields[8] as int,
      keyFacts: (fields[9] as List).cast<String>(),
      galleryUrls: (fields[10] as List).cast<dynamic>(),
      latitude: fields[11] as double?,
      longitude: fields[12] as double?,
      youtubeUrl: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HistoricalEvent obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.period)
      ..writeByte(4)
      ..write(obj.location)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.timeline)
      ..writeByte(7)
      ..write(obj.imageUrl)
      ..writeByte(8)
      ..write(obj.importanceLevel)
      ..writeByte(9)
      ..write(obj.keyFacts)
      ..writeByte(10)
      ..write(obj.galleryUrls)
      ..writeByte(11)
      ..write(obj.latitude)
      ..writeByte(12)
      ..write(obj.longitude)
      ..writeByte(13)
      ..write(obj.youtubeUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoricalEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
