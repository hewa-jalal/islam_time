import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Bang extends Equatable {
  final String speda;
  final String rojHalat;
  final String nevro;
  final String evar;
  final String maghrab;
  final String aesha;
  final DateTime theThird;
  final DateTime lastThird;
  final DateTime dayTime;
  final DateTime maghrabDateTime;
  final DateTime spedaDateTime;

  Bang({
    @required this.speda,
    @required this.rojHalat,
    @required this.nevro,
    @required this.evar,
    @required this.maghrab,
    @required this.aesha,
    @required this.theThird,
    @required this.lastThird,
    @required this.dayTime,
    @required this.maghrabDateTime,
    @required this.spedaDateTime,
  });

  @override
  List<Object> get props => [
        speda,
        rojHalat,
        nevro,
        evar,
        maghrab,
        aesha,
        theThird,
        lastThird,
        dayTime,
        maghrabDateTime,
      ];

  static Bang fromJson(dynamic json, int day) {
    DateTime testTime =
        _customStringToDate(json['data'][day]['timings']['Isha']);
    return Bang(
      speda: json['data'][day]['timings']['Fajr'],
      rojHalat: json['data'][day]['timings']['Sunrise'],
      nevro: json['data'][day]['timings']['Dhuhr'],
      evar: json['data'][day]['timings']['Asr'],
      maghrab: json['data'][day]['timings']['Maghrib'],
      aesha: json['data'][day]['timings']['Isha'],
      maghrabDateTime: testTime,
      dayTime: DateTime.now(),
      lastThird: DateTime.now(),
      theThird: DateTime.now(),
      spedaDateTime: DateTime.now(),
    );
  }

  static DateTime _customStringToDate(String time) {
    DateTime now = DateTime.now();
    List<String> splitedTime = time.split(':');

    int hour = int.parse(splitedTime[0].trim());
    // to remove the extra () at the end
    String formattedStringPartTwo = splitedTime[1]
        .replaceAll(RegExp(r'(?<=\().*?(?=\))'), '')
        .replaceAll('()', '');

    int minute = int.parse(formattedStringPartTwo);

    DateTime dateTime = DateTime(now.year, now.month, now.day, hour, minute);
    print('custom method $dateTime');

    return dateTime;
  }
}
