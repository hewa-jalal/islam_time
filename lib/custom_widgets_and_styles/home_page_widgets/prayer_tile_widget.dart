import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamtime/cubit/is_rtl_cubit.dart';
import '../custom_styles_formats.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrayerTile extends StatelessWidget {
  final String prayerTime;
  final String prayerName;
  final String iconTime;
  const PrayerTile({
    Key key,
    @required this.prayerTime,
    @required this.prayerName,
    @required this.iconTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xffF7F7B6),
      child: BlocBuilder<IsRtlCubit, bool>(
        builder: (context, state) => SizedBox(
          height: 150.h,
          child: Row(
            textDirection: state ? TextDirection.rtl : TextDirection.ltr,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0.w),
                child: Image.asset('assets/images/$iconTime.png'),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30.0.w, right: 30.w),
                child: Text(
                  prayerName,
                  textAlign: TextAlign.center,
                  style: customFarroDynamicStyle(
                    fontWeight: FontWeight.w600,
                    context: context,
                    size: 6.0,
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    prayerTime,
                    style: customFarroDynamicStyle(
                      fontWeight: FontWeight.w600,
                      context: context,
                      size: 6.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
