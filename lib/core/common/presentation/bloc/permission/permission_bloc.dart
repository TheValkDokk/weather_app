import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app/core/services/permission_service.dart';

part 'permission_event.dart';
part 'permission_state.dart';
part 'permission_bloc.freezed.dart';

@lazySingleton
class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  final PermissionService permissionService;

  PermissionBloc(this.permissionService)
    : super(const PermissionState.initial()) {
    on<_Started>(_onStarted);
    on<_CheckPermission>(_onCheckPermission);
  }

  Future<void> _onStarted(event, Emitter<PermissionState> emit) async {
    await permissionService.requestPermissions();
    add(const PermissionEvent.checkPermission());
  }

  Future<void> _onCheckPermission(event, Emitter<PermissionState> emit) async {
    emit(const PermissionState.loading());
    for (var permission in permissionService.permissions) {
      final status = await permissionService.getPermissionStatus(permission);

      switch (status) {
        case PermissionStatus.granted:
          emit(const PermissionState.granted());
          return;
        case PermissionStatus.denied:
          emit(const PermissionState.denied());
          return;
        case PermissionStatus.restricted:
          emit(const PermissionState.restricted());
          return;
        case PermissionStatus.limited:
          emit(const PermissionState.limited());
          return;
        case PermissionStatus.permanentlyDenied:
          emit(const PermissionState.permanentlyDenied());
          return;
        default:
          continue;
      }
    }
  }
}
