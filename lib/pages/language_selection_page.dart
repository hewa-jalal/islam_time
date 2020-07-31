import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i18n_extension/i18n_widget.dart';

import 'onboarding_page.dart';

class LanguageSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF232124),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 300.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            NeumorphicButton(
              child: Padding(
                padding: EdgeInsets.all(10.0.w),
                child: Text('English', textAlign: TextAlign.center),
              ),
              onPressed: () => _langaugeSelection(context, 'en'),
            ),
            SizedBox(height: 20.0),
            NeumorphicButton(
              child: Text('العربیة', textAlign: TextAlign.center),
              onPressed: () => _langaugeSelection(context, 'ar'),
            ),
          ],
        ),
      ),
    );
  }

  void _langaugeSelection(BuildContext context, String lang) {
    I18n.of(context).locale = Locale(lang);
    Get.to(OnBoardingPage());
  }
}