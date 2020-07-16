import 'package:flutter/material.dart';
import 'package:islamtime/custom_widgets_and_styles/custom_styles_formats.dart';

import '../size_config.dart';

class MethodNumberTile extends StatelessWidget {
  final bool isEnd;
  final String prayerName;
  final String prayerTime;
  final Function onChange;
  const MethodNumberTile({
    Key key,
    this.isEnd = false,
    @required this.prayerName,
    @required this.onChange,
    @required this.prayerTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey[700],
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 2.2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  prayerName,
                  style: customRobotoStyle(5.5, Colors.white),
                ),
                Text(
                  prayerTime,
                  style: customRobotoStyle(5.5, Colors.white),
                ),
              ],
            ),
            Spacer(),
            Container(
              width: SizeConfig.safeBlockHorizontal * 14,
              height: SizeConfig.safeBlockHorizontal * 14,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.amber[500],
                  width: 2,
                ),
              ),
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
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
                style: customRobotoStyle(6.4, Colors.white),
                onChanged: onChange,
                textAlign: TextAlign.center,
              ),
            )
          ],
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

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    this.thumbnail,
  });

  final Widget thumbnail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: thumbnail,
          ),
          const Icon(
            Icons.more_vert,
            size: 16.0,
          ),
        ],
      ),
    );
  }
}
