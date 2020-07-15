import 'package:cubit/cubit.dart';

class AfterSpotLightCubit extends Cubit<bool> {
  AfterSpotLightCubit() : super(false);

  void changeStatus() => emit(true);
}
