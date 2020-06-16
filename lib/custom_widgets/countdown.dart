import 'dart:async';

import 'package:flutter/material.dart';
import '../bang.dart';

class CountdownPage extends StatefulWidget {
  final Bang bang;

  const CountdownPage({Key key, @required this.bang}) : super(key: key);
  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  Timer _secondTimer;

  bool isMidNight;

  @override
  void initState() {
    super.initState();

    isMidNight = bang.midNightStart == DateTime.now() ||
        bang.midNightStart.isBefore(bang.midNightEnd);

    print('new way =====>>>>> $isMidNight');

    _secondTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });

    duration = Duration(
      hours: bang.theThird.hour,
      minutes: bang.theThird.minute,
    );
    endTime = DateTime.now().add(duration);

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
    // print('inside tick $remainingTime');
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
  Widget build(BuildContext context) {
    // print('inside build method');
    // print('isMidNight => $isMidNight');
    // _shouldStartCountdown();
    return Padding(
      child: Column(
        children: <Widget>[
          Text(
            formatDuration(
              remainingTime ?? duration,
            ),
            style: TextStyle(
              fontSize: 60,
              fontFamily: "monospace",
              color: Colors.red,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '${bang.midNightStart}',
            style: TextStyle(
              fontSize: 60,
              fontFamily: "monospace",
              color: Colors.red,
              fontWeight: FontWeight.w700, // w700 = bold
            ),
          ),
        ],
      ),
      padding: EdgeInsets.only(bottom: 50),
    );
  }
}
