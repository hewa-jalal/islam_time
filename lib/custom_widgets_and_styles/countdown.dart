import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamtime/bloc/time_cycle/time_cycle_bloc.dart';
import 'package:islamtime/models/bang.dart';
import 'package:islamtime/models/time_cycle.dart';

import 'custom_styles_formats.dart';

enum TimeIs { night, day }

class CountdownPage extends StatefulWidget {
  final Bang bang;

  const CountdownPage({Key key, @required this.bang}) : super(key: key);

  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  Bang bang;
  TimeIs _timeIs;
  TimeIs _oldTimeIs;
  bool _isLastThird = false;
  TimeCycleBloc _timeCycleBloc;
  String isDayOrNightText;

  /// Formats a duration to 'mm:ss'.
  static String formatDuration(Duration d) =>
      '${'${d.inHours % 24}'.padLeft(2, '0')}:'
      '${'${d.inMinutes % 60}'.padLeft(2, '0')}:'
      '${'${d.inSeconds % 60}'.padLeft(2, '0')}';

  /// Whether or not the countdown is (visually) running.
  bool get running {
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

  @override
  void initState() {
    super.initState();
    duration = Duration(seconds: 5);
    bang = widget.bang;
    _timeCycleBloc = BlocProvider.of<TimeCycleBloc>(context);
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
    checkDayNight();
    checkLastThird();
    return AutoSizeText(
      formatDuration(remainingTime ?? duration),
      maxLines: 1,
      style: customFarroDynamicStyle(
        fontWeight: FontWeight.bold,
        context: context,
        size: 10.0,
        letterSpacing: 10.0,
      ),
    );
  }

  void checkDayNight() {
    // if it passed maghrab prayer time
    if (DateTime.now().hour >= bang.maghrabDateTime.hour) {
      if (DateTime.now().hour == bang.maghrabDateTime.hour) {
        if (DateTime.now().minute >= bang.maghrabDateTime.minute) {
          // hours and minutes are greater
          _timeIs = TimeIs.night;
          if (_timeIs != _oldTimeIs) {
            _oldTimeIs = _timeIs;
            addToBloc();
            setDurationToNight();
          }
        } else {
          // minutes are still not greater so it's still day time
          _timeIs = TimeIs.day;
          if (_timeIs != _oldTimeIs) {
            _oldTimeIs = _timeIs;
            addToBloc();
            setDurationToDay();
          }
        }
      } else {
        // hours are greater
        _timeIs = TimeIs.night;
        if (_timeIs != _oldTimeIs) {
          _oldTimeIs = _timeIs;
          addToBloc();
          setDurationToNight();
        }
      }
    }
    // to also check if it's before speda prayer time
    else if (DateTime.now().hour <= bang.spedaDateTime.hour) {
      if (DateTime.now().hour == bang.spedaDateTime.hour) {
        if (DateTime.now().minute < bang.spedaDateTime.minute) {
          _timeIs = TimeIs.night;
          if (_timeIs != _oldTimeIs) {
            _oldTimeIs = _timeIs;
            addToBloc();
            setDurationToNight();
          }
        } else {
          _timeIs = TimeIs.day;
          if (_timeIs != _oldTimeIs) {
            _oldTimeIs = _timeIs;
            addToBloc();
            setDurationToDay();
          }
        }
      } else {
        // hours are smaller
        _timeIs = TimeIs.night;
        if (_timeIs != _oldTimeIs) {
          _oldTimeIs = _timeIs;
          addToBloc();
          setDurationToNight();
        }
      }
    } else {
      _timeIs = TimeIs.day;
      if (_timeIs != _oldTimeIs) {
        _oldTimeIs = _timeIs;
        addToBloc();
        setDurationToDay();
      }
    }
  }

  void checkLastThird() {
    // midNightEnd is the beginning of lastThird
    // lastThird == MidNightEnd
    if (DateTime.now().hour >= bang.midNightEnd.hour &&
        TimeOfDay.now().period == DayPeriod.am &&
        _timeIs == TimeIs.night) {
      if (DateTime.now().hour == bang.midNightEnd.hour) {
        if (DateTime.now().minute >= bang.midNightEnd.minute) {
          if (!_isLastThird) {
            _isLastThird = true;
            addToBloc();
          }
        }
      } else {
        // hours are greater
        if (!_isLastThird) {
          _isLastThird = true;
          addToBloc();
        }
      }
    }
  }

  void setDurationToDay() {
    final dayDuration = bang.maghrabDateTime.subtract(
      Duration(
        hours: DateTime.now().hour,
        minutes: DateTime.now().minute,
      ),
    );
    duration = Duration(hours: dayDuration.hour, minutes: dayDuration.minute);
  }

  void setDurationToNight() {
    final nightDuration = bang.spedaDateTime.subtract(
      Duration(
        hours: DateTime.now().hour,
        minutes: DateTime.now().minute,
      ),
    );
    duration =
        Duration(hours: nightDuration.hour, minutes: nightDuration.minute);
  }

  void addToBloc() {
    if (_timeIs == TimeIs.day) {
      // it's day so we need time until Night
      isDayOrNightText = 'Night';
    } else if (_timeIs == TimeIs.night) {
      isDayOrNightText = 'Last Third';
    }
    if (_isLastThird) {
      isDayOrNightText = 'Day';
    }

    _timeCycleBloc.add(
      GetTimeCycle(
        timeCycle: TimeCycle(
          timeIs: _timeIs,
          isLastThird: _isLastThird,
          untilDayOrNight: isDayOrNightText,
        ),
      ),
    );
  }
}
