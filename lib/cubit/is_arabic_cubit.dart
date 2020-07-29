import 'package:bloc/bloc.dart';
import 'package:devicelocale/devicelocale.dart';

class IsArabicCubit extends Cubit<bool> {
  IsArabicCubit() : super(false);

  void isArabic() {
    final locale = Devicelocale.currentLocale;
    locale == 'ar' ? emit(true) : emit(false);
  }
}
