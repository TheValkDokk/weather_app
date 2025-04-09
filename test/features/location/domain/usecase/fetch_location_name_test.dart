import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/errors/failure.dart';
import 'package:weather_app/core/usecase/usecase.dart';
import 'package:weather_app/features/location/domain/repository/location_repository.dart';
import 'package:weather_app/features/location/domain/usecase/fetch_location_name.dart';

class MockLocationRepository extends Mock implements LocationRepository {}

void main() {
  late FetchLocationNameUseCase useCase;
  late MockLocationRepository mockLocationRepository;
  late Position mockPosition;

  setUp(() {
    mockLocationRepository = MockLocationRepository();
    useCase = FetchLocationNameUseCase(mockLocationRepository);

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

  group('FetchLocationNameUseCase', () {
    test('should be a UseCase', () {
      expect(useCase, isA<UseCase<String, Position>>());
    });

    test(
      'should return city name when repository call is successful',
      () async {
        // Arrange
        const tCityName = 'Test City';
        when(
          () => mockLocationRepository.getCityName(mockPosition),
        ).thenAnswer((_) async => const Right(tCityName));

        // Act
        final result = await useCase(mockPosition);

        // Assert
        expect(result, equals(const Right(tCityName)));
        verify(
          () => mockLocationRepository.getCityName(mockPosition),
        ).called(1);
        verifyNoMoreInteractions(mockLocationRepository);
      },
    );

    test('should return failure when repository call fails', () async {
      // Arrange
      final tFailure = Failure(message: 'Failed to get city name');
      when(
        () => mockLocationRepository.getCityName(mockPosition),
      ).thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await useCase(mockPosition);

      // Assert
      expect(result, equals(Left(tFailure)));
      verify(() => mockLocationRepository.getCityName(mockPosition)).called(1);
      verifyNoMoreInteractions(mockLocationRepository);
    });

    test('should return failure when repository throws an exception', () async {
      when(
        () => mockLocationRepository.getCityName(mockPosition),
      ).thenThrow(Exception('Unexpected error'));

      final result = await useCase(mockPosition);

      expect(result.isLeft(), true);
      result.fold(
        (failure) =>
            expect(failure.message, equals('Exception: Unexpected error')),
        (r) => fail('should not be right'),
      );
      verify(() => mockLocationRepository.getCityName(mockPosition)).called(1);
      verifyNoMoreInteractions(mockLocationRepository);
    });
  });
}
