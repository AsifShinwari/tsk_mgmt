import 'package:dartz/dartz.dart';
import '../../data/models/user_model.dart';
import '../../core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, int>> login(String email, String password);
  Future<Either<Failure, UserModel>> getUserData(int empId); // Update to UserModel
}
