import 'package:flutter/services.dart' show rootBundle;

class ReadFile {
  loadAsset() async {
    String fileString = await rootBundle.loadString('assets/duhok.txt');

    // split the files into individual lines
    List<String> fileLines = fileString.split('\n');

    // get the line that contains the matched date
    String matchedDate =
        fileLines.where((element) => element.contains('05-23')).toString();

    // split the line that has the data by ','
    List<String> splitLine = matchedDate.split(',');
    String speda = splitLine[2];
    String rojHalat = splitLine[3];
    print('speda => $speda');
    print('rojHalat => $rojHalat');
  }
}
