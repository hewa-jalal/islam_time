import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';

class Clock extends StatefulWidget {
  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  String _currentTime() => Jiffy().format('h:mm a');

  double seconds;

  void _triggerUpdate() {
    Timer.periodic(
        Duration(seconds: 1),
        (timer) => setState(() {
              seconds = DateTime.now().second / 60;
            }));
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        _currentTime();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.0),
      width: 340,
      height: 340,
      child: Text(
        _currentTime(),
        textAlign: TextAlign.center,
        style: GoogleFonts.bungee(
          fontSize: 54.0,
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
        ),
      ),
    );
  }
}
