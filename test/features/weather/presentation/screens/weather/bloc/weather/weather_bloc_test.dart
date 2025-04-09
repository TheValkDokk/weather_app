import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weather_app/core/common/presentation/bloc/connectivity/connectivity_bloc.dart';
import 'package:weather_app/core/common/presentation/bloc/permission/permission_bloc.dart';
import 'package:weather_app/core/errors/failure.dart';
import 'package:weather_app/features/location/presentation/bloc/location_service/location_service_bloc.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/entities/current_temperature.dart';
import 'package:weather_app/features/weather/domain/entities/daily.dart';
import 'package:weather_app/features/weather/domain/entities/temperature.dart';
import 'package:weather_app/features/weather/presentation/screens/weather/bloc/weather_temp/weather_data_bloc.dart';
import 'package:weather_app/features/weather/presentation/screens/weather/bloc/weather/weather_bloc.dart';

class MockWeatherDataBloc extends Mock implements WeatherDataBloc {}

class MockPermissionBloc extends Mock implements PermissionBloc {}

class MockLocationServiceBloc extends Mock implements LocationServiceBloc {}

class MockConnectivityBloc extends Mock implements ConnectivityBloc {}

void main() {
  late WeatherBloc bloc;
  late MockWeatherDataBloc mockWeatherDataBloc;
  late MockPermissionBloc mockPermissionBloc;
  late MockLocationServiceBloc mockLocationServiceBloc;
  late MockConnectivityBloc mockConnectivityBloc;
  late Position mockPosition;
  late Weather mockWeather;
  late BehaviorSubject<PermissionState> permissionSubject;
  late BehaviorSubject<LocationServiceState> locationSubject;
  late BehaviorSubject<WeatherDataState> weatherDataSubject;

  setUp(() {
    mockWeatherDataBloc = MockWeatherDataBloc();
    mockPermissionBloc = MockPermissionBloc();
    mockLocationServiceBloc = MockLocationServiceBloc();
    mockConnectivityBloc = MockConnectivityBloc();

    permissionSubject = BehaviorSubject<PermissionState>();
    locationSubject = BehaviorSubject<LocationServiceState>();
    weatherDataSubject = BehaviorSubject<WeatherDataState>();

    when(
      () => mockPermissionBloc.stream,
    ).thenAnswer((_) => permissionSubject.stream);
    when(
      () => mockLocationServiceBloc.stream,
    ).thenAnswer((_) => locationSubject.stream);
    when(
      () => mockWeatherDataBloc.stream,
    ).thenAnswer((_) => weatherDataSubject.stream);

    bloc = WeatherBloc(
      mockWeatherDataBloc,
      mockPermissionBloc,
      mockLocationServiceBloc,
      mockConnectivityBloc,
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

  tearDown(() {
    permissionSubject.close();
    locationSubject.close();
    weatherDataSubject.close();
  });

  group('WeatherBloc', () {
    test('initial state should be Loading', () {
      expect(bloc.state, equals(const WeatherState.loading()));
    });

    blocTest<WeatherBloc, WeatherState>(
      'should call started when started',
      build: () => bloc,
      verify: (_) {
        verify(
          () => mockPermissionBloc.add(const PermissionEvent.started()),
        ).called(1);
      },
    );

    blocTest<WeatherBloc, WeatherState>(
      'should emit [error] when permission is denied',
      build: () => bloc,
      act: (bloc) {
        permissionSubject.add(const PermissionState.denied());
      },
      expect:
          () => [
            predicate<WeatherState>((state) {
              if (state is WeatherError) {
                return state.failure.message == 'Permission Denied' &&
                    state.failure.id.isNotEmpty;
              }
              return false;
            }),
          ],
    );

    blocTest<WeatherBloc, WeatherState>(
      'should check location service when permission is granted',
      build: () => bloc,
      act: (bloc) {
        permissionSubject.add(const PermissionState.granted());
      },
      verify: (_) {
        verify(
          () => mockLocationServiceBloc.add(const LocationServiceEvent.check()),
        ).called(1);
      },
    );

    blocTest<WeatherBloc, WeatherState>(
      'should emit [error] when location service is disabled',
      build: () => bloc,
      act: (bloc) {
        locationSubject.add(
          const LocationServiceState.locationServiceNotEnabled(),
        );
        return bloc;
      },
      expect:
          () => [
            predicate<WeatherState>((state) {
              if (state is WeatherError) {
                return state.failure.message == 'Location Service Disabled' &&
                    state.failure.id.isNotEmpty;
              }
              return false;
            }),
          ],
    );

    blocTest<WeatherBloc, WeatherState>(
      'should emit [error] when there is no internet connection',
      build: () {
        when(
          () => mockConnectivityBloc.state,
        ).thenReturn(const ConnectivityState.noInternetConnection());
        return bloc;
      },
      act: (bloc) {
        locationSubject.add(
          LocationServiceState.locationServiceEnabled(mockPosition),
        );
        return bloc;
      },
      expect:
          () => [
            predicate<WeatherState>((state) {
              if (state is WeatherError) {
                return state.failure.message == 'No Internet' &&
                    state.failure.id.isNotEmpty;
              }
              return false;
            }),
          ],
    );

    blocTest<WeatherBloc, WeatherState>(
      'should fetch weather when location is enabled and internet is connected',
      build: () {
        when(
          () => mockConnectivityBloc.state,
        ).thenReturn(const ConnectivityState.connected());
        return bloc;
      },
      act: (bloc) {
        locationSubject.add(
          LocationServiceState.locationServiceEnabled(mockPosition),
        );
        return bloc;
      },
      verify: (_) {
        verify(
          () => mockWeatherDataBloc.add(
            WeatherDataEvent.fetchWeather(mockPosition),
          ),
        ).called(1);
      },
    );

    blocTest<WeatherBloc, WeatherState>(
      'should emit [loaded] when weather is fetched successfully',
      build: () => bloc,
      act: (bloc) {
        weatherDataSubject.add(
          WeatherDataState.weatherDataloaded(
            weather: mockWeather,
            cityName: 'Test City',
          ),
        );
        return bloc.add(
          WeatherEvent.weatherFetched(
            isLoaded: true,
            weather: mockWeather,
            cityName: 'Test City',
          ),
        );
      },
      expect:
          () => [
            WeatherState.loaded(weather: mockWeather, cityName: 'Test City'),
          ],
    );

    blocTest<WeatherBloc, WeatherState>(
      'should emit [error] when weather fetch fails',
      build: () => bloc,
      act: (bloc) {
        weatherDataSubject.add(
          WeatherDataState.weatherDataError(
            Failure(
              message: 'Weather fetch failed',
              id: 'weather_fetch_failed',
            ),
          ),
        );
        return bloc.add(
          WeatherEvent.weatherFetched(
            isLoaded: false,
            failure: Failure(
              message: 'Weather fetch failed',
              id: 'weather_fetch_failed',
            ),
          ),
        );
      },
      expect:
          () => [
            WeatherState.error(
              Failure(
                message: 'Weather fetch failed',
                id: 'weather_fetch_failed',
              ),
            ),
          ],
    );
  });
}
