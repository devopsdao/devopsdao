
import 'package:animations/animations.dart';
import 'package:beamer/beamer.dart';
import 'package:devopsdao/widgets/tags/tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';

import '../blockchain/task_services.dart';
import '../widgets/task_item.dart';
import 'main_as_page.dart';



class ClickOnTask extends StatefulWidget {
  final String fromPage;
  final int index;
  const ClickOnTask({Key? key,
    required this.fromPage,
    required this.index
  }) : super(key: key);
  @override
  _ClickOnTaskState createState() => _ClickOnTaskState();
}

class _ClickOnTaskState extends State<ClickOnTask> {


  final ContainerTransitionType _transitionType2 = ContainerTransitionType.fadeThrough;

  @override
  Widget build(BuildContext context) {
    final String fromPage = widget.fromPage;
    final int index = widget.index;

    var tasksServices = context.watch<TasksServices>();
    return OpenContainer(
      transitionType: _transitionType2,
      openBuilder: (BuildContext context, VoidCallback _) {
        final String taskAddress =
        tasksServices.filterResults.values.toList()[index].taskAddress.toString();
        RouteInformation routeInfo = RouteInformation(location: '/$fromPage/$taskAddress');
        Beamer.of(context).updateRouteInformation(routeInfo);
        return TaskInformationFuture(
            fromPage: fromPage, taskAddress: tasksServices.filterResults.values.toList()[index].taskAddress, shimmerEnabled: true);
      },
      transitionDuration: const Duration(milliseconds: 400),
      closedElevation: 0,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      openElevation: 0,
      closedColor: Colors.white,
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return TaskItem(
          fromPage: fromPage,
          object: tasksServices.filterResults.values.toList()[index],
        );
      },
    );
  }
}

