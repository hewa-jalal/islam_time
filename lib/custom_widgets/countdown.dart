import 'dart:async';

import 'package:flutter/material.dart';
import '../bang.dart';

enum TimeIs { nightStart, midNightStart, midNightEnd, lastThird }

class CountdownPage extends StatefulWidget {
  final Bang bang;

  const CountdownPage({Key key, @required this.bang}) : super(key: key);

  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  Bang get bang => widget.bang;
  TimeIs _timeIs;

  /// Formats a duration to 'mm:ss'.
  static String formatDuration(Duration d) =>
      '${'${d.inHours % 24}'.padLeft(2, '0')}:'
      '${'${d.inMinutes % 60}'.padLeft(2, '0')}:'
      '${'${d.inSeconds % 60}'.padLeft(2, '0')}';

  /// Whether or not the countdown is (visually) running.
  bool get running {
    print('inside running');
    return (lastTick.isAfter(startTime) ||
            lastTick.isAtSameMomentAs(startTime)) &&
        lastTick.isBefore(endTime);
  }

  /// How long the countdown should be.
  var duration;

  /// When the countdown should start.
  DateTime startTime;

  /// When the running timer will hit zero.
  DateTime get endTime => startTime.add(duration);

  /// A timer that periodically fires to update the UI.
  Timer timer;

  /// The last time tick was called.
  DateTime lastTick;

  /// The remaining time before the countdown stops.
  Duration get remainingTime => endTime.difference(lastTick);

  /// How long until the next tick should fire, i.e. the next time the seconds
  /// remaining will change.
  Duration get nextTick {
    if (true) {
      return remainingTime - Duration(seconds: remainingTime.inSeconds);
    } else {
      return startTime.difference(lastTick);
    }
  }

  /// Updates the UI and schedules the next tick.
  void tick() {
    lastTick = DateTime.now();
    setState(() {});
    if (remainingTime > Duration.zero) {
      timer = Timer(nextTick, tick);
    } else {
      // Countdown is finished!
      restartCountdown();
    }
  }

  /// Starts [timer], if not running already.
  void startTimer() {
    if (timer != null) return;
    tick();
  }

  /// Stops [timer], if not stopped already.
  void stopTimer() {
    if (timer == null) return;
    timer.cancel();
    timer = null;
  }

  /// Restarts the countdown.
  void restartCountdown() {
    stopTimer();
    nextStartTime();
    startTimer();
    setState(() {});
  }

  /// Calculates the next start and end times.
  void nextStartTime() {
    var time = DateTime.now();
    startTime = time;
  }

  void initState() {
    super.initState();
    duration = Duration(seconds: 5);
    nextStartTime();
    restartCountdown();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (TickerMode.of(context)) {
      startTimer();
    } else {
      stopTimer();
    }
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeEnum(bang.midNightStart, TimeIs.midNightStart);
    timeEnum(bang.midNightEnd, TimeIs.midNightEnd);
    timeEnum(bang.lastThird, TimeIs.lastThird);
    print('timeIs => $_timeIs');
    // setDuration();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('Countdown'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed('settings');
            },
          )
        ],
      ),
      body: SizedBox.expand(
        child: Align(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (true) ...[
                Padding(
                  child: Text(
                    formatDuration(remainingTime ?? duration),
                    style: TextStyle(
                      fontSize: 60,
                      fontFamily: "monospace",
                    ),
                  ),
                  padding: EdgeInsets.only(bottom: 50),
                ),
                RaisedButton(
                  child: Text("Restart"),
                  onPressed: restartCountdown,
                  color: Colors.red,
                ),
              ] else
                Padding(
                  child: Text(
                    "Starts at ${startTime.hour}:${startTime.minute}",
                    style: TextStyle(
                      fontSize: 60,
                      fontFamily: "monospace",
                    ),
                  ),
                  padding: EdgeInsets.only(bottom: 50),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void setDuration(DateTime date) {
    final tempBang = date.subtract(
      Duration(
        hours: DateTime.now().hour,
        minutes: DateTime.now().minute,
      ),
    );
    duration = Duration(hours: tempBang.hour, minutes: tempBang.minute);
  }

  void timeEnum(DateTime date, TimeIs timeIs) {
    print('date => $date');
    print('now => ${DateTime.now()}');
    print('midNightStart => ${bang.midNightStart}');
    print('midNightEnd => ${bang.midNightEnd}');
    print('lastThird => ${bang.lastThird}');
    if (lastTick.hour > date.hour) {
      switch (timeIs) {
        case TimeIs.midNightStart:
          _timeIs = TimeIs.midNightStart;
          setDuration(bang.midNightEnd);
          break;
        case TimeIs.midNightEnd:
          print('in midNightEnd');
          _timeIs = TimeIs.midNightEnd;
          setDuration(bang.lastThird);
          break;
        case TimeIs.lastThird:
          print('in lastThird');
          _timeIs = TimeIs.lastThird;
          setDuration(bang.dayTime);
          break;
        case TimeIs.nightStart:
          // just break because we alrady handled this case above
          break;
      }
    } else if (lastTick.hour == date.hour) {
      if (lastTick.minute >= date.minute) {
        switch (timeIs) {
          case TimeIs.midNightStart:
            _timeIs = TimeIs.midNightStart;
            setDuration(bang.midNightEnd);
            break;
          case TimeIs.midNightEnd:
            _timeIs = TimeIs.midNightEnd;
            setDuration(bang.lastThird);
            break;
          case TimeIs.lastThird:
            _timeIs = TimeIs.lastThird;
            setDuration(bang.dayTime);
            break;
          case TimeIs.nightStart:
            // just break because we alrady handled this case above
            break;
        }
      }
    }
  }
}
