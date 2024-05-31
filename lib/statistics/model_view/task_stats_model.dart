import 'dart:async';
import 'package:flutter/cupertino.dart';

import '../../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';
//
// abstract class TaskStatsDelegate {
//   void onTaskStatsUpdated();
// }
//
// class TaskStatsModel extends ChangeNotifier implements TaskStatsDelegate {
//   final TasksServices tasksServices;
//
//   TaskStatsModel(this.tasksServices) {
//     tasksServices.addListener(_onTaskStatsUpdated);
//     // run();
//   }
//
//   // void run() async {
//   //   await Future.doWhile(() => Future.delayed(const Duration(milliseconds: 500)).then((_) {
//   //     print('wait: contracts initializing 22223123');
//   //     return !tasksServices.contractsInitialized;
//   //   }));
//   //   tasksServices.startFetchingTaskStats();
//   // }
//
//   TaskStats? get taskStats => tasksServices.taskStats;
//
//   void _onTaskStatsUpdated() {
//     notifyListeners();
//   }
//
//   @override
//   void onTaskStatsUpdated() {
//     _onTaskStatsUpdated();
//   }
//
//   @override
//   void dispose() {
//     tasksServices.removeListener(_onTaskStatsUpdated);
//     super.dispose();
//   }
// }


class TaskStatsModel extends ChangeNotifier {
  List<double> _itemWidths = [];

  List<double> get itemWidths => _itemWidths;

  void updateItemWidths(List<double> newWidths) {
    _itemWidths = newWidths;
    notifyListeners();
  }
}