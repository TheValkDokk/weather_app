import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/errors/failure.dart';
import 'package:weather_app/core/usecase/usecase.dart';
import 'package:weather_app/features/location/domain/repository/location_repository.dart';
import 'package:weather_app/features/location/domain/usecase/fetch_user_location_usecase.dart';

class MockLocationRepository extends Mock implements LocationRepository {}

void main() {
  late FetchUserLocationUsecase useCase;
  late MockLocationRepository mockLocationRepository;
  late Position mockPosition;

  setUp(() {
    mockLocationRepository = MockLocationRepository();
    useCase = FetchUserLocationUsecase(mockLocationRepository);

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
  });

  group('FetchUserLocationUsecase', () {
    test('should be a UseCase', () {
      expect(useCase, isA<UseCase<Position, void>>());
    });

    test('should return position when repository call is successful', () async {
      when(
        () => mockLocationRepository.getCurrentLocation(),
      ).thenAnswer((_) async => Right(mockPosition));

      final result = await useCase(null);

      expect(result, equals(Right(mockPosition)));
      verify(() => mockLocationRepository.getCurrentLocation()).called(1);
      verifyNoMoreInteractions(mockLocationRepository);
    });

    test('should return failure when repository call fails', () async {
      final tFailure = Failure(message: 'Failed to get location');
      when(
        () => mockLocationRepository.getCurrentLocation(),
      ).thenAnswer((_) async => Left(tFailure));

      final result = await useCase(null);

      expect(result, equals(Left(tFailure)));
      verify(() => mockLocationRepository.getCurrentLocation()).called(1);
      verifyNoMoreInteractions(mockLocationRepository);
    });

    test('should return failure when repository throws an exception', () async {
      when(
        () => mockLocationRepository.getCurrentLocation(),
      ).thenThrow(Exception('Unexpected error'));

      final result = await useCase(null);

      expect(result.isLeft(), true);
      result.fold(
        (failure) =>
            expect(failure.message, equals('Exception: Unexpected error')),
        (r) => fail('should not be right'),
      );
      verify(() => mockLocationRepository.getCurrentLocation()).called(1);
      verifyNoMoreInteractions(mockLocationRepository);
    });
  });
}
