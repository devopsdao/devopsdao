import 'dart:async';
import 'package:flutter/cupertino.dart';

import '../../../blockchain/classes.dart';
import '../services/manager_service.dart';

// model - service:
// get -> read
// set -> write
// on -> init
// ... -> check (logic with bool return(not bool stored data))


class ManagerModelState {
  List<TokenItem> tags = [];
  Map<String, Map<String, BigInt>> initialEmptyBalance = {};
  double valueOnWallet = 0.0; // for value_input max

  ManagerModelState({
    required this.tags,
    required this.initialEmptyBalance,
    required this.valueOnWallet,
  });
}

class ManagerModel extends ChangeNotifier {
  final _managerService = ManagerService();

  var _state = ManagerModelState(
    tags: [],
    initialEmptyBalance: {},
    valueOnWallet: 0.0,
  );
  ManagerModelState get state => _state;
  StreamSubscription<List<TokenItem>>? tagSubscription;

  ManagerModel() {
    ManagerModelState(
      tags: _managerService.tags,
      initialEmptyBalance: _managerService.initialEmptyBalance,
      valueOnWallet: 0.0,
    );
  }

  void unsubscribeStatistics () {
    tagSubscription!.cancel();
  }

  Future<void> onRequestBalances(int chainId, tasksServices) async {

  }

}
