import 'dart:async';
import 'package:flutter/cupertino.dart';

import '../../../blockchain/classes.dart';
import '../services/statistics_service.dart';

// model - service:
// get -> read
// set -> write
// on -> init
// ... -> check (logic with bool return(not bool stored data))


class StatisticsModelState {
  bool initialized = false;
  List<TokenItem> tags = [];
  Map<String, Map<String, BigInt>> initialEmptyBalance = {};

  StatisticsModelState({
    required this.initialized,
    required this.tags,
    required this.initialEmptyBalance,
  });
}

class StatisticsModel extends ChangeNotifier {
  final _statisticsService = StatisticsService();

  var _state = StatisticsModelState(
    initialized: false,
    tags: [],
    initialEmptyBalance: {},
  );
  StatisticsModelState get state => _state;
  StreamSubscription<List<TokenItem>>? tagSubscription;

  StatisticsModel() {
    StatisticsModelState(
      initialized: false,
      tags: _statisticsService.tags,
      initialEmptyBalance: _statisticsService.initialEmptyBalance,
    );
  }

  void subscribeToStatistics () {
    tagSubscription = _statisticsService.statisticsTokenItems.listen((data) {
      _state = StatisticsModelState(
        tags: data,
        initialized: true,
        initialEmptyBalance: _statisticsService.initialEmptyBalance,
      );
      notifyListeners();
    });
  }

  void unsubscribeStatistics () {
    tagSubscription!.cancel();
  }

  Future<void> onRequestBalances(int chainId, tasksServices) async {
    _statisticsService.initRequestBalances(chainId, tasksServices);
  }

  // void _updateState() {
  //   bool initialized = _state.initialized;
  //   _state = StatisticsModelState(
  //     initialized: initialized,
  //     tags: [],
  //     initialEmptyBalance:
  //   );
  //   notifyListeners();
  // }
  //
  // @override
  // void dispose() {
  //   print('disposed');
  //   tagSubscription?.cancel();
  //   super.dispose();
  // }
}
