import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:islamtime/bloc/bang_bloc.dart';
import 'package:islamtime/cubit/after_spotlight_cubit.dart';
import 'package:islamtime/custom_widgets_and_styles/custom_styles_formats.dart';
import 'package:islamtime/custom_widgets_and_styles/home_page_widgets/prayer_tile_widget.dart';
import 'package:islamtime/models/bang.dart';
import 'package:islamtime/models/time_cycle.dart';
import 'package:islamtime/pages/setting_page.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:islamtime/services/connection_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../size_config.dart';

class BottomSheetTime extends StatefulWidget {
  const BottomSheetTime({
    Key key,
    @required this.timeCycle,
  }) : super(key: key);

  final TimeCycle timeCycle;

  @override
  _BottomSheetTimeState createState() => _BottomSheetTimeState();
}

class _BottomSheetTimeState extends State<BottomSheetTime> {
  bool _firstTimeTutorial = false;
  bool _isLocal = false;
  Future<String> _locationFuture;
  final _settingButtonKey = GlobalKey();
  final List<TargetFocus> _targets = [];

  @override
  void initState() {
    super.initState();
    _locationFuture = _getLocation();
    _initTargets();
    SchedulerBinding.instance.addPostFrameCallback((_) => _afterLayout(_));
  }

  TimeCycle get timeCycle => widget.timeCycle;

  Future<String> _getLocation() async {
    final prefs = await SharedPreferences.getInstance();
    return '${prefs.getString('location')}';
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
                style: GoogleFonts.roboto(
                  fontSize: ScreenUtil().setSp(70),
                  fontWeight: FontWeight.bold,
                ),
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

  InkWell _buildSettingChoiceButton(
    BuildContext context,
    BangBloc bloc,
    bool isNotConnected,
  ) {
    return InkWell(
      key: _settingButtonKey,
      child: Icon(
        _isLocal ? Icons.add_location : Icons.settings,
        color: Colors.blue,
        size: SizeConfig.blockSizeHorizontal * 11,
      ),
      onTap: () {
        if (_isLocal) {
          _showLocationConfirmDialog(context, bloc);
        } else if (isNotConnected) {
          showOfflineDialog(context);
        } else {
          Get.to(SettingPage());
        }
      },
    );
  }

  void _showLocationConfirmDialog(BuildContext context, BangBloc bloc) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.SCALE,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 1),
          child: Wrap(
            direction: Axis.horizontal,
            children: <Widget>[
              Text(
                'you have fixed prayer times for you location, are you sure you want to change your location',
                style: customRobotoStyle(5),
                textAlign: TextAlign.center,
              ),
              Text(
                'and get prayer times from the internet?',
                style: customRobotoStyle(5),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      btnOkOnPress: () => bloc.add(FetchBang()),
      btnCancelOnPress: () {},
    )..show();
  }

  Column _buildPrayerTilesColumn(Bang bang) {
    return Column(
      children: <Widget>[
        PrayerTile(
          prayerTime: bang.speda,
          prayerName: 'Fajr',
          iconTime: 'sun',
        ),
        PrayerTile(
          prayerTime: bang.rojHalat,
          prayerName: 'Sunrise',
          iconTime: 'sun',
        ),
        PrayerTile(
          prayerTime: bang.nevro,
          prayerName: 'Zuhr',
          iconTime: 'sun',
        ),
        PrayerTile(
          prayerTime: bang.evar,
          prayerName: 'Asr',
          iconTime: 'sun',
        ),
        PrayerTile(
          prayerTime: bang.maghrab,
          prayerName: 'Maghrib',
          iconTime: 'moon',
        ),
        PrayerTile(
          prayerTime: bang.aesha,
          prayerName: 'Isha',
          iconTime: 'moon',
        ),
        PrayerTile(
          prayerTime: intl.DateFormat('HH:mm').format(bang.midNightStart),
          prayerName: 'Midnight',
          iconTime: 'moon',
        ),
        PrayerTile(
          prayerTime: intl.DateFormat('HH:mm').format(bang.midNightEnd),
          prayerName: 'Last Third',
          iconTime: 'moon',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BangBloc>(context);
    final connectionStatus = Provider.of<ConnectivityStatus>(context);
    final isNotConnected = connectionStatus == ConnectivityStatus.Offline;

    return Container(
      color: Colors.grey.withOpacity(0.4),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: BlocBuilder<BangBloc, BangState>(
            builder: (contt, state) {
              if (state is BangLoaded) {
                final bang = state.bang;
                return Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'Hijri ${bang.formattedHijriDate}',
                          style: customFarroDynamicStyle(
                            size: 4.0,
                            fontWeight: FontWeight.bold,
                            context: context,
                          ),
                        ),
                        Spacer(),
                        Text(
                          bang.date,
                          style: customFarroDynamicStyle(
                            size: 4.0,
                            fontWeight: FontWeight.bold,
                            context: context,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: FutureBuilder<String>(
                        future: _locationFuture,
                        builder: (_, snapshotLocation) {
                          if (!snapshotLocation.hasData) {
                            return CircularProgressIndicator();
                          }
                          return Stack(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Prayers for \n ${snapshotLocation.data}',
                                    textAlign: TextAlign.center,
                                    style: customFarroDynamicStyle(
                                      fontWeight: FontWeight.bold,
                                      context: context,
                                      size: 4.6,
                                    ),
                                  ),
                                ],
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    child: _buildSettingChoiceButton(
                                      context,
                                      bloc,
                                      isNotConnected,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                    Divider(color: Colors.black, height: 20, thickness: 2),
                    _buildPrayerTilesColumn(bang),
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
}
