import 'package:animations/animations.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webthree/credentials.dart';

import '../blockchain/accounts.dart';
import '../blockchain/task_services.dart';
import '../widgets/account_item.dart';
import '../widgets/data_loading_dialog.dart';
import '../task_item/task_item.dart';
import 'main.dart';

class ClickOnAccount extends StatelessWidget {
  final String fromPage;
  final int index;
  const ClickOnAccount({
    Key? key,
    required this.fromPage,
    required this.index,
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
        final String taskAddress = tasksServices.accountsData.values.toList()[index].walletAddress.toString();
        RouteInformation routeInfo = RouteInformation(location: '/$fromPage/$taskAddress');
        Beamer.of(context).updateRouteInformation(routeInfo);
        return AccountFuture(
          fromPage: fromPage,
          taskAddress: tasksServices.accountsData.values.toList()[index].walletAddress,
          shimmerEnabled: true,
        );
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
          object: tasksServices.accountsData.values.toList()[index],
        );
      },
    );
  }
}
