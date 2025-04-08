part of 'permission_bloc.dart';

@freezed
class PermissionEvent with _$PermissionEvent {
  const factory PermissionEvent.started() = _Started;
  const factory PermissionEvent.checkPermission() = _CheckPermission;
}
