import 'package:bloc/bloc.dart';

class BodyStatusCubit extends Cubit<bool> {
  BodyStatusCubit() : super(false);

  void changeStatus(bool isOpen) => emit(isOpen);
}
