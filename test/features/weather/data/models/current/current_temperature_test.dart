import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/data/models/current/current_temperature.dart';
import 'package:weather_app/features/weather/domain/entities/current_temperature.dart';

void main() {
  group('CurrentTemperature', () {
    // 2025-04-06 10:26:40
    const int epoch = 1743910000;
    final expectedDate = DateTime.fromMillisecondsSinceEpoch(epoch * 1000);
    const double temp = 20.5;
    test('should create a CurrentTemperature instance', () {
      final json = {'dt': epoch, 'temp': temp};

      final currentTemperature = CurrentTemperatureModel.fromJson(json);

      expect(currentTemperature.date, equals(expectedDate));
      expect(currentTemperature.temp, equals(temp));
    });

    test('should convert to a JSON', () {
      final currentTemperature = CurrentTemperatureModel(
        date: expectedDate,
        temp: temp,
      );

      final json = currentTemperature.toJson();

      expect(json['dt'], equals(epoch));
      expect(json['temp'], equals(20.5));
    });

    test('equality should work correctly', () {
      final temperature1 = CurrentTemperatureModel(
        date: expectedDate,
        temp: temp,
      );

      final temperature2 = CurrentTemperatureModel(
        date: expectedDate,
        temp: temp,
      );

      final temperature3 = CurrentTemperatureModel(
        date: DateTime.fromMillisecondsSinceEpoch((epoch + 1) * 1000),
        temp: 21.0,
      );

      expect(temperature1, equals(temperature2));
      expect(temperature1, isNot(equals(temperature3)));
    });

    test(
      'toCurrentTemperatureEntity should convert to CurrentTemperature entity correctly',
      () {
        final model = CurrentTemperatureModel(date: expectedDate, temp: temp);

        final entity = toCurrentTemperatureEntity(model);

        expect(entity, isA<CurrentTemperature>());
        expect(entity.date, equals(expectedDate));
        expect(entity.temp, equals(temp));
      },
    );
  });
}
