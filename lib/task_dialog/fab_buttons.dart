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
import '../config/utils/my_tools.dart';
import '../wallet/model_view/wallet_model.dart';
import '../wallet/services/wallet_service.dart';
import '../wallet/services/wc_service.dart';
import '../wallet/widgets/main/main.dart';
import '../widgets/wallet_action_dialog.dart';
import 'model_view/task_model_view.dart';

class SetsOfFabButtons extends StatelessWidget {
  final Task task;
  final String fromPage;

  SetsOfFabButtons({
    Key? key,
    required this.task,
    required this.fromPage,
  }) : super(key: key);

  // late Debouncing debounceNotifyListener = Debouncing(duration: const Duration(milliseconds: 1700));

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.read<TasksServices>();
    var interface = context.watch<InterfaceServices>();
    var taskModelView = context.watch<TaskModelView>();
    final listenAllowedChainId = context.select((WalletModel vm) => vm.state.allowedChainId);
    final listenWalletAddress = context.select((WalletModel vm) => vm.state.walletAddress);
    bool keyboardOnScreen = false;

    if (MediaQuery.of(context).viewInsets.bottom == 0) {
      keyboardOnScreen = true;
    } else {
      keyboardOnScreen = false;
    }

    final double buttonWidth = keyboardOnScreen ? 600 : 36; // Keyboard is here?
    final double buttonWidthLong = keyboardOnScreen ? 600 : 36; // Keyboard is here?

    return Builder(builder: (context) {
      // ##################### ACTION BUTTONS PART ######################## //
      // ************************ NEW (EXCHANGE) ************************** //
      if (fromPage == 'tasks') {
        return listenWalletAddress != null ? TaskDialogFAB(
          inactive: (task.contractOwner != listenWalletAddress || tasksServices.hardhatDebug == true) &&
              listenAllowedChainId &&
                  listenWalletAddress != null
              ? false
              : true,
          expand: true,
          buttonName: 'Participate',
          buttonColorRequired: Colors.lightBlue.shade300,
          widthSize: buttonWidth + calcTextSize('Participate', const TextStyle(fontSize: 18)).width,
          callback: () {
            task.loadingIndicator = true;
            String message = '[performer application] ${interface.taskMessage}';
            tasksServices.taskParticipate(task.taskAddress, task.nanoId, message: message);
            Navigator.pop(context);
            interface.emptyTaskMessage();
            RouteInformation routeInfo = const RouteInformation(location: '/tasks');
            Beamer.of(context).updateRouteInformation(routeInfo);

            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => WalletActionDialog(
                      nanoId: task.nanoId,
                      actionName: 'taskParticipate',
                    ));
          },
        ) : TaskDialogConnectWallet(
          buttonName: 'Connect wallet',
          widthSize: buttonWidth + calcTextSize('Connect wallet', const TextStyle(fontSize: 18)).width,
          callback: () {
            showDialog(
              context: context,
              builder: (context) => const WalletDialog(),
            );
          },
        );
      } else if (task.taskState == "agreed" && (fromPage == 'performer' || tasksServices.hardhatDebug == true)) {
        // ********************** PERFORMER BUTTONS ************************* //
        return TaskDialogFAB(
          inactive: false,
          expand: true,
          buttonName: 'Start the task',
          buttonColorRequired: Colors.lightBlue.shade300,
          widthSize: buttonWidthLong + calcTextSize('Start the task', const TextStyle(fontSize: 18)).width,
          callback: () {
            task.loadingIndicator = true;

            String message = '[in progress] ${interface.taskMessage}';
            tasksServices.taskStateChange(task.taskAddress, task.performer, 'progress', task.nanoId,
                message: message);
            Navigator.pop(context);
            interface.emptyTaskMessage();
            RouteInformation routeInfo = const RouteInformation(location: '/performer');
            Beamer.of(context).updateRouteInformation(routeInfo);

            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => WalletActionDialog(
                      nanoId: task.nanoId,
                      actionName: 'taskStateChange',
                    ));
          },
        );
      } else if (task.taskState == "progress" && (fromPage == 'performer' || tasksServices.hardhatDebug == true)) {
        return TaskDialogFAB(
          inactive: false,
          expand: true,
          buttonName: 'Submit for Review',
          buttonColorRequired: Colors.lightBlue.shade300,
          widthSize: buttonWidthLong  + calcTextSize('Submit for Review', const TextStyle(fontSize: 18)).width,
          callback: () {
            task.loadingIndicator = true;
            String message = '[sent to review] ${interface.taskMessage}';
            tasksServices.taskStateChange(task.taskAddress, task.performer, 'review', task.nanoId,
                message: message);
            Navigator.pop(context);
            interface.emptyTaskMessage();
            RouteInformation routeInfo = const RouteInformation(location: '/performer');
            Beamer.of(context).updateRouteInformation(routeInfo);
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => WalletActionDialog(
                      nanoId: task.nanoId,
                      actionName: 'taskStateChange',
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
          widthSize: buttonWidthLong + calcTextSize('Check merge', const TextStyle(fontSize: 18)).width,
          callback: () {
            // interface.statusText = const TextSpan(text: 'Checking ...', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green));
            // // tasksServices.myNotifyListeners();
            tasksServices.postWitnetRequest(task.taskAddress, task.nanoId);
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => WalletActionDialog(
                      nanoId: task.nanoId,
                      actionName: 'postWitnetRequest',
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
          tasksServices.transactionStatuses[task.nanoId]?['postWitnetRequest']?['witnetGetLastResult'][2] == 'closed') {
        return TaskDialogFAB(
          inactive: false,
          expand: true,
          buttonName: 'Complete Task',
          buttonColorRequired: Colors.lightBlue.shade300,
          widthSize: buttonWidthLong + calcTextSize('Complete Task', const TextStyle(fontSize: 18)).width,
          callback: () {
            // interface.statusText = const TextSpan(text: 'Checking ...', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green));
            // // tasksServices.myNotifyListeners();
            task.loadingIndicator = true;
            tasksServices.saveSuccessfulWitnetResult(task.taskAddress, task.nanoId);
            Navigator.pop(context);
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => WalletActionDialog(
                      nanoId: task.nanoId,
                      actionName: 'saveLastWitnetResult',
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
        String buttonText = 'Withdraw & Rate Task';
        return TaskDialogFAB(
          inactive: task.customerRating != 0 || taskModelView.state.rating == 0  ? true : false,
          expand: true,
          buttonName: buttonText,
          buttonColorRequired: Colors.lightBlue.shade300,
          widthSize: buttonWidthLong + calcTextSize(buttonText, const TextStyle(fontSize: 18)).width,
          callback: () {
            task.loadingIndicator = true;
            tasksServices.withdrawAndRate(task.taskAddress, task.nanoId, BigInt.from(taskModelView.state.rating));
            Navigator.pop(context);
            interface.emptyTaskMessage();
            RouteInformation routeInfo = const RouteInformation(location: '/performer');
            Beamer.of(context).updateRouteInformation(routeInfo);
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => WalletActionDialog(
                      nanoId: task.nanoId,
                      actionName: 'withdrawAndRate',
                    ));
          },
          task: task,
        );
      }
      // else if (task.taskState == "completed" && (fromPage == 'customer' || tasksServices.hardhatDebug == true)) {
      //   return TaskDialogFAB(
      //     inactive: false,
      //     expand: true,
      //     buttonName: 'Withdraw',
      //     buttonColorRequired: Colors.lightBlue.shade300,
      //     widthSize: buttonWidth,
      //     callback: () {
      //       task.loadingIndicator = true;
      //       tasksServices.withdrawAndRate(task.taskAddress, task.nanoId, BigInt.from(5));
      //       Navigator.pop(context);
      //       interface.emptyTaskMessage();
      //       showDialog(
      //           barrierDismissible: false,
      //           context: context,
      //           builder: (context) => WalletActionDialog(
      //             nanoId: task.nanoId,
      //             actionName: 'withdrawAndRate',
      //           ));
      //     },
      //     task: task,
      //   );
      // }
      // *********************** CUSTOMER BUTTONS *********************** //
      else if (task.taskState == 'review' && (fromPage == 'customer' || tasksServices.hardhatDebug == true)) {
        return TaskDialogFAB(
          inactive: task.performerRating != 0.0 || taskModelView.state.rating == 0 ?  true : false,
          expand: true,
          buttonName: 'Sign Review & Rate',
          buttonColorRequired: Colors.lightBlue.shade300,
          widthSize: buttonWidthLong + calcTextSize('Sign Review & Rate', const TextStyle(fontSize: 18)).width,
          callback: () {
            task.loadingIndicator = true;
            String message = '[review signed] ${interface.taskMessage}';
            tasksServices.taskStateChange(task.taskAddress, task.performer, 'completed', task.nanoId,
                message: message, score: BigInt.from(taskModelView.state.rating));
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
                actionName: 'taskStateChange',
              ));
          },
        );
      }
      else if (task.taskState == 'canceled' && (fromPage == 'customer' || tasksServices.hardhatDebug == true)) {
        bool inactiveResult = true;
        if (task.tokenBalances.isEmpty) {
          inactiveResult = false;
        } else {
          for (var tokenBalances in task.tokenBalances) {
            if (tokenBalances > 0) {
              inactiveResult = false;
            }
          }
        }
        return TaskDialogFAB(
          inactive: inactiveResult,
          expand: true,
          buttonName: 'Withdraw',
          buttonColorRequired: Colors.lightBlue.shade300,
          widthSize: buttonWidth + calcTextSize('Withdraw', const TextStyle(fontSize: 18)).width,
          callback: () {
            task.loadingIndicator = true;
            tasksServices.withdrawAndRate(task.taskAddress, task.nanoId, BigInt.from(0));
            Navigator.pop(context);
            interface.emptyTaskMessage();
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => WalletActionDialog(
                  nanoId: task.nanoId,
                  actionName: 'withdrawAndRate',
                ));
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
          widthSize: buttonWidth + calcTextSize('Take audit', const TextStyle(fontSize: 18)).width,
          callback: () {
            task.loadingIndicator = true;
            /// need to be finished:
            String message = '[auditor application] ${interface.taskMessage}';
            tasksServices.taskAuditParticipate(task.taskAddress, task.nanoId, message: message);
            Navigator.pop(context);
            interface.emptyTaskMessage();
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => WalletActionDialog(
                      nanoId: task.nanoId,
                      actionName: 'taskAuditParticipate',
                    ));
          },
        );
      } else if (interface.dialogCurrentState['name'] == 'auditor-performing' || tasksServices.hardhatDebug == true) {
        return TaskDialogFAB(
          inactive: false,
          expand: true,
          buttonName: interface.dialogCurrentState['mainButtonName'],
          buttonColorRequired: Colors.lightBlue.shade300,
          widthSize: buttonWidth + calcTextSize(interface.dialogCurrentState['mainButtonName'], const TextStyle(fontSize: 18)).width,
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
