import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/errors/failure.dart';
import 'package:weather_app/features/weather/data/datasource/remote/open_weather_datasource.dart';
import 'package:weather_app/features/weather/data/models/current/current_temperature.dart';
import 'package:weather_app/features/weather/data/models/daily/daily.dart';
import 'package:weather_app/features/weather/data/models/temperature/temperature.dart';
import 'package:weather_app/features/weather/data/models/weather_model.dart';
import 'package:weather_app/features/weather/data/repository/weather_repository_impl.dart';
import 'package:weather_app/features/weather/domain/entities/current_temperature.dart';
import 'package:weather_app/features/weather/domain/entities/daily.dart';
import 'package:weather_app/features/weather/domain/entities/temperature.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';

class MockWeatherRemoteDataSource extends Mock
    implements WeatherRemoteDataSource {}

void main() {
  late MockWeatherRemoteDataSource mockWeatherRemoteDataSource;
  late WeatherRepositoryImpl weatherRepositoryImpl;

  setUp(() {
    mockWeatherRemoteDataSource = MockWeatherRemoteDataSource();
    weatherRepositoryImpl = WeatherRepositoryImpl(
      weatherRemoteDataSource: mockWeatherRemoteDataSource,
    );
  });

  group('getCurrentWeather', () {
    final date = DateTime.now();
    const lat = 0.0;
    const lon = 0.0;
    final model = WeatherModel(
      timezone: 'Asia/Ho_Chi_Minh',
      current: CurrentTemperatureModel(temp: 20, date: date),
      daily: [
        DailyModel(
          date: date,
          temp: TemperatureModel(
            day: 10,
            min: 10,
            max: 10,
            night: 10,
            eve: 10,
            morn: 10,
          ),
        ),
      ],
    );
    final entity = Weather(
      timezone: 'Asia/Ho_Chi_Minh',
      current: CurrentTemperature(temp: 20, date: date),
      daily: [
        Daily(
          date: date,
          temp: Temperature(
            day: 10,
            min: 10,
            max: 10,
            night: 10,
            eve: 10,
            morn: 10,
          ),
        ),
      ],
    );

    test('should return a Weather entity', () async {
      when(
        () => mockWeatherRemoteDataSource.getCurrentWeather(any(), any()),
      ).thenAnswer((_) async => model);

      final result = await weatherRepositoryImpl.getCurrentWeather(0, 0);

      expect(result, equals(Right(entity)));
    });

    test('should return a Failure if the coordinates are invalid', () async {
      final result = await weatherRepositoryImpl.getCurrentWeather(-91, 0);

      final expected = Left(
        Failure(message: 'Invalid coordinates', id: 'invalid_coordinates'),
      );
      expect(result, equals(expected));
    });

    test(
      'should return Failure when data source throws an exception',
      () async {
        when(
          () => mockWeatherRemoteDataSource.getCurrentWeather(any(), any()),
        ).thenThrow(Exception('API error'));

        final result = await weatherRepositoryImpl.getCurrentWeather(lat, lon);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, contains('Unexpected error')),
          (_) => fail('Expected a Failure'),
        );
      },
    );

    test('should return Failure of datasouce', () async {
      when(
        () => mockWeatherRemoteDataSource.getCurrentWeather(any(), any()),
      ).thenThrow(Failure(message: 'API error'));

      final result = await weatherRepositoryImpl.getCurrentWeather(lat, lon);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('API error')),
        (_) => fail('Expected a Failure'),
      );
    });
  });
}
