import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamtime/bloc/time_cycle/time_cycle_bloc.dart';

import 'package:islamtime/custom_widgets/countdown.dart';
import 'package:islamtime/models/bang.dart';
import 'package:islamtime/models/time_cycle.dart';

import '../custom_widgets/countdown.dart';

class HomePage extends StatefulWidget {
  final Bang bang;

  const HomePage({Key key, @required this.bang}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String isDayOrNight;
  int animation;
  bool once;

  @override
  void initState() {
    super.initState();
    animation = 0;
    once = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocProvider(
          create: (context) => TimeCycleBloc(),
          child: BlocConsumer<TimeCycleBloc, TimeCycleState>(
            listener: (context, state) {
              if (state is TimeCycleLoaded) {
                //this thing keep loaded.
                if (isDay(state.timeCycle)) {
                  animation = 2;
                } else {
                  animation = 1;
                }
              }
            },
            builder: (context, state) {
              // print(state);
              if (state is TimeCycleLoaded) {
                // print(isDay(state.timeCycle));
                return Container(
                  color: hexToColor('#E3E3ED'),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Text(state.timeCycle.timeIs.toString()),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 90),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              '${state.timeCycle.isLastThird} : ${state.timeCycle.timeIs}',
                              style: GoogleFonts.roboto(
                                fontSize: 30.0,
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(2.0, 2.0),
                                      blurRadius: 3.0,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'It\'s ',
                                    style: myCustomTextStyleNonBold,
                                  ),
                                  TextSpan(
                                    text: isDayOrNight,
                                    style: myCustomTextStyle,
                                  ),
                                  TextSpan(
                                    text: ' Time',
                                    style: myCustomTextStyleNonBold,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: CountdownPage(bang: widget.bang),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: CountdownPage(bang: widget.bang),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  bool isDay(TimeCycle timeCycle) {
    if (timeCycle.timeIs == TimeIs.day) {
      // setState(() {
      //   isDayOrNight = 'Day';
      // });
      return true;
    }
    // } else {
    // setState(() {
    //   isDayOrNight = 'Night';
    // });
    return false;
    // }
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}

final myCustomTextStyle = GoogleFonts.roboto(
  fontSize: 40.0,
  textStyle: TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
    shadows: <Shadow>[
      Shadow(
        offset: Offset(2.0, 2.0),
        blurRadius: 3.0,
        color: Color.fromARGB(255, 0, 0, 0),
      ),
    ],
  ),
);

final myCustomTextStyleNonBold = GoogleFonts.roboto(
  fontSize: 40.0,
  textStyle: TextStyle(
    color: Colors.white,
    shadows: <Shadow>[
      Shadow(
        offset: Offset(2.0, 2.0),
        blurRadius: 3.0,
        color: Color.fromARGB(255, 0, 0, 0),
      ),
    ],
  ),
);
