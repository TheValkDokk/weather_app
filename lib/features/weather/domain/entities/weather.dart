import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weather_app/features/weather/domain/entities/current_temperature.dart';
import 'package:weather_app/features/weather/domain/entities/daily.dart';

part 'weather.freezed.dart';

@freezed
abstract class Weather with _$Weather {
  const factory Weather({
    required String timezone,
    required CurrentTemperature current,
    required List<Daily> daily,
  }) = _Weather;
}
