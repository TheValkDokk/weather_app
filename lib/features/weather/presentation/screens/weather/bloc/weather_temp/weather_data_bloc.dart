import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:weather_app/core/errors/failure.dart';
import 'package:weather_app/features/location/domain/usecase/fetch_location_name.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/usecase/fetch_weather_usecase.dart';

part 'weather_data_event.dart';
part 'weather_data_state.dart';
part 'weather_data_bloc.freezed.dart';

@lazySingleton
class WeatherDataBloc extends Bloc<WeatherDataEvent, WeatherDataState> {
  final FetchWeatherUsecase fetchWeatherUsecase;
  final FetchLocationNameUseCase fetchLocationNameUsecase;
  WeatherDataBloc(this.fetchWeatherUsecase, this.fetchLocationNameUsecase)
    : super(_WeatherDataInitial()) {
    on<_WeatherDataStarted>(_onStarted);
    on<_WeatherDataFetchWeather>(_onFetchWeather);
  }

  Future<void> _onStarted(
    _WeatherDataStarted event,
    Emitter<WeatherDataState> emit,
  ) async {
    emit(const WeatherDataState.weatherDataloading());
  }

  Future<void> _onFetchWeather(
    _WeatherDataFetchWeather event,
    Emitter<WeatherDataState> emit,
  ) async {
    try {
      emit(const WeatherDataState.weatherDataloading());
      final position = event.position;
      final weather = await fetchWeatherUsecase(position);
      final cityName = await fetchLocationNameUsecase(position);

      weather.fold(
        (failure) => emit(WeatherDataState.weatherDataError(failure)),
        (weatherData) => cityName.fold(
          (failure) => emit(WeatherDataState.weatherDataError(failure)),
          (city) => emit(
            WeatherDataState.weatherDataloaded(
              weather: weatherData,
              cityName: city,
            ),
          ),
        ),
      );
    } catch (e) {
      emit(WeatherDataState.weatherDataError(Failure(message: e.toString())));
    }
  }
}
