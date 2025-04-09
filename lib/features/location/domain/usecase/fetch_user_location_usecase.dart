import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:weather_app/core/app.dart';
import 'package:weather_app/features/location/domain/repository/location_repository.dart';

@injectable
class FetchUserLocationUsecase implements UseCase<Position, void> {
  final LocationRepository locationRepository;

  FetchUserLocationUsecase(this.locationRepository);

  @override
  Future<Either<Failure, Position>> call(void params) async {
    try {
      return await locationRepository.getCurrentLocation();
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
