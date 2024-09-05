import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';
import '../../data/models/user_model.dart';
import '../../core/errors/failures.dart';

class GetUserData {
  final AuthRepository repository;

  GetUserData(this.repository);

  Future<Either<Failure, UserModel>> execute(int empId) async {
    try {
      final user = await repository.getUserData(empId);
      return user.fold(
        (failure) => left(Failure('Failed to retrieve user data')), // Handle the Failure case
        (user) => Right(user) // Handle the UserModel case
      );
    } catch (e) {
      return Left(Failure('Failed to retrieve user data'));
    }
  }
}
