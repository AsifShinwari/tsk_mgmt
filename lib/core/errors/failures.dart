// Base Failure class
class Failure {
  final String message;

  Failure(this.message);

  @override
  String toString() => message;
}

// Example of a specific failure
class NetworkFailure extends Failure {
  NetworkFailure(String message) : super(message);
}

// Example of a specific failure
class DatabaseFailure extends Failure {
  DatabaseFailure(String message) : super(message);
}
