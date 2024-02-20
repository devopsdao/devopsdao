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