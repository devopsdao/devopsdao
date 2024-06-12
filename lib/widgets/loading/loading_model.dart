import 'dart:async';
import 'package:flutter/cupertino.dart';

import '../../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';

abstract class LoadingDelegate {
  void onLoadingUpdated();
}

class LoadingModel extends ChangeNotifier implements LoadingDelegate {
  // final TasksServices tasksServices;

  // LoadingModel(this.tasksServices) {
  //   tasksServices.addListener(_onLoadingUpdated);
  //   // run();
  // }

  // void run() async {
  //   await Future.doWhile(() => Future.delayed(const Duration(milliseconds: 500)).then((_) {
  //     print('wait: contracts initializing 22223123');
  //     return !tasksServices.contractsInitialized;
  //   }));
  //   tasksServices.startFetchingTaskStats();
  // }

  // TaskStats? get taskStats => tasksServices.taskStats;

  double getLoadingProgress(int loaded, int total) {
    if (total == 0) {
      return 0.0;
    }
    return loaded / total;
  }

  void _onLoadingUpdated() {
    notifyListeners();
  }

  @override
  void onLoadingUpdated() {
    _onLoadingUpdated();
  }

  // @override
  // void dispose() {
  //   tasksServices.removeListener(_onLoadingUpdated);
  //   super.dispose();
  // }
}