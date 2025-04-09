import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:weather_app/core/services/connectivity_service.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';
part 'connectivity_bloc.freezed.dart';

@lazySingleton
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityService connectivityService;
  ConnectivityBloc(this.connectivityService) : super(_Initial()) {
    on<_Started>((event, emit) async {
      await emit.forEach<ConnectivityResult>(
        connectivityService.connectivityStream(),
        onData: (result) {
          if (result == ConnectivityResult.none) {
            return const ConnectivityState.noInternetConnection();
          } else {
            return const ConnectivityState.connected();
          }
        },
      );
    });
    add(const ConnectivityEvent.started());
  }
}
