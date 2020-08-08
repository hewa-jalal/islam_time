import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations('en') +
      {
        'en':
            '''There are differences in perspective of the day's beginning(by day we mean the full 24 hour cycle not the morning time). Jews tend to begin at Magrib, Christians at sharp midnight.Most Muslims seem to abide by the Jewish timing, but this is wrong.''',
        'ar':
            'هناك اختلافات في منظور بداية اليوم (نعني باليوم دورة 24 ساعة كاملة وليس وقت الصباح). يميل اليهود إلى البدء في المغرب ، والمسيحيين عند منتصف الليل الحاد ، ويبدو أن معظم المسلمين يلتزمون بالتوقيت اليهودي ، لكن هذا خطأ.'
      } +
      {
        'en':
            '''For muslims the day starts at maghrib, also keep in mind that in islam the the night precedes the morning. and that's why on the last day of Ramadan, we don't pray Taraweeh, and that’s because the day (new day) has started at maghrib, so Ramadan is over and Eid has begun. this also mean that you may recite Surah Kahf any time after sunset of Thursday.''',
        'ar':
            '''بالنسبة للمسلمين يبدأ اليوم في المغرب ، ضع في اعتبارك أيضًا أن الإسلام يسبق الليل في الإسلام. ولهذا السبب في آخر يوم رمضان ، لا نصلي التراويح ، وذلك لأن اليوم (يوم جديد) بدأ في المغرب ، لذلك انتهى رمضان وبدأ العيد. هذا يعني أيضًا أنه يمكنك قراءة سورة الكهف في أي وقت بعد غروب الشمس يوم الخميس.'''
      } +
      {
        'en': 'done',
        'ar': 'حسنا',
      };

  String get i18n => localize(this, _t);
}
