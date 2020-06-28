import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamtime/bloc/bang_bloc.dart';
import 'package:islamtime/models/bang.dart';
import 'package:islamtime/pages/home_page.dart';

class LocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: BlocConsumer<BangBloc, BangState>(
          listener: (context, state) {
            if (state is BangLoaded) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HomePage(bang: state.bang),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is BangInitial) {
              return GestureDetector(
                onTap: () => getUserLocation(context),
                child: FlareActor(
                  'assets/flare/location_place_holder.flr',
                  animation: 'jump',
                ),
              );
            }
            // } else if (state is BangLoaded) {
            //   getUserLocation(context).then(
            //     (userLocationAddress) => showLocationDialog(
            //         userLocationAddress, context, state.bang),
            //   );
            //   return FlareActor(
            //     'assets/flare/location_place_holder.flr',
            //     animation: 'jump',
            //   );
            // }
            return CircularProgressIndicator();
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

  void showLocationDialog(
      String userLocation, BuildContext context, Bang bang) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.SCALE,
      body: Center(
        child: Text(
          'Your Location is $userLocation',
          style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(bang: bang),
          ),
        );
      },
      btnCancelColor: Colors.blue,
      btnCancelText: 'Not Corrcet?',
    )..show();
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
