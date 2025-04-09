import 'package:freezed_annotation/freezed_annotation.dart';

part 'current_temperature.freezed.dart';

@freezed
abstract class CurrentTemperature with _$CurrentTemperature {
  const factory CurrentTemperature({
    required DateTime date,
    required double temp,
  }) = _CurrentTemperature;
}
