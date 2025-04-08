import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:injectable/injectable.dart';
import 'package:weather_app/core/errors/failure.dart';

abstract class GeocodingService {
  Future<List<geocoding.Placemark>> placemarkFromCoordinates(
    double latitude,
    double longitude,
  );

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
