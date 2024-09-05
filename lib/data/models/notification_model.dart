// ignore: depend_on_referenced_packages
import 'package:hive/hive.dart';
part 'notification_model.g.dart';

@HiveType(typeId: 3)
class NotificationModel {
  @HiveField(0)
  final int userLogId;
  @HiveField(1)
  final String logDate;
  @HiveField(2)
  final String operationType;
  @HiveField(3)
  final String tableName;
  @HiveField(4)
  final String dataMessage;
  @HiveField(5)
  final int userID;
  @HiveField(6)
  final int employeeID;
  @HiveField(7)
  final bool isActive;
  @HiveField(8)
  final int logType;
  

  NotificationModel({
    required this.userLogId,
    required this.logDate,
    required this.operationType,
    required this.tableName,
    required this.dataMessage,
    required this.userID,
    required this.employeeID,
    required this.isActive,
    required this.logType
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      userLogId: json['UserLogId'],
      logDate: json['LogDate'],
      operationType: json['OperationType'],
      tableName: json['TableName'],
      dataMessage: json['DataMessage'],
      userID: json['UserID'],
      employeeID: json['EmployeeID'],
      isActive: json['IsActive'],
      logType: json['LogType']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserLogId': userLogId,
      'LogDate': logDate,
      'OperationType': operationType,
      'TableName': tableName,
      'DataMessage': dataMessage,
      'UserID': userID,
      'EmployeeID': employeeID,
      'IsActive': isActive,
      'LogType': logType
    };

  }
}
