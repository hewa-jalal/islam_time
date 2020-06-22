part of 'bang_bloc.dart';

abstract class BangState extends Equatable {
  const BangState();
}

class BangInitial extends BangState {
  const BangInitial();
  @override
  List<Object> get props => [];
}

class BangLoading extends BangState {
  const BangLoading();
  @override
  List<Object> get props => [];
}

class BangLoaded extends BangState {
  final Bang bang; // to display data in the model
  const BangLoaded(this.bang);
  @override
  List<Object> get props => [bang];
}
