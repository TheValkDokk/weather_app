part of 'location_service_bloc.dart';

@freezed
class LocationServiceEvent with _$LocationServiceEvent {
  const factory LocationServiceEvent.check() = _Check;
  const factory LocationServiceEvent.getLocation() = _GetLocation;
}
