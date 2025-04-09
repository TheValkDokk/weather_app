import 'package:injectable/injectable.dart';
import 'package:weather_app/core/errors/server_failure.dart';
import 'package:weather_app/core/services/dio_service.dart';
import 'package:weather_app/core/services/env_service.dart';
import 'package:weather_app/features/weather/data/models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  /// Fetches the current weather data for a given latitude and longitude.
  ///
  /// [lat] The latitude coordinate of the location.
  /// [lon] The longitude coordinate of the location.
  ///
  /// Returns a [Future] that completes with [WeatherModel] containing the weather data.
  /// Throws [ServerFailure] if the API request fails.
  Future<WeatherModel> getCurrentWeather(double lat, double lon);
}

@LazySingleton(as: WeatherRemoteDataSource)
class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final DioService dioService;
  final EnvService envService;

  late final String apiKey;
  WeatherRemoteDataSourceImpl(this.dioService, this.envService) {
    apiKey = envService.get('OPEN_WEATHER_API_KEY');
  }

  @override
  Future<WeatherModel> getCurrentWeather(double lat, double lon) async {
    final api = '/data/3.0/onecall';
    final response = await dioService.get(
      api,
      queryParameters: {
        'lat': lat.toString(),
        'lon': lon.toString(),
        'units': 'metric',
        'appid': apiKey,
        'exclude': 'minutely,alerts,hourly',
      },
    );

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(response.data);
    } else {
      throw ServerFailure(
        'Failed to fetch current weather ${response.data}',
        response.statusCode ?? 500,
      );
    }
  }
}
