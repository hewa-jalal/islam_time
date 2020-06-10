import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:islamtime/models/bang_model.dart';
import 'package:islamtime/models/user_model.dart';

class Prayer {
  getPrayer(UserModel userModel) async {
    String fileString = await rootBundle
        .loadString('assets/fixed_prayer_time/${userModel.country}/Duhok.txt');

    // split the files into individual lines
    List<String> fileLines = fileString.split('\n');

    print('current date ${userModel.currentDate}');

    // get the line that contains the matched date
    String matchedDate = fileLines
        .where((element) => element.contains(userModel.currentDate))
        .toString();

    print('matched data  => $matchedDate');

    // split the line that has the data by ','
    List<String> splitLine = matchedDate.split(',');
    print('split Line speda ${splitLine[2]}');
    print('split Line rojHalat ${splitLine[3]}');
    print('split Line nevro ${splitLine[4]}');
    print('split Line evar ${splitLine[5]}');
    print('split Line makhrab ${splitLine[6]}');
    print('split Line aesha ${splitLine[7]}');

    String speda = toAmPm(splitLine[2]);
    String rojHalat = toAmPm(splitLine[3]);
    String nevro = toAmPm(splitLine[4]);
    String evar = toAmPm(splitLine[5]);
    String makhrab = toAmPm(splitLine[6]);
    String aesha = toAmPm(splitLine[7].trim());
    print('speda am/pm $speda');
    print('rojHalat am/pm $rojHalat');
    print('nevro am/pm $nevro');
    print('evar am/pm $evar');
    print('makhrab am/pm $makhrab');
    print('aesha am/pm $aesha');

    BangModel bangModel = BangModel(
      speda,
      rojHalat,
      nevro,
      evar,
      makhrab,
      aesha,
    );

    print('toString bangModel ${bangModel.toString()}');
  }

  String toAmPm(String time) {
    List<String> splitedTime = time.split(':');
    int hour = int.parse(splitedTime[0].trim());

    TimeOfDay timeOfDay = TimeOfDay(hour: hour, minute: 0);

    if (timeOfDay.hourOfPeriod < 10 && timeOfDay.hourOfPeriod != 00)
      return '0${timeOfDay.hourOfPeriod}:${splitedTime[1]}';
    if (timeOfDay.hourOfPeriod == 00) return '12:${splitedTime[1]}';

    return '${timeOfDay.hourOfPeriod}:${splitedTime[1]}';
  }
}
