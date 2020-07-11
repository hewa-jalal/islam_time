import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamtime/bloc/bang_bloc.dart';
import 'package:islamtime/bloc/time_cycle/time_cycle_bloc.dart';
import 'package:islamtime/cubit/after_spotlight_cubit.dart';
import 'package:islamtime/cubit/body_status_cubit.dart';

import 'package:islamtime/custom_widgets_and_styles/countdown.dart';
import 'package:islamtime/custom_widgets_and_styles/custom_styles_formats.dart';
import 'package:islamtime/custom_widgets_and_styles/home_page_widgets/bottom_sheet_widget.dart';
import 'package:islamtime/models/time_cycle.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_tooltip/simple_tooltip.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/content_target.dart';
import 'package:tutorial_coach_mark/target_focus.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class HomePage extends StatefulWidget {
  final String userLocation;
  final bool showDialog;

  const HomePage({
    Key key,
    @required this.userLocation,
    this.showDialog = false,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _arrowAnimation = 'upArrowAnimation';
  int _animation;

  GlobalKey _swipeSheetKey = GlobalKey();
  List<TargetFocus> _targets = List();

  double prefsLat;
  double prefsLng;
  int prefsMethodNumber;
  List<int> prefsTuning;
  String locationPrefs;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  SolidController _solidController = SolidController();

  @override
  void initState() {
    _animation = 0;
    if (widget.showDialog) {
      SchedulerBinding.instance
          .addPostFrameCallback((_) => _showLocationDialog(context));
    }
    _initTargets();
    super.initState();
  }

  Future<bool> _getIsLocal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(IS_LOCAL_KEY);
  }

  void _showTutorial() {
    TutorialCoachMark(
      context,
      targets: _targets,
      colorShadow: Colors.grey[400],
      textSkip: 'Ok',
      clickSkip: () {},
      textStyleSkip: TextStyle(
        fontSize: 20,
        color: Colors.black,
      ),
      paddingFocus: -100,
    )..show();
  }

  void _initTargets() async {
    _targets.add(
      TargetFocus(
        identify: 'Target 1',
        keyTarget: _swipeSheetKey,
        shape: ShapeLightFocus.Circle,
        contents: [
          ContentTarget(
            align: AlignContent.top,
            child: Container(
              child: Column(
                children: <Widget>[
                  Text(
                    'Swipe to get more details',
                    style: customTextStyle(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefsLat = prefs.getDouble('lat');
    prefsLng = prefs.getDouble('lng');
    prefsMethodNumber = prefs.getInt('methodNumber');
    locationPrefs = prefs.getString('location');

    List<String> tuningString = prefs.getStringList('tuning');
    List<int> tuningInt = tuningString.map((e) => int.parse(e)).toList();

    prefsTuning = tuningInt;
  }

  void _showLocationDialog(BuildContext context) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.SCALE,
      body: Center(
        child: Text(
          'Your Location is ${widget.userLocation}',
          style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      btnOkOnPress: () => _showTutorial(),
    )..show();
  }

  Future<void> _onRefresh(BangBloc bloc) async {
    await _getSharedPrefs();
    bloc.add(
      FetchBangWithSettings(
          methodNumber: prefsMethodNumber, tuning: prefsTuning),
    );
  }

  Future<void> _persisetTutorialDisplay() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(IS_FIRST_TIME_KEY, true);
  }

  Future<bool> _getTutorialDisplay() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(IS_FIRST_TIME_KEY);
  }

  @override
  Widget build(BuildContext context) {
    final bangBloc = BlocProvider.of<BangBloc>(context);
    final bodyStatusCubit = context.cubit<BodyStatusCubit>();
    final afterSpotLightCubit = CubitProvider.of<AfterSpotLightCubit>(context);
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<bool>(
          future: _getIsLocal(),
          builder: (context, isLocalSnapshot) {
            if (isLocalSnapshot.hasData) {
              return SmartRefresher(
                onRefresh: () => _onRefresh(bangBloc),
                physics: isLocalSnapshot.data
                    ? NeverScrollableScrollPhysics()
                    : null,
                controller: _refreshController,
                header: WaterDropHeader(waterDropColor: Colors.blue),
                child: BlocConsumer<TimeCycleBloc, TimeCycleState>(
                  listener: (context, state) {
                    if (state is TimeCycleLoaded) {
                      if (state.timeCycle.timeIs == TimeIs.day) {
                        _animation = 2;
                      } else {
                        _animation = 1;
                      }
                    }
                  },
                  builder: (context, state) {
                    if (state is TimeCycleLoaded) {
                      // final mediaQuerySize = MediaQuery.of(context).size;
                      final timeCycle = state.timeCycle;
                      return Stack(
                        children: <Widget>[
                          buildFlareActor(),
                          buildBottomSheet(context, bodyStatusCubit, timeCycle),
                          BlocConsumer<BangBloc, BangState>(
                            listener: (context, state) {
                              if (state is BangLoaded) {
                                afterSpotLightCubit.changeStatus();
                                _persisetTutorialDisplay();
                                _refreshController.refreshCompleted();
                              }
                            },
                            builder: (context, state) {
                              if (state is BangLoaded) {
                                return SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 14, bottom: 18),
                                        child: FutureBuilder<bool>(
                                          future: _getTutorialDisplay(),
                                          builder:
                                              (context, isFirstTimeSnapshot) {
                                            return CubitBuilder<
                                                AfterSpotLightCubit, bool>(
                                              builder: (context, state) {
                                                return buildSimpleTooltip(
                                                  isLocalSnapshot,
                                                  isFirstTimeSnapshot,
                                                  state,
                                                  timeCycle,
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: CountdownPage(bang: state.bang),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return SizedBox();
                            },
                          )
                        ],
                      );
                    } else {
                      return BlocBuilder<BangBloc, BangState>(
                        builder: (context, state) {
                          if (state is BangLoaded) {
                            return CountdownPage(bang: state.bang);
                          }
                          return SizedBox();
                        },
                      );
                    }
                  },
                ),
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  FlareActor buildFlareActor() {
    return FlareActor(
      'assets/flare/DayAndNight.flr',
      animation: (_animation == 0)
          ? 'day_idle'
          : (_animation == 1)
              ? 'switch_to_night'
              : (_animation == 2) ? 'switch_to_day' : 'night_idle',
      callback: (value) {
        if (value == 'switch_to_night') {
          setState(() => _animation = 3);
        } else {
          setState(() => _animation = 0);
        }
      },
      fit: BoxFit.fill,
    );
  }

  Align buildBottomSheet(BuildContext context, BodyStatusCubit bodyStatusCubit,
      TimeCycle timeCycle) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SolidBottomSheet(
        controller: _solidController,
        maxHeight: MediaQuery.of(context).size.height / 2,
        headerBar: StatefulBuilder(
          builder: (context, sheetSetState) {
            _solidController.isOpenStream.listen((event) {
              if (event) {
                bodyStatusCubit.changeStatus(true);
                sheetSetState(() => _arrowAnimation = 'downArrowAnimation');
              } else {
                bodyStatusCubit.changeStatus(false);
                sheetSetState(() => _arrowAnimation = 'upArrowAnimation');
              }
            });
            return SizedBox(
              key: _swipeSheetKey,
              height: 100,
              child: FlareActor(
                'assets/flare/arrow_up_down.flr',
                animation: _arrowAnimation,
              ),
            );
          },
        ),
        body: CubitBuilder<BodyStatusCubit, bool>(
          builder: (context, state) =>
              state ? BottomSheetTime(timeCycle: timeCycle) : Container(),
        ),
      ),
    );
  }

  SimpleTooltip buildSimpleTooltip(
      AsyncSnapshot<bool> isLocalSnapshot,
      AsyncSnapshot<bool> isFirstTimeSnapshot,
      bool state,
      TimeCycle timeCycle) {
    print('''isLocalSnapshot => ${isLocalSnapshot.data} 
                isFirstTimeSnapshot => ${isFirstTimeSnapshot.data}
                state => $state''');
    return SimpleTooltip(
      content: Material(
        child: Text(
          'swipe from here to get latest prayer times',
          style: customFarroStyle(),
        ),
      ),
      show: () {
        if (isLocalSnapshot.data) {
          return false;
        }
        if (isFirstTimeSnapshot.data == null && state) {
          return true;
        }
        return false;
      }(),
      hideOnTooltipTap: true,
      tooltipTap: _persisetTutorialDisplay,
      tooltipDirection: TooltipDirection.down,
      child: Text(
        'Time Remaining Until ${timeCycle.untilDayOrNight}',
        style: customFarroStyle(26),
        textAlign: TextAlign.center,
      ),
    );
  }
}
