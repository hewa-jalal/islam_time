import 'package:date_format/date_format.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:islamtime/custom_widgets_and_styles/home_page_widgets/home_page_widgets.dart';
import 'package:jiffy/jiffy.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bang.g.dart';

@JsonSerializable()
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
  final String date;
  final DateTime hijriDate;
  final String formattedHijriDate;

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
    @required this.date,
    @required this.hijriDate,
    @required this.formattedHijriDate,
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

  factory Bang.fromJson(Map<String, dynamic> json) => _$BangFromJson(json);

  Map<String, dynamic> toJson() => _$BangToJson(this);

  static Bang fromJsonRequest(dynamic json, int day) {
    String speda = _toAmPm(json['data'][day]['timings']['Fajr']);
    String rojHalat = _toAmPm(json['data'][day]['timings']['Sunrise']);
    String nevro = _toAmPm(json['data'][day]['timings']['Dhuhr']);
    String evar = _toAmPm(json['data'][day]['timings']['Asr']);
    String maghrab = _toAmPm(json['data'][day]['timings']['Maghrib']);
    String aesha = _toAmPm(json['data'][day]['timings']['Isha']);

    String date = json['data'][day]['date']['readable'];
    String hijriDate = json['data'][day]['date']['hijri']['date'];

    List<String> hijriDateSplit = hijriDate.split('-');
    DateTime hijriDateTime = DateTime(int.parse(hijriDateSplit[2]),
        int.parse(hijriDateSplit[1]), int.parse(hijriDateSplit[0]));

    

    DateTime spedaDateTime =
        _customStringToDate(json['data'][day]['timings']['Fajr']);
    DateTime maghrabDateTime =
        _customStringToDate(json['data'][day]['timings']['Maghrib']);

    List<DateTime> dates = getTheDifference(spedaDateTime, maghrabDateTime);
    print('dates $dates');

    return Bang(
      speda: speda,
      rojHalat: rojHalat,
      nevro: nevro,
      evar: evar,
      maghrab: maghrab,
      aesha: aesha,
      maghrabDateTime: dates[3],
      dayTime: dates[2],
      lastThird: dates[1],
      theThird: dates[0],
      spedaDateTime: dates[4],
      date: date,
      hijriDate: hijriDateTime,
      formattedHijriDate: todayHijri,
    );
  }

  static DateTime _customStringToDate(String time, [bool isSpeda = false]) {
    DateTime now = DateTime.now();
    List<String> splitedTime = time.split(':');

    int hour = int.parse(splitedTime[0].trim());
    // to remove the extra stuff at the end
    String formattedStringPartTwo = splitedTime[1]
        .replaceAll(RegExp(r'(?<=\().*?(?=\))'), '')
        .replaceAll('()', '');

    int minute = int.parse(formattedStringPartTwo);

    DateTime dateTime = DateTime(now.year, now.month, now.day, hour, minute);

    return dateTime;
  }

  static String _toAmPm(String time) {
    String formattedString =
        time.replaceAll(RegExp(r'(?<=\().*?(?=\))'), '').replaceAll('()', '');
    List<String> splitString = formattedString.split(':');
    int hour = int.parse(splitString[0]);
    int minute = int.parse(splitString[1]);

    TimeOfDay tod = TimeOfDay(hour: hour, minute: minute);
    if (tod.hourOfPeriod == 0) {
      return '12:${tod.minute.toString().padLeft(2, '0')}';
    }

    return '${tod.hourOfPeriod.toString().padLeft(2, '0')}:${tod.minute.toString().padLeft(2, '0')}';
  }

  static List<DateTime> getTheDifference(
      DateTime spedaBang, DateTime maghrabBang) {
    // get the full differnce between speda and maghrab bang
    DateTime spedaAndMaghrabDiff = spedaBang.subtract(
      Duration(
        days: maghrabBang.day,
        hours: maghrabBang.hour,
        minutes: maghrabBang.minute,
      ),
    );

    // ** get a third of the time
    int thirdOfDifferenceSeconds =
        (Duration(hours: spedaAndMaghrabDiff.hour).inSeconds ~/ 3);
    Duration thirdDuration = Duration(
        seconds: thirdOfDifferenceSeconds,
        minutes: (spedaAndMaghrabDiff.minute ~/ 3));
    int thirdHours = thirdDuration.inHours;
    int thirdMin = thirdDuration.inMinutes % (thirdHours * 60);
    // int midSecond = thirdDuration.inSeconds;

    DateTime midNightStart = maghrabBang.add(
      Duration(
        hours: thirdHours,
        minutes: thirdMin,
      ),
    );

    DateTime midNightEnd = midNightStart.add(
      Duration(
        hours: thirdHours,
        minutes: thirdMin,
      ),
    );

    DateTime lastThird = midNightEnd.add(
      Duration(
        hours: thirdHours,
        minutes: thirdMin,
      ),
    );

    print('the last Third $lastThird');

    DateTime dayTime = maghrabBang.subtract(
      Duration(hours: spedaBang.hour, minutes: spedaBang.minute),
    );

    return [
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
          thirdHours, thirdMin),
      midNightEnd,
      dayTime,
      maghrabBang,
      spedaBang,
    ];
  }
}
