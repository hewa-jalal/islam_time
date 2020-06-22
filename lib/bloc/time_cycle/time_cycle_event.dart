part of 'time_cycle_bloc.dart';

abstract class TimeCycleEvent extends Equatable {
  const TimeCycleEvent();
}

class GetTimeCycle extends TimeCycleEvent {
  final TimeCycle timeCycle;

  GetTimeCycle({@required this.timeCycle});

  @override
  List<Object> get props => [timeCycle];
}
