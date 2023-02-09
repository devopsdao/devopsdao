
import 'package:animations/animations.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:webthree/credentials.dart';

import '../blockchain/task_services.dart';
import '../widgets/account_item.dart';
import '../widgets/data_loading_dialog.dart';
import '../task_item/task_item.dart';
import 'main.dart';
import 'shimmer.dart';



class ClickOnTask extends StatelessWidget {
  final String fromPage;
  final int index;
  const ClickOnTask({Key? key,
    required this.fromPage,
    required this.index
  }) : super(key: key);



  final ContainerTransitionType _transitionType2 = ContainerTransitionType.fadeThrough;

  @override
  Widget build(BuildContext context) {
    // final String fromPage = fromPage;
    // final int index = index;

    var tasksServices = context.watch<TasksServices>();
    return OpenContainer(
      transitionType: _transitionType2,
      openBuilder: (BuildContext context, VoidCallback _) {
        final String taskAddress =
        tasksServices.filterResults.values.toList()[index].taskAddress.toString();
        RouteInformation routeInfo = RouteInformation(location: '/$fromPage/$taskAddress');
        Beamer.of(context).updateRouteInformation(routeInfo);
        return TaskDialogFuture(
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

class ClickOnAccount extends StatelessWidget {
  final String fromPage;
  final int index;
  const ClickOnAccount({Key? key,
    required this.fromPage,
    required this.index
  }) : super(key: key);



  final ContainerTransitionType _transitionType2 = ContainerTransitionType.fadeThrough;

  @override
  Widget build(BuildContext context) {
    // final String fromPage = fromPage;
    // final int index = index;

    var tasksServices = context.watch<TasksServices>();
    return OpenContainer(
      transitionType: _transitionType2,
      openBuilder: (BuildContext context, VoidCallback _) {
        final String taskAddress =
        tasksServices.filterResults.values.toList()[index].taskAddress.toString();
        RouteInformation routeInfo = RouteInformation(location: '/$fromPage/$taskAddress');
        Beamer.of(context).updateRouteInformation(routeInfo);
        return TaskDialogFuture(
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
        return AccountItem(
          fromPage: fromPage,
          object: tasksServices.filterResults.values.toList()[index],
        );
      },
    );
  }
}

class LoadTaskByLink extends StatelessWidget {
  final String fromPage;
  final EthereumAddress? taskAddress;
  const LoadTaskByLink({Key? key,
    required this.fromPage,
    required this.taskAddress
  }) : super(key: key);



  final ContainerTransitionType _transitionType2 = ContainerTransitionType.fadeThrough;

  @override
  Widget build(BuildContext context) {
    // final String fromPage = fromPage;
    // final int index = index;

    var tasksServices = context.watch<TasksServices>();
    return OpenContainer(
      transitionType: _transitionType2,
      openBuilder: (BuildContext context, VoidCallback _) {
        final String taskAddressString = taskAddress.toString();
        RouteInformation routeInfo = RouteInformation(location: '/$fromPage/$taskAddressString');
        Beamer.of(context).updateRouteInformation(routeInfo);
        return TaskDialogFuture(
            fromPage: fromPage, taskAddress: taskAddress, shimmerEnabled: true);
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
        return const AppDataLoadingDialogWidget();
      },
    );
  }
}

