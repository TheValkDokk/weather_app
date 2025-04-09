import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/errors/failure.dart';
import 'package:weather_app/features/location/domain/usecase/fetch_user_location_usecase.dart';
import 'package:weather_app/features/location/presentation/bloc/location_service/location_service_bloc.dart';

class MockFetchUserLocationUsecase extends Mock
    implements FetchUserLocationUsecase {}

void mockMethodChannel({required String method, required dynamic result}) {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        MethodChannel('flutter.baseflow.com/geolocator'),
        (MethodCall methodCall) async {
          return Future.value(result);
        },
      );
}

void main() {
  late LocationServiceBloc bloc;
  late MockFetchUserLocationUsecase mockFetchUserLocationUsecase;
  late Position mockPosition;

  setUp(() {
    mockFetchUserLocationUsecase = MockFetchUserLocationUsecase();
    bloc = LocationServiceBloc(mockFetchUserLocationUsecase);

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

  group('LocationServiceBloc', () {
    blocTest<LocationServiceBloc, LocationServiceState>(
      'emits [LocationServiceState.locationServiceNotEnabled] when location service is disabled',
      setUp: () {
        TestWidgetsFlutterBinding.ensureInitialized();
        mockMethodChannel(method: 'isLocationServiceEnabled', result: false);
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const LocationServiceEvent.check()),
      expect:
          () => [
            LocationServiceState.loading(),
            const LocationServiceState.locationServiceNotEnabled(),
          ],
    );

    blocTest<LocationServiceBloc, LocationServiceState>(
      'emits [LocationServiceState.locationServiceEnabled] when location service is enabled and location is fetched successfully',
      setUp: () {
        TestWidgetsFlutterBinding.ensureInitialized();
        mockMethodChannel(method: 'isLocationServiceEnabled', result: true);
      },
      build: () {
        when(
          () => mockFetchUserLocationUsecase(null),
        ).thenAnswer((_) async => Right(mockPosition));
        return bloc;
      },
      act: (bloc) => bloc.add(const LocationServiceEvent.check()),
      expect:
          () => [
            LocationServiceState.loading(),
            LocationServiceState.locationServiceEnabled(mockPosition),
          ],
    );

    blocTest<LocationServiceBloc, LocationServiceState>(
      'emits [LocationServiceState.locationServiceError] when location service is enabled but location fetch fails',
      setUp: () {
        TestWidgetsFlutterBinding.ensureInitialized();
        mockMethodChannel(method: 'isLocationServiceEnabled', result: true);
      },
      build: () {
        final tFailure = Failure(message: 'Failed to get location');
        when(
          () => mockFetchUserLocationUsecase(null),
        ).thenAnswer((_) async => Left(tFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(const LocationServiceEvent.check()),
      expect:
          () => [
            LocationServiceState.loading(),
            predicate<LocationServiceState>((state) {
              if (state is LocationServiceError) {
                return state.failure.message == 'Failed to get location' &&
                    state.failure.id.isNotEmpty;
              }
              return false;
            }),
          ],
    );

    blocTest<LocationServiceBloc, LocationServiceState>(
      'emits [LocationServiceState.locationServiceEnabled] when GetLocation event is added and location is fetched successfully',
      build: () {
        when(
          () => mockFetchUserLocationUsecase(null),
        ).thenAnswer((_) async => Right(mockPosition));
        return bloc;
      },
      act: (bloc) => bloc.add(const LocationServiceEvent.getLocation()),
      expect: () => [LocationServiceState.locationServiceEnabled(mockPosition)],
    );

    blocTest<LocationServiceBloc, LocationServiceState>(
      'emits [LocationServiceState.locationServiceError] when GetLocation event is added and location fetch fails',
      build: () {
        final tFailure = Failure(message: 'Failed to get location');
        when(
          () => mockFetchUserLocationUsecase(null),
        ).thenAnswer((_) async => Left(tFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(const LocationServiceEvent.getLocation()),
      expect:
          () => [
            predicate<LocationServiceState>((state) {
              if (state is LocationServiceError) {
                return state.failure.message == 'Failed to get location' &&
                    state.failure.id.isNotEmpty;
              }
              return false;
            }),
          ],
    );
  });
}
