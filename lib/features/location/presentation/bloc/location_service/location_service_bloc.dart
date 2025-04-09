import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:weather_app/core/errors/failure.dart';
import 'package:weather_app/features/location/domain/usecase/fetch_user_location_usecase.dart';

part 'location_service_event.dart';
part 'location_service_state.dart';
part 'location_service_bloc.freezed.dart';

@lazySingleton
class LocationServiceBloc
    extends Bloc<LocationServiceEvent, LocationServiceState> {
  final FetchUserLocationUsecase fetchUserLocationUsecase;

  LocationServiceBloc(this.fetchUserLocationUsecase) : super(_Initial()) {
    on<_Check>(_onCheck);
    on<_GetLocation>(_onGetLocation);
  }

  Future<void> _onCheck(
    _Check event,
    Emitter<LocationServiceState> emit,
  ) async {
    emit(const LocationServiceState.loading());
    final result = await Geolocator.isLocationServiceEnabled();
    if (!result) {
      emit(const LocationServiceState.locationServiceNotEnabled());
    } else {
      add(const _GetLocation());
    }
  }

  Future<void> _onGetLocation(
    _GetLocation event,
    Emitter<LocationServiceState> emit,
  ) async {
    final uc = await fetchUserLocationUsecase(null);
    emit(
      uc.fold(
        (failure) => LocationServiceState.locationServiceError(failure),
        (position) => LocationServiceState.locationServiceEnabled(position),
      ),
    );
  }
}
