import 'package:flutter/material.dart';

import 'custom_styles_formats.dart';
import '../i18n/setting_page_i18n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      padding: EdgeInsets.symmetric(vertical: 20.0.w, horizontal: 4.0.w),
      child: FlatButton(
        child: Text(
          text.i18n2,
          style: customRobotoStyle(
            3.4,
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
