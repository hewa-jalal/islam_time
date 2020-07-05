import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamtime/bloc/bang_bloc.dart';
import 'package:islamtime/custom_widgets_and_styles/home_page_widgets/prayer_tile_widget.dart';
import 'package:islamtime/models/time_cycle.dart';
import 'package:islamtime/pages/setting_page.dart';
import 'package:jiffy/jiffy.dart';

import '../countdown.dart';
import 'home_page_widgets.dart';

class BottomSheetTime extends StatefulWidget {
  final TimeCycle timeCycle;
  const BottomSheetTime({Key key, @required this.timeCycle}) : super(key: key);

  @override
  _BottomSheetTimeState createState() => _BottomSheetTimeState();
}

class _BottomSheetTimeState extends State<BottomSheetTime> {
  bool addedDay = false;

  TimeCycle get timeCycle => widget.timeCycle;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.4),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Text(
                      'Prayer Times for ',
                      style: GoogleFonts.farro(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      child: Icon(
                        Icons.settings,
                        color: Colors.blue,
                        size: 50,
                      ),
                      onPressed: () => Get.to(SettingPage()),
                    ),
                  ),
                ],
              ),
              BlocBuilder<BangBloc, BangState>(
                builder: (context, state) {
                  if (state is BangLoaded) {
                    if (Jiffy().isSameOrAfter(state.bang.maghrabDateTime)) {
                      addedDay = true;
                    } else {
                      addedDay = false;
                    }
                    return Column(
                      children: <Widget>[
                        Text(
                          state.bang.date,
                          style: customTextStyle(),
                        ),
                        Text(
                          addedDay
                              ? 'Hijri \n ${state.bang.formattedAddedHijriTime}'
                              : 'Hijri \n ${state.bang.formattedHijriDate}',
                          style: customTextStyle(),
                        ),
                        Divider(color: Colors.black, height: 20, thickness: 2),
                        PrayerTile(
                            prayerTime: state.bang.speda,
                            prayerName: 'Fajr',
                            iconTime: 'sun'),
                        PrayerTile(
                            prayerTime: state.bang.rojHalat,
                            prayerName: 'Sunrise',
                            iconTime: 'sun'),
                        PrayerTile(
                            prayerTime: state.bang.nevro,
                            prayerName: 'Zuhr',
                            iconTime: 'sun'),
                        PrayerTile(
                            prayerTime: state.bang.evar,
                            prayerName: 'Asr',
                            iconTime: 'sun'),
                        PrayerTile(
                            prayerTime: state.bang.maghrab,
                            prayerName: 'Maghrib',
                            iconTime: 'moon'),
                        PrayerTile(
                            prayerTime: state.bang.aesha,
                            prayerName: 'Isha',
                            iconTime: 'moon'),
                      ],
                    );
                  } else {
                    return CircularProgressIndicator(
                      backgroundColor: Colors.purple,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
