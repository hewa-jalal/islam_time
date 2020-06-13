import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islamtime/bloc/bang_bloc.dart';
import 'package:islamtime/custom_widgets/clock.dart';
import 'package:islamtime/pages/home_page.dart';

import '../bang.dart';

class LocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocListener<BangBloc, BangState>(
          listener: (context, state) {
            if (state is BangLoaded) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: BlocProvider.of<BangBloc>(context),
                    child: HomePage(bang: state.bang),
                  ),
                ),
              );
            }
          },
          child: BlocBuilder<BangBloc, BangState>(
            builder: (context, state) {
              if (state is BangInitial) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Model State', style: TextStyle(fontSize: 36)),
                    Expanded(
                      child: FlatButton(
                        child: Icon(
                          Icons.my_location,
                          size: 100,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: RaisedButton(
                          onPressed: () async {
                            await getUserLocation(context);
                          },
                          child: Text('OK'),
                        ),
                      ),
                    )
                  ],
                );
              } else if (state is BangLoaded) {
                return CircularProgressIndicator();
              } else if (state is BangLoading) {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget initialState() {
    return Center(
      child: FlatButton(
        child: Text('Initial state'),
        onPressed: () {},
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

  Future<String> getUserLocation(context) async {
    final bangBloc = BlocProvider.of<BangBloc>(context);

    Position position = await Geolocator().getCurrentPosition();
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];

    String formattedAddress = '${placemark.locality},${placemark.country}';
    List<String> splitedAddress = formattedAddress.split(',');

    var userCity = splitedAddress[0];
    var userCountry = splitedAddress[1];

    bangBloc.add(GetBang(countryName: userCountry, cityName: userCity));

    return '$userCountry, $userCity';
  }
}
