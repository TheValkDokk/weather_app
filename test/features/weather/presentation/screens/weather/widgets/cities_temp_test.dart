import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/domain/entities/daily.dart';
import 'package:weather_app/features/weather/domain/entities/temperature.dart';
import 'package:weather_app/features/weather/presentation/screens/weather/widgets/cities_temp.dart';
import 'package:weather_app/features/weather/presentation/screens/weather/widgets/city_temp_tile.dart';

void main() {
  group('CitiesTempWidget', () {
    final mockDailies = List.generate(
      6,
      (index) => Daily(
        date: DateTime.now().add(Duration(days: index)),
        temp: Temperature(
          day: 20.0,
          min: 15.0,
          max: 25.0,
          night: 18.0,
          eve: 22.0,
          morn: 16.0,
        ),
      ),
    );

    testWidgets('should display correct number of items (max 4)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CitiesTempWidget(dailies: mockDailies)),
        ),
      );

      // Verify only 4 items are displayed even though we provided 6
      expect(find.byType(CityTempTile), findsNWidgets(4));
    });

    testWidgets('should have correct layout properties', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CitiesTempWidget(dailies: mockDailies)),
        ),
      );

      // Verify container properties
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.color, equals(Colors.white));
      expect(container.padding, equals(const EdgeInsets.only(top: 16)));

      // Verify column is present
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('should handle empty list gracefully', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CitiesTempWidget(dailies: []))),
      );

      // Verify no items are displayed
      expect(find.byType(CityTempTile), findsNothing);
    });

    testWidgets('should display items in correct order', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CitiesTempWidget(dailies: mockDailies)),
        ),
      );

      // Get all CityTempTile widgets
      final tiles = tester.widgetList<CityTempTile>(find.byType(CityTempTile));

      // Verify the order of items matches the input list
      expect(tiles.length, equals(4));
      for (var i = 0; i < 4; i++) {
        expect(tiles.elementAt(i).daily, equals(mockDailies[i]));
      }
    });
  });
}
