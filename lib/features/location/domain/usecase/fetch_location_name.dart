import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:weather_app/core/app.dart';
import 'package:weather_app/features/location/domain/repository/location_repository.dart';

@injectable
class FetchLocationNameUseCase implements UseCase<String, Position> {
  final LocationRepository locationRepository;

  FetchLocationNameUseCase(this.locationRepository);
  @override
  Future<Either<Failure, String>> call(Position params) async {
    try {
      return await locationRepository.getCityName(params);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
