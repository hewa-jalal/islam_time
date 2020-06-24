import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamtime/bloc/time_cycle/time_cycle_bloc.dart';

TextStyle customTextStyle({bool isBold = false}) => GoogleFonts.roboto(
      fontSize: 40.0,
      textStyle: TextStyle(
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        color: Colors.white,
        shadows: <Shadow>[
          Shadow(
            offset: Offset(2.0, 2.0),
            blurRadius: 10.0,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ],
      ),
    );

RichText customRichText(TimeCycleLoaded state) {
  return RichText(
    text: TextSpan(
      children: <TextSpan>[
        TextSpan(
          text: 'It\'s ',
          style: customTextStyle(),
        ),
        TextSpan(
          text: state.timeCycle.untilDayOrNight,
          style: customTextStyle(isBold: true),
        ),
        TextSpan(
          text: ' Time',
          style: customTextStyle(),
        )
      ],
    ),
  );
}
