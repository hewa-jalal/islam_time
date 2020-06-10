import 'package:flutter/material.dart';
import 'package:islamtime/pages/home_page.dart';
import 'package:islamtime/pages/location_page.dart';
import 'package:islamtime/user_information.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LocationPage(
        userInformation: UserInformation(),
      ),
    ),
  );
}
