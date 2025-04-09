import 'package:flutter/material.dart';
import 'package:weather_app/core/theme/textstyle.dart';

class MainTempWidget extends StatelessWidget {
  const MainTempWidget({super.key, required this.temp, required this.cityName});

  final String temp;
  final String cityName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$temp°', style: currentTempTextStyle),
        Text(cityName, style: currentCityNameTextStyle),
      ],
    );
  }
}
