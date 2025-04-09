import 'dart:async';

import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weather_app/core/services/connectivity_service.dart';

class MockConnectivity extends Mock implements Connectivity {}

class MockBehaviorSubject extends Mock
    implements BehaviorSubject<ConnectivityResult> {}

void main() {
  late MockConnectivity mockConnectivity;
  late MockBehaviorSubject mockConnectivitySubject;
  late ConnectivityService connectivityService;
  late StreamController<List<ConnectivityResult>> connectivityController;

  setUpAll(() {
    registerFallbackValue(ConnectivityResult.wifi);
  });

  setUp(() {
    mockConnectivity = MockConnectivity();
    mockConnectivitySubject = MockBehaviorSubject();
    connectivityController = StreamController<List<ConnectivityResult>>();

    when(
      () => mockConnectivity.onConnectivityChanged,
    ).thenAnswer((_) => connectivityController.stream);

    final realSubject = BehaviorSubject<ConnectivityResult>();
    when(
      () => mockConnectivitySubject.stream,
    ).thenAnswer((_) => realSubject.stream);
    when(() => mockConnectivitySubject.add(any())).thenAnswer((invocation) {
      realSubject.add(invocation.positionalArguments[0] as ConnectivityResult);
    });
    when(() => mockConnectivitySubject.close()).thenAnswer((_) async {
      await realSubject.close();
    });
    when(
      () => mockConnectivitySubject.isClosed,
    ).thenAnswer((_) => realSubject.isClosed);

    connectivityService = ConnectivityService.test(
      connectivity: mockConnectivity,
      connectivitySubject: mockConnectivitySubject,
    );

    registerFallbackValue(ConnectivityResult.wifi);
  });

  tearDown(() {
    connectivityController.close();
    connectivityService.dispose();
  });

  group('ConnectivityService Tests', () {
    test('initializes and listens to connectivity changes', () {
      connectivityController.add([ConnectivityResult.wifi]);

      expectLater(
        connectivityService.connectivityStream(),
        emits(ConnectivityResult.wifi),
      );
    });

    test('currentConnectivityStatus returns connectivity result', () async {
      // Arrange
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.mobile]);

      // Act
      final result = await connectivityService.currentConnectivityStatus();

      // Assert
      expect(result, [ConnectivityResult.mobile]);
      verify(() => mockConnectivity.checkConnectivity()).called(1);
    });

    test('connectivityStream emits values when connectivity changes', () async {
      // Act
      connectivityController.add([ConnectivityResult.wifi]);
      connectivityController.add([ConnectivityResult.mobile]);
      connectivityController.add([ConnectivityResult.none]);

      // Assert
      await expectLater(
        connectivityService.connectivityStream().take(3),
        emitsInOrder([
          ConnectivityResult.wifi,
          ConnectivityResult.mobile,
          ConnectivityResult.none,
        ]),
      );
    });

    test('handles empty connectivity results gracefully', () async {
      // Act
      connectivityController.add([]);

      // Assert - no value should be added to the subject
      verifyNever(() => mockConnectivitySubject.add(any()));
    });

    test('dispose closes the connectivity subject', () async {
      final stream = connectivityService.connectivityStream();
      final emissions = <ConnectivityResult>[];

      final subscription = stream.listen(emissions.add);

      connectivityController.add([ConnectivityResult.wifi]);
      await Future.delayed(const Duration(milliseconds: 10));

      await connectivityService.dispose();

      verify(() => mockConnectivitySubject.close()).called(1);
      expect(emissions, [ConnectivityResult.wifi]);

      await subscription.cancel();
    });

    test('handles connectivity check errors', () async {
      // Arrange
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenThrow(Exception('Connectivity check failed'));

      // Act & Assert
      expect(
        () async => await connectivityService.currentConnectivityStatus(),
        throwsA(isA<Exception>()),
      );
      verify(() => mockConnectivity.checkConnectivity()).called(1);
    });
  });
}
