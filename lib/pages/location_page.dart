import 'package:flutter/material.dart';

import 'package:islamtime/user_information.dart';

class LocationPage extends StatefulWidget {
  final UserInformation userInformation;

  const LocationPage({@required this.userInformation});

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.my_location),
              onPressed: () => widget.userInformation.getUserPrayer(),
            ),
          ],
        ),
      ),
    );
  }
}
