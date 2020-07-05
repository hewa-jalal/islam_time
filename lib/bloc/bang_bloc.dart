import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:islamtime/models/bang.dart';
import 'package:islamtime/repository/bang_repository.dart';
import 'package:islamtime/repository/location_repository.dart';

part 'bang_event.dart';
part 'bang_state.dart';

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
        print('position with FetchBang $position');
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
}
