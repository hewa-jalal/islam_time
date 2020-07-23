import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lottie/lottie.dart';

import '../size_config.dart';

enum OfflineMessage {
  location,
  setting,
  local,
}

void showOfflineDialog(
  BuildContext context,
  OfflineMessage offlineMessage,
) async {
  AwesomeDialog(
    context: context,
    customHeader: Lottie.asset('assets/images/no_internet.json'),
    animType: AnimType.SCALE,
    body: Center(
      child: Text(
        () {
          switch (offlineMessage) {
            case OfflineMessage.location:
              return 'Please make sure you are connected to the internet so we can get correct prayers times for your location';
            case OfflineMessage.setting:
              return 'Please make sure you are connected to the internet before going into settings';
            case OfflineMessage.local:
              return 'for the option to change location and get prayers from the internet you must be online';
            default:
              return '';
          }
        }(),
        style: customFarroDynamicStyle(
          size: 5.0,
          context: context,
        ),
        textAlign: TextAlign.center,
      ),
    ),
    btnOkOnPress: () {},
  )..show();
}

const String IS_LOCAL_KEY = 'isLocal';
const String IS_FIRST_TIME_KEY = 'isFirstTime';

TextStyle customRobotoStyle(
  double size, [
  Color color = Colors.black,
  FontWeight fontWeight = FontWeight.bold,
  bool haveShadow = false,
]) =>
    GoogleFonts.roboto(
      fontSize: SizeConfig.blockSizeHorizontal * size,
      color: color,
      fontWeight: fontWeight,
      shadows: haveShadow
          ? <Shadow>[
              Shadow(
                offset: Offset(10.0, 10.0),
                blurRadius: 3.0,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              Shadow(
                offset: Offset(10.0, 10.0),
                blurRadius: 8.0,
                color: Color.fromARGB(125, 0, 0, 255),
              ),
            ]
          : null,
    );

TextStyle customFarroDynamicStyle({
  double letterSpacing = 0,
  FontWeight fontWeight = FontWeight.normal,
  @required BuildContext context,
  @required double size,
}) {
  final themeData = Theme.of(context);
  return GoogleFonts.farro(
    fontSize: SizeConfig.safeBlockHorizontal * size,
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

// RichText customRichText(String text, BuildContext context) {
//   return RichText(
//     textAlign: TextAlign.end,
//     text: TextSpan(
//       children: <TextSpan>[
//         TextSpan(
//           text: 'Prayer times for',
//           style: customFarroDynamicStyle(
//               fontWeight: FontWeight.bold, context: context, size: 10),
//         ),
//         TextSpan(text: '\n'),
//         TextSpan(
//           text: text,
//           style: customFarroDynamicStyle(
//               fontWeight: FontWeight.bold, context: context, size: 10),
//         ),
//       ],
//     ),
//   );
// }

var _tempHijri = HijriCalendar.now();
String todayHijri = _tempHijri.toFormat('MMMM dd yyyy');

final todayGeorgean = Jiffy({
  'year': DateTime.now().year,
  'month': DateTime.now().month,
  'day': DateTime.now().day
}).format('dd MMM yyyy');
