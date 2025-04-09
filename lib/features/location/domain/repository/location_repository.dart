import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/core/errors/failure.dart';

abstract class LocationRepository {
  /// Retrieves the current device location.
  ///
  /// Returns [Either] containing:
  /// - [Failure] if there was an error getting the location
  /// - [Position] with the current latitude and longitude if successful
  Future<Either<Failure, Position>> getCurrentLocation();

  /// Gets the city name for a given position.
  ///
  /// [position] The position containing latitude and longitude coordinates
  /// Returns [Either] containing:
  /// - [Failure] if there was an error getting the city name
  /// - [String] with the city name if successful
  Future<Either<Failure, String>> getCityName(Position position);
}
