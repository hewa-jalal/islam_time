import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations('en') +
      {
        'en': 'Tune prayer times (in minutes)',
        'ar': 'ضبط أوقات الصلاة (بالدقائق)'
      } +
      {
        'en': 'Select a method',
        'ar': 'حدد طريقة',
      } +
      {
        'en': 'Close',
        'ar': 'أغلق',
      } +
      {
        'en': 'Ok',
        'ar': 'حسنا',
      } +
      {
        'en': 'Change Langauge',
        'ar': 'تغيير اللغة',
      } +
      {
        'en': 'Get a new location',
        'ar': 'احصل على موقع جديد',
      } +
      {
        'en': 'Settings',
        'ar': 'الإعدادات',
      } +
      {
        'en': 'Last third deeds',
        'ar': 'اعمال الثلث اللأخیر',
      } +
      {
        'en': 'Shia Ithna-Ansari',
        'ar': 'الشيعة إثنا الأنصاري',
      } +
      {
        'en': 'University of Islamic Sciences, Karachi',
        'ar': 'جامعة العلوم الإسلامية، بكراتشي',
      } +
      {
        'en': 'Islamic Society of North America',
        'ar': 'الجمعية الإسلامية لأمريكا الشمالية',
      } +
      {
        'en': 'Muslim World League',
        'ar': 'رابطة العالم الإسلامي',
      } +
      {
        'en': 'Umm Al-Qura University, Makkah',
        'ar': 'جامعة أم القرى بمكة المكرمة',
      } +
      {
        'en': 'Egyptian General Authority of Survey',
        'ar': 'الهيئة العامة المصرية للاستطلاع',
      } +
      {
        'en': 'Institute of Geophysics, University of Tehran',
        'ar': 'معهد الجيوفيزياء بجامعة طهران',
      } +
      {
        'en': 'Gulf Region',
        'ar': 'منطقة الخليج',
      } +
      {
        'en': 'Kuwait',
        'ar': 'الكويت',
      } +
      {
        'en': 'Qatar',
        'ar': 'دولة قطر',
      } +
      {
        'en': 'Majlis Ugama Islam Singapura, Singapore',
        'ar': 'مجلس أوغاما إسلام سينجابورا ، سنغافورة',
      } +
      {
        'en': 'Union Organization islamic de France',
        'ar': 'منظمة الاتحاد الإسلامية الفرنسية',
      } +
      {
        'en': 'Diyanet İşleri Başkanlığı, Turkey',
        'ar': 'مديرية الشؤون الدينية ، تركيا',
      } +
      {
        'en': 'Spiritual Administration of Muslims of Russia',
        'ar': 'الإدارة الروحية لمسلمي روسيا',
      };

  String get i18n2 => localize(this, _t);
}
