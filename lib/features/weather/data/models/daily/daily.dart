import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weather_app/core/helpers/datetime_json.dart';
import 'package:weather_app/features/weather/data/models/temperature/temperature.dart';
import 'package:weather_app/features/weather/domain/entities/daily.dart';

part 'daily.freezed.dart';
part 'daily.g.dart';

@freezed
abstract class DailyModel with _$DailyModel {
  const factory DailyModel({
    @JsonKey(name: 'dt', fromJson: dateFromJson, toJson: dateToJson)
    required DateTime date,
    @JsonKey(name: 'temp', toJson: temperatureToJson)
    required TemperatureModel temp,
  }) = _DailyModel;

  factory DailyModel.fromJson(Map<String, dynamic> json) =>
      _$DailyModelFromJson(json);
}

Daily toDailyEntity(DailyModel model) =>
    Daily(date: model.date, temp: toTemperatureEntity(model.temp));

List<Map<String, dynamic>> dailyListToJson(List<DailyModel> daily) =>
    daily.map((e) => e.toJson()).toList();
