// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 1;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      clientSchedualID: fields[0] as int,
      schedualTitle: fields[1] as String,
      schedualStartDate: fields[2] as String,
      schedualStarttime: fields[3] as String,
      schedualEndDate: fields[4] as String,
      scheualEndTime: fields[5] as String,
      clientAddress: fields[6] as String,
      schedualComments: fields[9] as String,
      schedulStatus: fields[7] as int,
      assignedByEmployeeName: fields[8] as String,
      sureName: fields[10] as String,
      givenName: fields[11] as String,
      checkInTime: fields[12] as String?,
      latitude: fields[13] as String?,
      longitude: fields[14] as String?,
      clientSchedulDetialID: fields[15] as int,
      synced: fields[16] as bool,
      supportDuringTravel: fields[17] as bool?,
      travelDetails: fields[18] as String?,
      travelKm: fields[19] as double?,
      isAdminstratMedicine: fields[20] as bool?,
      medicationName: fields[21] as String?,
      medicationTime: fields[22] as String?,
      isIncidentHappened: fields[23] as bool?,
      remarks: fields[24] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.clientSchedualID)
      ..writeByte(1)
      ..write(obj.schedualTitle)
      ..writeByte(2)
      ..write(obj.schedualStartDate)
      ..writeByte(3)
      ..write(obj.schedualStarttime)
      ..writeByte(4)
      ..write(obj.schedualEndDate)
      ..writeByte(5)
      ..write(obj.scheualEndTime)
      ..writeByte(6)
      ..write(obj.clientAddress)
      ..writeByte(7)
      ..write(obj.schedulStatus)
      ..writeByte(8)
      ..write(obj.assignedByEmployeeName)
      ..writeByte(9)
      ..write(obj.schedualComments)
      ..writeByte(10)
      ..write(obj.sureName)
      ..writeByte(11)
      ..write(obj.givenName)
      ..writeByte(12)
      ..write(obj.checkInTime)
      ..writeByte(13)
      ..write(obj.latitude)
      ..writeByte(14)
      ..write(obj.longitude)
      ..writeByte(15)
      ..write(obj.clientSchedulDetialID)
      ..writeByte(16)
      ..write(obj.synced)
      ..writeByte(17)
      ..write(obj.supportDuringTravel)
      ..writeByte(18)
      ..write(obj.travelDetails)
      ..writeByte(19)
      ..write(obj.travelKm)
      ..writeByte(20)
      ..write(obj.isAdminstratMedicine)
      ..writeByte(21)
      ..write(obj.medicationName)
      ..writeByte(22)
      ..write(obj.medicationTime)
      ..writeByte(23)
      ..write(obj.isIncidentHappened)
      ..writeByte(24)
      ..write(obj.remarks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
