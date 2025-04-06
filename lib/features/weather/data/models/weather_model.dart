import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weather_app/features/weather/data/models/current/current_temperature.dart';
import 'package:weather_app/features/weather/data/models/daily/daily.dart';

part 'weather_model.freezed.dart';
part 'weather_model.g.dart';

@freezed
abstract class WeatherModel with _$WeatherModel {
  const factory WeatherModel({
    required String timezone,
    @JsonKey(toJson: currentTemperatureToJson)
    required CurrentTemperature current,
    @JsonKey(toJson: dailyListToJson) required List<Daily> daily,
  }) = _WeatherModel;

  factory WeatherModel.fromJson(Map<String, Object?> json) =>
      _$WeatherModelFromJson(json);
}
