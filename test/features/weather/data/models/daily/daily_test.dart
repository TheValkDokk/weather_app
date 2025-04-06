import 'package:test/test.dart';
import 'package:weather_app/features/weather/data/models/daily/daily.dart';
import 'package:weather_app/features/weather/data/models/temperature/temperature.dart';

void main() {
  group('Daily', () {
    // 2025-04-06 10:26:40
    const int epoch = 1743910000;
    final apiJson = {
      "dt": epoch,
      "sunrise": 1743893212,
      "sunset": 1743937413,
      "moonrise": 1743918600,
      "moonset": 1743876300,
      "moon_phase": 0.29,
      "summary": "There will be partly cloudy today",
      "temp": {
        "day": 306.06,
        "min": 298.85,
        "max": 307.06,
        "night": 301.6,
        "eve": 305.12,
        "morn": 298.85,
      },
      "feels_like": {
        "day": 311.08,
        "night": 303.69,
        "eve": 306.14,
        "morn": 299.67,
      },
      "pressure": 1010,
      "humidity": 56,
      "dew_point": 296.12,
      "wind_speed": 8.62,
      "wind_deg": 168,
      "wind_gust": 12.64,
      "weather": [
        {
          "id": 803,
          "main": "Clouds",
          "description": "broken clouds",
          "icon": "04d",
        },
      ],
      "clouds": 77,
      "pop": 0,
      "uvi": 13.44,
    };
    test('should create a Daily instance from JSON', () {
      final daily = Daily.fromJson(apiJson);

      expect(daily.date, DateTime(2025, 4, 6, 10, 26, 40));
      expect(daily.temp, isA<Temperature>());
      expect(daily.temp.day, 306.06);
      expect(daily.temp.min, 298.85);
      expect(daily.temp.max, 307.06);
      expect(daily.temp.night, 301.6);
      expect(daily.temp.eve, 305.12);
      expect(daily.temp.morn, 298.85);
    });

    test('should convert Daily instance to JSON', () {
      final daily = Daily(
        date: DateTime(2025, 4, 6, 10, 26, 40),
        temp: Temperature(
          day: 306.06,
          min: 298.85,
          max: 307.06,
          night: 301.6,
          eve: 305.12,
          morn: 298.85,
        ),
      );

      final json = daily.toJson();

      expect(json['dt'], apiJson['dt']);
      expect(json['temp'], apiJson['temp']);
    });
  });
}
