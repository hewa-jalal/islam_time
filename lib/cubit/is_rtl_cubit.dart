import 'package:bloc/bloc.dart';

class IsRtlCubit extends Cubit<bool> {
  IsRtlCubit() : super(false);

  void isRtl(bool isRtl) => emit(isRtl);
}
