import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations('en') +
      {
        'en': 'Ok',
        'ar': 'حسنا',
      } +
      {
        'en': 'Cancel',
        'ar': 'إلغاء',
      } +
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
        'en': 'Last third deeds',
        'ar': 'اعمال الثلث اللأخیر',
      } +
      {
        'en': 'Prayers Times for',
        'ar': 'أوقات الصلاة في',
      } +
      {
        'en': 'Time Remaining Until',
        'ar': 'الوقت المتبقي حتى',
      } +
      {
        'en': 'Night',
        'ar': 'الیل',
      } +
      {
        'en': 'Day',
        'ar': 'صباح',
      } +
      {
        'en': 'Swipe from here to get latest prayer times',
        'ar': 'اسحب من هنا للحصول على أحدث مواقيت الصلاة',
      } +
      {
        'en': 'Swipe to get more details',
        'ar': 'اسحب للحصول على مزيد من التفاصيل',
      } +
      {
        'en': 'Tap here to tune prayers times or get a new location',
        'ar': 'اضغط هنا لضبط مواقيت الصلاة أو الحصول على موقع جديد',
      } +
      {
        'en': 'Tap here to get a new location',
        'ar': 'اضغط هنا للحصول على موقع جديد',
      } +
      {
        'en': 'Tap the screen to get your location',
        'ar': 'اضغط على الشاشة للحصول على موقعك',
      } +
      {
        'en': 'Your Location is',
        'ar': 'موقعك هو',
      } +
      {
        'en': 'Getting prayer times for today',
        'ar': 'الحصول على أوقات الصلاة لهذا اليوم',
      } +
      {
        'en':
            '''you have fixed prayer times for your location, are you sure you want to change your location,and get prayer times from the internet?''',
        'ar':
            '''لديك أوقات الصلاة الثابتة لموقعك، هل أنت متأكد من أنك تريد تغيير موقعك، والحصول على أوقات الصلاة من الإنترنت؟''',
      };

  String get i18n => localize(this, _t);
}
