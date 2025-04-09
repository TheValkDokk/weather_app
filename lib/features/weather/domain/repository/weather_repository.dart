import 'package:fpdart/fpdart.dart';
import 'package:weather_app/core/errors/failure.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';

abstract class WeatherRepository {
  /// Fetches the current weather data for a given latitude and longitude.
  ///
  /// [lat] The latitude coordinate of the location.
  /// [lon] The longitude coordinate of the location.
  ///
  /// Returns a [Future] that completes with either:
  /// - [Right] containing the [Weather] data if successful
  /// - [Left] containing a [Failure] if an error occurs
  Future<Either<Failure, Weather>> getCurrentWeather(double lat, double lon);
}
