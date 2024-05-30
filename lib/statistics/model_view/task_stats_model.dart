// import 'dart:async';
// import 'package:flutter/cupertino.dart';
//
// import '../../../blockchain/classes.dart';
// import '../../blockchain/task_services.dart';
// class TaskStatsModel extends ChangeNotifier {
//   final TasksServices tasksServices;
//
//   TaskStatsModel(this.tasksServices) {
//     tasksServices.addListener(_onTaskStatsUpdated);
//     tasksServices.startFetchingTaskStats();
//   }
//
//   TaskStats? get taskStats => tasksServices.taskStats;
//
//   void _onTaskStatsUpdated() {
//     notifyListeners();
//   }
//
//   @override
//   void dispose() {
//     tasksServices.removeListener(_onTaskStatsUpdated);
//     super.dispose();
//   }
// }