part of 'time_cycle_bloc.dart';

abstract class TimeCycleState extends Equatable {
  const TimeCycleState();
}

class TimeCycleInitial extends TimeCycleState {
  @override
  List<Object> get props => [];
}

class TimeCycleLoading extends TimeCycleState {
  @override
  List<Object> get props => [];
}

class TimeCycleLoaded extends TimeCycleState {
  final TimeCycle timeCycle;
  const TimeCycleLoaded(this.timeCycle);
  @override
  List<Object> get props => [timeCycle];
}
