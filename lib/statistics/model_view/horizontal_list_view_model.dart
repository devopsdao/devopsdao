import 'dart:async';
import 'package:flutter/cupertino.dart';

import '../../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';

class HorizontalListViewModel extends ChangeNotifier {
  List<double> _itemWidths = [];

  List<double> get itemWidths => _itemWidths;

  void updateItemWidths(List<double> newWidths) {
    _itemWidths = newWidths;
    notifyListeners();
  }
}