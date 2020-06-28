import 'package:geolocator/geolocator.dart';

class LocationRepository {
  Future<Position> getUserLocation() async {
    return await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
