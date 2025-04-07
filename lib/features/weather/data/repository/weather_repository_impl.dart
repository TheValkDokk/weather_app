import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:weather_app/core/errors/failure.dart';
import 'package:weather_app/features/weather/data/datasource/remote/open_weather_datasource.dart';
import 'package:weather_app/features/weather/data/models/weather_model.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/repository/weather_repository.dart';

@LazySingleton(as: WeatherRepository)
class WeatherRepositoryImpl extends WeatherRepository {
  final WeatherRemoteDataSource weatherRemoteDataSource;

  WeatherRepositoryImpl({required this.weatherRemoteDataSource});

  @override
  Future<Either<Failure, Weather>> getCurrentWeather(
    double lat,
    double lon,
  ) async {
    try {
      if (lat < -90 || lat > 90 || lon < -180 || lon > 180) {
        return left(
          Failure(message: 'Invalid coordinates', id: 'invalid_coordinates'),
        );
      }
      final weather = await weatherRemoteDataSource.getCurrentWeather(lat, lon);
      final weatherEntity = toWeatherEntity(weather);
      return right(weatherEntity);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(Failure(message: 'Unexpected error ${e.toString()}'));
    }
  }
}
