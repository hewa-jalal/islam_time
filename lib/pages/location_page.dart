import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamtime/bloc/bang_bloc.dart';
import 'package:islamtime/models/bang.dart';
import 'package:islamtime/pages/home_page.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  List<String> cities = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            decoration: InputDecoration.collapsed(
                fillColor: Colors.white, hintText: 'Enter a city name'),
          ),
        ),
        backgroundColor: Colors.grey,
        body: BlocConsumer<BangBloc, BangState>(
          listener: (context, state) async {
            if (state is BangLoaded) {
              // getUserLocation(context).then((value) {
              //   Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //       builder: (_) =>
              //           HomePage(bang: state.bang, userLocation: value),
              //     ),
              //   );
              // });
            }
          },
          builder: (context, state) {
            if (state is BangInitial) {
              return FutureBuilder(
                future: _initImages(context),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            final String item = snapshot.data[index];
                            final regex = RegExp(r'\w+(?=\.)');
                            Iterable iter = regex.allMatches(item);
                            for (var element in iter) {
                              cities.add(
                                  item.substring(element.start, element.end));
                            }
                            return ListTile(
                              title: Text(cities[index].toString()),
                            );
                          },
                        )
                      : CircularProgressIndicator(
                          backgroundColor: Colors.green,
                        );
                },
              );
              // return Stack(
              //   children: <Widget>[
              //     GestureDetector(
              //       onTap: () => getUserLocation(context),
              //       child: FlareActor(
              //         'assets/flare/location_place_holder.flr',
              //         animation: 'jump',
              //       ),
              //     ),
              //     Positioned.fill(
              //       top: 30,
              //       child: Align(
              //         alignment: Alignment.topCenter,
              //         child: Text(
              //           'Tap the screen to get your location',
              //           style: GoogleFonts.roboto(
              //               fontSize: 22,
              //               color: Colors.black,
              //               fontWeight: FontWeight.w900),
              //         ),
              //       ),
              //     ),
              //   ],
              // );
            }
            if (state is BangLoading) {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget columnWithData(Bang bang) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Model State ${bang.speda}', style: TextStyle(fontSize: 36)),
        Text('Model State ${bang.rojHalat}', style: TextStyle(fontSize: 36)),
        Text('Model State ${bang.nevro}', style: TextStyle(fontSize: 36)),
        Text('Model State ${bang.evar}', style: TextStyle(fontSize: 36)),
        Text('Model State ${bang.maghrab}', style: TextStyle(fontSize: 36)),
        Text('Model State ${bang.aesha}', style: TextStyle(fontSize: 36)),
      ],
    );
  }

  Future<List<String>> _initImages(BuildContext context) async {
    // >> To get paths you need these 2 lines
    final manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // >> To get paths you need these 2 lines

    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('fixed_prayer_time/Iraq/'))
        .where((String key) => key.contains('.txt'))
        .toList();
    return imagePaths;
  }

  Future<String> getUserLocation(context) async {
    final bangBloc = BlocProvider.of<BangBloc>(context);

    Position position = await Geolocator().getCurrentPosition();
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];

    String formattedAddress = '${placemark.locality},${placemark.country}';
    List<String> splitedAddress = formattedAddress.split(',');

    String userCity = splitedAddress[0];
    String userCountry = splitedAddress[1];

    bangBloc.add(GetBang(countryName: userCountry, cityName: userCity));

    return '$userCountry, $userCity';
  }
}
