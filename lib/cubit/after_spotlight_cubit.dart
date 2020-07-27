import 'package:bloc/bloc.dart';

class AfterSpotLightCubit extends Cubit<bool> {
  AfterSpotLightCubit() : super(false);

  void changeStatus() => emit(true);
}
