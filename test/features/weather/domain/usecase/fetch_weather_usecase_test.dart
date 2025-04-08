import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app/core/app.dart';
import 'package:weather_app/core/services/connectivity_service.dart';
import 'package:weather_app/features/location/domain/repository/location_repository.dart';
import 'package:weather_app/features/weather/domain/entities/current_temperature.dart';
import 'package:weather_app/features/weather/domain/entities/daily.dart';
import 'package:weather_app/features/weather/domain/entities/temperature.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/repository/weather_repository.dart';
import 'package:weather_app/features/weather/domain/usecase/fetch_weather_usecase.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

class MockLocationRepository extends Mock implements LocationRepository {}

class MockConnectivityService extends Mock implements ConnectivityService {}

class MockPermissionService extends Mock implements PermissionService {}

void main() {
  late FetchWeatherUsecase usecase;
  late MockWeatherRepository mockWeatherRepository;
  late MockLocationRepository mockLocationRepository;
  late MockConnectivityService mockConnectivityService;
  late MockPermissionService mockPermissionService;

  setUpAll(() {
    registerFallbackValue(Permission.location);
  });

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    mockLocationRepository = MockLocationRepository();
    mockConnectivityService = MockConnectivityService();
    mockPermissionService = MockPermissionService();

    usecase = FetchWeatherUsecase(
      mockWeatherRepository,
      mockLocationRepository,
      mockConnectivityService,
      mockPermissionService,
    );
  });

  final tPosition = Position(
    latitude: 1.0,
    longitude: 1.0,
    timestamp: DateTime.now(),
    accuracy: 0.0,
    altitude: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
    altitudeAccuracy: 0.0,
    headingAccuracy: 0.0,
  );
  final tWeather = Weather(
    timezone: 'UTC',
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

  group('FetchWeatherUsecase', () {
    test('should return weather data when all conditions are met', () async {
      when(
        () => mockConnectivityService.isConnected(),
      ).thenAnswer((_) async => true);
      when(
        () => mockPermissionService.isGranted(Permission.locationWhenInUse),
      ).thenAnswer((_) async => true);
      when(
        () => mockLocationRepository.getCurrentLocation(),
      ).thenAnswer((_) async => Right(tPosition));
      when(
        () => mockWeatherRepository.getCurrentWeather(any(), any()),
      ).thenAnswer((_) async => Right(tWeather));

      final result = await usecase(null);

      expect(result, Right(tWeather));
      verify(() => mockConnectivityService.isConnected()).called(1);
      verify(
        () => mockPermissionService.isGranted(Permission.locationWhenInUse),
      ).called(1);
      verify(() => mockLocationRepository.getCurrentLocation()).called(1);
      verify(() => mockWeatherRepository.getCurrentWeather(1.0, 1.0)).called(1);
    });

    test(
      'should return failure when there is no internet connection',
      () async {
        when(
          () => mockConnectivityService.isConnected(),
        ).thenAnswer((_) async => false);

        final result = await usecase(null);

        expect(
          result,
          Left(Failure(message: 'No internet connection', id: 'no_internet')),
        );
        verify(() => mockConnectivityService.isConnected()).called(1);
        verifyNever(() => mockPermissionService.isGranted(any()));
        verifyNever(() => mockLocationRepository.getCurrentLocation());
        verifyNever(
          () => mockWeatherRepository.getCurrentWeather(any(), any()),
        );
      },
    );

    test(
      'should return failure when location permission is not granted',
      () async {
        when(
          () => mockConnectivityService.isConnected(),
        ).thenAnswer((_) async => true);
        when(
          () => mockPermissionService.isGranted(Permission.locationWhenInUse),
        ).thenAnswer((_) async => false);

        final result = await usecase(null);

        expect(
          result,
          Left(
            Failure(
              message: 'Location permission not granted',
              id: 'location_permission_not_granted',
            ),
          ),
        );
        verify(() => mockConnectivityService.isConnected()).called(1);
        verify(
          () => mockPermissionService.isGranted(Permission.locationWhenInUse),
        ).called(1);
        verifyNever(() => mockLocationRepository.getCurrentLocation());
        verifyNever(
          () => mockWeatherRepository.getCurrentWeather(any(), any()),
        );
      },
    );

    test('should return failure when location retrieval fails', () async {
      final tFailure = Failure(message: 'Location error', id: 'location_error');
      when(
        () => mockConnectivityService.isConnected(),
      ).thenAnswer((_) async => true);
      when(
        () => mockPermissionService.isGranted(Permission.locationWhenInUse),
      ).thenAnswer((_) async => true);
      when(
        () => mockLocationRepository.getCurrentLocation(),
      ).thenAnswer((_) async => Left(tFailure));

      final result = await usecase(null);

      expect(result, Left(tFailure));
      verify(() => mockConnectivityService.isConnected()).called(1);
      verify(
        () => mockPermissionService.isGranted(Permission.locationWhenInUse),
      ).called(1);
      verify(() => mockLocationRepository.getCurrentLocation()).called(1);
      verifyNever(() => mockWeatherRepository.getCurrentWeather(any(), any()));
    });

    test('should return failure when weather retrieval fails', () async {
      final tFailure = Failure(message: 'Weather error', id: 'weather_error');
      when(
        () => mockConnectivityService.isConnected(),
      ).thenAnswer((_) async => true);
      when(
        () => mockPermissionService.isGranted(Permission.locationWhenInUse),
      ).thenAnswer((_) async => true);
      when(
        () => mockLocationRepository.getCurrentLocation(),
      ).thenAnswer((_) async => Right(tPosition));
      when(
        () => mockWeatherRepository.getCurrentWeather(any(), any()),
      ).thenAnswer((_) async => Left(tFailure));

      final result = await usecase(null);

      expect(result, Left(tFailure));
      verify(() => mockConnectivityService.isConnected()).called(1);
      verify(
        () => mockPermissionService.isGranted(Permission.locationWhenInUse),
      ).called(1);
      verify(() => mockLocationRepository.getCurrentLocation()).called(1);
      verify(() => mockWeatherRepository.getCurrentWeather(1.0, 1.0)).called(1);
    });
  });
}
