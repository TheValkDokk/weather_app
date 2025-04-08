import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/theme/textstyle.dart';
import 'package:weather_app/features/weather/domain/entities/daily.dart';
import 'package:weather_app/features/weather/domain/entities/temperature.dart';
import 'package:weather_app/features/weather/presentation/screens/weather/widgets/city_temp_tile.dart';

void main() {
  group('CityTempTile', () {
    final mockDaily = Daily(
      date: DateTime(2025, 04, 08), // Tuesday
      temp: Temperature(
        day: 20.0,
        min: 15.0,
        max: 25.0,
        night: 18.0,
        eve: 22.0,
        morn: 16.0,
      ),
    );

    testWidgets('should display correct weekday and temperature', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CityTempTile(daily: mockDaily))),
      );

      // Verify weekday text
      expect(find.text('Tuesday'), findsOneWidget);
      final weekdayText = tester.widget<Text>(find.text('Tuesday'));
      expect(weekdayText.style, equals(tileCityNameTextStyle));

      // Verify temperature text
      expect(find.text('20 C'), findsOneWidget);
      final tempText = tester.widget<Text>(find.text('20 C'));
      expect(tempText.style, equals(tileTempTextStyle));
    });

    testWidgets('should have correct layout properties', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CityTempTile(daily: mockDaily))),
      );

      // Verify container height
      final container = tester.widget<Container>(find.byType(Container));
      expect(
        container.constraints,
        equals(const BoxConstraints(minHeight: 80, maxHeight: 80)),
      );

      // Verify border color
      final decoration = container.decoration as BoxDecoration;
      final border = decoration.border as Border;
      expect(border.bottom.color, equals(const Color(0xffF4F4F4)));

      // Verify padding - last for inner padding
      final padding = tester.widget<Padding>(find.byType(Padding).last);
      expect(
        padding.padding,
        equals(const EdgeInsets.symmetric(horizontal: 16)),
      );

      // Verify row alignment
      final row = tester.widget<Row>(find.byType(Row));
      expect(row.mainAxisAlignment, equals(MainAxisAlignment.spaceBetween));
    });

    testWidgets('should calculate average temperature correctly', (
      WidgetTester tester,
    ) async {
      // Test case with different min/max values
      final testDaily = Daily(
        date: DateTime.now(),
        temp: Temperature(
          day: 0.0,
          min: 10.0,
          max: 30.0,
          night: 0.0,
          eve: 0.0,
          morn: 0.0,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CityTempTile(daily: testDaily))),
      );

      // Verify average temperature calculation ((10 + 30) / 2 = 20)
      expect(find.text('20 C'), findsOneWidget);
    });
  });
}
