import 'dart:async';
import 'package:flutter/cupertino.dart';

import '../../../blockchain/classes.dart';
import '../services/value_input_service.dart';

// model - service:
// get -> read
// set -> write
// on -> init
// ... -> check (logic with bool return(not bool stored data))


class ValueInputModelState {
  bool initialized = false;
  Map<String, Map<String, BigInt>> initialEmptyBalance = {};

  ValueInputModelState({
    required this.initialized,
    required this.initialEmptyBalance,
  });
}

class ValueInputModel extends ChangeNotifier {
  final _valueInputService = ValueInputService();

  var _state = ValueInputModelState(
    initialized: false,
    initialEmptyBalance: {},
  );
  ValueInputModelState get state => _state;
  StreamSubscription<List<TokenItem>>? tagSubscription;

  ValueInputModel() {
    ValueInputModelState(
      initialized: false,
      initialEmptyBalance: _valueInputService.initialEmptyBalance,
    );
  }

  void subscribeToValueInput () {
    _state = ValueInputModelState(
      initialized: true,
      initialEmptyBalance: _valueInputService.initialEmptyBalance,
    );
    notifyListeners();
  }

  void unsubscribeValueInput () {
    tagSubscription!.cancel();
  }

  Future<void> onRequestBalances(int chainId, tasksServices) async {
    _valueInputService.initRequestBalances(chainId, tasksServices);
  }

  // void _updateState() {
  //   bool initialized = _state.initialized;
  //   _state = ValueInputModelState(
  //     initialized: initialized,
  //     tags: [],
  //     initialEmptyBalance:
  //   );
  //   notifyListeners();
  // }
}
