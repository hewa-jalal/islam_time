import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'location_page.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  @override
  Widget build(BuildContext context) {
    return IntroViewsFlutter(
      [page, page2],
      showSkipButton: false,
      onTapDoneButton: () => Get.off(LocationPage()),
    );
  }

  final page = PageViewModel(
    title: Wrap(
      direction: Axis.horizontal,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
              'Most of the Muslim Population, around the Globe are of the opinion that the Muslims day starts at Magrib (sunset) time.'),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text('but this is wrong'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
              'The day starts at Magrib for the Jews and sharp midnight for the Christians'),
        )
      ],
    ),
    mainImage: Icon(Icons.clear, size: 200, color: Colors.red[900]),
    body: Text(''),
    pageColor: Colors.red[500],
    textStyle: GoogleFonts.heebo(
      fontSize: 26,
    ),
  );

  final page2 = PageViewModel(
    title: Wrap(
      direction: Axis.horizontal,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: AutoSizeText(
            'as for muslims the day starts at Fajr (sharp sunrise)',
            maxLines: 3,
          ),
        ),
        AutoSizeText(
          'This statement could very well be authenticated by the words of Allah(swt) in the holy Quran:',
          maxLines: 3,
        ),
        AutoSizeText(
          'Guard strictly (all) your prayers, especially the middle prayer and stand before Allah in a devout.',
          maxLines: 3,
        ),
        Center(
          child: AutoSizeText(
            'Quran- 2:238',
            maxLines: 1,
          ),
        ),
      ],
    ),
    mainImage: Icon(
      Icons.check_circle,
      size: 200,
      color: Colors.green[800],
    ),
    body: Text(''),
    pageColor: Colors.teal[900],
    textStyle: GoogleFonts.heebo(fontSize: 26),
  );
}
