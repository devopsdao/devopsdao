import 'package:animations/animations.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webthree/credentials.dart';

import '../../blockchain/accounts.dart';
import '../../blockchain/interface.dart';
import '../../blockchain/task_services.dart';
import '../../config/theme.dart';
import '../../task_dialog/contractor_info.dart';
import 'account_item.dart';
import '../../widgets/data_loading_dialog.dart';
import '../../task_item/task_item.dart';
import '../../account_dialog/widget/main.dart';

class ClickOnAccountFromIndexedList extends StatelessWidget {
  final String fromPage;
  // final int index;
  final Account account;
  const ClickOnAccountFromIndexedList({
    Key? key,
    required this.fromPage,
    // required this.index,
    required this.account,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fadeThrough,
      openColor: DodaoTheme.of(context).taskBackgroundColor,
      openElevation: DodaoTheme.of(context).elevation,
      openBuilder: (BuildContext context, VoidCallback _) {
        // RouteInformation routeInfo = RouteInformation(location: '/$fromPage/$taskAddress');
        // Beamer.of(context).updateRouteInformation(routeInfo);
        return AccountFuture(
          fromPage: fromPage,
          account: account,
          shimmerEnabled: true,
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
      closedColor: DodaoTheme.of(context).taskBackgroundColor,
      closedElevation: DodaoTheme.of(context).elevation,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return AccountItem(
            fromPage: fromPage,
            account: account,
          );
        }
      // },
    );
  }
}

class ClickOnAccount extends StatelessWidget {
  // final String fromPage;
  final int index;
  // final Map<String, Account> accountsList;
  const ClickOnAccount({
    Key? key,
    // required this.fromPage,
    required this.index,
    // required this.accountsList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final String fromPage = fromPage;
    // final int index = index;
    var interface = context.read<InterfaceServices>();
    return OpenContainer(
      transitionType: ContainerTransitionType.fadeThrough,
      openColor: DodaoTheme.of(context).taskBackgroundColor,
      openElevation: DodaoTheme.of(context).elevation,
      // transitionType: _transitionType2,
      openBuilder: (BuildContext context, VoidCallback _) {
        // final String taskAddress = accountsList.values.toList()[index].walletAddress.toString();
        // RouteInformation routeInfo = RouteInformation(location: '/$fromPage/$taskAddress');
        // Beamer.of(context).updateRouteInformation(routeInfo);
        return AccountFuture(
          fromPage: 'participants',
          account: interface.selectedUser,
          shimmerEnabled: true,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      closedColor: DodaoTheme.of(context).taskBackgroundColor,
      closedElevation: DodaoTheme.of(context).elevation,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      closedBuilder: (BuildContext context, VoidCallback openContainer) {

        return const Padding(
          padding: EdgeInsets.all(12.0),
          child: ContractorInfo(
            // account: interface.selectedUser,
          ),
        );
      },
    );
  }
}

