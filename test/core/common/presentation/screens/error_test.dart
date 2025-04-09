import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/common/presentation/screens/error.dart';
import 'package:weather_app/core/theme/pallet.dart';
import 'package:weather_app/core/theme/textstyle.dart';

void main() {
  group('ErrorPage', () {
    testWidgets(
      'should display default error message when no message is provided',
      (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: ErrorPage(onRetry: () {})));

        // Verify default error message is displayed
        expect(find.text('Something went wrong at our end!'), findsOneWidget);

        // Verify retry button is present
        expect(find.text('Retry'), findsOneWidget);

        // Verify background color
        final container = tester.widget<Container>(find.byType(Container));
        expect(container.color, equals(screenBgColorError));
      },
    );

    testWidgets('should display custom error message when provided', (
      WidgetTester tester,
    ) async {
      const customMessage = 'Custom error message';

      await tester.pumpWidget(
        MaterialApp(
          home: ErrorPage(errorMessage: customMessage, onRetry: () {}),
        ),
      );

      expect(find.text(customMessage), findsOneWidget);
    });

    testWidgets('should call onRetry when retry button is pressed', (
      WidgetTester tester,
    ) async {
      bool retryPressed = false;

      await tester.pumpWidget(
        MaterialApp(home: ErrorPage(onRetry: () => retryPressed = true)),
      );

      // Tap the retry button
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(retryPressed, isTrue);
    });

    testWidgets('should have correct layout and styling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: ErrorPage(onRetry: () {})));

      // Verify the container takes full width and height
      final container = tester.widget<Container>(find.byType(Container));
      expect(container.constraints, equals(BoxConstraints.expand()));

      // Verify the column is centered
      final column = tester.widget<Column>(find.byType(Column));
      expect(column.mainAxisAlignment, equals(MainAxisAlignment.center));
      expect(column.spacing, equals(44));

      // Verify text style
      final text = tester.widget<Text>(
        find.text('Something went wrong at our end!'),
      );
      expect(text.style, equals(errorTextStyle));
    });
  });
}
