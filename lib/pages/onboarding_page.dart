import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:islamtime/custom_widgets_and_styles/custom_styles_formats.dart';
import 'package:islamtime/size_config.dart';
import 'location_page.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  @override
  Widget build(BuildContext context) {
    return IntroViewsFlutter(
      [page1, page2],
      showSkipButton: false,
      onTapDoneButton: () => Get.off(LocationPage()),
      doneText: Text(
        'Done',
        style: customRobotoStyle(6, Colors.white, FontWeight.normal),
      ),
    );
  }

  final page1 = PageViewModel(
    title: Wrap(
      direction: Axis.horizontal,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
          child: Text(
            'Most of the Muslim Population, around the Globe are of the opinion that the Muslims day starts at Magrib (sunset) time.',
            style: customRobotoStyle(6, Colors.white, FontWeight.normal),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.safeBlockVertical * 2,
            ),
            child: Text(
              'but this is wrong',
              style: customRobotoStyle(7, Colors.white, FontWeight.normal),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            'The day starts at Magrib for the Jews and sharp midnight for the Christians',
            style: customRobotoStyle(6, Colors.white, FontWeight.normal),
          ),
        )
      ],
    ),
    mainImage: Icon(
      Icons.clear,
      size: SizeConfig.blockSizeHorizontal * 60,
      color: Colors.red[900],
    ),
    body: Text(''),
    pageColor: Colors.red[500],
    textStyle: GoogleFonts.heebo(fontSize: 26),
  );

  final page2 = PageViewModel(
    title: Wrap(
      direction: Axis.horizontal,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
          child: AutoSizeText(
            'as for muslims the day starts at Fajr (sharp sunrise)',
            style: customRobotoStyle(6, Colors.white, FontWeight.normal),
          ),
        ),
        AutoSizeText(
          'This statement could very well be authenticated by the words of Allah(swt) in the holy Quran:',
          style: customRobotoStyle(6, Colors.white, FontWeight.normal),
        ),
        AutoSizeText(
          ' " Guard strictly (all) your prayers, especially the middle prayer and stand before Allah in a devout. " ',
          style: customRobotoStyle(6, Colors.white, FontWeight.normal),
        ),
        Center(
          child: AutoSizeText(
            'Quran- 2:238',
            style: customRobotoStyle(6, Colors.white, FontWeight.normal),
          ),
        ),
      ],
    ),
    mainImage: Icon(
      Icons.check_circle,
      size: SizeConfig.blockSizeHorizontal * 60,
      color: Colors.green[800],
    ),
    body: Text(''),
    pageColor: Colors.teal[900],
    textStyle: customRobotoStyle(3, Colors.white, FontWeight.normal),
  );
}
