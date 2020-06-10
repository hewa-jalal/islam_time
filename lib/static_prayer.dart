import 'package:flutter/services.dart' show rootBundle;
import 'package:islamtime/models/user_model.dart';


class Prayer {
  // TODO: add a user model to prayer class

  static getPrayer(UserModel userModel) async {
    String fileString = await rootBundle.loadString(
        'assets/fixed_prayer_time/${userModel.country}/${userModel.city}.txt');

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
    String speda = splitLine[2];
//    String rojHalat = splitLine[3];
    print('speda => $speda');
//    print('rojHalat => $rojHalat');
  }
}
