import 'package:weather_app/core/errors/failure.dart';

class ServerFailure extends Failure {
  ServerFailure(String message, this.statusCode) : super(message: message);

  final int statusCode;
}
