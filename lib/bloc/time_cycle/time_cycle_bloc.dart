import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:islamtime/models/time_cycle.dart';

part 'time_cycle_event.dart';
part 'time_cycle_state.dart';

class TimeCycleBloc extends Bloc<TimeCycleEvent, TimeCycleState> {
  @override
  TimeCycleState get initialState => TimeCycleInitial();

  @override
  Stream<TimeCycleState> mapEventToState(
    TimeCycleEvent event,
  ) async* {
    if (event is GetTimeCycle) {
      yield TimeCycleLoading();
      if (event is GetTimeCycle) {
        TimeCycle timeCycle = TimeCycle(
          isLastThird: event.timeCycle.isLastThird,
          timeIs: event.timeCycle.timeIs,
          untilDayOrNight: event.timeCycle.untilDayOrNight,
        );
        yield TimeCycleLoaded(timeCycle);
      }
    }
  }
}
