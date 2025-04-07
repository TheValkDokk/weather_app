import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weather_app/features/weather/domain/entities/temperature.dart';

part 'daily.freezed.dart';

@freezed
abstract class Daily with _$Daily {
  const factory Daily({required DateTime date, required Temperature temp}) =
      _Daily;
}
