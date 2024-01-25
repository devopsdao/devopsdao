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
  List<TokenItem> tags = [];
  Map<String, Map<String, BigInt>> initialEmptyBalance = {};
  double valueOnWallet = 0.0; // for value_input max

  StatisticsModelState({
    required this.tags,
    required this.initialEmptyBalance,
    required this.valueOnWallet,
  });
}

class StatisticsModel extends ChangeNotifier {
  final _statisticsService = StatisticsService();

  var _state = StatisticsModelState(
    tags: [],
    initialEmptyBalance: {},
    valueOnWallet: 0.0,
  );
  StatisticsModelState get state => _state;
  StreamSubscription<List<TokenItem>>? tagSubscription;

  StatisticsModel() {
    StatisticsModelState(
      tags: _statisticsService.tags,
      initialEmptyBalance: _statisticsService.initialEmptyBalance,
      valueOnWallet: 0.0,
    );
  }

  void subscribeToStatistics () {
    tagSubscription = _statisticsService.statisticsTokenItems.listen((data) {
      _state = StatisticsModelState(
        tags: data,
        initialEmptyBalance: _statisticsService.initialEmptyBalance,
        valueOnWallet: data.first.balance,
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
