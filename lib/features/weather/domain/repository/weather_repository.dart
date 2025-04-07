import 'package:fpdart/fpdart.dart';
import 'package:weather_app/core/errors/failure.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';

abstract class WeatherRepository {
  Future<Either<Failure, Weather>> getCurrentWeather(double lat, double lon);
}
