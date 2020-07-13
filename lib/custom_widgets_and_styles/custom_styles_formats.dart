import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:jiffy/jiffy.dart';

void showOfflineDialog(BuildContext context) async {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.WARNING,
    animType: AnimType.SCALE,
    body: Center(
      child: Text(
        'Please make sure you are connecetd to the internet before going into settings',
        style: customFarroPrayerStyle(
          fontWeight: FontWeight.w400,
          context: context,
          size: 20,
        ),
        textAlign: TextAlign.center,
      ),
    ),
    btnOkOnPress: () {},
  )..show();
}

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

TextStyle customFarroPrayerStyle({
  double letterSpacing = 0,
  @required FontWeight fontWeight,
  @required BuildContext context,
  @required double size,
}) {
  final themeData = Theme.of(context);
  return GoogleFonts.farro(
    fontSize: size,
    fontWeight: fontWeight,
    letterSpacing: letterSpacing,
    color: themeData.textTheme.bodyText1.color,
    shadows: themeData.textTheme.bodyText1.color == Colors.white
        ? <Shadow>[
            Shadow(
              offset: Offset(2.0, 2.0),
              blurRadius: 6.0,
              color: Colors.black,
            ),
            Shadow(
              offset: Offset(2.0, 2.0),
              blurRadius: 6.0,
              color: Colors.black,
            ),
          ]
        : null,
  );
}

Color hexToColor(String code) =>
    Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);

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
