import 'dart:ui';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamtime/bloc/bang_bloc.dart';
import 'package:islamtime/custom_widgets_and_styles/custom_styles_formats.dart';
import 'package:islamtime/pages/select_city_page.dart';
import 'package:islamtime/pages/home_page.dart';
import 'package:islamtime/services/connection_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../size_config.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final connectionStatus = Provider.of<ConnectivityStatus>(context);
    final isNotConnected = connectionStatus == ConnectivityStatus.Offline;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: BlocConsumer<BangBloc, BangState>(
          listener: (context, state) async {
            final prefs = await SharedPreferences.getInstance();
            String locationPrefs = prefs.get('location');
            if (state is BangLoaded) {
              if (locationPrefs != null) {
                Get.off(
                  HomePage(
                    userLocation: locationPrefs,
                    showDialog: true,
                  ),
                );
              } else {
                getUserLocation(context).then(
                  (value) {
                    Get.off(
                      HomePage(
                        userLocation: value,
                        showDialog: true,
                      ),
                    );
                  },
                );
              }
            }
          },
          builder: (context, state) {
            return AbsorbPointer(
              absorbing: _isLoading,
              child: Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () => isNotConnected
                        ? showOfflineDialog(context, OfflineMessage.location)
                        : getUserLocation(context),
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
                          fontSize: SizeConfig.blockSizeHorizontal * 5.4,
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  _isLoading
                      ? Center(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Container(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<String> getUserLocation(context) async {
    setState(() => _isLoading = true);
    final bangBloc = BlocProvider.of<BangBloc>(context);

    final prefs = await SharedPreferences.getInstance();
    final locationPrefs = prefs.getString('location');

    final position = await Geolocator().getCurrentPosition();
    final placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    final placemark = placemarks[0];

    final formattedAddress = '${placemark.locality},${placemark.country}';
    final splitedAddress = formattedAddress.split(',');

    final userCity = splitedAddress[0];
    final userCountry = splitedAddress[1];

    if (locationPrefs != null) {
      final splitedPrefs = locationPrefs.split(',');
      bangBloc.add(
        GetBang(countryName: splitedPrefs[0], cityName: splitedPrefs[1].trim()),
      );
    }

    if (userCountry.toLowerCase().contains('iraq')) {
      await prefs.setBool(IS_LOCAL_KEY, true);
      Get.off(SelectCityPage());
    } else {
      await prefs.setBool(IS_LOCAL_KEY, false);
      bangBloc.add(GetBang(cityName: userCity, countryName: userCountry));
    }
    return '$userCountry, $userCity';
  }
}
