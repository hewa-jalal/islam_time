import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:jiffy/jiffy.dart';

const String IS_LOCAL_KEY = 'isLocal';
const String IS_FIRST_TIME_KEY = 'isFirstTime';

TextStyle customTextStyle({bool isBold = false}) => GoogleFonts.roboto(
      fontSize: 40.0,
      textStyle: TextStyle(
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        color: Colors.white,
        shadows: <Shadow>[
          Shadow(
            offset: Offset(2.0, 2.0),
            blurRadius: 10.0,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ],
      ),
    );

TextStyle customFarroStyle([double size = 16]) => GoogleFonts.farro(
      fontSize: size,
      fontWeight: FontWeight.bold,
    );

TextStyle customLatoPrayerStyle({
  double letterSpacing = 0,
  @required FontWeight fontWeight,
  @required BuildContext context,
}) =>
    GoogleFonts.lato(
      fontSize: 30,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      color: Theme.of(context).textTheme.bodyText1.color,
    );

Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

RichText customRichText(String hijriDate) {
  return RichText(
    text: TextSpan(
      children: <TextSpan>[
        TextSpan(
          text: 'Hijri ',
          style: GoogleFonts.farro(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: hijriDate,
          style: customTextStyle(isBold: true),
        ),
      ],
    ),
  );
}

var _tempHijri = HijriCalendar.now();
String todayHijri = _tempHijri.toFormat('MMMM dd yyyy');

final todayGeorgean = Jiffy({
  'year': DateTime.now().year,
  'month': DateTime.now().month,
  'day': DateTime.now().day
}).format('dd MMM yyyy');
