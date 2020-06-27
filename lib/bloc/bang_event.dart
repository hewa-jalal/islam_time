part of 'bang_bloc.dart';

abstract class BangEvent extends Equatable {
  const BangEvent();
}

class GetBang extends BangEvent {
  final String cityName;
  final String countryName;

  const GetBang({
    @required this.countryName,
    @required this.cityName,
  });

  @override
  List<Object> get props => [cityName, countryName];
}

class FetchBang extends BangEvent {
  const FetchBang();
  @override
  List<Object> get props => [];
}
