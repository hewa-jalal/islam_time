import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamtime/bloc/time_cycle/time_cycle_bloc.dart';

import 'package:islamtime/custom_widgets_and_styles/countdown.dart';
import 'package:islamtime/custom_widgets_and_styles/home_page_widgets/bottom_sheet_widget.dart';
import 'package:islamtime/models/bang.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  final Bang bang;

  const HomePage({Key key, @required this.bang}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int animation;

  Bang get bang => widget.bang;

  @override
  void initState() {
    super.initState();
    animation = 0;
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
            print('maghrab is a date not a string => ${bang.maghrabDateTime}');
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
                          maxHeight: MediaQuery.of(context).size.height / 2,
                          headerBar: SizedBox(
                            height: 100,
                            child: FlareActor(
                              'assets/flare/arrow_up_down.flr',
                              animation: 'upArrowAnimation',
                            ),
                          ),
                          body: BottomSheetTime(
                            bang: bang,
                            timeCycle: timeCycle,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return CountdownPage(bang: bang);
            }
          },
        ),
      ),
    );
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
