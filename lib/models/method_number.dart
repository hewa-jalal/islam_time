import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamtime/custom_widgets_and_styles/custom_styles_formats.dart';

class MethodNumberTile extends StatelessWidget {
  final bool isEnd;
  final String prayerName;
  final Function onChange;
  const MethodNumberTile({
    Key key,
    this.isEnd = false,
    @required this.prayerName,
    @required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey[700],
      child: ListTile(
        dense: true,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(prayerName, style: customTextStyle()),
        ),
        trailing: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Colors.amber[500],
              ),
            ),
            width: 80,
            child: TextField(
              maxLength: 2,
              maxLengthEnforced: true,
              keyboardType: TextInputType.number,
              textInputAction:
                  isEnd ? TextInputAction.done : TextInputAction.next,
              decoration:
                  InputDecoration(border: InputBorder.none, counterText: ''),
              onSubmitted: (_) {
                isEnd
                    ? FocusScope.of(context).unfocus()
                    : FocusScope.of(context).nextFocus();
              },
              style: GoogleFonts.roboto(
                fontSize: 30,
                color: Colors.white,
              ),
              onChanged: onChange,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class MethodNumber {
  int number;

  static final Map<int, String> map = {
    0: "Shia Ithna-Ansari",
    1: "University of Islamic Sciences, Karachi",
    2: "Islamic Society of North America",
    3: "Muslim World League",
    4: "Umm Al-Qura University, Makkah",
    5: "Egyptian General Authority of Survey",
    6: "Institute of Geophysics, University of Tehran",
    7: "Gulf Region",
    8: "Kuwait",
    9: "Qatar",
    10: "Majlis Ugama Islam Singapura, Singapore",
    11: "Union Organization islamic de France",
    12: "Diyanet İşleri Başkanlığı, Turkey",
    13: "Spiritual Administration of Muslims of Russia",
  };

  String get numberString {
    return (map.containsKey(number) ? map[number] : "unknown");
  }

  MethodNumber(this.number);

  String toString() {
    return ("${map[number]}");
  }

  static List<MethodNumber> get list {
    return (map.keys.map((num) {
      return (MethodNumber(num));
    })).toList();
  }
}
