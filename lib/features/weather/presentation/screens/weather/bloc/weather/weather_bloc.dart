import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:weather_app/core/common/presentation/bloc/connectivity/connectivity_bloc.dart';
import 'package:weather_app/core/common/presentation/bloc/permission/permission_bloc.dart';
import 'package:weather_app/core/errors/failure.dart';
import 'package:weather_app/features/location/presentation/bloc/location_service/location_service_bloc.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/presentation/screens/weather/bloc/weather_temp/weather_data_bloc.dart';

part 'weather_event.dart';
part 'weather_state.dart';
part 'weather_bloc.freezed.dart';

@lazySingleton
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherDataBloc weatherDataBloc;
  final PermissionBloc permissionBloc;
  final LocationServiceBloc locationServiceBloc;
  final ConnectivityBloc connectivityBloc;

  WeatherBloc(
    this.weatherDataBloc,
    this.permissionBloc,
    this.locationServiceBloc,
    this.connectivityBloc,
  ) : super(_Initial()) {
    on<_Started>((event, emit) {
      emit(const WeatherState.loading());
      if (connectivityBloc.state is Connected) {
        permissionBloc.add(const PermissionEvent.started());
      } else {
        emit(WeatherError(Failure(message: 'No Internet', id: 'no_internet')));
      }
    });

    on<_PermissionChecked>((event, emit) {
      if (event.state is Granted) {
        locationServiceBloc.add(const LocationServiceEvent.check());
      } else if (event.state is PermissionLoading) {
        emit(WeatherLoading());
      } else {
        emit(WeatherError(Failure(message: 'Permission Denied')));
      }
    });

    on<_LocationFetched>((event, emit) {
      if (event.isEnabled) {
        if (connectivityBloc.state is Connected) {
          weatherDataBloc.add(WeatherDataEvent.fetchWeather(event.position));
        } else {
          emit(WeatherError(Failure(message: 'No Internet')));
        }
      } else {
        emit(WeatherError(Failure(message: 'Location Service Disabled')));
      }
    });

    on<_WeatherFetched>((event, emit) {
      if (event.isLoaded) {
        emit(WeatherLoaded(weather: event.weather!, cityName: event.cityName!));
      } else {
        emit(WeatherError(event.failure!));
      }
    });

    permissionBloc.stream.listen((state) {
      add(_PermissionChecked(state: state));
    });

    connectivityBloc.stream.listen((state) {
      if (state is Connected) {
        add(const _Started());
      }
    });

    locationServiceBloc.stream.listen((state) {
      switch (state) {
        case LocationServiceEnabled():
          add(_LocationFetched(isEnabled: true, position: state.position));
        case LocationServiceLoading():
          break;
        default:
          add(_LocationFetched(isEnabled: false, position: null));
      }
    });

    weatherDataBloc.stream.listen((state) {
      if (state is WeatherDataLoaded) {
        add(
          _WeatherFetched(
            isLoaded: true,
            weather: state.weather,
            cityName: state.cityName,
          ),
        );
      } else if (state is WeatherDataError) {
        add(_WeatherFetched(isLoaded: false, failure: state.failure));
      }
    });

    add(const _Started());
  }
}
