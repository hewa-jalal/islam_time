import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations('en') +
      {
        'en': 'Fajr',
        'ar': 'الصباح',
      } +
      {
        'en': 'Sunrise',
        'ar': 'الشروق',
      } +
      {
        'en': 'Zuhr',
        'ar': 'الظهر',
      } +
      {
        'en': 'Asr',
        'ar': 'العصر',
      } +
      {
        'en': 'Maghrib',
        'ar': 'المغرب',
      } +
      {
        'en': 'Isha',
        'ar': 'العشاء',
      } +
      {
        'en': 'Midnight',
        'ar': 'منتصف الليل',
      } +
      {
        'en': 'Last Third',
        'ar': 'الثلث الأخير',
      } +
      {
        'en': 'Prayers Times for',
        'ar': 'أوقات الصلاة في',
      } +
      {
        'en': 'Time Remaining Until ',
        'ar': 'الوقت المتبقي حتى',
      } +
      {
        'en': 'Night',
        'ar': 'الیل',
      } +
      {
        'en': 'Day',
        'ar': 'صباح',
      };

  String get i18n => localize(this, _t);
}
