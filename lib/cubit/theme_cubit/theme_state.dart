part of 'theme_cubit.dart';

class ThemeChanged extends Equatable {
  final ThemeData themeData;
  const ThemeChanged({@required this.themeData});

  @override
  List<Object> get props => [themeData];
}
