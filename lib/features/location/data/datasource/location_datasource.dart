import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app/core/app.dart';
import 'package:weather_app/features/location/data/datasource/geocoding_datasource.dart';

abstract class LocationDataSource {
  Future<Position> getCurrentLocation();
  Future<List<Placemark>> getPlacemarks({
    required double latitude,
    required double longitude,
  });
}

@Singleton(as: LocationDataSource)
class LocationDataSourceImpl implements LocationDataSource {
  final PermissionService permissionService;
  final GeocodingService geocodingService;
  final GeolocatorPlatform geolocator;

  LocationDataSourceImpl(
    this.geolocator,
    this.permissionService,
    this.geocodingService,
  );

  @override
  Future<Position> getCurrentLocation() async {
    final isServiceEnabled = await geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      throw Failure(
        message: 'Location services are disabled. Please enable them.',
        id: 'location_service_disabled',
      );
    }

    final status = await permissionService.isGranted(
      Permission.locationWhenInUse,
    );

    if (!status) {
      throw Failure(
        message: 'Location permission is not granted. Please grant it.',
        id: 'location_permission_not_granted',
      );
    }

    //if last known position is available, use it (it's faster than getting current position)
    try {
      final lastKnownPosition = await geolocator.getLastKnownPosition();
      if (lastKnownPosition != null) {
        return lastKnownPosition;
      }
    } catch (e) {
      //no last known position, ignore
    }

    return await geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        //checking temp in city area so medium accuracy is sufficient
        accuracy: LocationAccuracy.medium,
      ),
    );
  }

  @override
  Future<List<Placemark>> getPlacemarks({
    required double latitude,
    required double longitude,
  }) {
    return geocodingService.placemarkFromCoordinates(latitude, longitude);
  }
}
