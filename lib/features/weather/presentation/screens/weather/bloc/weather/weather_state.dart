part of 'weather_bloc.dart';

@freezed
class WeatherState with _$WeatherState {
  const factory WeatherState.initial() = _Initial;
  const factory WeatherState.loading() = WeatherLoading;
  const factory WeatherState.loaded({
    required Weather weather,
    required String cityName,
  }) = WeatherLoaded;
  const factory WeatherState.error(Failure failure) = WeatherError;
}
