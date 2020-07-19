import 'package:flutter/material.dart';
import '../../size_config.dart';
import '../custom_styles_formats.dart';

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
      color: Colors.amber[100],
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        leading: Image.asset('assets/images/$iconTime.png'),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 4),
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
    );
  }
}
