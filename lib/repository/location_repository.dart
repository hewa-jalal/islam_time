import 'package:geolocator/geolocator.dart';
import 'package:islamtime/custom_widgets_and_styles/custom_styles_formats.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationRepository {
  Future<Position> getUserLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final position = await Geolocator().getCurrentPosition();
    final placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    final placemark = placemarks[0];

    final formattedAddress = '${placemark.locality},${placemark.country}';
    final splitedAddress = formattedAddress.split(',');

    await prefs.setString(
        LOCATION_KEY, '${splitedAddress[0]}, ${splitedAddress[1]}');

    return position;
  }
}
