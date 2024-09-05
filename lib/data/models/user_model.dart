// ignore: depend_on_referenced_packages
import 'package:hive/hive.dart' show BinaryReader, BinaryWriter, HiveField, HiveObject, HiveType, TypeAdapter;
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart'; // This should match the generated file

@HiveType(typeId: 0)
@JsonSerializable()
class UserModel extends HiveObject {
  @HiveField(0)
  final int hiringStatus;
  @HiveField(1)
  final int employeeID;
  @HiveField(2)
  final int employeeRegistrationNumber;
  @HiveField(3)
  final String givenName;
  @HiveField(4)
  final String familyName;
  @HiveField(5)
  final String dateOfBirth;
  @HiveField(6)
  final String currentAddress;
  @HiveField(7)
  final String contactNumber;
  @HiveField(8)
  final String emailAddress;
  @HiveField(9)
  final int clientCompanyID;
  @HiveField(10)
  final int gender;
  @HiveField(11)
  final String employeePhoto;
  @HiveField(12)
  final String supervisorFullName;
  @HiveField(13)
  final String empGender;
  @HiveField(14)
  final String dutyStation;
  @HiveField(15)
  final String positionType;
  @HiveField(16)
  final int contractStatusID;
  @HiveField(17)
  final String contractStatus;
  @HiveField(18)
  final String positionTitle;

  UserModel({
    required this.hiringStatus,
    required this.employeeID,
    required this.employeeRegistrationNumber,
    required this.givenName,
    required this.familyName,
    required this.dateOfBirth,
    required this.currentAddress,
    required this.contactNumber,
    required this.emailAddress,
    required this.clientCompanyID,
    required this.gender,
    required this.employeePhoto,
    required this.supervisorFullName,
    required this.empGender,
    required this.dutyStation,
    required this.positionType,
    required this.contractStatusID,
    required this.contractStatus,
    required this.positionTitle,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
