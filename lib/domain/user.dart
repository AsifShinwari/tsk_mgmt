class User {
  final int hiringStatus;
  final int employeeID;
  final int employeeRegistrationNumber;
  final String givenName;
  final String familyName;
  final String dateOfBirth;
  final String currentAddress;
  final String contactNumber;
  final String emailAddress;
  final int clientCompanyID;
  final int gender;
  final String employeePhoto;
  final String supervisorFullName;
  final String empGender;
  final String dutyStation;
  final String positionType;
  final int contractStatusID;
  final String contractStatus;
  final String positionTitle;

  User({
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
}
