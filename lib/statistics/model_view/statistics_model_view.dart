import 'package:flutter/material.dart';

class IndexedChildrenManager extends ChangeNotifier {
  final List<Widget> children;
  List<int> indexOrder;

  IndexedChildrenManager(this.children, this.indexOrder);

  List<Widget> getOrderedChildren() {
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


