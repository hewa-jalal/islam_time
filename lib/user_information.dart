import 'package:geolocator/geolocator.dart';
import 'package:islamtime/models/user_model.dart';
import 'package:islamtime/static_prayer.dart';
import 'package:jiffy/jiffy.dart';

class UserInformation {
  String currentDate;
  String userCity;
  String userCountry;
  UserModel userModel;

  Future<void> getUserLocation() async {
    Position position = await Geolocator().getCurrentPosition();
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];

    String formattedAddress = '${placemark.locality},${placemark.country}';
    List<String> splitedAddress = formattedAddress.split(',');

    userCity = splitedAddress[0];
    userCountry = splitedAddress[1];

    print('User Country => $userCountry');
    print('User City =>  $userCity');
  }

  void getDate() {
    int month = Jiffy().month;
    int day = Jiffy().date;

    // used quotes on the last one to make it a String
    String formattedMonth = month < 10 ? '0$month' : '$month';
    String formattedDay = day < 10 ? '0$day' : '$day';

    currentDate = '$formattedMonth-$formattedDay';

    userModel = UserModel(
        city: userCity, country: userCountry, currentDate: currentDate);
  }

  void getUserPrayer() async {
    await getUserLocation();
    getDate();
    Prayer prayer = Prayer();
    prayer.getPrayer(userModel);
  }
}
