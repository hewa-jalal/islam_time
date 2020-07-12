part of 'theme_cubit.dart';

class ThemeStateCu extends Equatable {
  final ThemeData themeData;
  const ThemeStateCu({@required this.themeData});

  @override
  List<Object> get props => [themeData];
}
