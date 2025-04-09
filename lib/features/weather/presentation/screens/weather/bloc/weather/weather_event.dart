part of 'weather_bloc.dart';

@freezed
class WeatherEvent with _$WeatherEvent {
  const factory WeatherEvent.started() = _Started;
  const factory WeatherEvent.permissionChecked({
    required PermissionState state,
  }) = _PermissionChecked;
  const factory WeatherEvent.locationFetched({
    required bool isEnabled,
    dynamic position,
  }) = _LocationFetched;
  const factory WeatherEvent.weatherFetched({
    required bool isLoaded,
    Weather? weather,
    String? cityName,
    Failure? failure,
  }) = _WeatherFetched;
}
