import 'dart:async';
import 'package:flutter/material.dart';
import '../../config/preferences.dart';

class StatsManagerStates {

}

class StatisticsWidgetsManager extends ChangeNotifier {
  late List<int> smallListOrderIndex;
  late List<int> largeListOrderIndex;
  final Completer<void> _initializationCompleter = Completer<void>();

  StatisticsWidgetsManager() {
    _initializeIndexes();
  }

  Future<void> _initializeIndexes() async {
    final prefs = StatisticsOrderPreferences();
    smallListOrderIndex = await prefs.getSmallList();
    largeListOrderIndex = await prefs.getLargeList();
    _initializationCompleter.complete();
    // notifyListeners(); // Notify listeners after initialization
  }

  Future<List<Widget>> getStatsWidgets(List<Widget> children) async {
    return children;
  }

  // void update() {
  //   print('update  $smallListOrderIndex');
  // }

  List<int> getOrderList(bool walletConnected) {
    // print('getOrderList ${smallListOrderIndex.length}');
    return walletConnected ? largeListOrderIndex : smallListOrderIndex;
  }

  Future<List<Widget>> getOrderedChildren(List<Widget> children, bool walletConnected) async {
    await _initializationCompleter.future;
    if ((!walletConnected && children.length != smallListOrderIndex.length) ||
        (walletConnected && children.length != largeListOrderIndex.length)) {
      print('smallListOrderIndex or largeListOrderIndex not equal, clear prefs!');
      final prefs = StatisticsOrderPreferences();
      prefs.setDefaultStatisticsPrefs();
      await _initializeIndexes(); // Reinitialize the indices
    }
    return walletConnected
        ? largeListOrderIndex.map((index) => children[index]).toList()
        : smallListOrderIndex.map((index) => children[index]).toList();
  }

  void reorder(int oldIndex, int newIndex, bool walletConnected) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    if (walletConnected) {
      final item = largeListOrderIndex.removeAt(oldIndex);
      largeListOrderIndex.insert(newIndex, item);
    } else {
      final item = smallListOrderIndex.removeAt(oldIndex);
      smallListOrderIndex.insert(newIndex, item);
    }
    notifyListeners();
    saveOrderPreferences(walletConnected);
  }

  Future<void> saveOrderPreferences(walletConnected) async {
    final prefs = StatisticsOrderPreferences();
    if (walletConnected) {
      await prefs.setLargeList(largeListOrderIndex);
    } else {
      await prefs.setSmallList(smallListOrderIndex);
    }
  }
}









