import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:i18n_extension/i18n_widget.dart';

import 'onboarding_page.dart';

class LanguageSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          NeumorphicButton(
            style: NeumorphicStyle(
              shape: NeumorphicShape.flat,
            ),
            child: Text('English'),
            onPressed: () => _langaugeSelection(context, 'en'),
          ),
          SizedBox(height: 20.0),
          RaisedButton(
            child: Text('Arabic'),
            onPressed: () => _langaugeSelection(context, 'ar'),
            hoverColor: Colors.blue,
            splashColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  void _langaugeSelection(BuildContext context, String lang) {
    I18n.of(context).locale = Locale(lang);
    Get.to(OnBoardingPage());
  }
}
