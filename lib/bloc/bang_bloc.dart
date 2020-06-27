import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamtime/models/bang.dart';
import 'package:islamtime/repository/bang_repository.dart';

part 'bang_event.dart';
part 'bang_state.dart';

class BangBloc extends Bloc<BangEvent, BangState> {
  final BangRepository repository;

  BangBloc({@required this.repository});

  @override
  BangState get initialState => BangInitial();

  @override
  Stream<BangState> mapEventToState(
    BangEvent event,
  ) async* {
    yield BangLoading();
    if (event is FetchBang) {
      try {
        final Bang bang = await repository.fetchBang();
        yield BangLoaded(bang);
      } catch (e) {
        print('catch BangError() => ${e.toString()}');
        yield BangError();
      }
    } else if (event is GetBang) {
      try {
        final Bang bang =
            await repository.getPrayerData(event.countryName, event.cityName);
        yield BangLoaded(bang);
      } catch (e) {
        print('inside catch before FetchBang ${e.toString()}');
        add(FetchBang());
      }
    }
  }
}
