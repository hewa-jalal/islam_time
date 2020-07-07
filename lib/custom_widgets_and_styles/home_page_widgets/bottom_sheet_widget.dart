import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamtime/bloc/bang_bloc.dart';
import 'package:islamtime/custom_widgets_and_styles/custom_styles_formats.dart';
import 'package:islamtime/custom_widgets_and_styles/home_page_widgets/prayer_tile_widget.dart';
import 'package:islamtime/models/time_cycle.dart';
import 'package:islamtime/pages/setting_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomSheetTime extends StatelessWidget {
  final TimeCycle timeCycle;
  const BottomSheetTime({
    Key key,
    @required this.timeCycle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final bloc = BlocProvider.of<BangBloc>(context);
    return Container(
      color: Colors.grey.withOpacity(0.4),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: BlocBuilder<BangBloc, BangState>(
            builder: (context, state) {
              if (state is BangLoaded) {
                return Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'Hijri ${state.bang.formattedHijriDate}',
                          style: GoogleFonts.farro(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Text(
                          state.bang.date,
                          style: GoogleFonts.farro(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: <Widget>[
                          Spacer(),
                          FutureBuilder<String>(
                            future: getLocation(),
                            builder: (_, snapshot) {
                              if (!snapshot.hasData) {
                                return CircularProgressIndicator(
                                    backgroundColor: Colors.teal);
                              } else {
                                List<String> splitSnapshot =
                                    snapshot.data.split(',');
                                String location =
                                    '${splitSnapshot[0]}, ${splitSnapshot[1]}';
                                bool isLocal = splitSnapshot[2] == 'true';
                                print('BOTTOM SHEET split => $splitSnapshot');
                                print('BOTTOM SHEET islocal => $isLocal');
                                return Row(
                                  children: <Widget>[
                                    Text(
                                      'Prayer Times for \n  $location',
                                      style: GoogleFonts.farro(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        height: 1.4,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: FlatButton(
                                        child: Icon(
                                          isLocal
                                              ? Icons.add_location
                                              : Icons.settings,
                                          color: Colors.blue,
                                          size: 50,
                                        ),
                                        onPressed: () {
                                          isLocal
                                              ? bloc.add(FetchBang())
                                              : Get.to(SettingPage());
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
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
        ),
      ),
    );
  }

  Future<String> getLocation() async {
    final prefs = await SharedPreferences.getInstance();
    return '${prefs.getString('location')},${prefs.getBool(IS_LOCAL_KEY)}';
  }
}
