import 'dart:async';
import 'package:flutter/cupertino.dart';

import '../../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';

abstract class LoadingDelegate {
  void onTaskLoadingUpdated(int loaded, int total);
  void onLoadingPublicStats(int loaded, int total);
  void onTaskPreparationUpdated(int loaded, int total);
}

class LoadingModel extends ChangeNotifier implements LoadingDelegate {
  // final TasksServices tasksServices;

  // LoadingModel(this.tasksServices) {
  //   tasksServices.addListener(_onTaskLoadingUpdated);
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



  int loadedOverAllStats = 0;
  int totalOverAllStats = 0;
  void _onLoadingPublicStats(int loaded, int total) {
    loadedOverAllStats = loaded;
    totalOverAllStats = total;
    notifyListeners();
  }
  @override
  void onLoadingPublicStats(int loaded, int total) {
    _onLoadingPublicStats(loaded,total);
  }
  double getPublicStatsLoadingProgress(int loaded, int total) {
    if (total == 0) {
      return 0.0;
    }
    return loaded / total;
  }


  int loadedTasks = 0;
  int totalTasks = 0;
  @override
  void onTaskLoadingUpdated(int loaded, int total) {
    loadedTasks = loaded;
    totalTasks = total;
    _onTaskLoadingUpdated();
  }
  void _onTaskLoadingUpdated() {
    notifyListeners();
  }
  double getLoadingProgress(int loaded, int total) {
    if (total == 0) {
      return 0.0;
    }
    return loaded / total;
  }

  int preparedTasks = 0;
  int totalPreparedTasks = 0;
  @override
  void onTaskPreparationUpdated(int loaded, int total) {
    preparedTasks = loaded;
    totalPreparedTasks = total;
    _onTaskPreparationUpdated();
  }
  void _onTaskPreparationUpdated() {
    notifyListeners();
  }

  // @override
  // void dispose() {
  //   tasksServices.removeListener(_onTaskLoadingUpdated);
  //   super.dispose();
  // }
}