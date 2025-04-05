import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app/core/services/permission_service.dart';

class MockPermissionService extends Mock implements PermissionService {}

void main() {
  late PermissionService permissionService;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    permissionService = PermissionService();
  });

  void mockMethodChannel({required String method, required dynamic result}) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          MethodChannel('flutter.baseflow.com/permissions/methods'),
          (MethodCall methodCall) async {
            return Future.value(result);
          },
        );
  }

  test('isDenied returns Success with denied status', () async {
    mockMethodChannel(method: 'requestPermissions', result: 0);
    final result = await permissionService.isDenied(Permission.location);
    expect(result, true);
  });

  test('isGranted returns Success with granted status', () async {
    mockMethodChannel(method: 'requestPermissions', result: 1);
    final result = await permissionService.isGranted(Permission.location);
    expect(result, true);
  });

  test('isLimited returns Success with limited status', () async {
    mockMethodChannel(method: 'requestPermissions', result: 3);
    final result = await permissionService.isLimited(Permission.location);
    expect(result, true);
  });

  test(
    'isPermanentlyDenied returns Success with permanently denied status',
    () async {
      mockMethodChannel(method: 'requestPermissions', result: 4);
      final result = await permissionService.isPermanentlyDenied(
        Permission.location,
      );
      expect(result, true);
    },
  );

  test('requestPermission returns Success with all denied status', () async {
    mockMethodChannel(method: 'requestPermissions', result: {0: 0});
    final result = await permissionService.requestPermissions();
    expect(result, [PermissionStatus.denied]);
  });

  test('getPermissionStatus returns correct status', () async {
    mockMethodChannel(method: 'requestPermissions', result: 1);
    final status = await permissionService.getPermissionStatus(
      Permission.location,
    );
    expect(status, PermissionStatus.granted);
  });
}
