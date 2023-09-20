import 'package:flutter/cupertino.dart';
import 'package:webthree/webthree.dart';

class MyNotifyListener extends ChangeNotifier {

  Future<void> myNotifyListeners() async {
    notifyListeners();
  }
}
