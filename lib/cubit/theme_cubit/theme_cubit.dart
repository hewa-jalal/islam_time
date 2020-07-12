import 'package:cubit/cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:islamtime/ui/global/theme/app_themes.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeStateCu> {
  ThemeCubit()
      : super(
          ThemeStateCu(
            themeData: appThemeData[AppTheme.light],
          ),
        );

  void changeToDark() => emit(
        ThemeStateCu(themeData: appThemeData[AppTheme.dark]),
      );
}
