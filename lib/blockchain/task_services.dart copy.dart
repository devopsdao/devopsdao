// import 'dart:math';
//
// import 'package:beamer/beamer.dart';
// import 'package:dodao/blockchain/task_services.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:isolate_manager/isolate_manager.dart';
// import 'package:provider/provider.dart';
// import 'package:webthree/credentials.dart';
//
// import '../config/theme.dart';
// import '../config/utils/platform.dart';
// import '../main.dart';
// import '../navigation/beamer_delegate.dart';
// import '../wallet/model_view/mm_model.dart';
// import '../wallet/model_view/wallet_model.dart';
// import '../wallet/services/wallet_service.dart';
// import 'abi/IERC20.g.dart';
// import 'abi/TaskCreateFacet.g.dart';
// import 'abi/TaskDataFacet.g.dart';
// import 'abi/TaskStatsFacet.g.dart';
// import 'classes.dart';
//
// class TasksServices extends ChangeNotifier {
//
//   Future<void> initTaskStats() async {
//     const int batchSize = 50;
//     const int maxSimultaneousRequests = 10;
//
//     int offset = 0;
//     int taskCount = (await taskDataFacet.getTaskContractsCount()).toInt();
//
//     log.info('Total task count: $taskCount');
//
//     BigInt countNew = BigInt.zero;
//     BigInt countAgreed = BigInt.zero;
//
//     while (offset < taskCount) {
//       int limit = min(batchSize, taskCount - offset);
//       List<Future<dynamic>> futures = [];
//       int remainingTasks = taskCount - offset;
//
//       for (int i = 0; i < maxSimultaneousRequests && remainingTasks > 0; i++) {
//         int currentLimit = min(limit, remainingTasks);
//         futures.add(taskStatsFacet.getTaskStatsWithTimestamps(BigInt.from(offset), BigInt.from(currentLimit)));
//         remainingTasks -= currentLimit;
//         offset += currentLimit;
//       }
//
//       List<dynamic> results = await Future.wait(futures);
//
//       for (dynamic result in results) {
//         countNew += result[0];
//         countAgreed += result[1];
//       }
//       await Future.delayed(const Duration(milliseconds: 201));
//     }
//
//     _taskStats = TaskStats(
//         countNew: countNew,
//         countAgreed: countAgreed,
//     );
//     notifyListeners();
//   }
// }
//
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await DodaoTheme.initialize();
//
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => TasksServices(),),
//       ],
//       child: MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatefulWidget {
//   @override
//   State<MyApp> createState() => _MyAppState();
//
//   static _MyAppState of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>()!;
// }
//
// class _MyAppState extends State<MyApp> {
//   bool displaySplashImage = true;
//   var tasksServices = context.read<TasksServices>();
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       try {
//         await tasksServices.initTaskStats();
//       } catch (e) {
//         log.severe('MyApp->initState->initTaskStats error: $e');
//       }
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//         create: (_) => ModelTheme(),
//         child: Consumer<ModelTheme>(
//             builder: (context, ModelTheme themeNotifier, child) {
//               return MaterialApp.router(
//                 theme:  ThemeData(),
//               );
//             }
//         ));
//   }
// }
//
//
// Future<TaskStats> initTaskStats(batchSize) async {
//   const int maxSimultaneousRequests = 10;
//
//   int offset = 0;
//   int taskCount = (await ContractConnector.taskDataFacet.getTaskContractsCount()).toInt();
//   BigInt countNew = BigInt.zero;
//   BigInt countAgreed = BigInt.zero;
//   BigInt countProgress = BigInt.zero;
//
//   while (offset < taskCount) {
//     int limit = min(batchSize, taskCount - offset);
//     List<Future<dynamic>> futures = [];
//     int remainingTasks = taskCount - offset;
//     for (int i = 0; i < maxSimultaneousRequests && remainingTasks > 0; i++) {
//       int currentLimit = min(limit, remainingTasks);
//       futures.add(ContractConnector.taskStatsFacet.getTaskStatsWithTimestamps(BigInt.from(offset), BigInt.from(currentLimit)));
//       remainingTasks -= currentLimit;
//       offset += currentLimit;
//     }
//     List<dynamic> results = await Future.wait(futures);
//     for (dynamic result in results) {
//       countNew += result[0];
//       countAgreed += result[1];
//       countProgress += result[2];
//
//     }
//     await Future.delayed(const Duration(milliseconds: 201));
//   }
//
//   return TaskStats(
//       countNew: countNew,
//       countAgreed: countAgreed,
//       countProgress: countProgress,
//   );
// }
