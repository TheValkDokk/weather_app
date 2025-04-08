import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app/core/common/presentation/bloc/permission/permission_bloc.dart';
import 'package:weather_app/core/services/permission_service.dart';

class MockPermissionService extends Mock implements PermissionService {}

void main() {
  late MockPermissionService mockPermissionService;
  late PermissionBloc permissionBloc;

  setUpAll(() {
    registerFallbackValue(Permission.location);
  });

  setUp(() {
    mockPermissionService = MockPermissionService();
    permissionBloc = PermissionBloc(mockPermissionService);
  });

  group('PermissionBloc', () {
    blocTest<PermissionBloc, PermissionState>(
      'emits [initial, loading, granted] when permission is granted',
      build: () {
        when(
          () => mockPermissionService.requestPermissions(),
        ).thenAnswer((_) async => [PermissionStatus.granted]);
        when(
          () => mockPermissionService.permissions,
        ).thenReturn([Permission.location]);
        when(
          () => mockPermissionService.getPermissionStatus(any()),
        ).thenAnswer((_) async => PermissionStatus.granted);
        return permissionBloc;
      },
      act: (bloc) => bloc.add(const PermissionEvent.started()),
      expect:
          () => [
            const PermissionState.loading(),
            const PermissionState.granted(),
          ],
    );

    blocTest<PermissionBloc, PermissionState>(
      'emits [initial, loading, denied] when permission is denied',
      build: () {
        when(
          () => mockPermissionService.requestPermissions(),
        ).thenAnswer((_) async => []);
        when(
          () => mockPermissionService.permissions,
        ).thenReturn([Permission.location]);
        when(
          () => mockPermissionService.getPermissionStatus(any()),
        ).thenAnswer((_) async => PermissionStatus.denied);
        return permissionBloc;
      },
      act: (bloc) => bloc.add(const PermissionEvent.started()),
      expect:
          () => [
            const PermissionState.loading(),
            const PermissionState.denied(),
          ],
    );

    blocTest<PermissionBloc, PermissionState>(
      'emits [initial, loading, restricted] when permission is restricted',
      build: () {
        when(
          () => mockPermissionService.requestPermissions(),
        ).thenAnswer((_) async => []);
        when(
          () => mockPermissionService.permissions,
        ).thenReturn([Permission.location]);
        when(
          () => mockPermissionService.getPermissionStatus(any()),
        ).thenAnswer((_) async => PermissionStatus.restricted);
        return permissionBloc;
      },
      act: (bloc) => bloc.add(const PermissionEvent.started()),
      expect:
          () => [
            const PermissionState.loading(),
            const PermissionState.restricted(),
          ],
    );

    blocTest<PermissionBloc, PermissionState>(
      'emits [initial, loading, permanentlyDenied] when permission is permanently denied',
      build: () {
        when(
          () => mockPermissionService.requestPermissions(),
        ).thenAnswer((_) async => []);
        when(
          () => mockPermissionService.permissions,
        ).thenReturn([Permission.location]);
        when(
          () => mockPermissionService.getPermissionStatus(any()),
        ).thenAnswer((_) async => PermissionStatus.permanentlyDenied);
        return permissionBloc;
      },
      act: (bloc) => bloc.add(const PermissionEvent.started()),
      expect:
          () => [
            const PermissionState.loading(),
            const PermissionState.permanentlyDenied(),
          ],
    );

    blocTest<PermissionBloc, PermissionState>(
      'emits [initial, loading, limited] when permission is limited',
      build: () {
        when(
          () => mockPermissionService.requestPermissions(),
        ).thenAnswer((_) async => []);
        when(
          () => mockPermissionService.permissions,
        ).thenReturn([Permission.location]);
        when(
          () => mockPermissionService.getPermissionStatus(any()),
        ).thenAnswer((_) async => PermissionStatus.limited);
        return permissionBloc;
      },
      act: (bloc) => bloc.add(const PermissionEvent.started()),
      expect:
          () => [
            const PermissionState.loading(),
            const PermissionState.limited(),
          ],
    );

    blocTest<PermissionBloc, PermissionState>(
      'checks multiple permissions until granted',
      build: () {
        when(
          () => mockPermissionService.requestPermissions(),
        ).thenAnswer((_) async => []);
        when(
          () => mockPermissionService.permissions,
        ).thenReturn([Permission.location, Permission.locationAlways]);
        when(
          () => mockPermissionService.getPermissionStatus(Permission.location),
        ).thenAnswer((_) async => PermissionStatus.denied);
        when(
          () => mockPermissionService.getPermissionStatus(
            Permission.locationAlways,
          ),
        ).thenAnswer((_) async => PermissionStatus.granted);
        return permissionBloc;
      },
      act: (bloc) => bloc.add(const PermissionEvent.started()),
      expect:
          () => [
            const PermissionState.loading(),
            const PermissionState.denied(),
          ],
    );
  });
}
