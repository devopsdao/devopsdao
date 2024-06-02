import 'dart:async';
import 'package:flutter/material.dart';
import '../../config/preferences.dart';

class IndexedChildrenManager extends ChangeNotifier {
  late List<int> indexOrder;
  late List<int> smallListOrderIndex;
  final Completer<void> _initializationCompleter = Completer<void>();

  IndexedChildrenManager() {
    _initializeIndexes();
  }

  Future<void> _initializeIndexes() async {
    final prefs = StatisticsOrderPreferences();
    smallListOrderIndex = await prefs.getSmallList();
    indexOrder = smallListOrderIndex; // or some other initial value
    _initializationCompleter.complete();
    notifyListeners();
  }

  Future<List<Widget>> getOrderedChildren(List<Widget> children) async {
    await _initializationCompleter.future;
    return indexOrder.map((index) => children[index]).toList();
  }

  void updateIndexOrder(List<int> newOrder) {
    indexOrder = newOrder;
    notifyListeners();
  }

  void reorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = indexOrder.removeAt(oldIndex);
    indexOrder.insert(newIndex, item);
    notifyListeners();
  }
}
