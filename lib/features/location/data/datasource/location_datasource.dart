import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:weather_app/core/app.dart';

abstract class LocationDataSource {
  Future<Position> getCurrentLocation();
  Future<List<Placemark>> getPlacemarks(Position position);
}

@Singleton(as: LocationDataSource)
class LocationDataSourceImpl implements LocationDataSource {
  final PermissionService permissionService;
  final GeolocatorPlatform geolocator;

  LocationDataSourceImpl(this.geolocator, this.permissionService);

  @override
  Future<Position> getCurrentLocation() async {
    // TODO: implement getCurrentLocation
    throw UnimplementedError();
  }

  @override
  Future<List<Placemark>> getPlacemarks(Position position) async {
    // TODO: implement getPlacemarks
    throw UnimplementedError();
  }
}
