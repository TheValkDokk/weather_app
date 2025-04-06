import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/errors/failure.dart';
import 'package:weather_app/core/errors/server_failure.dart';
import 'package:weather_app/core/services/dio_service.dart';
import 'package:weather_app/core/services/env_service.dart';
import 'package:weather_app/features/weather/data/datasource/remote/open_weather_datasource.dart';
import 'package:weather_app/features/weather/data/models/weather_model.dart';
import 'package:weather_app/features/weather/data/models/current/current_temperature.dart';

class MockDioService extends Mock implements DioService {}

class MockEnvService extends Mock implements EnvService {
  @override
  String get(String key) {
    return 'test_api_key';
  }
}

void main() {
  late WeatherRemoteDataSourceImpl dataSource;
  late MockDioService mockDioService;
  late MockEnvService mockEnvService;
  const apiKey = 'test_api_key';

  setUp(() {
    mockDioService = MockDioService();
    mockEnvService = MockEnvService();
    dataSource = WeatherRemoteDataSourceImpl(mockDioService, mockEnvService);
  });

  group('getCurrentWeather', () {
    const lat = 10.8504;
    const lon = 106.7647;
    final mockResponse = {
      'timezone': 'Asia/Ho_Chi_Minh',
      'current': {
        'dt': 1743913928,
        'sunrise': 1743893212,
        'sunset': 1743937413,
        'temp': 306.03,
        'feels_like': 310.69,
        'pressure': 1010,
        'humidity': 55,
        'dew_point': 295.79,
        'uvi': 13.44,
        'clouds': 75,
        'visibility': 10000,
        'wind_speed': 4.63,
        'wind_deg': 110,
        'weather': [
          {
            'id': 803,
            'main': 'Clouds',
            'description': 'broken clouds',
            'icon': '04d',
          },
        ],
      },
      'daily': [
        {
          'dt': 1743912000,
          'sunrise': 1743893212,
          'sunset': 1743937413,
          'moonrise': 1743918600,
          'moonset': 1743876300,
          'moon_phase': 0.29,
          'summary': 'There will be partly cloudy today',
          'temp': {
            'day': 306.06,
            'min': 298.85,
            'max': 307.06,
            'night': 301.6,
            'eve': 305.12,
            'morn': 298.85,
          },
          'feels_like': {
            'day': 311.08,
            'night': 303.69,
            'eve': 306.14,
            'morn': 299.67,
          },
          'pressure': 1010,
          'humidity': 56,
          'dew_point': 296.12,
          'wind_speed': 8.62,
          'wind_deg': 168,
          'wind_gust': 12.64,
          'weather': [
            {
              'id': 803,
              'main': 'Clouds',
              'description': 'broken clouds',
              'icon': '04d',
            },
          ],
          'clouds': 77,
          'pop': 0,
          'uvi': 13.44,
        },
      ],
    };

    test('should return WeatherModel when API call is successful', () async {
      when(
        () => mockDioService.get(
          '/data/3.0/onecall',
          queryParameters: {
            'lat': lat.toString(),
            'lon': lon.toString(),
            'units': 'metric',
            'appid': apiKey,
            'exclude': 'minutely,alerts,hourly',
          },
        ),
      ).thenAnswer(
        (_) async => Response(
          data: mockResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/data/3.0/onecall'),
        ),
      );

      final result = await dataSource.getCurrentWeather(lat, lon);

      expect(result, isA<WeatherModel>());
      expect(result.timezone, equals('Asia/Ho_Chi_Minh'));
      expect(result.current, isA<CurrentTemperature>());
      expect(result.daily, hasLength(1));
      verify(
        () => mockDioService.get(
          '/data/3.0/onecall',
          queryParameters: {
            'lat': lat.toString(),
            'lon': lon.toString(),
            'units': 'metric',
            'appid': apiKey,
            'exclude': 'minutely,alerts,hourly',
          },
        ),
      ).called(1);
    });

    test(
      'should throw ServerFailure when server calls throws an error',
      () async {
        when(
          () => mockDioService.get(
            '/data/3.0/onecall',
            queryParameters: {
              'lat': lat.toString(),
              'lon': lon.toString(),
              'units': 'metric',
              'appid': apiKey,
              'exclude': 'minutely,alerts,hourly',
            },
          ),
        ).thenAnswer(
          (_) async => Response(
            data: {'message': 'Invalid API key'},
            statusCode: 401,
            requestOptions: RequestOptions(path: '/data/3.0/onecall'),
          ),
        );

        expect(
          () => dataSource.getCurrentWeather(lat, lon),
          throwsA(isA<ServerFailure>()),
        );
      },
    );

    test(
      'should throw ServerFailure when calling an API throws an exception',
      () async {
        when(
          () => mockDioService.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(Failure(message: 'Network error'));

        try {
          await dataSource.getCurrentWeather(lat, lon);
        } catch (e) {
          expect(e, isA<Failure>());
        }
      },
    );
  });
}
