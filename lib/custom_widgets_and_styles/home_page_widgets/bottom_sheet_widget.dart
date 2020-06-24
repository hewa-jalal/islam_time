import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamtime/custom_widgets_and_styles/countdown.dart';
import 'package:islamtime/custom_widgets_and_styles/home_page_widgets/prayer_tile_widget.dart';
import 'package:islamtime/models/bang.dart';
import 'package:islamtime/models/time_cycle.dart';

class BottomSheetTime extends StatelessWidget {
  final Bang bang;
  final TimeCycle timeCycle;
  const BottomSheetTime(
      {Key key, @required this.bang, @required this.timeCycle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.4),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
          child: Column(
            children: <Widget>[
              Text(
                'Time Remaining Until ${timeCycle.untilDayOrNight}',
                style: GoogleFonts.farro(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 22),
                child: CountdownPage(
                  bang: bang,
                ),
              ),
              Divider(color: Colors.black, height: 20, thickness: 2),
              PrayerTile(prayerTime: bang.speda, prayerName: 'Fajr', iconTime: 'sun'),
              PrayerTile(prayerTime: bang.rojHalat, prayerName: 'Sunrise', iconTime: 'sun'),
              PrayerTile(prayerTime: bang.nevro, prayerName: 'Zuhr', iconTime: 'sun'),
              PrayerTile(prayerTime: bang.evar, prayerName: 'Asr', iconTime: 'sun'),
              PrayerTile(prayerTime: bang.maghrab, prayerName: 'Maghrib', iconTime: 'moon'),
              PrayerTile(prayerTime: bang.aesha, prayerName: 'Isha',  iconTime: 'moon'),
            ],
          ),
        ),
      ),
    );
  }
}
