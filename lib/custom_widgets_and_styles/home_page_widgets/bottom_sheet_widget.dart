import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamtime/bloc/bang_bloc.dart';
import 'package:islamtime/cubit/after_spotlight_cubit.dart';
import 'package:islamtime/custom_widgets_and_styles/custom_styles_formats.dart';
import 'package:islamtime/custom_widgets_and_styles/home_page_widgets/prayer_tile_widget.dart';
import 'package:islamtime/models/time_cycle.dart';
import 'package:islamtime/pages/setting_page.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class BottomSheetTime extends StatefulWidget {
  final TimeCycle timeCycle;
  const BottomSheetTime({
    Key key,
    @required this.timeCycle,
  }) : super(key: key);

  @override
  _BottomSheetTimeState createState() => _BottomSheetTimeState();
}

class _BottomSheetTimeState extends State<BottomSheetTime> {
  GlobalKey _settingButtonKey = GlobalKey();
  List<TargetFocus> _targets = List();
  bool _firstTimeTutorial = false;
  bool _isLocal = false;
  Future<String> _locationFuture;
  Future<bool> _isLocalFuture;

  @override
  void initState() {
    super.initState();
    _locationFuture = _getLocation();
    _isLocalFuture = _getIsLocal();
    _initTargets();
    SchedulerBinding.instance.addPostFrameCallback((_) => _afterLayout(_));
  }

  Future<String> _getLocation() async {
    final prefs = await SharedPreferences.getInstance();
    return '${prefs.getString('location')}';
  }

  Future<void> clearSp() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<bool> _getIsLocal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(IS_LOCAL_KEY);
  }

  void _initTargets() async {
    _getIsLocal().then((value) {
      _isLocal = value;
      _targets.add(
        TargetFocus(
          identify: 'Target 1',
          keyTarget: _settingButtonKey,
          shape: ShapeLightFocus.Circle,
          contents: [
            ContentTarget(
              align: AlignContent.top,
              child: Text(
                _isLocal
                    ? 'Tap here to get a new location'
                    : 'Tap here to tune prayers times or get a new location',
                style: GoogleFonts.autourOne(fontSize: 30),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _showTutorial() {
    final afterSpotLightCubit = CubitProvider.of<AfterSpotLightCubit>(context);
    TutorialCoachMark(
      context,
      targets: _targets,
      colorShadow: Colors.grey[400],
      textSkip: 'Ok',
      clickSkip: () {},
      finish: () {
        afterSpotLightCubit.changeStatus();
        _persisetTutorialDisplay();
      },
      clickTarget: (_) {
        afterSpotLightCubit.changeStatus();
        _persisetTutorialDisplay();
      },
    )..show();
  }

  void _afterLayout(_) async {
    final prefs = await SharedPreferences.getInstance();
    _firstTimeTutorial = prefs.getBool(IS_FIRST_TIME_KEY);
    Future.delayed(Duration(milliseconds: 700), () {
      if (_firstTimeTutorial == null) {
        _showTutorial();
      }
    });
  }

  Future<void> _persisetTutorialDisplay() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(IS_FIRST_TIME_KEY, true);
  }

  @override
  Widget build(BuildContext context) {
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
                          style: customFarroStyle(),
                        ),
                        Spacer(),
                        Text(
                          state.bang.date,
                          style: customFarroStyle(),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: <Widget>[
                          Spacer(),
                          FutureBuilder<String>(
                            future: _locationFuture,
                            builder: (_, snapshot) {
                              if (!snapshot.hasData) {
                                return CircularProgressIndicator(
                                    backgroundColor: Colors.teal);
                              } else {
                                return Row(
                                  children: <Widget>[
                                    FlatButton(
                                      child: Icon(Icons.clear_all),
                                      onPressed: () => clearSp(),
                                    ),
                                    Text(
                                      'Prayer Times for \n  ${snapshot.data}',
                                      style: GoogleFonts.farro(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        height: 1.4,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    buildSettingChoiceButton(context, bloc),
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.black, height: 20, thickness: 2),
                    _buildPrayerTilesList(state),
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

  Padding buildSettingChoiceButton(BuildContext context, BangBloc bloc) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: FlatButton(
        key: _settingButtonKey,
        child: Icon(
          _isLocal ? Icons.add_location : Icons.settings,
          color: Colors.blue,
          size: 50,
        ),
        onPressed: () => _isLocal
            ? _showLocationConfirmDialog(context, bloc)
            : Get.to(SettingPage()),
      ),
    );
  }

  void _showLocationConfirmDialog(BuildContext context, BangBloc bloc) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.SCALE,
      body: Center(
        child: Wrap(
          direction: Axis.horizontal,
          children: <Widget>[
            Text(
              'you have fixed prayer times for you location, are you sure you want to change your location',
              style:
                  GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              'and get prayer times from the internet?',
              style:
                  GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      btnOkOnPress: () => bloc.add(FetchBang()),
      btnCancelOnPress: () {},
    )..show();
  }
}

Column _buildPrayerTilesList(state) => Column(
      children: <Widget>[
        PrayerTile(
            prayerTime: state.bang.speda, prayerName: 'Fajr', iconTime: 'sun'),
        PrayerTile(
            prayerTime: state.bang.rojHalat,
            prayerName: 'Sunrise',
            iconTime: 'sun'),
        PrayerTile(
            prayerTime: state.bang.nevro, prayerName: 'Zuhr', iconTime: 'sun'),
        PrayerTile(
            prayerTime: state.bang.evar, prayerName: 'Asr', iconTime: 'sun'),
        PrayerTile(
            prayerTime: state.bang.maghrab,
            prayerName: 'Maghrib',
            iconTime: 'moon'),
        PrayerTile(
            prayerTime: state.bang.aesha, prayerName: 'Isha', iconTime: 'moon'),
      ],
    );
