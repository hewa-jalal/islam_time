import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:islamtime/cubit/is_rtl_cubit.dart';
import 'package:islamtime/custom_widgets_and_styles/langauge_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:islamtime/custom_widgets_and_styles/custom_styles_formats.dart';
import 'home_page.dart';
import 'onboarding_page.dart';

class LanguageSelectionPage extends StatelessWidget {
  final bool isFromSetting;

  const LanguageSelectionPage({Key key, this.isFromSetting = false})
      : super(key: key);
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
            LanguageButton(
              text: 'English',
              onPressed: () => _langaugeSelection(context, 'en', isFromSetting),
            ),
            SizedBox(height: 20.0),
            LanguageButton(
              text: 'العربیة',
              onPressed: () => _langaugeSelection(context, 'ar', isFromSetting),
            ),
          ],
        ),
      ),
    );
  }

  void _langaugeSelection(
      BuildContext context, String lang, isFromSetting) async {
    final prefs = await SharedPreferences.getInstance();
    final isRtlCubit = BlocProvider.of<IsRtlCubit>(context);
    I18n.of(context).locale = Locale(lang);
    lang == 'ar' ? isRtlCubit.isRtl(true) : isRtlCubit.isRtl(false);
    prefs.setString(LANGUAGE_KEY, lang);
    isFromSetting
        ? Get.off(
            HomePage(
              showDialog: false,
              userLocation: 'from setting',
            ),
          )
        : Get.to(OnBoardingPage());
  }
}
