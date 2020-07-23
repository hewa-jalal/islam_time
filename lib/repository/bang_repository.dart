import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:islamtime/custom_widgets_and_styles/custom_styles_formats.dart';
import 'package:islamtime/models/bang.dart';
import 'package:islamtime/repository/bang_api_client.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter/services.dart' show rootBundle;

abstract class BangRepository {
  Future<Bang> fetchBang({
    @required double lat,
    @required double lng,
    @required int month,
    @required int year,
    int method,
    List<int> tuning,
  });
  Future<Bang> getPrayerData(String countryName, String cityName);
}

class LocalBangRepository implements BangRepository {
  final BangApiClient bangApiClient;

  LocalBangRepository({@required this.bangApiClient});

  @override
  Future<Bang> fetchBang({
    @required double lat,
    @required double lng,
    @required int month,
    @required int year,
    int method = 3,
    List<int> tuning = const [0, 0, 0, 0, 0, 0],
  }) async {
    return await bangApiClient.fetchBang(
      lat: lat,
      lng: lng,
      month: month,
      year: year,
      method: method,
      tuning: tuning,
    );
  }

  @override
  Future<Bang> getPrayerData(String countryName, String cityName) async {
    print('countryName $countryName');
    if (countryName.toLowerCase() == 'iraq') {
      final fileString = await rootBundle
          .loadString('assets/fixed_prayer_time/Iraq/$cityName.txt');

      // split the files into individual lines
      final fileLines = fileString.split('\n');

      // get the line that contains the matched date
      final matchedDate =
          fileLines.where((element) => element.contains(getDate())).toString();

      // print('matched data => $matchedDate');

      // split the line that has the data by ','
      final splitLine = matchedDate.split(',');

      final speda = toAmPm(splitLine[2]);
      final rojHalat = toAmPm(splitLine[3]);
      final nevro = toAmPm(splitLine[4]);
      final evar = toAmPm(splitLine[5]);
      final maghrab = toAmPm(splitLine[6]);
      final aesha = toAmPm(splitLine[7]).replaceAll(')', '').trim();
      final dates = getTheDifference(splitLine[1], splitLine[2], splitLine[6]);

      return Bang(
        speda: speda,
        rojHalat: rojHalat,
        nevro: nevro,
        evar: evar,
        maghrab: maghrab,
        aesha: aesha,
        theThird: dates[0],
        lastThird: dates[1],
        midNightStart: dates[1],
        midNightEnd: dates[2],
        dayTime: dates[3],
        maghrabDateTime: dates[4],
        spedaDateTime: dates[5],
        date: todayGeorgean,
        formattedHijriDate: todayHijri,
      );
    } else {
      // so it goes to FetchBang() event
      throw Exception();
    }
  }

  String getDate() {
    final month = Jiffy().month;
    final day = Jiffy().date;

    final formattedMonth = month.toString().padLeft(2, '0');
    final formattedDay = day.toString().padLeft(2, '0');

    return '$formattedMonth-$formattedDay';
  }

  String toAmPm(String time) {
    final splitedTime = time.split(':');
    final hour = int.parse(splitedTime[0].trim());

    final timeOfDay = TimeOfDay(hour: hour, minute: 0);

    if (timeOfDay.hourOfPeriod < 10 && timeOfDay.hourOfPeriod != 00) {
      return '0${timeOfDay.hourOfPeriod}:${splitedTime[1]}';
    }
    if (timeOfDay.hourOfPeriod == 00) return '12:${splitedTime[1]}';

    return '${timeOfDay.hourOfPeriod}:${splitedTime[1]}';
  }

  List<DateTime> getTheDifference(String date, String speda, String maghrab) {
    final splitedDate = date.split('-');
    final month = int.parse(splitedDate[0]);
    final day = int.parse(splitedDate[1]);

    final splitedSpedaTime = speda.split(':');
    final spedaH = int.parse(splitedSpedaTime[0]);
    final spedaM = int.parse(splitedSpedaTime[1]);

    final splitedMaghrabTime = maghrab.split(':');
    final maghrabH = int.parse(splitedMaghrabTime[0]);
    final maghrabM = int.parse(splitedMaghrabTime[1]);

    final spedaBang = DateTime(DateTime.now().year, month, day, spedaH, spedaM);
    final maghrabBang =
        DateTime(DateTime.now().year, month, day, maghrabH, maghrabM);

    // get the full differnce between speda and maghrab bang
    final spedaAndMaghrabDiff = spedaBang.subtract(
      Duration(
        days: maghrabBang.day,
        hours: maghrabBang.hour,
        minutes: maghrabBang.minute,
      ),
    );

    // get a third of the time
    final thirdOfDifferenceSeconds =
        (Duration(hours: spedaAndMaghrabDiff.hour).inSeconds ~/ 3);
    final thirdDuration = Duration(
        seconds: thirdOfDifferenceSeconds,
        minutes: (spedaAndMaghrabDiff.minute ~/ 3));
    final thirdHours = thirdDuration.inHours;
    final thirdMin = thirdDuration.inMinutes % (thirdHours * 60);
    // int midSecond = thirdDuration.inSeconds;

    final midNightStart = maghrabBang.add(
      Duration(
        hours: thirdHours,
        minutes: thirdMin,
      ),
    );

    final midNightEnd = midNightStart.add(
      Duration(
        hours: thirdHours,
        minutes: thirdMin,
      ),
    );

    final lastThird = midNightEnd.add(
      Duration(
        hours: thirdHours,
        minutes: thirdMin,
      ),
    );

    final dayTime = maghrabBang
        .subtract(Duration(hours: spedaBang.hour, minutes: spedaBang.minute));

    print('''##### 
            the difference $thirdHours:$thirdMin
            midNightStart $midNightStart
            midNightEnd $midNightEnd
            lastThird $lastThird
            ####
            ''');

    return [
      DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        thirdHours,
        thirdMin,
      ),
      midNightStart,
      midNightEnd,
      dayTime,
      maghrabBang,
      spedaBang,
    ];
  }
}
