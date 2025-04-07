import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weather_app/features/weather/domain/entities/temperature.dart';

part 'temperature.freezed.dart';
part 'temperature.g.dart';

@freezed
abstract class TemperatureModel with _$TemperatureModel {
  const factory TemperatureModel({
    required double day,
    required double min,
    required double max,
    required double night,
    required double eve,
    required double morn,
  }) = _TemperatureModel;

  factory TemperatureModel.fromJson(Map<String, dynamic> json) =>
      _$TemperatureModelFromJson(json);
}

Temperature toTemperatureEntity(TemperatureModel model) => Temperature(
  day: model.day,
  min: model.min,
  max: model.max,
  night: model.night,
  eve: model.eve,
  morn: model.morn,
);
Map<String, dynamic> temperatureToJson(TemperatureModel temp) => temp.toJson();
