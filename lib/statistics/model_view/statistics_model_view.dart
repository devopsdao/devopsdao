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
}