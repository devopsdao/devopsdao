import 'package:beamer/beamer.dart';
import 'package:dodao/task_dialog/widget/auditor_decision_alert.dart';
import 'package:dodao/task_dialog/widget/dialog_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:throttling/throttling.dart';

import '../blockchain/interface.dart';
import '../blockchain/classes.dart';
import '../blockchain/task_services.dart';
import '../widgets/wallet_action_dialog.dart';

class SetsOfFabButtons extends StatelessWidget {
  final Task task;
  final String fromPage;

  SetsOfFabButtons({
    Key? key,
    required this.task,
    required this.fromPage,
  }) : super(key: key);

  late Debouncing debounceNotifyListener = Debouncing(duration: const Duration(milliseconds: 1700));

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.read<TasksServices>();
    var interface = context.read<InterfaceServices>();
    // String message = interface.taskMessage.text;

    final double buttonWidth = MediaQuery.of(context).viewInsets.bottom == 0 ? 600 : 120; // Keyboard is here?
    final double buttonWidthLong = MediaQuery.of(context).viewInsets.bottom == 0 ? 600 : 160; // Keyboard is here?

    return Builder(builder: (context) {
      // ##################### ACTION BUTTONS PART ######################## //
      // ************************ NEW (EXCHANGE) ************************** //
      if (fromPage == 'tasks') {
        return TaskDialogFAB(
          inactive: (task.contractOwner != tasksServices.publicAddress || tasksServices.hardhatDebug == true) &&
                  tasksServices.validChainID &&
                  tasksServices.publicAddress != null
              ? false
              : true,
          expand: true,
          buttonName: 'Participate',
          buttonColorRequired: Colors.lightBlue.shade300,
          widthSize: buttonWidth,
          callback: () {
            task.justLoaded = false;
            tasksServices.taskParticipate(task.taskAddress, task.nanoId, message: interface.taskMessage.isEmpty ? null : interface.taskMessage);
            Navigator.pop(context);
            interface.emptyTaskMessage();
            RouteInformation routeInfo = const RouteInformation(location: '/tasks');
            Beamer.of(context).updateRouteInformation(routeInfo);

            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => WalletActionDialog(
                      nanoId: task.nanoId,
                      taskName: 'taskParticipate',
                    ));
          },
        );
      } else if (task.taskState == "agreed" && (fromPage == 'performer' || tasksServices.hardhatDebug == true)) {
        // ********************** PERFORMER BUTTONS ************************* //
        return TaskDialogFAB(
          inactive: false,
          expand: true,
          buttonName: 'Start the task',
          buttonColorRequired: Colors.lightBlue.shade300,
          widthSize: buttonWidthLong,
          callback: () {
            task.justLoaded = false;
            tasksServices.taskStateChange(task.taskAddress, task.performer, 'progress', task.nanoId,
                message: interface.taskMessage.isEmpty ? null : interface.taskMessage);
            Navigator.pop(context);
            interface.emptyTaskMessage();
            RouteInformation routeInfo = const RouteInformation(location: '/performer');
            Beamer.of(context).updateRouteInformation(routeInfo);

            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => WalletActionDialog(
                      nanoId: task.nanoId,
                      taskName: 'taskStateChange',
                    ));
          },
        );
      } else if (task.taskState == "progress" && (fromPage == 'performer' || tasksServices.hardhatDebug == true)) {
        return TaskDialogFAB(
          inactive: false,
          expand: true,
          buttonName: 'Submit for Review',
          buttonColorRequired: Colors.lightBlue.shade300,
          widthSize: buttonWidthLong,
          callback: () {
            task.justLoaded = false;
            tasksServices.taskStateChange(task.taskAddress, task.performer, 'review', task.nanoId,
                message: interface.taskMessage.isEmpty ? null : interface.taskMessage);
            Navigator.pop(context);
            interface.emptyTaskMessage();
            RouteInformation routeInfo = const RouteInformation(location: '/performer');
            Beamer.of(context).updateRouteInformation(routeInfo);
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => WalletActionDialog(
                      nanoId: task.nanoId,
                      taskName: 'taskStateChange',
                    ));
          },
        );
      } else if ((task.taskState == "review" && fromPage == 'performer') &&
          (tasksServices.transactionStatuses[task.nanoId] == null ||
              tasksServices.transactionStatuses[task.nanoId]?['postWitnetRequest'] == null ||
              tasksServices.transactionStatuses[task.nanoId]?['postWitnetRequest']!['witnetGetLastResult'][2] != "closed") &&
          task.repository.isNotEmpty) {
        return TaskDialogFAB(
          inactive: false,
          expand: true,
          buttonName: 'Check merge',
          buttonColorRequired: Colors.lightBlue.shade300,
          widthSize: buttonWidthLong,
          callback: () {
            // interface.statusText = const TextSpan(text: 'Checking ...', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green));
            // // tasksServices.myNotifyListeners();
            tasksServices.postWitnetRequest(task.taskAddress, task.nanoId);
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => WalletActionDialog(
                      nanoId: task.nanoId,
                      taskName: 'postWitnetRequest',
                    ));
            // interface.statusText = TextSpan(text: response.toString(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black));
            //
            // debounceNotifyListener.debounce(() {
            //   interface.statusText = TextSpan(text: response.toString(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black));
            //   tasksServices.myNotifyListeners();
            // });
          },
        );
      } else if ((task.taskState == "review" && fromPage == 'performer') &&
          tasksServices.transactionStatuses[task.nanoId]?['postWitnetRequest']!['witnetGetLastResult'][2] == 'closed') {
        return TaskDialogFAB(
          inactive: false,
          expand: true,
          buttonName: 'Complete Task',
          buttonColorRequired: Colors.lightBlue.shade300,
          widthSize: buttonWidthLong,
          callback: () {
            // interface.statusText = const TextSpan(text: 'Checking ...', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green));
            // // tasksServices.myNotifyListeners();
            tasksServices.saveSuccessfulWitnetResult(task.taskAddress);
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => WalletActionDialog(
                      nanoId: task.nanoId,
                      taskName: 'saveLastWitnetResult',
                    ));
            // interface.statusText = TextSpan(text: response.toString(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black));
            //
            // debounceNotifyListener.debounce(() {
            //   interface.statusText = TextSpan(text: response.toString(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black));
            //   tasksServices.myNotifyListeners();
            // });
          },
        );
      } else if (task.taskState == "completed" && (fromPage == 'performer' || tasksServices.hardhatDebug == true)) {
        return TaskDialogFAB(
          inactive: (task.tokenBalances.isNotEmpty) ? false : true,
          expand: true,
          buttonName: 'Withdraw',
          buttonColorRequired: Colors.lightBlue.shade300,
          widthSize: buttonWidth,
          callback: () {
            task.justLoaded = false;
            tasksServices.withdrawToChain(task.taskAddress, task.nanoId);
            Navigator.pop(context);
            interface.emptyTaskMessage();
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => WalletActionDialog(
                      nanoId: task.nanoId,
                      taskName: 'withdrawToChain',
                    ));
          },
          task: task,
        );
      }
      // *********************** CUSTOMER BUTTONS *********************** //
      else if (task.taskState == 'review' && (fromPage == 'customer' || tasksServices.hardhatDebug == true)) {
        return TaskDialogFAB(
          inactive: false,
          expand: true,
          buttonName: 'Sign Review',
          buttonColorRequired: Colors.lightBlue.shade300,
          widthSize: buttonWidthLong,
          callback: () {
            task.justLoaded = false;
            tasksServices.taskStateChange(task.taskAddress, task.performer, 'completed', task.nanoId,
                message: interface.taskMessage.isEmpty ? null : interface.taskMessage);
            // context.beamToNamed('/customer');
            Navigator.pop(context);
            interface.emptyTaskMessage();
            RouteInformation routeInfo = const RouteInformation(location: '/customer');
            Beamer.of(context).updateRouteInformation(routeInfo);
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => WalletActionDialog(
                      nanoId: task.nanoId,
                      taskName: 'taskStateChange',
                    ));
          },
        );
      } else if (task.taskState == 'completed' && (fromPage == 'customer' || tasksServices.hardhatDebug == true)) {
        return TaskDialogFAB(
          inactive: false,
          expand: true,
          buttonName: 'Rate task',
          buttonColorRequired: Colors.lightBlue.shade300,
          widthSize: buttonWidth,
          callback: () {
            (task.rating == 0)
                ? () {
                    task.justLoaded = false;
                    // tasksServices.rateTask(
                    //     task.taskAddress, ratingScore, task.nanoId);
                    Navigator.pop(context);
                    interface.emptyTaskMessage();
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => WalletActionDialog(
                              nanoId: task.nanoId,
                              taskName: 'rateTask',
                            ));
                  }
                : null;
          },
        );
      }
      // ************************* AUDITOR BUTTONS ************************ //
      else if (interface.dialogCurrentState['name'] == 'auditor-new' || tasksServices.hardhatDebug == true) {
        return TaskDialogFAB(
          inactive: false,
          expand: true,
          buttonName: 'Take audit',
          buttonColorRequired: Colors.lightBlue.shade300,
          widthSize: buttonWidth,
          callback: () {
            task.justLoaded = false;
            tasksServices.taskAuditParticipate(task.taskAddress, task.nanoId, message: interface.taskMessage.isEmpty ? null : interface.taskMessage);
            Navigator.pop(context);
            interface.emptyTaskMessage();
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => WalletActionDialog(
                      nanoId: task.nanoId,
                      taskName: 'taskAuditParticipate',
                    ));
          },
        );
      } else if (interface.dialogCurrentState['name'] == 'auditor-performing' || tasksServices.hardhatDebug == true) {
        return TaskDialogFAB(
          inactive: false,
          expand: true,
          buttonName: interface.dialogCurrentState['mainButtonName'],
          buttonColorRequired: Colors.lightBlue.shade300,
          widthSize: buttonWidth,
          callback: () {
            showDialog(context: context, builder: (context) => AuditorDecision(task: task));
          },
        );
      } else {
        return const Center();
      }
    });
  }
}
