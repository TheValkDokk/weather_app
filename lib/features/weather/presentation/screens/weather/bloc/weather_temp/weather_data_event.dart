part of 'weather_data_bloc.dart';

@freezed
class WeatherDataEvent with _$WeatherDataEvent {
  const factory WeatherDataEvent.started() = _WeatherDataStarted;
  const factory WeatherDataEvent.fetchWeather(Position position) =
      _WeatherDataFetchWeather;
}
