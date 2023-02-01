import 'package:beamer/beamer.dart';
import 'package:devopsdao/task_dialog/widget/auditor_decision_alert.dart';
import 'package:devopsdao/task_dialog/widget/dialog_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:throttling/throttling.dart';

import '../blockchain/interface.dart';
import '../blockchain/task.dart';
import '../blockchain/task_services.dart';
import '../widgets/wallet_action.dart';

class DialogButtonSetOnFirstPage extends StatefulWidget {
  final Task task;
  final String fromPage;
  final double width;

  const DialogButtonSetOnFirstPage(
      {Key? key,
        required this.task,
        required this.fromPage,
        required this.width,
      })
      : super(key: key);

  @override
  _DialogButtonSetState createState() => _DialogButtonSetState();
}

class _DialogButtonSetState extends State<DialogButtonSetOnFirstPage> {

  late Debouncing debounceNotifyListener = Debouncing(duration: const Duration(milliseconds: 1700));

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.read<TasksServices>();
    var interface = context.read<InterfaceServices>();
    Task task = widget.task;
    String fromPage = widget.fromPage;
    double innerPaddingWidth = widget.width;
    // String message = interface.taskMessage.text;

    return Container(
      padding: const EdgeInsets.fromLTRB(0.0, 14.0, 0.0, 16.0),
      width: innerPaddingWidth + 8,
      child: Row(
        // direction: Axis.horizontal,
        // crossAxisAlignment: WrapCrossAlignment.start,
        children: [
          // ##################### ACTION BUTTONS PART ######################## //
          // ************************ NEW (EXCHANGE) ************************** //
          if (fromPage == 'tasks')
            TaskDialogButton(
              inactive: (task.contractOwner != tasksServices.publicAddress ||
                  tasksServices.hardhatDebug == true) &&
                  tasksServices.validChainID &&
                  tasksServices.publicAddress != null
                  ? false
                  : true,
              buttonName: 'Participate',
              buttonColorRequired: Colors.lightBlue.shade600,
              callback: () {
                setState(() {
                  task.justLoaded = false;
                });
                tasksServices.taskParticipate(task.taskAddress, task.nanoId,
                    message: interface.taskMessage.isEmpty ? null : interface.taskMessage);
                Navigator.pop(context);
                interface.emptyTaskMessage();
                RouteInformation routeInfo =
                const RouteInformation(location: '/tasks');
                Beamer.of(context).updateRouteInformation(routeInfo);

                showDialog(
                    context: context,
                    builder: (context) => WalletAction(
                      nanoId: task.nanoId,
                      taskName: 'taskParticipate',
                    ));
              },
            ),
          // ********************** PERFORMER BUTTONS ************************* //
          if (task.taskState == "agreed" &&
              (fromPage == 'performer' || tasksServices.hardhatDebug == true))
            TaskDialogButton(
              inactive: false,
              buttonName: 'Start the task',
              buttonColorRequired: Colors.lightBlue.shade600,
              callback: () {
                setState(() {
                  task.justLoaded = false;
                });
                tasksServices.taskStateChange(
                    task.taskAddress, task.participant, 'progress', task.nanoId,
                    message: interface.taskMessage.isEmpty ? null : interface.taskMessage);
                Navigator.pop(context);
                interface.emptyTaskMessage();
                RouteInformation routeInfo =
                const RouteInformation(location: '/performer');
                Beamer.of(context).updateRouteInformation(routeInfo);

                showDialog(
                    context: context,
                    builder: (context) => WalletAction(
                      nanoId: task.nanoId,
                      taskName: 'taskStateChange',
                    ));
              },
            ),
          if (task.taskState == "progress" &&
              (fromPage == 'performer' || tasksServices.hardhatDebug == true))
            TaskDialogButton(
              inactive: false,
              buttonName: 'Review',
              buttonColorRequired: Colors.lightBlue.shade600,
              callback: () {
                setState(() {
                  task.justLoaded = false;
                });
                tasksServices.taskStateChange(
                    task.taskAddress, task.participant, 'review', task.nanoId,
                    message: interface.taskMessage.isEmpty ? null : interface.taskMessage);
                Navigator.pop(context);
                interface.emptyTaskMessage();
                RouteInformation routeInfo =
                const RouteInformation(location: '/performer');
                Beamer.of(context).updateRouteInformation(routeInfo);
                showDialog(
                    context: context,
                    builder: (context) => WalletAction(
                      nanoId: task.nanoId,
                      taskName: 'taskStateChange',
                    ));
              },
            ),

          if (task.taskState == "review" &&
              (fromPage == 'performer' || tasksServices.hardhatDebug == true))
            TaskDialogButton(
              inactive: false,
              buttonName: 'Check merge',
              buttonColorRequired: Colors.lightBlue.shade600,
              callback: () {
                interface.statusText = const TextSpan(
                    text: 'Checking ...',
                    style: TextStyle( fontWeight: FontWeight.bold, color: Colors.green)
                );
                tasksServices.myNotifyListeners();
                debounceNotifyListener.debounce(() {
                  interface.statusText = const TextSpan(
                      text: 'Open',
                      style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black)
                  );
                  tasksServices.myNotifyListeners();
                });
                // setState(() {
                //   task.justLoaded = false;
                // });
                // tasksServices.taskStateChange(
                //     task.taskAddress, task.participant, 'review', task.nanoId,
                //     message: interface.taskMessage.isEmpty ? null : interface.taskMessage);
                // Navigator.pop(context);
                // interface.emptyTaskMessage();
                // RouteInformation routeInfo =
                // const RouteInformation(location: '/performer');
                // Beamer.of(context).updateRouteInformation(routeInfo);
                // showDialog(
                //     context: context,
                //     builder: (context) => WalletAction(
                //       nanoId: task.nanoId,
                //       taskName: 'taskStateChange',
                //     ));
              },
            ),

          if (task.taskState == "completed" &&
              (fromPage == 'performer' || tasksServices.hardhatDebug == true)
          )
          // WithdrawButton(object: task),
            TaskDialogButton(
              inactive: (task.contractValue != 0 || task.contractValueToken != 0) ? false : true,
              buttonName: 'Withdraw',
              buttonColorRequired: Colors.lightBlue.shade600,
              callback: () {
                setState(() {
                  task.justLoaded = false;
                });
                tasksServices.withdrawToChain(task.taskAddress, task.nanoId);
                Navigator.pop(context);
                interface.emptyTaskMessage();
                showDialog(
                    context: context,
                    builder: (context) => WalletAction(
                      nanoId: task.nanoId,
                      taskName: 'withdrawToChain',
                    ));
              },
              task: task,
            ),

          // *********************** CUSTOMER BUTTONS *********************** //
          // if (fromPage == 'customer' || tasksServices.hardhatDebug == true)
          //   TaskDialogButton(
          //     inactive: false,
          //     buttonName: 'Topup',
          //     buttonColorRequired: Colors.lightBlue.shade600,
          //     callback: () {
          //       showDialog(
          //           context: context,
          //           builder: (context) => AlertDialog(
          //             title: const Text('Topup contract'),
          //             // backgroundColor: Colors.black,
          //             content: const Payment(
          //               purpose: 'topup',
          //             ),
          //             actions: [
          //               TextButton(
          //                 onPressed: () {
          //                   tasksServices.addTokens(task.taskAddress,
          //                       interface.tokensEntered, task.nanoId);
          //                   Navigator.pop(context);
          //
          //                   showDialog(
          //                       context: context,
          //                       builder: (context) => WalletAction(
          //                         nanoId: task.nanoId,
          //                         taskName: 'addTokens',
          //                       ));
          //                 },
          //                 style: TextButton.styleFrom(
          //                     primary: Colors.white,
          //                     backgroundColor: Colors.green),
          //                 child: const Text('Topup contract'),
          //               ),
          //               TextButton(
          //                   child: const Text('Close'),
          //                   onPressed: () => context.beamToNamed('/tasks')
          //                 // Navigator.pop(context),
          //               ),
          //             ],
          //           ));
          //     },
          //   ),

          if (task.taskState == 'review' &&
              (fromPage == 'customer' || tasksServices.hardhatDebug == true))
            TaskDialogButton(
              inactive: false,
              buttonName: 'Sign Review',
              buttonColorRequired: Colors.lightBlue.shade600,
              callback: () {
                setState(() {
                  task.justLoaded = false;
                });
                tasksServices.taskStateChange(task.taskAddress,
                    task.participant, 'completed', task.nanoId,
                    message: interface.taskMessage.isEmpty ? null : interface.taskMessage);
                // context.beamToNamed('/customer');
                Navigator.pop(context);
                interface.emptyTaskMessage();
                RouteInformation routeInfo =
                const RouteInformation(location: '/customer');
                Beamer.of(context).updateRouteInformation(routeInfo);
                showDialog(
                    context: context,
                    builder: (context) => WalletAction(
                      nanoId: task.nanoId,
                      taskName: 'taskStateChange',
                    ));
              },
            ),
          if (task.taskState == 'completed' &&
              (fromPage == 'customer' || tasksServices.hardhatDebug == true))
            TaskDialogButton(
              inactive: false,
              buttonName: 'Rate task',
              buttonColorRequired: Colors.lightBlue.shade600,
              callback: () {
                (task.rating == 0)
                    ? () {
                  setState(() {
                    task.justLoaded = false;
                  });
                  // tasksServices.rateTask(
                  //     task.taskAddress, ratingScore, task.nanoId);
                  Navigator.pop(context);
                  interface.emptyTaskMessage();
                  showDialog(
                      context: context,
                      builder: (context) => WalletAction(
                        nanoId: task.nanoId,
                        taskName: 'rateTask',
                      ));
                }
                    : null;
              },
            ),

          // ************************* AUDITOR BUTTONS ************************ //
          if (
            interface.dialogCurrentState['name'] == 'auditor-new' ||
            tasksServices.hardhatDebug == true
          )
            TaskDialogButton(
              inactive: false,
              buttonName: 'Take audit',
              buttonColorRequired: Colors.lightBlue.shade600,
              callback: () {
                setState(() {
                  task.justLoaded = false;
                });
                tasksServices.taskAuditParticipate(
                    task.taskAddress, task.nanoId,
                    message: interface.taskMessage.isEmpty ? null : interface.taskMessage);
                Navigator.pop(context);
                interface.emptyTaskMessage();
                showDialog(
                    context: context,
                    builder: (context) => WalletAction(
                      nanoId: task.nanoId,
                      taskName: 'taskAuditParticipate',
                    ));
              },
            ),

          if (interface.dialogCurrentState['name'] == 'auditor-performing' ||
              tasksServices.hardhatDebug == true)
            TaskDialogButton(
              inactive: false,
              buttonName: interface.dialogCurrentState['mainButtonName'],
              buttonColorRequired: Colors.lightBlue.shade600,
              callback: () {
                showDialog(
                    context: context,
                    builder: (context) => AuditorDecision( task: task)
                );
              },
            ),
          // if ((fromPage == 'auditor' || tasksServices.hardhatDebug == true) &&
          //     task.auditState == 'performing')
          //   TaskDialogButton(
          //     inactive: false,
          //     buttonName: 'In favor of Performer',
          //     buttonColorRequired: Colors.lightBlue.shade600,
          //     callback: () {
          //       setState(() {
          //         task.justLoaded = false;
          //       });
          //       tasksServices.taskAuditDecision(
          //           task.taskAddress, 'performer', task.nanoId,
          //           message: interface.taskMessage.isEmpty ? null : interface.taskMessage);
          //       Navigator.pop(context);
          // interface.emptyTaskMessage();
          //       showDialog(
          //           context: context,
          //           builder: (context) => WalletAction(
          //             nanoId: task.nanoId,
          //             taskName: 'taskAuditDecision',
          //           ));
          //     },
          //   ),

          // ************************ ALL ROLES BUTTONS ********************** //
          // TextButton(
          //     child: const Text('Close'),
          //     onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}