import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:weather_app/core/errors/failure.dart';
import 'package:weather_app/features/location/data/datasource/location_datasource.dart';
import 'package:weather_app/features/location/domain/repository/location_repository.dart';

@LazySingleton(as: LocationRepository)
class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource locationDataSource;

  LocationRepositoryImpl(this.locationDataSource);

  @override
  Future<Either<Failure, Position>> getCurrentLocation() async {
    try {
      final result = await locationDataSource.getCurrentLocation();
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failure(message: e.toString(), id: 'unknown_error'));
    }
  }

  @override
  Future<Either<Failure, String>> getCityName(Position position) async {
    try {
      final result = await locationDataSource.getPlacemarks(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      if (result.isEmpty) {
        return Left(Failure(message: 'No city name found', id: 'no_city_name'));
      }
      //China has subAdministrativeArea as ""
      return Right(result.first.subAdministrativeArea!);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failure(message: e.toString(), id: 'unknown_error'));
    }
  }
}
