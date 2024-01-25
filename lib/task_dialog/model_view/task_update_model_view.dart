import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:webthree/credentials.dart';

import '../../blockchain/classes.dart';
import '../../blockchain/empty_classes.dart';
import '../services/task_update_service.dart';

class TaskUpdateModelViewState {
  EthereumAddress currentTaskOpened;

  TaskUpdateModelViewState({
    required this.currentTaskOpened
  });
}

class TaskUpdateModelView extends ChangeNotifier {
  final _taskUpdateService = TaskUpdateService();

  // /// State update:
  // var _state = TaskUpdateModelViewState(
  //   currentTaskOpened: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
  // );
  //
  // TaskUpdateModelViewState get state => _state;
  StreamSubscription<EthereumAddress>? taskSubscription;

  // void _updateState() {
  //   _state = TaskUpdateModelViewState(
  //     currentTaskOpened: _emptyClasses.emptyTask,
  //   );
  //   notifyListeners();
  // }

  Future<void> onOpenedTask(EthereumAddress taskAddress) async {
    _taskUpdateService.saveOpenedTaskAddress(taskAddress);
  }

  void subscribeToTaskUpdate () {
    taskSubscription = _taskUpdateService.taskItems.listen((data) {
      notifyListeners();
    });
  }

  void unsubscribeTaskUpdate () {
    taskSubscription!.cancel();
  }
}