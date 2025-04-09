import 'package:flutter/material.dart';
import 'package:weather_app/core/helpers/weekday.dart';
import 'package:weather_app/core/theme/textstyle.dart';
import 'package:weather_app/features/weather/domain/entities/daily.dart';

class CityTempTile extends StatelessWidget {
  const CityTempTile({super.key, required this.daily});

  final Daily daily;

  @override
  Widget build(BuildContext context) {
    final averageTemp = ((daily.temp.max + daily.temp.min) / 2).toInt();
    return Container(
      height: 80,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xffF4F4F4))),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(daily.date.engWeekday, style: tileCityNameTextStyle),
            Text('$averageTemp C', style: tileTempTextStyle),
          ],
        ),
      ),
    );
  }
}
