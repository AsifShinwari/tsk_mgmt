// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      hiringStatus: fields[0] as int,
      employeeID: fields[1] as int,
      employeeRegistrationNumber: fields[2] as int,
      givenName: fields[3] as String,
      familyName: fields[4] as String,
      dateOfBirth: fields[5] as String,
      currentAddress: fields[6] as String,
      contactNumber: fields[7] as String,
      emailAddress: fields[8] as String,
      clientCompanyID: fields[9] as int,
      gender: fields[10] as int,
      employeePhoto: fields[11] as String,
      supervisorFullName: fields[12] as String,
      empGender: fields[13] as String,
      dutyStation: fields[14] as String,
      positionType: fields[15] as String,
      contractStatusID: fields[16] as int,
      contractStatus: fields[17] as String,
      positionTitle: fields[18] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.hiringStatus)
      ..writeByte(1)
      ..write(obj.employeeID)
      ..writeByte(2)
      ..write(obj.employeeRegistrationNumber)
      ..writeByte(3)
      ..write(obj.givenName)
      ..writeByte(4)
      ..write(obj.familyName)
      ..writeByte(5)
      ..write(obj.dateOfBirth)
      ..writeByte(6)
      ..write(obj.currentAddress)
      ..writeByte(7)
      ..write(obj.contactNumber)
      ..writeByte(8)
      ..write(obj.emailAddress)
      ..writeByte(9)
      ..write(obj.clientCompanyID)
      ..writeByte(10)
      ..write(obj.gender)
      ..writeByte(11)
      ..write(obj.employeePhoto)
      ..writeByte(12)
      ..write(obj.supervisorFullName)
      ..writeByte(13)
      ..write(obj.empGender)
      ..writeByte(14)
      ..write(obj.dutyStation)
      ..writeByte(15)
      ..write(obj.positionType)
      ..writeByte(16)
      ..write(obj.contractStatusID)
      ..writeByte(17)
      ..write(obj.contractStatus)
      ..writeByte(18)
      ..write(obj.positionTitle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      hiringStatus: (json['hiringStatus'] as num).toInt(),
      employeeID: (json['employeeID'] as num).toInt(),
      employeeRegistrationNumber:
          (json['employeeRegistrationNumber'] as num).toInt(),
      givenName: json['givenName'] as String,
      familyName: json['familyName'] as String,
      dateOfBirth: json['dateOfBirth'] as String,
      currentAddress: json['currentAddress'] as String,
      contactNumber: json['contactNumber'] as String,
      emailAddress: json['emailAddress'] as String,
      clientCompanyID: (json['clientCompanyID'] as num).toInt(),
      gender: (json['gender'] as num).toInt(),
      employeePhoto: json['employeePhoto'] as String,
      supervisorFullName: json['supervisorFullName'] as String,
      empGender: json['empGender'] as String,
      dutyStation: json['dutyStation'] as String,
      positionType: json['positionType'] as String,
      contractStatusID: (json['contractStatusID'] as num).toInt(),
      contractStatus: json['contractStatus'] as String,
      positionTitle: json['positionTitle'] as String,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'hiringStatus': instance.hiringStatus,
      'employeeID': instance.employeeID,
      'employeeRegistrationNumber': instance.employeeRegistrationNumber,
      'givenName': instance.givenName,
      'familyName': instance.familyName,
      'dateOfBirth': instance.dateOfBirth,
      'currentAddress': instance.currentAddress,
      'contactNumber': instance.contactNumber,
      'emailAddress': instance.emailAddress,
      'clientCompanyID': instance.clientCompanyID,
      'gender': instance.gender,
      'employeePhoto': instance.employeePhoto,
      'supervisorFullName': instance.supervisorFullName,
      'empGender': instance.empGender,
      'dutyStation': instance.dutyStation,
      'positionType': instance.positionType,
      'contractStatusID': instance.contractStatusID,
      'contractStatus': instance.contractStatus,
      'positionTitle': instance.positionTitle,
    };
