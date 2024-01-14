import 'package:animations/animations.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../blockchain/classes.dart';
import '../config/theme.dart';
import '../task_item/task_item.dart';
import 'main.dart';

class TaskTransition extends StatelessWidget {
  final String fromPage;
  final Task task;
  const TaskTransition({Key? key, required this.fromPage, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fadeThrough,
      openColor: DodaoTheme.of(context).taskBackgroundColor,
      openElevation: DodaoTheme.of(context).elevation,
      openBuilder: (BuildContext context, VoidCallback _) {
        final String taskAddress = task.taskAddress.toString();
        RouteInformation routeInfo = RouteInformation(location: '/$fromPage/$taskAddress');
        Beamer.of(context).updateRouteInformation(routeInfo);
        return TaskDialogFuture(
            fromPage: fromPage, taskAddress: task.taskAddress);
      },
      transitionDuration: const Duration(milliseconds: 400),
      closedColor: DodaoTheme.of(context).taskBackgroundColor,
      closedElevation: DodaoTheme.of(context).elevation,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return TaskItem(
          fromPage: fromPage,
          object: task,
        );
      },
    );
  }
}


// class TaskTransitionFromLastActivities extends StatelessWidget {
//   final String fromPage;
//   final Task task;
//   const TaskTransitionFromLastActivities({Key? key, required this.fromPage, required this.task}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return OpenContainer(
//       transitionType: ContainerTransitionType.fadeThrough,
//       openColor: DodaoTheme.of(context).taskBackgroundColor,
//       openElevation: DodaoTheme.of(context).elevation,
//       openBuilder: (BuildContext context, VoidCallback _) {
//         final String taskAddress = task.taskAddress.toString();
//         RouteInformation routeInfo = RouteInformation(location: '/$fromPage/$taskAddress');
//         Beamer.of(context).updateRouteInformation(routeInfo);
//         return TaskDialogFuture(
//             fromPage: fromPage, taskAddress: task.taskAddress);
//       },
//       transitionDuration: const Duration(milliseconds: 400),
//       closedColor: DodaoTheme.of(context).taskBackgroundColor,
//       closedElevation: DodaoTheme.of(context).elevation,
//       closedShape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(Radius.circular(18)),
//       ),
//       closedBuilder: (BuildContext context, VoidCallback openContainer) {
//         return TaskItem(
//           fromPage: fromPage,
//           object: task,
//         );
//       },
//     );
//   }
// }
//
// class LoadTaskByLink extends StatelessWidget {
//   final String fromPage;
//   final EthereumAddress? taskAddress;
//   const LoadTaskByLink({Key? key, required this.fromPage, required this.taskAddress}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // var tasksServices = context.watch<TasksServices>();
//     return OpenContainer(
//       transitionType: ContainerTransitionType.fadeThrough,
//       openColor: DodaoTheme.of(context).taskBackgroundColor,
//       openBuilder: (BuildContext context, VoidCallback _) {
//         final String taskAddressString = taskAddress.toString();
//         RouteInformation routeInfo = RouteInformation(location: '/$fromPage/$taskAddressString');
//         Beamer.of(context).updateRouteInformation(routeInfo);
//         return TaskDialogFuture(fromPage: fromPage, taskAddress: taskAddress);
//       },
//       transitionDuration: const Duration(milliseconds: 400),
//       closedElevation: 0,
//       closedShape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(
//           Radius.circular(10.0),
//         ),
//       ),
//       openElevation: 0,
//       closedColor: Colors.transparent,
//       closedBuilder: (BuildContext context, VoidCallback openContainer) {
//         return const AppDataLoadingDialogWidget();
//       },
//     );
//   }
// }
