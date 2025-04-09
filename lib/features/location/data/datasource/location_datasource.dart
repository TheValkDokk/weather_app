import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app/core/app.dart';
import 'package:weather_app/features/location/data/datasource/geocoding_datasource.dart';

abstract class LocationDataSource {
  /// Retrieves the current device location.
  ///
  /// Returns a [Future] that completes with a [Position] object containing
  /// the current latitude and longitude coordinates.
  ///
  /// Throws a [Failure] if:
  /// - Location services are disabled
  /// - Location permission is not granted
  /// - Unable to get the current position
  Future<Position> getCurrentLocation();

  /// Converts latitude and longitude coordinates to a list of placemarks.
  ///
  /// [latitude] The latitude coordinate (must be between -90 and 90)
  /// [longitude] The longitude coordinate (must be between -180 and 180)
  ///
  /// Returns a [Future] that completes with a list of [Placemark] objects
  /// containing location information.
  ///
  /// Throws a [Failure] if:
  /// - The coordinates are invalid
  /// - Unable to get placemarks for the given coordinates
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
