import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamtime/bloc/bang_bloc.dart';
import 'package:islamtime/bloc/time_cycle/time_cycle_bloc.dart';
import 'package:islamtime/pages/network_page.dart';

import 'pages/location_page.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<BangBloc>(
          create: (_) => BangBloc(),
        ),
        BlocProvider<TimeCycleBloc>(
          create: (_) => TimeCycleBloc(),
        ),
      ],
      child: MaterialApp(
        home: NetworkPage(),
      ),
    ),
  );
}
