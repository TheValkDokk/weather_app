import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/data/models/temperature/temperature.dart';

void main() {
  group('Temperature', () {
    test('should create a Temperature', () {
      const temperature = Temperature(
        day: 20.5,
        min: 15.0,
        max: 25.0,
        night: 18.0,
        eve: 22.0,
        morn: 16.0,
      );

      expect(temperature.day, equals(20.5));
      expect(temperature.min, equals(15.0));
      expect(temperature.max, equals(25.0));
      expect(temperature.night, equals(18.0));
      expect(temperature.eve, equals(22.0));
      expect(temperature.morn, equals(16.0));
    });

    test('should convert Temperature to JSON', () {
      const temperature = Temperature(
        day: 20.5,
        min: 15.0,
        max: 25.0,
        night: 18.0,
        eve: 22.0,
        morn: 16.0,
      );

      final json = temperatureToJson(temperature);

      expect(json, isA<Map<String, dynamic>>());
      expect(json['day'], equals(20.5));
      expect(json['min'], equals(15.0));
      expect(json['max'], equals(25.0));
      expect(json['night'], equals(18.0));
      expect(json['eve'], equals(22.0));
      expect(json['morn'], equals(16.0));
    });

    test('should create Temperature from JSON', () {
      final json = {
        'day': 20.5,
        'min': 15.0,
        'max': 25.0,
        'night': 18.0,
        'eve': 22.0,
        'morn': 16.0,
      };

      final temperature = Temperature.fromJson(json);

      expect(temperature.day, equals(20.5));
      expect(temperature.min, equals(15.0));
      expect(temperature.max, equals(25.0));
      expect(temperature.night, equals(18.0));
      expect(temperature.eve, equals(22.0));
      expect(temperature.morn, equals(16.0));
    });
  });
}
