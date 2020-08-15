import 'package:flutter_bloc/flutter_bloc.dart';

class IsOutdatedCubit extends Cubit<bool> {
  IsOutdatedCubit() : super(false);

  void isOutdated(bool isOutdated) => emit(isOutdated);
}
