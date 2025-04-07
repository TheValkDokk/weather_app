import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/core/theme/pallet.dart';

const fontThin = FontWeight.w100;
const fontBlack = FontWeight.w900;
const fontRegular = FontWeight.w400;

final currentTempTextStyle = GoogleFonts.roboto(
  fontSize: 96,
  fontWeight: fontBlack,
  color: mainTempColor,
);

final currentCityNameTextStyle = GoogleFonts.roboto(
  color: mainCityColor,
  fontSize: 36,
  fontWeight: fontThin,
);

final errorTextStyle = GoogleFonts.roboto(
  fontSize: 54,
  color: errorTextColor,
  fontWeight: fontThin,
);

final tileCityNameTextStyle = GoogleFonts.roboto(
  color: cityColor,
  fontSize: 16,
  fontWeight: fontRegular,
);
final tileTempTextStyle = GoogleFonts.roboto(
  color: tempColor,
  fontSize: 16,
  fontWeight: fontRegular,
);
