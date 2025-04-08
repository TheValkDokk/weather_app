import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/theme/textstyle.dart';
import 'package:weather_app/features/weather/presentation/screens/weather/widgets/main_temp.dart';

void main() {
  group('MainTempWidget', () {
    const testTemp = '25';
    const testCityName = 'New York';

    testWidgets('should display correct temperature and city name', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MainTempWidget(temp: testTemp, cityName: testCityName),
          ),
        ),
      );

      // Verify temperature text
      expect(find.text('25°'), findsOneWidget);
      final tempText = tester.widget<Text>(find.text('25°'));
      expect(tempText.style, equals(currentTempTextStyle));

      // Verify city name text
      expect(find.text('New York'), findsOneWidget);
      final cityText = tester.widget<Text>(find.text('New York'));
      expect(cityText.style, equals(currentCityNameTextStyle));
    });

    testWidgets('should display temperature with degree symbol', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MainTempWidget(temp: '30', cityName: testCityName),
          ),
        ),
      );

      expect(find.text('30°'), findsOneWidget);
    });

    testWidgets('should have correct layout structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MainTempWidget(temp: testTemp, cityName: testCityName),
          ),
        ),
      );

      // Verify column is present
      expect(find.byType(Column), findsOneWidget);

      // Verify text widgets are in correct order
      final column = tester.widget<Column>(find.byType(Column));
      expect(column.children.length, equals(2));
      expect(column.children[0], isA<Text>());
      expect(column.children[1], isA<Text>());
    });
  });
}
