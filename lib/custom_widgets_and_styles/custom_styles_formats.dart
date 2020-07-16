import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:jiffy/jiffy.dart';

import '../size_config.dart';

void showOfflineDialog(BuildContext context, [bool isSetting = true]) async {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.WARNING,
    animType: AnimType.SCALE,
    body: Center(
      child: Text(
        isSetting
            ? 'Please make sure you are connecetd to the internet before going into settings'
            : 'Please make sure you are connecetd to the internet so we can get correct prayers for your location',
        style: customRobotoStyle(5),
        textAlign: TextAlign.center,
      ),
    ),
    btnOkOnPress: () {},
  )..show();
}

const String IS_LOCAL_KEY = 'isLocal';
const String IS_FIRST_TIME_KEY = 'isFirstTime';

TextStyle customFarroStyle([double size = 16]) => GoogleFonts.farro(
      fontSize: size,
      fontWeight: FontWeight.bold,
    );

TextStyle customRobotoStyle(
  double size, [
  Color color = Colors.black,
  FontWeight fontWeight = FontWeight.bold,
]) =>
    GoogleFonts.roboto(
      fontSize: SizeConfig.blockSizeHorizontal * size,
      color: color,
      fontWeight: fontWeight,
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

RichText customRichText(String text, BuildContext context) {
  return RichText(
    textAlign: TextAlign.end,
    text: TextSpan(
      children: <TextSpan>[
        TextSpan(
          text: 'Prayer times for',
          style: customFarroPrayerStyle(
              fontWeight: FontWeight.bold, context: context, size: 10),
        ),
        TextSpan(text: '\n'),
        TextSpan(
          text: text,
          style: customFarroPrayerStyle(
              fontWeight: FontWeight.bold, context: context, size: 10),
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
