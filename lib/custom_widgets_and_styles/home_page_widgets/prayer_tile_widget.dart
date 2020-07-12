import 'package:flutter/material.dart';

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                prayerName,
                textAlign: TextAlign.center,
                style: customLatoPrayerStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Text(
                prayerTime,
                style: customLatoPrayerStyle(
                  letterSpacing: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
