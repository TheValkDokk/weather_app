import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/entities/current_temperature.dart';
import 'package:weather_app/features/weather/domain/entities/daily.dart';
import 'package:weather_app/features/weather/domain/entities/temperature.dart';
import 'package:weather_app/features/weather/presentation/screens/weather/widgets/weather_page.dart';
import 'package:weather_app/features/weather/presentation/screens/weather/widgets/cities_temp.dart';

void main() {
  group('WeatherPage', () {
    late Weather mockWeather;

    setUp(() {
      mockWeather = Weather(
        timezone: 'Asia/Ho_Chi_Minh',
        current: CurrentTemperature(date: DateTime.now(), temp: 25.0),
        daily: [
          Daily(
            date: DateTime.now(),
            temp: Temperature(
              day: 25.0,
              min: 20.0,
              max: 30.0,
              night: 22.0,
              eve: 24.0,
              morn: 21.0,
            ),
          ),
        ],
      );
    });

    testWidgets('should display correct temperature and city name', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherPage(weather: mockWeather, cityName: 'Test City'),
          ),
        ),
      );

      // Wait for animation to complete
      await tester.pumpAndSettle();

      expect(find.text('25 C'), findsOneWidget);
      expect(find.text('Test City'), findsOneWidget);
    });

    testWidgets('should have correct layout structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherPage(weather: mockWeather, cityName: 'Test City'),
          ),
        ),
      );

      // Wait for animation to complete
      await tester.pumpAndSettle();

      // Verify main column structure
      final columnFinder = find.byKey(const Key('weather_page_column'));
      expect(columnFinder, findsOneWidget);

      // Verify SizedBox heights
      final sizedBoxFinder = find.byType(SizedBox);
      expect(sizedBoxFinder, findsNWidgets(3));

      // Verify Expanded widget for daily temperatures
      final expandedFinder = find.byType(Expanded);
      expect(expandedFinder, findsOneWidget);
    });

    testWidgets('should display daily temperatures', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherPage(weather: mockWeather, cityName: 'Test City'),
          ),
        ),
      );

      // Wait for animation to complete
      await tester.pumpAndSettle();

      // Verify daily temperature widget is present
      expect(find.byType(CitiesTempWidget), findsOneWidget);
    });
  });
}
