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
import 'account_item_shimmer.dart'; // Import the AccountItemShimmer

class ClickOnAccountFromIndexedList extends StatelessWidget {
  final String tabName;
  // final int index;
  final Account account;
  final int index;
  final bool isLoading; // Add a boolean flag to indicate loading state

  const ClickOnAccountFromIndexedList({
    Key? key,
    required this.tabName,
    // required this.index,
    required this.account,
    required this.index,
    this.isLoading = false, // Set a default value for isLoading
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
            accountRole: tabName,
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
          return isLoading
              ? AccountItemShimmer(
                  account: Account(
                    walletAddress: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
                    nickName: '',
                    about: '',
                    customerTasks: List.from([]),
                    customerRating: List.from([]),
                    participantTasks: List.from([]),
                    auditParticipantTasks: List.from([]),
                    performerRating: List.from([]),
                    performerAgreedTasks: List.from([]),
                    customerAgreedTasks: List.from([]),
                    auditAgreed: List.from([]),
                    auditCompleted: List.from([]),
                    performerAuditedTasks: List.from([]),
                    customerAuditedTasks: List.from([]),
                    performerCompletedTasks: List.from([]),
                    customerCompletedTasks: List.from([]),
                  ),
                ) // Show the shimmer effect if isLoading is true
              : AccountItem(tabName: tabName, account: account, index: index);
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
          accountRole: 'participants',
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
          padding: EdgeInsets.all(8.0),
          child: ContractorInfo(
              // account: interface.selectedUser,
              ),
        );
      },
    );
  }
}
