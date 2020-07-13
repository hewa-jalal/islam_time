import 'package:cubit/cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:islamtime/ui/global/theme/app_themes.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeChanged> {
  ThemeCubit()
      : super(
          ThemeChanged(
            themeData: appThemeData[AppTheme.light],
          ),
        );

  void changeTheme(AppTheme appTheme) => emit(
        ThemeChanged(themeData: appThemeData[appTheme]),
      );

  @override
  void onTransition(Transition<ThemeChanged> transition) {
    print('onTransition $transition');
    super.onTransition(transition);
  }
}
