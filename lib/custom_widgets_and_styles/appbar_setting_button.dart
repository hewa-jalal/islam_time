import 'package:flutter/material.dart';

import '../size_config.dart';
import 'custom_styles_formats.dart';
import '../i18n/setting_page_i18n.dart';

class AppBarSettingButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const AppBarSettingButton({
    Key key,
    this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 0.4),
      child: FlatButton(
        child: Text(
          text.i18n2,
          style: customRobotoStyle(
            2.4,
            Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        onPressed: onPressed,
        color: Colors.blue[900],
      ),
    );
  }
}
