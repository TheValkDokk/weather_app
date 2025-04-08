import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/features/weather/presentation/screens/weather/dialogs/permission_denied.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    mockNavigatorObserver = MockNavigatorObserver();
  });

  group('PermissionDeniedDialog', () {
    testWidgets('should show correct title and content', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder:
                  (context) => TextButton(
                    onPressed:
                        () => showDialog(
                          context: context,
                          builder: (context) => const PermissionDeniedDialog(),
                        ),
                    child: const Text('Show Dialog'),
                  ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Permission Denied'), findsOneWidget);
      expect(
        find.text('Please grant permission to use the app'),
        findsOneWidget,
      );
    });

    testWidgets('should show OK button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder:
                  (context) => TextButton(
                    onPressed:
                        () => showDialog(
                          context: context,
                          builder: (context) => const PermissionDeniedDialog(),
                        ),
                    child: const Text('Show Dialog'),
                  ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('OK'), findsOneWidget);
    });

    testWidgets(
      'should close dialog and open app settings when OK is pressed',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorObservers: [mockNavigatorObserver],
            home: Scaffold(
              body: Builder(
                builder:
                    (context) => TextButton(
                      onPressed:
                          () => showDialog(
                            context: context,
                            builder:
                                (context) => const PermissionDeniedDialog(),
                          ),
                      child: const Text('Show Dialog'),
                    ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        // Verify dialog is closed
        expect(find.text('Permission Denied'), findsNothing);
        expect(
          find.text('Please grant permission to use the app'),
          findsNothing,
        );
        expect(find.text('OK'), findsNothing);
      },
    );
  });
}
