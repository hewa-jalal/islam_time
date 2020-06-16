import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Bang extends Equatable {
  final String speda;
  final String rojHalat;
  final String nevro;
  final String evar;
  final String maghrab;
  final String aesha;
  final String differenceH;
  final String differenceM;
  final String midNightStart;
  final String midNightEnd;
  final String lastThird;

  Bang({
    @required this.speda,
    @required this.rojHalat,
    @required this.nevro,
    @required this.evar,
    @required this.maghrab,
    @required this.aesha,
    @required this.differenceH,
    @required this.differenceM,
    @required this.midNightStart,
    @required this.midNightEnd,
    @required this.lastThird,
  });

  @override
  List<Object> get props => [
        speda,
        rojHalat,
        nevro,
        evar,
        maghrab,
        aesha,
        differenceH,
        differenceM,
        midNightStart,
        midNightEnd,
        lastThird,
      ];
}
