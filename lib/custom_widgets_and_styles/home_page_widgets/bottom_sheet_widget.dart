import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamtime/bloc/bang_bloc.dart';
import 'package:islamtime/cubit/after_spotlight_cubit.dart';
import 'package:islamtime/custom_widgets_and_styles/custom_styles_formats.dart';
import 'package:islamtime/custom_widgets_and_styles/home_page_widgets/prayer_tile_widget.dart';
import 'package:islamtime/models/bang.dart';
import 'package:islamtime/models/fetch_settings.dart';
import 'package:islamtime/pages/setting_page.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:islamtime/services/connection_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:jiffy/jiffy.dart';

import 'package:islamtime/i18n/prayer_and_time_names_i18n.dart';

import '../../services/size_config.dart';

class BottomSheetTime extends StatefulWidget {
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

  Future<FetchSetting> _getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final methodNumber = prefs.getInt(METHOD_NUMBER_KEY);
    final tuning = prefs.getStringList(TUNING_KEY);

    return FetchSetting(methodNumber: methodNumber, tuning: tuning);
  }

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
              child: AutoSizeText(
                _isLocal
                    ? 'Tap here to get a new location'.i18n
                    : 'Tap here to tune prayers times or get a new location'
                        .i18n,
                style: GoogleFonts.roboto(
                  fontSize: 90.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      );
    });
  }

  void _showTutorial() {
    final afterSpotLightCubit = BlocProvider.of<AfterSpotLightCubit>(context);
    TutorialCoachMark(
      context,
      targets: _targets,
      colorShadow: Colors.grey[600],
      textSkip: 'Ok'.i18n,
      clickSkip: () {},
      finish: () {
        afterSpotLightCubit.changeStatus();
        _persisetTutorialDisplay();
      },
      clickTarget: (_) {
        afterSpotLightCubit.changeStatus();
        _persisetTutorialDisplay();
      },
      textStyleSkip: customRobotoStyle(4.4),
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
    await prefs.setBool(IS_FIRST_TIME_KEY, true);
  }

  Widget _buildSettingChoiceButton(
    BuildContext context,
    BangBloc bloc,
    bool isNotConnected,
  ) {
    return InkWell(
      key: _settingButtonKey,
      child: Icon(
        _isLocal ? Icons.add_location : Icons.settings,
        color: Colors.blue,
        size: SizeConfig.safeBlockHorizontal * 11.0,
      ),
      onTap: () {
        if (_isLocal) {
          if (isNotConnected) {
            showOfflineDialog(context, OfflineMessage.local, true);
            return;
          }
          _showLocationConfirmDialog(context, bloc);
        } else {
          if (isNotConnected) {
            showOfflineDialog(context, OfflineMessage.setting, true);
            return;
          }
          Get.to(SettingPage());
        }
      },
    );
  }

  void _showLocationConfirmDialog(BuildContext context, BangBloc bloc) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.SCALE,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 1.0),
          child: Text(
            '''you have fixed prayer times for your location, are you sure you want to change your location,and get prayer times from the internet?'''
                .i18n,
            style: customFarroDynamicStyle(
              size: 3.2,
              context: context,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      btnOkOnPress: () => bloc.add(FetchBang()),
      btnCancelOnPress: () {},
      btnOkText: 'Ok'.i18n,
      btnCancelText: 'Cancel'.i18n,
    )..show();
  }

  Widget _buildPrayerTilesColumn(Bang bang) {
    return Column(
      children: <Widget>[
        PrayerTile(
          prayerTime: bang.speda,
          prayerName: 'Fajr'.i18n,
          iconTime: 'sun',
        ),
        PrayerTile(
          prayerTime: bang.rojHalat,
          prayerName: 'Sunrise'.i18n,
          iconTime: 'sun',
        ),
        PrayerTile(
          prayerTime: bang.nevro,
          prayerName: 'Zuhr'.i18n,
          iconTime: 'sun',
        ),
        PrayerTile(
          prayerTime: bang.evar,
          prayerName: 'Asr'.i18n,
          iconTime: 'sun',
        ),
        PrayerTile(
          prayerTime: bang.maghrab,
          prayerName: 'Maghrib'.i18n,
          iconTime: 'moon',
        ),
        PrayerTile(
          prayerTime: bang.aesha,
          prayerName: 'Isha'.i18n,
          iconTime: 'moon',
        ),
        PrayerTile(
          prayerTime: _toAmPm(bang.midNightStart),
          prayerName: 'Midnight'.i18n,
          iconTime: 'moon',
        ),
        PrayerTile(
          prayerTime: _toAmPm(bang.midNightEnd),
          prayerName: 'Last Third'.i18n,
          iconTime: 'moon',
        ),
      ],
    );
  }

  String _toAmPm(DateTime date) {
    final tod = TimeOfDay(hour: date.hour, minute: date.minute);
    if (tod.hourOfPeriod == 00) {
      return '12:${'${tod.minute}'.padLeft(2, '0')}';
    }
    return '${'${tod.hourOfPeriod}'.padLeft(2, '0')}:${'${tod.minute}'.padLeft(2, '0')}';
  }

  Widget _buildIsOutdatedWidget(
    BangBloc bangBloc,
    Bang bang,
    bool isNotConnected,
    bool isLocal,
    String location,
  ) {
    final jif = Jiffy(bang.date, 'dd MMM yyyy');
    if ((jif.date < DateTime.now().day ||
            jif.month < DateTime.now().month ||
            jif.year < DateTime.now().year) &&
        !isLocal) {
      return FutureBuilder<FetchSetting>(
        future: _getSettings(),
        builder: (context, fetchSetting) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.0.w),
            child: GestureDetector(
              child: Icon(Icons.warning, color: Colors.red),
              onTap: () {
                if (isNotConnected) {
                  showOfflineDialog(context, OfflineMessage.basic, false);
                } else {
                  bangBloc.add(
                    FetchBangWithSettings(
                      methodNumber: fetchSetting.data.methodNumber ?? 3,
                      tuning: fetchSetting.data.tuningInt ?? [0, 0, 0, 0, 0, 0],
                    ),
                  );
                }
              },
            ),
          );
        },
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final bangBloc = BlocProvider.of<BangBloc>(context);
    final connectionStatus = Provider.of<ConnectivityStatus>(context);
    final isNotConnected = connectionStatus == ConnectivityStatus.Offline;

    return FutureBuilder(
      future: _locationFuture,
      builder: (context, snapshotLocation) => Container(
        color: Colors.grey.withOpacity(0.4),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            child: BlocBuilder<BangBloc, BangState>(
              builder: (context, state) {
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
                          _buildIsOutdatedWidget(
                            bangBloc,
                            bang,
                            isNotConnected,
                            _isLocal,
                            snapshotLocation.data,
                          ),
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
                        child: Stack(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Prayers Times for'.i18n +
                                      '\n' +
                                      snapshotLocation.data,
                                  style: customFarroDynamicStyle(
                                    fontWeight: FontWeight.bold,
                                    context: context,
                                    size: 4.6,
                                    height: 1.35,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  child: _buildSettingChoiceButton(
                                    context,
                                    bangBloc,
                                    isNotConnected,
                                  ),
                                ),
                              ),
                            )
                          ],
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
      ),
    );
  }
}
