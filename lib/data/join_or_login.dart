import 'package:flutter/foundation.dart';

class JoinOrLogin extends ChangeNotifier {
  bool _isJoin = false;

  bool get isJoin => _isJoin;

  void toggle(){
    _isJoin = !_isJoin;
    notifyListeners(); // changeNotifier 를 사용하는 Widget 에게 알림을 보내주는 것
  }
}