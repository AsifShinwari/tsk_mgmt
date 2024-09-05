// ignore: depend_on_referenced_packages
import 'package:hive/hive.dart';
part 'task.g.dart';

@HiveType(typeId: 1)
class Task {
  @HiveField(0)
  final int clientSchedualID;
  @HiveField(1)
  final String schedualTitle;
  @HiveField(2)
  final String schedualStartDate;
  @HiveField(3)
  final String schedualStarttime;
  @HiveField(4)
  final String schedualEndDate;
  @HiveField(5)
  final String scheualEndTime;
  @HiveField(6)
  final String clientAddress;
  @HiveField(7)
  final int schedulStatus;
  @HiveField(8)
  final String assignedByEmployeeName;
  @HiveField(9)
  final String schedualComments;
  @HiveField(10)
  final String sureName;
  @HiveField(11)
  final String givenName;
  @HiveField(12)
  late final String? checkInTime;
  @HiveField(13)
  final String? latitude;
  @HiveField(14)
  final String? longitude;
  @HiveField(15)
  final int clientSchedulDetialID;
  @HiveField(16)
  final bool synced;
  @HiveField(17)
  final bool? supportDuringTravel;
  @HiveField(18)
  final String? travelDetails;
  @HiveField(19)
  final double? travelKm;
  @HiveField(20)
  final bool? isAdminstratMedicine;
  @HiveField(21)
  final String? medicationName;
  @HiveField(22)
  final String? medicationTime;
  @HiveField(23)
  final bool? isIncidentHappened;
  @HiveField(24)
  final String? remarks;

  Task({
    required this.clientSchedualID,
    required this.schedualTitle,
    required this.schedualStartDate,
    required this.schedualStarttime,
    required this.schedualEndDate,
    required this.scheualEndTime,
    required this.clientAddress,
    required this.schedualComments,
    required this.schedulStatus,
    required this.assignedByEmployeeName,
    required this.sureName,
    required this.givenName,
    required this.checkInTime,
    required this.latitude,
    required this.longitude,
    required this.clientSchedulDetialID,
    required this.synced,
    required this.supportDuringTravel,
    required this.travelDetails,
    required this.travelKm,
    required this.isAdminstratMedicine,
    required this.medicationName,
    required this.medicationTime,
    required this.isIncidentHappened,
    required this.remarks,


  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      clientSchedualID: json['ClientSchedualID'],
      schedualTitle: json['SchedualTitle'],
      schedualStartDate: json['SchedualStartDate'],
      schedualStarttime: json['SchedualStarttime'],
      schedualEndDate: json['SchedualEndDate'],
      scheualEndTime: json['ScheualEndTime'],
      clientAddress: json['ClientAddress'],
      schedualComments: json['SchedualComments'],
      schedulStatus: json['SchedulStatus'],
      assignedByEmployeeName: json['AssignedByEmployeeName'],
      clientSchedulDetialID: json['ClientSchedulDetialID'],
      sureName: json['SureName'],
      givenName: json['GivenName'],
      checkInTime: '',
      latitude: '',
      longitude: '',
      synced: false,
      supportDuringTravel: false,
      travelDetails: '',
      travelKm: 0,
      isAdminstratMedicine: false,
      medicationName: '',
      medicationTime: '',
      isIncidentHappened: false,
      remarks: '',

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ClientSchedualID': clientSchedualID,
      'SchedualTitle': schedualTitle,
      'SchedualStartDate': schedualStartDate,
      'SchedualStarttime': schedualStarttime,
      'SchedualEndDate': schedualEndDate,
      'ScheualEndTime': scheualEndTime,
      'ClientAddress': clientAddress,
      'SchedualComments': schedualComments,
      'SchedulStatus': schedulStatus,
      'AssignedByEmployeeName': assignedByEmployeeName,
      'ClientSchedulDetialID': clientSchedulDetialID,
      'GivenName': givenName,
      'SureName': sureName,
      'checkInTime': checkInTime,
      'latitude': latitude,
      'longitude': longitude,
      'synced': synced,
      'supportDuringTravel': supportDuringTravel,
      'travelDetails': travelDetails,
      'travelKm': travelKm,
      'isAdminstratMedicine': isAdminstratMedicine,
      'medicationName': medicationName,
      'medicationTime': medicationTime,
      'isIncidentHappened': isIncidentHappened,
      'remarks': remarks,
    };

  }

  Task copyWith({
    int? clientSchedualID,
    String? schedualTitle,
    String? checkInTime,
    String? latitude,
    String? longitude,
    int? schedulStatus,
    bool? synced,
    bool? supportDuringTravel,
    String?  travelDetails,
    double?  travelKm,
    bool? isAdminstratMedicine,
    String? medicationName,
    String? medicationTime,
    bool? isIncidentHappened,
    String? remarks
  }) {
    return Task(
      synced: synced ?? this.synced,
      clientSchedulDetialID: clientSchedulDetialID,
      schedualStartDate: schedualStartDate,
      schedualComments: schedualComments,
      schedualStarttime: schedualStarttime,
      schedualEndDate: schedualEndDate,
      scheualEndTime: scheualEndTime,
      sureName: sureName,
      givenName: givenName,
      clientAddress: clientAddress,
      assignedByEmployeeName: assignedByEmployeeName,
      clientSchedualID: clientSchedualID ?? this.clientSchedualID,
      schedualTitle: schedualTitle ?? this.schedualTitle,
      checkInTime: checkInTime ?? this.checkInTime,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      schedulStatus: schedulStatus ?? this.schedulStatus,
      supportDuringTravel: supportDuringTravel ?? this.supportDuringTravel,
      travelDetails: travelDetails ?? this.travelDetails,
      travelKm: travelKm ?? this.travelKm,
      isAdminstratMedicine: isAdminstratMedicine ?? this.isAdminstratMedicine,
      medicationName: medicationName ?? this.medicationName,
      medicationTime: medicationTime ?? this.medicationTime,
      isIncidentHappened: isIncidentHappened ?? this.isIncidentHappened,
      remarks: remarks ?? this.remarks,
    );
  }
}
