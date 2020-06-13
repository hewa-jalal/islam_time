import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class Bang extends Equatable {
  final String speda;
  final String rojHalat;
  final String nevro;
  final String evar;
  final String maghrab;
  final String aesha;

  Bang(
      {@required this.speda,
      @required this.rojHalat,
      @required this.nevro,
      @required this.evar,
      @required this.maghrab,
      @required this.aesha});

  @override
  List<Object> get props => [speda, rojHalat, nevro, evar, maghrab, aesha];

  void myParse() {
    var spedaTime = DateFormat('Hm', 'en_US').parse('05:45');
    var maghrabTime = DateFormat('Hm', 'en_US').parse('17:06');

    print('speda $spedaTime');
    print('maghrab $maghrabTime');

    var difference = spedaTime.subtract(
      Duration(hours: maghrabTime.hour, minutes: maghrabTime.minute),
    );

    print('the difference is $difference');
  }
}
