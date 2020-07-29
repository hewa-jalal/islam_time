import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' as get_package;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:islamtime/bloc/bang_bloc.dart';
import 'package:islamtime/bloc/time_cycle/time_cycle_bloc.dart';
import 'package:islamtime/cubit/after_spotlight_cubit.dart';
import 'package:islamtime/pages/home_page.dart';
import 'package:islamtime/pages/language_selection_page.dart';
import 'package:islamtime/pages/liquid_introduction.dart';
import 'package:islamtime/repository/bang_api_client.dart';
import 'package:islamtime/repository/bang_repository.dart';
import 'package:islamtime/services/connection_service.dart';
import 'package:islamtime/size_config.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:provider/provider.dart';
import 'cubit/body_status_cubit.dart';
import 'cubit/is_arabic_cubit.dart';
import 'cubit/theme_cubit/theme_cubit.dart';
import 'package:http/http.dart' as http;
import 'package:islamtime/repository/location_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SimpleBlocDelegate extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('transition $transition');
  }

  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print('event $event');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = SimpleBlocDelegate();
  HydratedBloc.storage = await HydratedStorage.build();

  final prefs = await SharedPreferences.getInstance();
  final locationPrefs = prefs.getString('location');

  final repository = LocalBangRepository(
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
        BlocProvider<BodyStatusCubit>(
          create: (_) => BodyStatusCubit(),
        ),
        BlocProvider<AfterSpotLightCubit>(
          create: (_) => AfterSpotLightCubit(),
        ),
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(),
        ),
        BlocProvider<IsArabicCubit>(
          create: (_) => IsArabicCubit(),
        ),
      ],
      child: StreamProvider<ConnectivityStatus>(
        create: (context) =>
            ConnectivityService().connectionStatusController.stream,
        child: BlocBuilder<ThemeCubit, ThemeChanged>(
          builder: (context, state) {
            return NeumorphicApp(
              debugShowCheckedModeBanner: false,
              home: get_package.GetMaterialApp(
                // localizationsDelegates: [
                //   GlobalMaterialLocalizations.delegate,
                //   GlobalWidgetsLocalizations.delegate,
                //   GlobalCupertinoLocalizations.delegate,
                // ],
                // supportedLocales: const [const Locale('ar'), const Locale('en_us')],
                theme: state.themeData,
                debugShowCheckedModeBanner: false,
                home: locationPrefs != null
                    ? Builder(
                        builder: (context) {
                          ScreenUtil.init(context);
                          return HomePage(
                            showDialog: false,
                            userLocation: locationPrefs,
                          );
                        },
                      )
                    : Builder(
                        builder: (context) {
                          SizeConfig().init(context);
                          ScreenUtil.init(context);
                          return I18n(
                            child: LiquidIntroductionPage(),
                          );
                        },
                      ),
                // home: SplashScreenPage(locationPrefs: locationPrefs),
              ),
            );
          },
        ),
      ),
    ),
  );
}
