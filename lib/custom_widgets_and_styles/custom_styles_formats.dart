import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:islamtime/pages/athkar_page.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lottie/lottie.dart';
import 'package:islamtime/i18n/dialogs_i18n.dart';

import '../size_config.dart';

const String IS_LOCAL_KEY = 'isLocal';
const String IS_FIRST_TIME_KEY = 'isFirstTime';
const String LANGUAGE_KEY = 'language';

enum OfflineMessage {
  location,
  setting,
  local,
}

void showOfflineDialog(
  BuildContext context,
  OfflineMessage offlineMessage,
  bool showLastThirdDeeds,
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
              return 'Please make sure you are connected to the internet so we can get correct prayers times for your location'
                  .i18n;
            case OfflineMessage.setting:
              return 'Please make sure you are connected to the internet before going into settings'
                  .i18n;
            case OfflineMessage.local:
              return 'For the option to change location and get prayers from the internet you must be online'
                  .i18n;
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
    btnOkText: 'Ok'.i18n,
    btnCancelText: showLastThirdDeeds ? 'Last third deeds'.i18n : null,
    btnCancelOnPress: showLastThirdDeeds ? () => Get.to(AthkarPage()) : null,
    btnCancelColor: Colors.blue[800],
  )..show();
}

TextStyle customRobotoStyle(
  double size, [
  Color color = Colors.black,
  FontWeight fontWeight = FontWeight.bold,
]) {
  return GoogleFonts.roboto(
    fontSize: SizeConfig.safeBlockHorizontal * size,
    color: color,
    fontWeight: fontWeight,
  );
}

TextStyle customFarroDynamicStyle({
  double letterSpacing = 0.0,
  FontWeight fontWeight = FontWeight.normal,
  double height = 1.0,
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
              blurRadius: 4.0,
              color: Colors.black,
            ),
            Shadow(
              offset: Offset(2.0, 2.0),
              blurRadius: 4.0,
              color: Colors.black,
            ),
          ]
        : null,
    height: height,
  );
}

Color hexToColor(String code) =>
    Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);

final _tempHijri = HijriCalendar.now();
final todayHijri = _tempHijri.toFormat('MMMM dd yyyy');

final todayGeorgean = Jiffy({
  'year': DateTime.now().year,
  'month': DateTime.now().month,
  'day': DateTime.now().day
}).format('dd MMM yyyy');
