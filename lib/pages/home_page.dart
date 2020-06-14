import 'dart:async';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamtime/bang.dart';
import 'package:islamtime/custom_widgets/clock.dart';

class HomePage extends StatelessWidget {
  final Bang bang;

  const HomePage({Key key, @required this.bang}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('build inside HomePage ${bang.myParse}');
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: hexToColor('#E3E3ED'),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Stack(
              children: <Widget>[
                FlareActor(
                  'assets/flare/DayAndNight.flr',
                  animation: 'night_idle',
                  fit: BoxFit.fill,
                ),
                Align(alignment: Alignment.topCenter, child: Clock()),
                Padding(
                  padding: const EdgeInsets.only(top: 90),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'Time Left until midnight',
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
                Align(
                  alignment: Alignment.center,
                  child: CountdownPage(bang: bang),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}

class CountdownPage extends StatefulWidget {
  final Bang bang;

  const CountdownPage({Key key, @required this.bang}) : super(key: key);
  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  @override
  void initState() {
    super.initState();
    print('midnightBang ${bang.midNight}');
    duration = Duration(
      hours: int.parse(bang.midNight[0]),
      minutes: int.parse(bang.midNight[1]),
    );
    startCountdown();
  }

  Bang get bang => widget.bang;

  /// Formats a duration to 'mm:ss'.
  static String formatDuration(Duration d) =>
      '${'${d.inHours}'.padLeft(2, '0')}:'
      '${'${d.inMinutes % 60}'.padLeft(2, '0')}:'
      '${'${d.inSeconds % 60}'.padLeft(2, '0')}';

  /// Whether or not the widget is counting down.
  var running = false;

  /// How long the countdown should be.
  var duration;

  // final formatDuration()

  DateTime endTime;

  /// A timer that periodically fires to update the UI.
  Timer timer;

  /// The remaining time before the countdown stops.
  Duration remainingTime;

  /// How long until the next tick should fire, i.e. the next time the seconds
  /// remaining will change.
  Duration get nextTick =>
      remainingTime - Duration(seconds: remainingTime.inSeconds);

  /// Updates the UI and schedules the next tick.
  void tick() {
    setState(() {});
    remainingTime = endTime.difference(DateTime.now());
    if (remainingTime > Duration.zero) {
      timer = Timer(nextTick, tick);
    } else {
      // Countdown is finished!
      stopCountdown();
    }
  }

  /// Starts [timer], if not running already.
  void startTimer() {
    if (timer != null || !running) return;
    tick();
  }

  /// Stops [timer], if not stopped already.
  void stopTimer() {
    if (timer == null) return;
    timer.cancel();
    timer = null;
  }

  /// Starts the countdown
  void startCountdown() {
    running = true;
    endTime = DateTime.now().add(duration);
    startTimer();
  }

  /// Stops the countdown
  void stopCountdown() {
    running = false;
    stopTimer();
    remainingTime = duration;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Padding(
        child: Text(
          formatDuration(
            remainingTime ?? duration,
          ),
          style: TextStyle(
            fontSize: 60,
            fontFamily: "monospace",
            color: Colors.red,
            fontWeight: FontWeight.w700, // w700 = bold
          ),
        ),
        padding: EdgeInsets.only(bottom: 50),
      );
}
