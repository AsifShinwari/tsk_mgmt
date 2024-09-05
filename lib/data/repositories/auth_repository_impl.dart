import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:task_mgmnt_system/data/data_providers/auth_local_data_provider.dart';
import 'package:task_mgmnt_system/data/data_providers/auth_remote_data_provider.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/errors/failures.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio dio;

  final AuthRemoteDataProvider remoteDataProvider;
  final AuthLocalDataProvider localDataProvider;

  AuthRepositoryImpl(
    this.dio, {
    required this.remoteDataProvider,
    required this.localDataProvider,
  });

  @override
  Future<Either<Failure, int>> login(String email, String password) async {
    try {
      final response = await dio.get(
        'https://myabilities.lightway-soft.com/api/WebServicesForMobileApp',
        queryParameters: {
          'usrName': email,
          'passwrd': password,
        },
      );

      if (int.parse(response.toString()) == 0) {
        return Left(Failure('Login failed'));
      } else {
        return Right(int.parse(response.toString()));
      }
    } catch (e) {
      return Left(Failure('Failed to login'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getUserData(int empId) async {
    try {
      final response = await dio.get(
        'https://myabilities.lightway-soft.com/api/WebServicesForMobileApp/fnUserProfile',
        queryParameters: {
          'empId': empId,
        },
      );

      final userData = response.data[0];
      final user = UserModel(
        hiringStatus: userData['HiringStatus'],
        employeeID: userData['EmployeeID'],
        employeeRegistrationNumber: userData['EmployeeRegistrationNumber'],
        givenName: userData['GivenName'],
        familyName: userData['FamilyName'],
        dateOfBirth: userData['DateofBirth'],
        currentAddress: userData['CurrentAddress'],
        contactNumber: userData['ContactNumber'],
        emailAddress: userData['EmailAddress'],
        clientCompanyID: userData['ClientCompanyID'],
        gender: userData['Gender'],
        employeePhoto: userData['EmployeePhoto'],
        supervisorFullName: userData['SuperVisorFullName'],
        empGender: userData['EmpGender'],
        dutyStation: userData['DutyStation'],
        positionType: userData['PositionType'],
        contractStatusID: userData['ContractStatusID'],
        contractStatus: userData['ContractStatus'],
        positionTitle: userData['PositionTitle'],
      );

      localDataProvider.saveUser(user);
      
      return Right(user);
    } catch (e) {
      return Left(Failure('Failed to fetch user data'));
    }
  }
}
