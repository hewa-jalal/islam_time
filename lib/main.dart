import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamtime/bloc/bang_bloc.dart';
import 'package:islamtime/bloc/time_cycle/time_cycle_bloc.dart';
import 'package:islamtime/repository/bang_api_client.dart';
import 'package:islamtime/repository/bang_repository.dart';
import 'package:http/http.dart' as http;
import 'package:islamtime/repository/location_repository.dart';

import 'pages/location_page.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

    @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print('event $event');
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();

  print('vscodeeee');

  final BangRepository repository = BangRepository(
    bangApiClient: BangApiClient(
      httpClient: http.Client(),
    ),
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<BangBloc>(
          create: (_) => BangBloc(
            bangRepository: repository,
            locationRepository: LocationRepository(),
          ),
        ),
        BlocProvider<TimeCycleBloc>(
          create: (_) => TimeCycleBloc(),
        ),
      ],
      child: MaterialApp(
        home: LocationPage(),
      ),
    ),
  );
}
