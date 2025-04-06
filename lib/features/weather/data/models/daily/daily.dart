import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weather_app/core/helpers/datetime_json.dart';
import 'package:weather_app/features/weather/data/models/temperature/temperature.dart';

part 'daily.freezed.dart';
part 'daily.g.dart';

@freezed
abstract class Daily with _$Daily {
  const factory Daily({
    @JsonKey(name: 'dt', fromJson: dateFromJson, toJson: dateToJson)
    required DateTime date,
    @JsonKey(name: 'temp', toJson: temperatureToJson) required Temperature temp,
  }) = _Daily;

  factory Daily.fromJson(Map<String, dynamic> json) => _$DailyFromJson(json);
}

List<Map<String, dynamic>> dailyListToJson(List<Daily> daily) =>
    daily.map((e) => e.toJson()).toList();
