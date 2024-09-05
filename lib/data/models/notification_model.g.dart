// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationModelAdapter extends TypeAdapter<NotificationModel> {
  @override
  final int typeId = 3;

  @override
  NotificationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationModel(
      userLogId: fields[0] as int,
      logDate: fields[1] as String,
      operationType: fields[2] as String,
      tableName: fields[3] as String,
      dataMessage: fields[4] as String,
      userID: fields[5] as int,
      employeeID: fields[6] as int,
      isActive: fields[7] as bool,
      logType: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.userLogId)
      ..writeByte(1)
      ..write(obj.logDate)
      ..writeByte(2)
      ..write(obj.operationType)
      ..writeByte(3)
      ..write(obj.tableName)
      ..writeByte(4)
      ..write(obj.dataMessage)
      ..writeByte(5)
      ..write(obj.userID)
      ..writeByte(6)
      ..write(obj.employeeID)
      ..writeByte(7)
      ..write(obj.isActive)
      ..writeByte(8)
      ..write(obj.logType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
