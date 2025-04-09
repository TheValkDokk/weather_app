part of 'connectivity_bloc.dart';

@freezed
class ConnectivityState with _$ConnectivityState {
  const factory ConnectivityState.initial() = _Initial;
  const factory ConnectivityState.error(String message) = Error;
  const factory ConnectivityState.noInternetConnection() = NoInternetConnection;
  const factory ConnectivityState.connected() = Connected;
}
