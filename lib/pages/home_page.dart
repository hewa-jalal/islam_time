import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamtime/bloc/bang_bloc.dart';
import 'package:islamtime/bloc/time_cycle/time_cycle_bloc.dart';

import 'package:islamtime/custom_widgets_and_styles/countdown.dart';
import 'package:islamtime/custom_widgets_and_styles/home_page_widgets/bottom_sheet_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  int animation;

  GlobalKey swipeSheetKey = GlobalKey();
  List<TargetFocus> _targets = List();

  double prefsLat;
  double prefsLng;
  int prefsMethodNumber;
  List<int> prefsTuning;
  String locationPrefs;
  bool _sheetEvent = false;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  SolidController _solidController = SolidController();

  @override
  void initState() {
    animation = 0;
    if (widget.showDialog) {
      SchedulerBinding.instance
          .addPostFrameCallback((_) => _showLocationDialog(context));
    }
    _initTargets();
    SchedulerBinding.instance.addPostFrameCallback((_) => _afterLayout(_));
    super.initState();
  }

  void _afterLayout(_) {
    Future.delayed(Duration(milliseconds: 100), () {
      _showTutorial();
    });
  }

  void _showTutorial() {
    TutorialCoachMark(
      context,
      targets: _targets,
      colorShadow: Colors.grey[400],
      textSkip: 'Ok',
      clickSkip: () => _solidController.show(),
      textStyleSkip: TextStyle(
        fontSize: 20,
        color: Colors.black,
      ),
      paddingFocus: -100,
      clickTarget: (target) {},
    )..show();
  }

  void _initTargets() async {
    _targets.add(
      TargetFocus(
        identify: 'Target 1',
        keyTarget: swipeSheetKey,
        shape: ShapeLightFocus.Circle,
        contents: [
          ContentTarget(
            align: AlignContent.top,
            child: Container(
              child: Column(
                children: <Widget>[
                  Text(
                    'Swipe to get more details',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
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
      btnOkOnPress: () {},
    )..show();
  }

  Future<void> _onRefresh(BangBloc bloc) async {
    await _getSharedPrefs();
    bloc.add(FetchBangWithSettings(
        methodNumber: prefsMethodNumber, tuning: prefsTuning));
  }

  @override
  Widget build(BuildContext context) {
    final bangBloc = BlocProvider.of<BangBloc>(context);
    print('isOpenedController ${_solidController.isOpened}');
    return SafeArea(
      child: Scaffold(
        body: SmartRefresher(
          onRefresh: () => _onRefresh(bangBloc),
          controller: _refreshController,
          header: WaterDropHeader(
            waterDropColor: Colors.blue,
          ),
          child: BlocConsumer<TimeCycleBloc, TimeCycleState>(
            listener: (context, state) {
              if (state is TimeCycleLoaded) {
                if (state.timeCycle.timeIs == TimeIs.day) {
                  animation = 2;
                } else {
                  animation = 1;
                }
              }
            },
            builder: (context, state) {
              if (state is TimeCycleLoaded) {
                // final mediaQuerySize = MediaQuery.of(context).size;
                final timeCycle = state.timeCycle;
                return Stack(
                  children: <Widget>[
                    FlareActor(
                      'assets/flare/DayAndNight.flr',
                      animation: (animation == 0)
                          ? 'day_idle'
                          : (animation == 1)
                              ? 'switch_to_night'
                              : (animation == 2)
                                  ? 'switch_to_day'
                                  : 'night_idle',
                      callback: (value) {
                        if (value == 'switch_to_night') {
                          setState(() {
                            animation = 3;
                          });
                        } else {
                          setState(() {
                            animation = 0;
                          });
                        }
                      },
                      fit: BoxFit.fill,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SolidBottomSheet(
                        controller: _solidController,
                        maxHeight: MediaQuery.of(context).size.height / 2,
                        headerBar: StatefulBuilder(
                          builder: (context, sheetSetState) {
                            _solidController.isOpenStream.listen((event) {
                              if (event) {
                                sheetSetState(() =>
                                    _arrowAnimation = 'downArrowAnimation');
                              } else {
                                sheetSetState(
                                    () => _arrowAnimation = 'upArrowAnimation');
                              }
                            });
                            return SizedBox(
                              key: swipeSheetKey,
                              height: 100,
                              child: FlareActor(
                                'assets/flare/arrow_up_down.flr',
                                animation: _arrowAnimation,
                              ),
                            );
                          },
                        ),
                        body: StatefulBuilder(
                          builder: (context, bodySetState) {
                            if (_solidController.isOpened) {
                              bodySetState(() {
                                return BottomSheetTime(timeCycle: timeCycle);
                              });
                            } else {
                              bodySetState(() {
                                return SizedBox();
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    BlocConsumer<BangBloc, BangState>(
                      listener: (context, state) {
                        if (state is BangLoaded) {
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
                                  child: Text(
                                    'Time Remaining Until ${timeCycle.untilDayOrNight}',
                                    style: GoogleFonts.farro(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
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
        ),
      ),
    );
  }
}
