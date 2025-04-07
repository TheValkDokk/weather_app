import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weather_app/features/weather/data/models/current/current_temperature.dart';
import 'package:weather_app/features/weather/data/models/daily/daily.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';

part 'weather_model.freezed.dart';
part 'weather_model.g.dart';

@freezed
abstract class WeatherModel with _$WeatherModel {
  const factory WeatherModel({
    required String timezone,
    @JsonKey(toJson: currentTemperatureToJson)
    required CurrentTemperatureModel current,
    @JsonKey(toJson: dailyListToJson) required List<DailyModel> daily,
  }) = _WeatherModel;

  factory WeatherModel.fromJson(Map<String, Object?> json) =>
      _$WeatherModelFromJson(json);
}

Weather toWeatherEntity(WeatherModel model) => Weather(
  timezone: model.timezone,
  current: toCurrentTemperatureEntity(model.current),
  daily: model.daily.map(toDailyEntity).toList(),
);
