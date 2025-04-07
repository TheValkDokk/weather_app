import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weather_app/core/helpers/datetime_json.dart';
import 'package:weather_app/features/weather/domain/entities/current_temperature.dart';

part 'current_temperature.freezed.dart';
part 'current_temperature.g.dart';

@freezed
abstract class CurrentTemperatureModel with _$CurrentTemperatureModel {
  factory CurrentTemperatureModel({
    @JsonKey(name: 'dt', fromJson: dateFromJson, toJson: dateToJson)
    required DateTime date,
    required double temp,
  }) = _CurrentTemperatureModel;

  factory CurrentTemperatureModel.fromJson(Map<String, dynamic> json) =>
      _$CurrentTemperatureModelFromJson(json);
}

CurrentTemperature toCurrentTemperatureEntity(CurrentTemperatureModel model) =>
    CurrentTemperature(date: model.date, temp: model.temp);

Map<String, dynamic> currentTemperatureToJson(CurrentTemperatureModel temp) =>
    temp.toJson();
