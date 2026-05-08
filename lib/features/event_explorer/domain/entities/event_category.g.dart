// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventCategoryAdapter extends TypeAdapter<EventCategory> {
  @override
  final int typeId = 20;

  @override
  EventCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EventCategory.warsAndConflicts;
      case 1:
        return EventCategory.revolutionsAndPolitical;
      case 2:
        return EventCategory.scienceAndDiscoveries;
      case 3:
        return EventCategory.cultureAndCivilizations;
      default:
        return EventCategory.warsAndConflicts;
    }
  }

  @override
  void write(BinaryWriter writer, EventCategory obj) {
    switch (obj) {
      case EventCategory.warsAndConflicts:
        writer.writeByte(0);
        break;
      case EventCategory.revolutionsAndPolitical:
        writer.writeByte(1);
        break;
      case EventCategory.scienceAndDiscoveries:
        writer.writeByte(2);
        break;
      case EventCategory.cultureAndCivilizations:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
