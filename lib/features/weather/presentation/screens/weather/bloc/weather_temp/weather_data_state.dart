part of 'weather_data_bloc.dart';

@freezed
class WeatherDataState with _$WeatherDataState {
  const factory WeatherDataState.weatherDataInitial() = _WeatherDataInitial;
  const factory WeatherDataState.weatherDataloading() = WeatherDataLoading;
  const factory WeatherDataState.weatherDataloaded({
    required Weather weather,
    required String cityName,
  }) = WeatherDataLoaded;
  const factory WeatherDataState.weatherDataError(Failure failure) =
      WeatherDataError;
}
