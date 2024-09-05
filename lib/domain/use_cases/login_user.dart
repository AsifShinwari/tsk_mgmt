import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';
import '../../core/errors/failures.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<Either<Failure, int>> execute(String email, String password) async {
    try {
      return await repository.login(email, password);
    } catch (e) {
      return Left(Failure('Login failed'));
    }
  }
}
