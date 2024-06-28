import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../blockchain/accounts.dart';

class CachedPersonalStatisticsDataModel extends ChangeNotifier {
  Map<String, Account>? _cachedData;

  Map<String, Account>? get cachedData => _cachedData;

  void setCachedData(Map<String, Account> data) {
    _cachedData = data;
    notifyListeners();
  }

  void clearCachedData() {
    _cachedData = null;
    notifyListeners();
  }
}
