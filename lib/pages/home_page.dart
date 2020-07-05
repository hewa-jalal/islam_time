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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  final String userLocation;
  final bool showDialog;

  const HomePage({
    Key key,
    @required this.userLocation,
    @required this.showDialog,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _arrowAnimation = 'upArrowAnimation';
  int animation;

  SolidController _solidController = SolidController();

  void getLocationPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String strPrefs = prefs.getString('location');
    print('strPrefs HomePage $strPrefs');
  }

  @override
  void initState() {
    super.initState();
    getLocationPrefs();
    animation = 0;
    if (widget.showDialog) {
      SchedulerBinding.instance
          .addPostFrameCallback((_) => showLocationDialog(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<TimeCycleBloc, TimeCycleState>(
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
              return Container(
                color: hexToColor('#E3E3ED'),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Stack(
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
                      // Align(alignment: Alignment.topCenter, child: Clock()),
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
                                  sheetSetState(() =>
                                      _arrowAnimation = 'upArrowAnimation');
                                }
                              });
                              return SizedBox(
                                height: 100,
                                child: FlareActor(
                                  'assets/flare/arrow_up_down.flr',
                                  animation: _arrowAnimation,
                                ),
                              );
                            },
                          ),
                          body: BottomSheetTime(timeCycle: timeCycle),
                        ),
                      ),
                      BlocBuilder<BangBloc, BangState>(
                        builder: (context, state) {
                          if (state is BangLoaded) {
                            return Column(
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
                            );
                          }
                          return CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          );
                        },
                      )
                    ],
                  ),
                ),
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
    );
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  void showLocationDialog(BuildContext context) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.SCALE,
      body: Center(
        child: Text(
          'Your Location is ${widget.userLocation}',
          style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      btnCancelOnPress: () {},
      btnOkOnPress: () {},
      btnCancelColor: Colors.blue,
      btnCancelText: 'Not Corrcet?',
    )..show();
  }
}
