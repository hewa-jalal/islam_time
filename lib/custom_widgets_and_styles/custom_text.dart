import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamtime/cubit/is_rtl_cubit.dart';
import 'package:islamtime/custom_widgets_and_styles/custom_styles_formats.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;

  const CustomText(
    this.text, {
    @required this.size,
    this.color,
    this.fontWeight = FontWeight.bold,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final isRtlCubit = BlocProvider.of<IsRtlCubit>(context);
    return Text(
      text,
      style: customRobotoStyle(size, color, fontWeight),
      textDirection: isRtlCubit.state ? TextDirection.rtl : TextDirection.ltr,
      textAlign: textAlign,
    );
  }
}
