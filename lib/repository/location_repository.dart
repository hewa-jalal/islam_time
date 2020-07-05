import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationRepository {
  Future<Position> getUserLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final position = await Geolocator().getCurrentPosition();
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];

    String formattedAddress = '${placemark.locality},${placemark.country}';
    List<String> splitedAddress = formattedAddress.split(',');

    prefs.setString('location', '${splitedAddress[0]}, ${splitedAddress[1]}');

    return position;
  }
}
