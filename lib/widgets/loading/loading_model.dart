import 'package:flutter/cupertino.dart';

class LoadingUpdatedData extends ChangeNotifier {
  late int tasksLoaded = 0;
  late int totalTaskLen = 0;
  void updateData(int loaded, int length) {
    tasksLoaded = loaded;
    totalTaskLen = length;
    notifyListeners();
  }
  void resetLength() {
    totalTaskLen = 0;
    notifyListeners();
  }
}