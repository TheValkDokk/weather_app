import 'package:freezed_annotation/freezed_annotation.dart';

part 'temperature.freezed.dart';

@freezed
abstract class Temperature with _$Temperature {
  const factory Temperature({
    required double day,
    required double min,
    required double max,
    required double night,
    required double eve,
    required double morn,
  }) = _Temperature;
}
