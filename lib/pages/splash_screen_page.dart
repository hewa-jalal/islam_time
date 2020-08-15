import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamtime/custom_widgets_and_styles/custom_styles_formats.dart';
import 'package:islamtime/services/size_config.dart';

import 'home_page.dart';
import 'onboarding_page.dart';

class SplashScreenPage extends StatelessWidget {
  final String locationPrefs;

  const SplashScreenPage({
    Key key,
    @required this.locationPrefs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    _goToHomePage();
    return Material(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TyperAnimatedTextKit(
              text: ['Islam Time'],
              textStyle: customRobotoStyle(10.0),
            ),
            Image.asset('assets/images/no_bg_launcher_icon.png'),
          ],
        ),
      ),
    );
  }

  void _goToHomePage() {
    Future.delayed(Duration(seconds: 3), () {
      locationPrefs != null
          ? Get.off(HomePage(showDialog: false, userLocation: locationPrefs))
          : Get.off(
              Builder(
                builder: (context) {
                  SizeConfig().init(context);
                  return OnBoardingPage();
                },
              ),
            );
    });
  }
}
