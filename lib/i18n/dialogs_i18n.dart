import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations('en') +
      {
        'en':
            'Please make sure you are connected to the internet so we can get correct prayers times for your location',
        'ar':
            'يرجى التأكد من اتصالك بالإنترنت حتى نتمكن من الحصول على أوقات الصلاة الصحيحة لموقعك',
      } +
      {
        'en':
            'Please make sure you are connected to the internet before going into settings',
        'ar': 'يرجى التأكد من اتصالك بالإنترنت قبل الدخول إلى الإعدادات',
      } +
      {
        'en':
            'Please make sure you are connected to the internet before going into settings',
        'ar': 'يرجى التأكد من اتصالك بالإنترنت قبل الدخول إلى الإعدادات',
      } +
      {
        'en':
            'For the option to change location and get prayers from the internet you must be online',
        'ar':
            'لخيار تغيير الموقع والحصول على صلاة من الإنترنت ، يجب أن تكون متصلاً بالإنترنت',
      } +
      {
        'en': 'Last third deeds',
        'ar': 'عرض اعمال الثلث اللأخیر',
      } +
      {
        'en': 'Ok',
        'ar': 'حسنا',
      } +
      {
        'en':
            'Please make sure you are connected to the internet to get the latest prayer times',
        'ar': 'يرجى التأكد من اتصالك بالإنترنت للحصول على أحدث مواقيت الصلاة',
      };
  String get i18n => localize(this, _t);
}
