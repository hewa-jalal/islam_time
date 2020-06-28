import 'package:flutter/cupertino.dart';

class ArrowAnimation with ChangeNotifier {
  String animation = 'upArrowAnimation';

  void changeAnimation(String animationDirection) {
    animation = animationDirection;
    notifyListeners();
  }
}
