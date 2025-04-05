import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@singleton
class PermissionService {
  List<Permission> permissions = [Permission.locationWhenInUse];

  Future<List<PermissionStatus>> requestPermissions() async {
    final list = <PermissionStatus>[];
    for (var permission in permissions) {
      final result = await permission.request();
      list.add(result);
    }
    return list;
  }

  Future<bool> isGranted(Permission permission) async {
    return await permission.status.isGranted;
  }

  Future<bool> isPermanentlyDenied(Permission permission) async {
    return await permission.status.isPermanentlyDenied;
  }

  Future<bool> isDenied(Permission permission) async {
    return await permission.status.isDenied;
  }

  Future<bool> isLimited(Permission permission) async {
    return await permission.status.isLimited;
  }

  Future<PermissionStatus> getPermissionStatus(Permission permission) async {
    return await permission.status;
  }
}
