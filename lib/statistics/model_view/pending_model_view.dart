import 'dart:async';
import 'package:flutter/cupertino.dart';

import '../../../blockchain/classes.dart';
import '../services/pending_service.dart';

// model - service:
// get -> read
// set -> write
// on -> init
// ... -> check (logic with bool return(not bool stored data))


class TokenPendingModelState {
  List<TokenItem> tags = [];
  Map<String, Map<String, BigInt>> initialEmptyBalance = {};
  double valueOnWallet = 0.0; // for value_input max

  TokenPendingModelState({
    required this.tags,
    required this.initialEmptyBalance,
    required this.valueOnWallet,
  });
}

class TokenPendingModel extends ChangeNotifier {
  final _TokenPendingService = TokenPendingService();

  var _state = TokenPendingModelState(
    tags: [],
    initialEmptyBalance: {},
    valueOnWallet: 0.0,
  );
  TokenPendingModelState get state => _state;
  StreamSubscription<List<TokenItem>>? tagSubscription;

  TokenPendingModel() {
    TokenPendingModelState(
      tags: _TokenPendingService.tags,
      initialEmptyBalance: _TokenPendingService.initialEmptyBalance,
      valueOnWallet: 0.0,
    );
  }

  void subscribeToStatistics () {
    tagSubscription = _TokenPendingService.statisticsTokenItems.listen((data) {
      _state = TokenPendingModelState(
        tags: data,
        initialEmptyBalance: _TokenPendingService.initialEmptyBalance,
        valueOnWallet: data.first.balance,
      );
      notifyListeners();
    });
  }

  void unsubscribeStatistics () {
    tagSubscription!.cancel();
  }

  Future<void> onRequestBalances(int chainId, tasksServices) async {
    _TokenPendingService.initRequestBalances(chainId, tasksServices);
  }

  // void _updateState() {
  //   bool initialized = _state.initialized;
  //   _state = TokenPendingModelState(
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
