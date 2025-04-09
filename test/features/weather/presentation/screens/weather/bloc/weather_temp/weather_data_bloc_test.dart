import 'package:bloc_test/bloc_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/errors/failure.dart';
import 'package:weather_app/features/location/domain/usecase/fetch_location_name.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/entities/current_temperature.dart';
import 'package:weather_app/features/weather/domain/entities/daily.dart';
import 'package:weather_app/features/weather/domain/entities/temperature.dart';
import 'package:weather_app/features/weather/domain/usecase/fetch_weather_usecase.dart';
import 'package:weather_app/features/weather/presentation/screens/weather/bloc/weather_temp/weather_data_bloc.dart';

class MockFetchWeatherUsecase extends Mock implements FetchWeatherUsecase {}

class MockFetchLocationNameUseCase extends Mock
    implements FetchLocationNameUseCase {}

void main() {
  late WeatherDataBloc bloc;
  late MockFetchWeatherUsecase mockFetchWeatherUsecase;
  late MockFetchLocationNameUseCase mockFetchLocationNameUseCase;
  late Position mockPosition;
  late Weather mockWeather;

  setUp(() {
    mockFetchWeatherUsecase = MockFetchWeatherUsecase();
    mockFetchLocationNameUseCase = MockFetchLocationNameUseCase();
    bloc = WeatherDataBloc(
      mockFetchWeatherUsecase,
      mockFetchLocationNameUseCase,
    );

    mockPosition = Position(
      latitude: 10.0,
      longitude: 20.0,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );

    mockWeather = Weather(
      timezone: 'Asia/Ho_Chi_Minh',
      current: CurrentTemperature(date: DateTime.now(), temp: 25.0),
      daily: [
        Daily(
          date: DateTime.now(),
          temp: Temperature(
            day: 25.0,
            min: 20.0,
            max: 30.0,
            night: 22.0,
            eve: 24.0,
            morn: 21.0,
          ),
        ),
      ],
    );
  });

  group('WeatherDataBloc', () {
    test('initial state should be WeatherDataInitial', () {
      expect(bloc.state, equals(const WeatherDataState.weatherDataInitial()));
    });

    blocTest<WeatherDataBloc, WeatherDataState>(
      'should emit [loading] when started event is added',
      build: () => bloc,
      act: (bloc) => bloc.add(const WeatherDataEvent.started()),
      expect: () => [const WeatherDataState.weatherDataloading()],
    );

    blocTest<WeatherDataBloc, WeatherDataState>(
      'should emit [loading, loaded] when fetch weather is successful',
      build: () {
        when(
          () => mockFetchWeatherUsecase(mockPosition),
        ).thenAnswer((_) async => Either.right(mockWeather));
        when(
          () => mockFetchLocationNameUseCase(mockPosition),
        ).thenAnswer((_) async => Either.right('Test City'));
        return bloc;
      },
      act: (bloc) => bloc.add(WeatherDataEvent.fetchWeather(mockPosition)),
      expect:
          () => [
            const WeatherDataState.weatherDataloading(),
            WeatherDataState.weatherDataloaded(
              weather: mockWeather,
              cityName: 'Test City',
            ),
          ],
    );

    blocTest<WeatherDataBloc, WeatherDataState>(
      'should emit [loading, error] when fetch weather fails',
      build: () {
        when(() => mockFetchWeatherUsecase(mockPosition)).thenAnswer(
          (_) async => Either.left(
            Failure(
              message: 'Weather fetch failed',
              id: 'weather_fetched_failed',
            ),
          ),
        );
        when(
          () => mockFetchLocationNameUseCase(mockPosition),
        ).thenAnswer((_) async => Either.right('Test City'));
        return bloc;
      },
      act: (bloc) => bloc.add(WeatherDataEvent.fetchWeather(mockPosition)),
      expect:
          () => [
            const WeatherDataState.weatherDataloading(),
            WeatherDataState.weatherDataError(
              Failure(
                message: 'Weather fetch failed',
                id: 'weather_fetched_failed',
              ),
            ),
          ],
    );

    blocTest<WeatherDataBloc, WeatherDataState>(
      'should emit [loading, error] when fetch location name fails',
      build: () {
        when(
          () => mockFetchWeatherUsecase(mockPosition),
        ).thenAnswer((_) async => Either.right(mockWeather));
        when(() => mockFetchLocationNameUseCase(mockPosition)).thenAnswer(
          (_) async => Either.left(
            Failure(
              message: 'Location name fetch failed',
              id: 'location_name_fetch_failed',
            ),
          ),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(WeatherDataEvent.fetchWeather(mockPosition)),
      expect:
          () => [
            const WeatherDataState.weatherDataloading(),
            WeatherDataState.weatherDataError(
              Failure(
                message: 'Location name fetch failed',
                id: 'location_name_fetch_failed',
              ),
            ),
          ],
    );

    blocTest<WeatherDataBloc, WeatherDataState>(
      'should emit [loading, error] when an exception occurs',
      build: () {
        when(
          () => mockFetchWeatherUsecase(mockPosition),
        ).thenThrow(Exception('Unexpected error'));
        return bloc;
      },
      act: (bloc) => bloc.add(WeatherDataEvent.fetchWeather(mockPosition)),
      expect:
          () => [
            const WeatherDataState.weatherDataloading(),
            predicate<WeatherDataState>((state) {
              if (state is WeatherDataError) {
                return state.failure.message == 'Exception: Unexpected error' &&
                    state.failure.id.isNotEmpty;
              }
              return false;
            }),
          ],
    );
  });
}
