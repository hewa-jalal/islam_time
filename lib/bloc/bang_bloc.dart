import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islamtime/models/bang.dart';
import 'package:islamtime/repository/bang_repository.dart';
import 'package:islamtime/repository/location_repository.dart';

part 'bang_event.dart';
part 'bang_state.dart';

class BangBloc extends Bloc<BangEvent, BangState> {
  final BangRepository bangRepository;
  final LocationRepository locationRepository;

  BangBloc({@required this.bangRepository, @required this.locationRepository});

  @override
  BangState get initialState => BangInitial();

  @override
  Stream<BangState> mapEventToState(
    BangEvent event,
  ) async* {
    yield BangLoading();
    if (event is FetchBang) {
      try {
        Position position = await locationRepository.getUserLocation();
        print('position $position');
        final Bang bang = await bangRepository.fetchBang(position.latitude,
            position.longitude, DateTime.now().month, DateTime.now().year);
        yield BangLoaded(bang);
      } catch (e) {
        print('catch BangError() => ${e.toString()}');
        yield BangError();
      }
    } else if (event is GetBang) {
      try {
        final Bang bang = await bangRepository.getPrayerData(
            event.countryName, event.cityName);
        yield BangLoaded(bang);
      } catch (e) {
        print('inside catch before FetchBang ${e.toString()}');
        add(FetchBang());
      }
    }
  }
}
