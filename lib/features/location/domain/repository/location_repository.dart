import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/core/errors/failure.dart';

abstract class LocationRepository {
  Future<Either<Failure, Position>> getCurrentLocation();
  Future<Either<Failure, String>> getCityName(Position position);
}
