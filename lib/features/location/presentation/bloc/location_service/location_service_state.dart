part of 'location_service_bloc.dart';

@freezed
class LocationServiceState with _$LocationServiceState {
  const factory LocationServiceState.initial() = _Initial;
  const factory LocationServiceState.loading() = Loading;
  const factory LocationServiceState.locationServiceNotEnabled() =
      LocationServiceNotEnabled;
  const factory LocationServiceState.locationServiceEnabled(Position position) =
      LocationServiceEnabled;
  const factory LocationServiceState.locationServiceError(Failure failure) =
      LocationServiceError;
}
