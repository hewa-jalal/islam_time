import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:islamtime/custom_widgets_and_styles/custom_styles_formats.dart';
import 'package:islamtime/size_config.dart';
import 'location_page.dart';
import 'package:islamtime/i18n/onboarding_i18n.dart';

class OnBoardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IntroViewsFlutter(
      [page1, page2],
      showSkipButton: false,
      onTapDoneButton: () => Get.off(LocationPage()),
      doneText: Text(
        'done'.i18n,
        style: customRobotoStyle(6.0, Colors.white, FontWeight.normal),
      ),
    );
  }

  final page1 = PageViewModel(
    title: Padding(
      padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
      child: Text(
        '''ومن الحقائق الثابتة منذ فترة طويلة أن القارئ سوف يشتت انتباهه من خلال المحتوى المقروء للصفحة عند النظر إلى تخطيطها. إن الهدف من استخدام هو أن يكون توزيع الأحرف طبيعياً بشكل أكبر أو أقل، بدلاً من استخدام "المحتوى هنا"،'''
            .i18n,
        style: customRobotoStyle(6.4, Colors.white, FontWeight.normal),
      ),
    ),
    mainImage: FlutterLogo(),
    // mainImage: Image.asset('assets/images/jew_and_christian.png'),
    body: Text(''),
    pageColor: Colors.blueGrey[800],
    textStyle: GoogleFonts.heebo(fontSize: 26.0),
  );

  final page2 = PageViewModel(
    title: Padding(
      padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1.0),
      child: Text(
        '''For muslims the day starts at maghrib, also keep in mind that in islam the the night precedes the morning. and that's why on the last day of Ramadan, we don't pray Taraweeh, and that’s because the day (new day) has started at maghrib, so Ramadan is over and Eid has begun. this also mean that you may recite Surah Kahf any time after sunset of Thursday.'''
            .i18n,
        style: customRobotoStyle(5.6, Colors.white, FontWeight.normal),
      ),
    ),
    mainImage: Image.asset('assets/images/muslim.png'),
    body: Text(''),
    pageColor: Colors.blueGrey[800],
    textStyle: customRobotoStyle(3.0, Colors.white, FontWeight.normal),
  );
}
