import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:test/test.dart';
import 'package:weather_app/core/errors/failure.dart';
import 'package:weather_app/features/location/data/datasource/location_datasource.dart';
import 'package:weather_app/features/location/data/repository/location_repository_impl.dart';

class MockLocationDataSource implements LocationDataSource {
  @override
  Future<Position> getCurrentLocation() async {
    return Position(
      latitude: 0.0,
      longitude: 0.0,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );
  }

  @override
  Future<List<Placemark>> getPlacemarks({
    required double latitude,
    required double longitude,
  }) async {
    return [
      Placemark(
        subAdministrativeArea: 'Test City',
        administrativeArea: 'Test State',
        country: 'Test Country',
        isoCountryCode: 'TC',
        name: 'Test Place',
        locality: 'Test Locality',
        postalCode: '12345',
        street: 'Test Street',
        subLocality: 'Test SubLocality',
        subThoroughfare: 'Test SubThoroughfare',
        thoroughfare: 'Test Thoroughfare',
      ),
    ];
  }
}

class MockLocationDataSourceEmptyPlacemarks implements LocationDataSource {
  @override
  Future<Position> getCurrentLocation() async {
    return Position(
      latitude: 0.0,
      longitude: 0.0,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );
  }

  @override
  Future<List<Placemark>> getPlacemarks({
    required double latitude,
    required double longitude,
  }) async {
    return [];
  }
}

class MockLocationDataSourceThrowsFailure implements LocationDataSource {
  @override
  Future<Position> getCurrentLocation() async {
    throw Failure(message: 'Location error', id: 'location_error');
  }

  @override
  Future<List<Placemark>> getPlacemarks({
    required double latitude,
    required double longitude,
  }) async {
    throw Failure(message: 'Geocoding error', id: 'geocoding_error');
  }
}

class MockLocationDataSourceThrowsException implements LocationDataSource {
  @override
  Future<Position> getCurrentLocation() async {
    throw Exception('Unexpected error');
  }

  @override
  Future<List<Placemark>> getPlacemarks({
    required double latitude,
    required double longitude,
  }) async {
    throw Exception('Unexpected error');
  }
}

void main() {
  group('LocationRepositoryImpl', () {
    late LocationRepositoryImpl repository;
    late MockLocationDataSource mockDataSource;

    setUp(() {
      mockDataSource = MockLocationDataSource();
      repository = LocationRepositoryImpl(mockDataSource);
    });

    test(
      'getCurrentLocation should return Right with Position on success',
      () async {
        final result = await repository.getCurrentLocation();
        expect(result.isRight(), true);
        result.fold((failure) => fail('Expected Right, got Left'), (position) {
          expect(
            position,
            isA<Position>()
                .having((p) => p.latitude, 'latitude', 0.0)
                .having((p) => p.longitude, 'longitude', 0.0),
          );
        });
      },
    );

    test('getCityName should return Right with city name on success', () async {
      final position = Position(
        latitude: 0.0,
        longitude: 0.0,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );
      final result = await repository.getCityName(position);
      expect(result.isRight(), true);
      result.fold((failure) => fail('Expected Right, got Left'), (cityName) {
        expect(cityName, 'Test City');
      });
    });

    test(
      'getCityName should return Left with Failure if no placemarks are found',
      () async {
        final position = Position(
          latitude: 0.0,
          longitude: 0.0,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          altitudeAccuracy: 0.0,
          headingAccuracy: 0.0,
        );
        final repositoryWithEmptyPlacemarks = LocationRepositoryImpl(
          MockLocationDataSourceEmptyPlacemarks(),
        );
        final result = await repositoryWithEmptyPlacemarks.getCityName(
          position,
        );
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure.id, 'no_city_name');
          expect(failure.message, 'No city name found');
        }, (cityName) => fail('Expected Left, got Right'));
      },
    );

    test(
      'getCurrentLocation should return Left with Failure when LocationDataSource throws Failure',
      () async {
        final repositoryWithFailure = LocationRepositoryImpl(
          MockLocationDataSourceThrowsFailure(),
        );
        final result = await repositoryWithFailure.getCurrentLocation();
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure.id, 'location_error');
          expect(failure.message, 'Location error');
        }, (position) => fail('Expected Left, got Right'));
      },
    );

    test(
      'getCurrentLocation should return Left with unknown_error when LocationDataSource throws Exception',
      () async {
        final repositoryWithException = LocationRepositoryImpl(
          MockLocationDataSourceThrowsException(),
        );
        final result = await repositoryWithException.getCurrentLocation();
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure.id, 'unknown_error');
          expect(failure.message, 'Exception: Unexpected error');
        }, (position) => fail('Expected Left, got Right'));
      },
    );

    test(
      'getCityName should return Left with Failure when LocationDataSource throws Failure',
      () async {
        final position = Position(
          latitude: 0.0,
          longitude: 0.0,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          altitudeAccuracy: 0.0,
          headingAccuracy: 0.0,
        );
        final repositoryWithFailure = LocationRepositoryImpl(
          MockLocationDataSourceThrowsFailure(),
        );
        final result = await repositoryWithFailure.getCityName(position);
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure.id, 'geocoding_error');
          expect(failure.message, 'Geocoding error');
        }, (cityName) => fail('Expected Left, got Right'));
      },
    );

    test(
      'getCityName should return Left with unknown_error when LocationDataSource throws Exception',
      () async {
        final position = Position(
          latitude: 0.0,
          longitude: 0.0,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          altitudeAccuracy: 0.0,
          headingAccuracy: 0.0,
        );
        final repositoryWithException = LocationRepositoryImpl(
          MockLocationDataSourceThrowsException(),
        );
        final result = await repositoryWithException.getCityName(position);
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure.id, 'unknown_error');
          expect(failure.message, 'Exception: Unexpected error');
        }, (cityName) => fail('Expected Left, got Right'));
      },
    );
  });
}
