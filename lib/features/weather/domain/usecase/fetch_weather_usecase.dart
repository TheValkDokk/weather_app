import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app/core/app.dart';
import 'package:weather_app/core/services/connectivity_service.dart';
import 'package:weather_app/features/location/domain/repository/location_repository.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/repository/weather_repository.dart';

@injectable
/// A use case for fetching weather data.
///
/// This use case handles the process of fetching weather data by:
/// 1. Checking internet connectivity
/// 2. Verifying location permissions
/// 3. Getting the current location
/// 4. Fetching weather data for that location
///
/// Returns [Either] containing:
/// - [Right] with [Weather] data if successful
/// - [Left] with [Failure] if any step fails
class FetchWeatherUsecase implements UseCase<Weather, void> {
  final WeatherRepository weatherRepository;
  final LocationRepository locationRepository;
  final ConnectivityService connectivityService;
  final PermissionService permissionService;

  FetchWeatherUsecase(
    this.weatherRepository,
    this.locationRepository,
    this.connectivityService,
    this.permissionService,
  );
  @override
  Future<Either<Failure, Weather>> call(void params) async {
    //check if the user is connected to the internet
    final isConnected = await connectivityService.isConnected();
    if (!isConnected) {
      return left(
        Failure(message: 'No internet connection', id: 'no_internet'),
      );
    }

    //get the user's locationPermission
    final locationPermission = await permissionService.isGranted(
      Permission.locationWhenInUse,
    );
    if (!locationPermission) {
      return left(
        Failure(
          message: 'Location permission not granted',
          id: 'location_permission_not_granted',
        ),
      );
    }

    //get the user's location
    final location = await locationRepository.getCurrentLocation();
    return location.fold(
      (failure) => left(failure),
      (position) => weatherRepository.getCurrentWeather(
        position.latitude,
        position.longitude,
      ),
    );
  }
}
