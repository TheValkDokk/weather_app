import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weather_app/core/helpers/datetime_json.dart';

part 'current_temperature.freezed.dart';
part 'current_temperature.g.dart';

@freezed
abstract class CurrentTemperature with _$CurrentTemperature {
  factory CurrentTemperature({
    @JsonKey(name: 'dt', fromJson: dateFromJson, toJson: dateToJson)
    required DateTime date,
    required double temp,
  }) = _CurrentTemperature;

  factory CurrentTemperature.fromJson(Map<String, dynamic> json) =>
      _$CurrentTemperatureFromJson(json);
}

Map<String, dynamic> currentTemperatureToJson(CurrentTemperature temp) =>
    temp.toJson();
