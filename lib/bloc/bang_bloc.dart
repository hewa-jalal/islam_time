import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:islamtime/custom_widgets_and_styles/custom_styles_formats.dart';
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
        final position = await locationRepository.getUserLocation();
        _saveUserLocationToPrefs(position);
        _saveSettingsToPrefs(
          lat: position.latitude,
          lng: position.longitude,
          isLocal: false,
        );
        final bang = await bangRepository.fetchBang(
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
        final bang = await bangRepository.getPrayerData(
            event.countryName, event.cityName);
        yield BangLoaded(bang);
      } catch (e) {
        print('catch error in GetBang() ${e.toString()}');
        add(FetchBang());
      }
    } else if (event is FetchBangWithSettings) {
      final position = await locationRepository.getUserLocation();
      // print('''
      // lat => ${position.latitude},
      // lng => ${position.longitude},
      // methodNumber => ${event.methodNumber},
      // tuning => ${event.tuning}''');
      _saveSettingsToPrefs(
        lat: position.latitude,
        lng: position.longitude,
        methodNumber: event.methodNumber,
        tuning: event.tuning,
        isLocal: false,
      );
      try {
        final bang = await bangRepository.fetchBang(
          lat: position.latitude,
          lng: position.longitude,
          month: DateTime.now().month,
          year: DateTime.now().year,
          method: event.methodNumber,
          tuning: event.tuning,
        );
        yield BangLoaded(bang);
      } catch (_) {
        yield BangError();
      }
    }
  }

  void _saveSettingsToPrefs({
    double lat,
    double lng,
    int methodNumber = 3,
    List<int> tuning = const [0, 0, 0, 0, 0, 0],
    bool isLocal,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final stringTuning = tuning.map((e) => e.toString()).toList();
    await prefs.setDouble('lat', lat);
    await prefs.setDouble('lng', lng);
    await prefs.setInt('methodNumber', methodNumber);
    await prefs.setStringList('tuning', stringTuning);
    await prefs.setBool(IS_LOCAL_KEY, isLocal);

    print(''' bloc => lat prefs ${prefs.getDouble('lat')} 
              bloc => lng prefs ${prefs.getDouble('lng')}
              bloc => methodNumber prefs ${prefs.getInt('methodNumber')}
              bloc => tuning prefs ${prefs.getStringList('tuning')}
              bloc => isLocal ${prefs.getBool(IS_LOCAL_KEY)}''');
  }

  void _saveUserLocationToPrefs(Position position) async {
    final prefs = await SharedPreferences.getInstance();
    final placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    final placemark = placemarks[0];

    final formattedAddress = '${placemark.locality},${placemark.country}';
    final splitedAddress = formattedAddress.split(',');

    final userCity = splitedAddress[0];
    final userCountry = splitedAddress[1];

    await prefs.setString('location', '$userCountry, $userCity');

    print('inside bloc userLocation => ${prefs.getString('location')}');
  }
}
