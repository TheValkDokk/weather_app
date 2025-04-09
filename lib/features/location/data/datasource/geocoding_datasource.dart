import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:injectable/injectable.dart';
import 'package:weather_app/core/errors/failure.dart';

abstract class GeocodingService {
  /// Converts latitude and longitude coordinates to a list of placemarks.
  ///
  /// [latitude] The latitude coordinate (must be between -90 and 90)
  /// [longitude] The longitude coordinate (must be between -180 and 180)
  ///
  /// Returns a [Future] that completes with a list of [Placemark] objects
  /// containing location information.
  ///
  /// Throws a [Failure] if the coordinates are invalid or if the geocoding fails.
  Future<List<geocoding.Placemark>> placemarkFromCoordinates(
    double latitude,
    double longitude,
  );

  /// Validates that the given coordinates are within acceptable ranges.
  ///
  /// [latitude] The latitude coordinate to validate
  /// [longitude] The longitude coordinate to validate
  ///
  /// Throws a [Failure] if either coordinate is outside its valid range:
  /// - Latitude must be between -90 and 90
  /// - Longitude must be between -180 and 180
  void validateCoordinates(double latitude, double longitude);
}

@Singleton(as: GeocodingService)
class GeocodingServiceImpl implements GeocodingService {
  @override
  void validateCoordinates(double latitude, double longitude) {
    const minLatitude = -90.0;
    const maxLatitude = 90.0;
    const minLongitude = -180.0;
    const maxLongitude = 180.0;

    if (!(latitude >= minLatitude &&
        latitude <= maxLatitude &&
        longitude >= minLongitude &&
        longitude <= maxLongitude)) {
      throw Failure(message: 'Invalid coordinates', id: 'invalid_coordinates');
    }
  }

  @override
  Future<List<geocoding.Placemark>> placemarkFromCoordinates(
    double latitude,
    double longitude,
  ) {
    validateCoordinates(latitude, longitude);
    try {
      return geocoding.placemarkFromCoordinates(latitude, longitude);
    } catch (e) {
      throw Failure(message: 'Failed to get placemarks', id: 'geocoding_error');
    }
  }
}
