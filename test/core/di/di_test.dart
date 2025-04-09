import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:weather_app/core/di/di.dart';

class MockDio extends Mock implements Dio {}

class MockGeolocatorPlatform extends Mock implements GeolocatorPlatform {}

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late MockDio mockDio;
  late MockGeolocatorPlatform mockGeolocator;
  late MockConnectivity mockConnectivity;
  late GetIt getIt;

  setUp(() async {
    getIt = GetIt.instance;
    await getIt.reset();

    mockDio = MockDio();
    mockGeolocator = MockGeolocatorPlatform();
    mockConnectivity = MockConnectivity();

    registerFallbackValue(RequestOptions(path: ''));
  });

  group('Dependency Injection Tests', () {
    test(
      'configureDependencies initializes GetIt with all dependencies',
      () async {
        await configureDependencies();

        expect(getIt.isRegistered<Dio>(), true);
        expect(getIt.isRegistered<GeolocatorPlatform>(), true);
        expect(getIt.isRegistered<Connectivity>(), true);
      },
    );

    test('Dio instance is registered and retrievable', () async {
      await configureDependencies();

      final dio = getIt<Dio>();
      expect(dio, isA<Dio>());
    });

    test('GeolocatorPlatform instance is registered and retrievable', () async {
      await configureDependencies();

      final geolocator = getIt<GeolocatorPlatform>();
      expect(geolocator, isA<GeolocatorPlatform>());
    });

    test('Connectivity instance is registered and retrievable', () async {
      await configureDependencies();

      final connectivity = getIt<Connectivity>();
      expect(connectivity, isA<Connectivity>());
    });

    test('Dependencies are singletons', () async {
      await configureDependencies();

      final dio1 = getIt<Dio>();
      final dio2 = getIt<Dio>();
      expect(identical(dio1, dio2), true);

      final geo1 = getIt<GeolocatorPlatform>();
      final geo2 = getIt<GeolocatorPlatform>();
      expect(identical(geo1, geo2), true);

      final conn1 = getIt<Connectivity>();
      final conn2 = getIt<Connectivity>();
      expect(identical(conn1, conn2), true);
    });
  });

  group('Mocked Dependencies Tests', () {
    setUp(() async {
      getIt.registerSingleton<Dio>(mockDio);
      getIt.registerSingleton<GeolocatorPlatform>(mockGeolocator);
      getIt.registerSingleton<Connectivity>(mockConnectivity);
    });

    test('Mock Dio returns expected response', () async {
      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/test'),
          data: {'test': 'data'},
          statusCode: 200,
        ),
      );

      final dio = getIt<Dio>();
      final response = await dio.get('/test');

      expect(response.data, {'test': 'data'});
      verify(() => mockDio.get('/test')).called(1);
    });

    test('Mock Geolocator returns expected position', () async {
      when(() => mockGeolocator.getCurrentPosition()).thenAnswer(
        (_) async => Position(
          latitude: 1.0,
          longitude: 2.0,
          timestamp: DateTime.now(),
          accuracy: 1.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          altitudeAccuracy: 0.0,
          headingAccuracy: 0.0,
        ),
      );

      final geo = getIt<GeolocatorPlatform>();
      final position = await geo.getCurrentPosition();

      expect(position.latitude, 1.0);
      expect(position.longitude, 2.0);
      verify(() => mockGeolocator.getCurrentPosition()).called(1);
    });

    test('Mock Connectivity returns expected result', () async {
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      final connectivity = getIt<Connectivity>();
      final result = await connectivity.checkConnectivity();

      expect(result, [ConnectivityResult.wifi]);
      verify(() => mockConnectivity.checkConnectivity()).called(1);
    });

    test('Dio handles errors correctly', () async {
      when(() => mockDio.get(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/test'),
          error: 'Test error',
        ),
      );

      final dio = getIt<Dio>();
      expect(() async => await dio.get('/test'), throwsA(isA<DioException>()));
      verify(() => mockDio.get('/test')).called(1);
    });
  });
}
