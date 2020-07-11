import 'package:cubit/cubit.dart';

class BodyStatusCubit extends Cubit<bool> {
  BodyStatusCubit() : super(false);

  void changeStatus(bool isOpen) => emit(isOpen);
}
