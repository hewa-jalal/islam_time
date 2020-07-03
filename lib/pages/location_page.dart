import 'package:adhan/adhan.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:islamtime/bloc/bang_bloc.dart';
import 'package:islamtime/models/bang.dart';
import 'package:islamtime/pages/select_city_page.dart';
import 'package:islamtime/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: BlocConsumer<BangBloc, BangState>(
          listener: (context, state) async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String prefStr = prefs.get('location');
            if (state is BangLoaded) {
              if (prefStr != null) {
                Get.off(
                  HomePage(
                    bang: state.bang,
                    userLocation: prefStr,
                    showDialog: true,
                  ),
                );
              } else {
                getUserLocation(context).then((value) {
                  Get.off(
                    HomePage(
                      bang: state.bang,
                      userLocation: value,
                      showDialog: true,
                    ),
                  );
                });
              }
            }
          },
          builder: (context, state) {
            if (state is BangInitial) {
              return Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () => getUserLocation(context),
                    child: FlareActor(
                      'assets/flare/location_place_holder.flr',
                      animation: 'jump',
                    ),
                  ),
                  Positioned.fill(
                    top: 30,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'Tap the screen to get your location',
                        style: GoogleFonts.roboto(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is BangLoaded) {}
            return CircularProgressIndicator(backgroundColor: Colors.pink);
          },
        ),
      ),
    );
  }

  Future<String> getUserLocation(context, [Bang bang]) async {
    final bangBloc = BlocProvider.of<BangBloc>(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Position position = await Geolocator().getCurrentPosition();
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];

    String formattedAddress = '${placemark.locality},${placemark.country}';
    List<String> splitedAddress = formattedAddress.split(',');

    String userCity = splitedAddress[0];
    String userCountry = splitedAddress[1];

    if (userCountry.toLowerCase().contains('iraq')) {
      String strPrefs = prefs.getString('location');
      List<String> splitedPrefs = strPrefs.split(',');
      if (strPrefs != null) {
        bangBloc.add(GetBang(
            countryName: splitedPrefs[0], cityName: splitedPrefs[1].trim()));
      } else {
        Get.off(SelectCityPage());
      }
      print('strPrefs LocationPage $strPrefs');
    } else {
      bangBloc.add(GetBang(cityName: userCity, countryName: userCountry));
    }

    return '$userCountry, $userCity';
  }
}
