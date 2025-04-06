import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app/core/app.dart';
import 'package:weather_app/features/location/data/datasource/geocoding_datasource.dart';
import 'package:weather_app/features/location/data/datasource/location_datasource.dart';
import 'package:test/test.dart';

class MockGeolocatorPlatform with Mock implements GeolocatorPlatform {}

class MockPermissionService with Mock implements PermissionService {}

class MockGeocodingService with Mock implements GeocodingService {}

void main() {
  late MockPermissionService mockPermissionService;
  late MockGeolocatorPlatform mockGeolocator;
  late LocationDataSourceImpl locationDataSource;
  late MockGeocodingService mockGeocodingService;

  setUp(() {
    mockPermissionService = MockPermissionService();
    mockGeolocator = MockGeolocatorPlatform();
    mockGeocodingService = MockGeocodingService();

    locationDataSource = LocationDataSourceImpl(
      mockGeolocator,
      mockPermissionService,
      mockGeocodingService,
    );
  });

  group('getCurrentLocation', () {
    final position = Position(
      latitude: 10.0,
      longitude: 10.0,
      timestamp: DateTime.now(),
      accuracy: 10.0,
      altitude: 10.0,
      altitudeAccuracy: 10.0,
      heading: 10.0,
      headingAccuracy: 10.0,
      speed: 10.0,
      speedAccuracy: 10.0,
    );
    test('should return current location', () async {
      when(
        () => mockGeolocator.isLocationServiceEnabled(),
      ).thenAnswer((_) async => true);
      when(
        () => mockPermissionService.isGranted(Permission.locationWhenInUse),
      ).thenAnswer((_) async => true);
      when(
        () => mockGeolocator.getCurrentPosition(
          locationSettings: any(named: 'locationSettings'),
        ),
      ).thenAnswer((_) async => position);

      await expectLater(
        await locationDataSource.getCurrentLocation(),
        isA<Position>()
            .having((p) => p.latitude, 'latitude', 10.0)
            .having((p) => p.longitude, 'longitude', 10.0),
      );
    });

    test('should return last known position if available', () async {
      when(
        () => mockGeolocator.isLocationServiceEnabled(),
      ).thenAnswer((_) async => true);
      when(
        () => mockPermissionService.isGranted(Permission.locationWhenInUse),
      ).thenAnswer((_) async => true);

      when(
        () => mockGeolocator.getLastKnownPosition(),
      ).thenAnswer((_) async => position);

      await expectLater(
        await locationDataSource.getCurrentLocation(),
        isA<Position>()
            .having((p) => p.latitude, 'latitude', 10.0)
            .having((p) => p.longitude, 'longitude', 10.0),
      );
    });

    test('should throw error if location service is not enabled', () async {
      when(
        () => mockGeolocator.isLocationServiceEnabled(),
      ).thenAnswer((_) async => false);

      await expectLater(
        locationDataSource.getCurrentLocation(),
        throwsA(
          isA<Failure>().having((f) => f.id, 'id', 'location_service_disabled'),
        ),
      );
    });

    test('should throw error if location permission is not granted', () async {
      when(
        () => mockGeolocator.isLocationServiceEnabled(),
      ).thenAnswer((_) async => true);
      when(
        () => mockPermissionService.isGranted(Permission.locationWhenInUse),
      ).thenAnswer((_) async => false);

      await expectLater(
        locationDataSource.getCurrentLocation(),
        throwsA(
          isA<Failure>().having(
            (f) => f.id,
            'id',
            'location_permission_not_granted',
          ),
        ),
      );
    });
  });

  group('getPlacemarks', () {
    test('should return placemarks for given coordinates', () async {
      final dummyPlacemark = Placemark(
        name: 'Test Place',
        street: '123 Test Street',
        locality: 'Test City',
        subLocality: 'Test Suburb',
        administrativeArea: 'Test State',
        postalCode: '12345',
        country: 'Test Land',
        isoCountryCode: 'TP',
      );
      final placemarks = [dummyPlacemark];
      when(
        () => mockGeocodingService.placemarkFromCoordinates(any(), any()),
      ).thenAnswer((_) async => placemarks);

      final result = await locationDataSource.getPlacemarks(
        latitude: 10.0,
        longitude: 20.0,
      );
      expect(result, placemarks);
    });

    test('should throw error if geocoding service fails', () async {
      when(
        () => mockGeocodingService.placemarkFromCoordinates(any(), any()),
      ).thenThrow(Failure(message: 'geocoding error', id: 'geocoding_error'));

      await expectLater(
        () async => await locationDataSource.getPlacemarks(
          latitude: 10.0,
          longitude: 20.0,
        ),
        throwsA(isA<Failure>().having((f) => f.id, 'id', 'geocoding_error')),
      );
    });
  });
}
