import 'package:flutter/cupertino.dart';

class NotificationProvider with ChangeNotifier {
  bool _isHighlighted = true;

  bool get isHighlighted => _isHighlighted;

  void changeHighlighted(bool res) async {
    await Future.delayed(Duration(milliseconds: 700), () {});
    _isHighlighted = res;
    notifyListeners();
  }
}
