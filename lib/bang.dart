import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Bang extends Equatable {
  final String speda;
  final String rojHalat;
  final String nevro;
  final String evar;
  final String maghrab;
  final String aesha;
  final List<String> midNight;

  Bang({
    @required this.speda,
    @required this.rojHalat,
    @required this.nevro,
    @required this.evar,
    @required this.maghrab,
    @required this.aesha,
    @required this.midNight,
  });

  @override
  List<Object> get props =>
      [speda, rojHalat, nevro, evar, maghrab, aesha, midNight];
}
