part of 'permission_bloc.dart';

@freezed
class PermissionState with _$PermissionState {
  const factory PermissionState.initial() = _Initial;
  const factory PermissionState.loading() = PermissionLoading;
  const factory PermissionState.granted() = Granted;
  const factory PermissionState.denied() = Denied;
  const factory PermissionState.restricted() = Restricted;
  const factory PermissionState.limited() = Limited;
  const factory PermissionState.permanentlyDenied() = PermanentlyDenied;
}
