import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/data/models/weather_model.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/entities/current_temperature.dart';
import 'package:weather_app/features/weather/domain/entities/temperature.dart';

void main() {
  group('WeatherModel', () {
    final apiJson = {
      "timezone": "Asia/Ho_Chi_Minh",
      "current": {
        "dt": 1743913928,
        "sunrise": 1743893212,
        "sunset": 1743937413,
        "temp": 306.03,
        "feels_like": 310.69,
        "pressure": 1010,
        "humidity": 55,
        "dew_point": 295.79,
        "uvi": 13.44,
        "clouds": 75,
        "visibility": 10000,
        "wind_speed": 4.63,
        "wind_deg": 110,
        "weather": [
          {
            "id": 803,
            "main": "Clouds",
            "description": "broken clouds",
            "icon": "04d",
          },
        ],
      },
      "daily": [
        {
          "dt": 1743912000,
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
        },
      ],
    };
    test('fromJson should parse JSON correctly', () {
      final weatherModel = WeatherModel.fromJson(apiJson);

      expect(weatherModel.timezone, equals("Asia/Ho_Chi_Minh"));
      expect(
        weatherModel.current.date,
        equals(DateTime.fromMillisecondsSinceEpoch(1743913928 * 1000)),
      );
      expect(weatherModel.daily.length, equals(1));
      expect(
        weatherModel.daily[0].date,
        equals(DateTime.fromMillisecondsSinceEpoch(1743912000 * 1000)),
      );
    });

    test('toJson should convert to JSON correctly', () {
      final weatherModel = WeatherModel.fromJson(apiJson);
      final json = weatherModel.toJson();
      expect(json, isA<Map<String, dynamic>>());
      expect(json['timezone'], equals("Asia/Ho_Chi_Minh"));
      expect(json['current'], isA<Map<String, dynamic>>());
      expect(json['daily'], isA<List<dynamic>>());
    });

    test('toWeatherEntity should convert to Weather entity correctly', () {
      final weatherModel = WeatherModel.fromJson(apiJson);
      final weatherEntity = toWeatherEntity(weatherModel);

      expect(weatherEntity, isA<Weather>());
      expect(weatherEntity.timezone, equals("Asia/Ho_Chi_Minh"));
      expect(weatherEntity.current, isA<CurrentTemperature>());
      expect(
        weatherEntity.current.date,
        equals(DateTime.fromMillisecondsSinceEpoch(1743913928 * 1000)),
      );
      expect(weatherEntity.current.temp, equals(306.03));
      expect(weatherEntity.daily, hasLength(1));
      expect(
        weatherEntity.daily[0].date,
        equals(DateTime.fromMillisecondsSinceEpoch(1743912000 * 1000)),
      );
      expect(weatherEntity.daily[0].temp, isA<Temperature>());
      expect(weatherEntity.daily[0].temp.day, equals(306.06));
      expect(weatherEntity.daily[0].temp.min, equals(298.85));
      expect(weatherEntity.daily[0].temp.max, equals(307.06));
      expect(weatherEntity.daily[0].temp.night, equals(301.6));
      expect(weatherEntity.daily[0].temp.eve, equals(305.12));
      expect(weatherEntity.daily[0].temp.morn, equals(298.85));
    });
  });
}
