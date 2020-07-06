import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:islamtime/models/bang.dart';
import 'package:islamtime/repository/bang_repository.dart';
import 'package:islamtime/repository/location_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'bang_event.dart';
part 'bang_state.dart';

// enum BangEvent {BangLoaded,  }

class BangBloc extends HydratedBloc<BangEvent, BangState> {
  final BangRepository bangRepository;
  final LocationRepository locationRepository;

  BangBloc({
    @required this.bangRepository,
    @required this.locationRepository,
  }) : super(BangInitial());

  @override
  BangState fromJson(Map<String, dynamic> json) {
    try {
      final bang = Bang.fromJson(json);
      return BangLoaded(bang);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson(BangState state) {
    if (state is BangLoaded) {
      return state.bang.toJson();
    } else {
      return null;
    }
  }

  @override
  Stream<BangState> mapEventToState(
    BangEvent event,
  ) async* {
    yield BangLoading();
    if (event is FetchBang) {
      try {
        Position position = await locationRepository.getUserLocation();
        _saveUserLocationToPrefs(position);
        final Bang bang = await bangRepository.fetchBang(
          lat: position.latitude,
          lng: position.longitude,
          month: DateTime.now().month,
          year: DateTime.now().year,
        );

        yield BangLoaded(bang);
      } catch (e) {
        print('catch BangError() in FetchBang => ${e.toString()}');
        yield BangError();
      }
    } else if (event is GetBang) {
      try {
        final Bang bang = await bangRepository.getPrayerData(
            event.countryName, event.cityName);
        yield BangLoaded(bang);
      } catch (e) {
        print('catch error in GetBang() ${e.toString()}');
        add(FetchBang());
      }
    } else if (event is FetchBangWithSettings) {
      Position position = await locationRepository.getUserLocation();
      print('with Setting position $position');
      print('methodNumber => => => ${event.methodNumber}');
      print('tuning => => => ${event.tuning}');
      _saveSettingsToPrefs(
          lat: position.latitude,
          lng: position.longitude,
          methodNumber: event.methodNumber,
          tuning: event.tuning);
      final Bang bang = await bangRepository.fetchBang(
        lat: position.latitude,
        lng: position.longitude,
        month: DateTime.now().month,
        year: DateTime.now().year,
        method: event.methodNumber,
        tuning: event.tuning,
      );
      yield BangLoaded(bang);
    }
  }

  void _saveSettingsToPrefs(
      {double lat, double lng, int methodNumber, List<int> tuning}) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> stringTuning = tuning.map((e) => e.toString()).toList();
    prefs.setDouble('lat', lat);
    prefs.setDouble('lng', lng);
    prefs.setInt('methodNumber', methodNumber);
    prefs.setStringList('tuning', stringTuning);

    print(''' bloc => lat prefs ${prefs.getDouble('lat')} 
              bloc => lng prefs ${prefs.getDouble('lng')}
              bloc => methodNumber prefs ${prefs.getInt('methodNumber')}
              bloc => tuning prefs ${prefs.getStringList('tuning')}''');
  }

  void _saveUserLocationToPrefs(Position position) async {
    final prefs = await SharedPreferences.getInstance();
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];

    String formattedAddress = '${placemark.locality},${placemark.country}';
    List<String> splitedAddress = formattedAddress.split(',');

    String userCity = splitedAddress[0];
    String userCountry = splitedAddress[1];

    prefs.setString('location', '$userCountry, $userCity');

    print('bloc userLocation => ${prefs.getString('location')}');
  }
}
