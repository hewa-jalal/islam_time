import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamtime/cubit/is_rtl_cubit.dart';
import 'package:islamtime/custom_widgets_and_styles/custom_styles_formats.dart';
import 'package:islamtime/custom_widgets_and_styles/custom_text.dart';
import 'package:islamtime/i18n/setting_page_i18n.dart';

import '../size_config.dart';

class MethodNumberTile extends StatelessWidget {
  const MethodNumberTile({
    Key key,
    this.isEnd = false,
    @required this.prayerName,
    @required this.onChange,
    @required this.prayerTime,
  }) : super(key: key);

  final bool isEnd;
  final Function onChange;
  final String prayerName;
  final String prayerTime;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IsRtlCubit, bool>(
      builder: (context, state) => Card(
        color: Colors.blueGrey[700],
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 2.2),
          child: Row(
            textDirection: state ? TextDirection.rtl : TextDirection.ltr,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomText(
                    prayerName,
                    size: 5.0,
                    color: Colors.white,
                  ),
                  CustomText(
                    prayerTime,
                    size: 5.0,
                    color: Colors.white,
                  ),
                ],
              ),
              Spacer(),
              Container(
                width: SizeConfig.safeBlockHorizontal * 12,
                height: SizeConfig.safeBlockHorizontal * 12,
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
                  decoration: InputDecoration(
                      border: InputBorder.none, counterText: ''),
                  onSubmitted: (_) {
                    isEnd
                        ? FocusScope.of(context).unfocus()
                        : FocusScope.of(context).nextFocus();
                  },
                  style: customRobotoStyle(5.6, Colors.white),
                  onChanged: onChange,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MethodNumber {
  MethodNumber(this.number);

  static Map<int, String> map = {
    0: 'Shia Ithna-Ansari'.i18n2,
    1: 'University of Islamic Sciences, Karachi'.i18n2,
    2: 'Islamic Society of North America'.i18n2,
    3: 'Muslim World League'.i18n2,
    4: 'Umm Al-Qura University, Makkah'.i18n2,
    5: 'Egyptian General Authority of Survey'.i18n2,
    6: 'Institute of Geophysics, University of Tehran'.i18n2,
    7: 'Gulf Region'.i18n2,
    8: 'Kuwait'.i18n2,
    9: 'Qatar'.i18n2,
    10: 'Majlis Ugama Islam Singapura, Singapore'.i18n2,
    11: 'Union Organization islamic de France'.i18n2,
    12: 'Diyanet İşleri Başkanlığı, Turkey'.i18n2,
    13: 'Spiritual Administration of Muslims of Russia'.i18n2,
  };

  int number;

  @override
  String toString() {
    return ('${map[number]}');
  }

  String get numberString {
    return (map.containsKey(number) ? map[number] : 'unknown');
  }

  static List<MethodNumber> get list {
    return (map.keys.map((num) {
      return (MethodNumber(num));
    })).toList();
  }
}
