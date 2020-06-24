import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:islamtime/custom_widgets_and_styles/countdown.dart';

class TimeCycle extends Equatable {
  final TimeIs timeIs;
  final bool isLastThird;
  final String untilDayOrNight;

  TimeCycle({
    @required this.timeIs,
    @required this.isLastThird,
    @required this.untilDayOrNight,
  });

  @override
  List<Object> get props => [timeIs, isLastThird, untilDayOrNight];
}
