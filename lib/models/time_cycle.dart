import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../custom_widgets/countdown.dart';

class TimeCycle extends Equatable {
  final TimeIs timeIs;
  final bool isLastThird;

  TimeCycle({@required this.timeIs, @required this.isLastThird});

  @override
  List<Object> get props => [timeIs, isLastThird];
}
