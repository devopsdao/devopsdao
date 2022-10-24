import 'package:badges/badges.dart';
import 'package:devopsdao/custom_widgets/participants_list.dart';
import 'package:devopsdao/custom_widgets/payment.dart';
import 'package:devopsdao/custom_widgets/selectMenu.dart';
import 'package:devopsdao/custom_widgets/wallet_action.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../blockchain/interface.dart';
import '../blockchain/task.dart';
import '../blockchain/task_services.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';

import 'package:devopsdao/blockchain/task_services.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'buttons.dart';

class TaskInformationDialog extends StatefulWidget {
  // final int taskCount;
  final String role;
  final Task object;
  const TaskInformationDialog(
      {Key? key,
      // required this.taskCount,
      required this.role,
      required this.object})
      : super(key: key);

  @override
  _TaskInformationDialogState createState() => _TaskInformationDialogState();
}

class _TaskInformationDialogState extends State<TaskInformationDialog> {
  late Task task;
  bool enableRatingButton = false;
  double ratingScore = 0;

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();
    task = widget.object;

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text(task.title),
          content: SingleChildScrollView(
              child: ListBody(
            children: <Widget>[
              // RichText(
              //     text: TextSpan(
              //         style: DefaultTextStyle.of(context)
              //             .style
              //             .apply(fontSizeFactor: 1.0),
              //         children: <TextSpan>[
              //           const TextSpan(
              //               text: 'id: \n',
              //               style: TextStyle(fontWeight: FontWeight.bold)),
              //           TextSpan(text: task.nanoId)
              //         ])),
              RichText(
                  text: TextSpan(
                      style: DefaultTextStyle.of(context)
                          .style
                          .apply(fontSizeFactor: 1.0),
                      children: <TextSpan>[
                    const TextSpan(
                        text: 'Description: \n',
                        style:
                            TextStyle(height: 2, fontWeight: FontWeight.bold)),
                    TextSpan(text: task.description)
                  ])),
              RichText(
                  text: TextSpan(
                      style: DefaultTextStyle.of(context)
                          .style
                          .apply(fontSizeFactor: 1.0),
                      children: <TextSpan>[
                    const TextSpan(
                        text: 'Contract value: \n',
                        style:
                            TextStyle(height: 2, fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: '${task.contractValue} DEV \n',
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontSizeFactor: 1.0)),
                    TextSpan(
                        text: '${task.contractValueToken} aUSDC',
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontSizeFactor: 1.0))
                  ])),
              RichText(
                  text: TextSpan(
                      style: DefaultTextStyle.of(context)
                          .style
                          .apply(fontSizeFactor: 1.0),
                      children: <TextSpan>[
                    const TextSpan(
                        text: 'Contract owner: \n',
                        style:
                            TextStyle(height: 2, fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: task.contractOwner.toString(),
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontSizeFactor: 0.7))
                  ])),
              RichText(
                  text: TextSpan(
                      style: DefaultTextStyle.of(context)
                          .style
                          .apply(fontSizeFactor: 1.0),
                      children: <TextSpan>[
                    const TextSpan(
                        text: 'Contract address: \n',
                        style:
                            TextStyle(height: 2, fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: task.contractAddress.toString(),
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontSizeFactor: 0.7))
                  ])),
              RichText(
                  text: TextSpan(
                      style: DefaultTextStyle.of(context)
                          .style
                          .apply(fontSizeFactor: 1.0),
                      children: <TextSpan>[
                    const TextSpan(
                        text: 'Created: ',
                        style:
                            TextStyle(height: 2, fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: DateFormat('MM/dd/yyyy, hh:mm a')
                            .format(task.createTime),
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontSizeFactor: 1.0))
                  ])),

              // ********************** CUSTOMER ROLE ************************* //

              if (task.taskState == 'completed' && widget.role == 'customer')
                RichText(
                    text: TextSpan(
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontSizeFactor: 1.0),
                        children: const <TextSpan>[
                      TextSpan(
                          text: 'Rate the task:',
                          style: TextStyle(
                              height: 2, fontWeight: FontWeight.bold)),
                    ])),

              if (task.taskState == 'completed' && widget.role == 'customer')
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RatingBar.builder(
                        initialRating: 4,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 5.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemSize: 30.0,
                        onRatingUpdate: (rating) {
                          setState(() {
                            enableRatingButton = true;
                          });
                          ratingScore = rating;
                          tasksServices.myNotifyListeners();
                        },
                      ),
                    ]),
              if (task.taskState == "new" && widget.role == 'customer')
                RichText(
                    text: TextSpan(
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontSizeFactor: 1.0),
                        children: const <TextSpan>[
                      TextSpan(
                          text: 'Choose contractor: ',
                          style: TextStyle(
                              height: 2, fontWeight: FontWeight.bold)),
                    ])),
              if (task.taskState == "new" && widget.role == 'customer')
                ParticipantList(
                  listType: 'customer',
                  obj: task,
                ),

              // ************************ PERFORMER ROLE ************************** //

              if (task.taskState == 'completed' &&
                  widget.role == 'performer' &&
                  (task.contractValue != 0 || task.contractValueToken != 0))
                SelectNetworkMenu(object: task),

              // ****************** PERFORMER AND CUSTOMER ROLE ******************* //
              // *************************** AUDIT ******************************** //

              if (task.taskState == "audit" &&
                  task.auditState == "requested" &&
                  (widget.role == 'customer' || widget.role == 'performer'))
                RichText(
                    text: TextSpan(
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontSizeFactor: 1.0),
                        children: const <TextSpan>[
                      TextSpan(
                          text: 'Warning, this contract on Audit state \n'
                              'Please choose auditor: ',
                          style: TextStyle(
                              height: 2, fontWeight: FontWeight.bold)),
                    ])),
              if (task.taskState == "audit" &&
                  task.auditState == "performing" &&
                  (widget.role == 'customer' || widget.role == 'performer'))
                RichText(
                    text: TextSpan(
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontSizeFactor: 1.0),
                        children: <TextSpan>[
                      const TextSpan(
                          text: 'Your request is being resolved \n'
                              'Your auditor: \n',
                          style: TextStyle(
                              height: 2, fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: task.auditor.toString(),
                          style: DefaultTextStyle.of(context)
                              .style
                              .apply(fontSizeFactor: 0.7))
                    ])),
              if (task.taskState == "audit" &&
                  task.auditState == "requested" &&
                  (widget.role == 'customer' || widget.role == 'performer'))
                ParticipantList(
                  listType: 'audit',
                  obj: task,
                ),
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.green),
                  onPressed: () {
                    setState(() {
                      task.justLoaded = false;
                    });
                    tasksServices.taskAuditParticipate(
                        task.contractAddress, task.nanoId);
                    Navigator.pop(context);

                    showDialog(
                        context: context,
                        builder: (context) => WalletAction(
                              nanoId: task.nanoId,
                              taskName: 'taskParticipate',
                            ));
                  },
                  child: const Text('Participate')),

              // ************************ AUDITOR ROLE ************************** //
              // ************************ EMPTY ************************** //
            ],
          )),
          actions: [
            // ##################### ACTION BUTTONS PART ######################## //
            // ************************ NEW (EXCHANGE) ************************** //
            if ((task.contractOwner != tasksServices.publicAddress ||
                    tasksServices.hardhatDebug == true) &&
                tasksServices.publicAddress != null &&
                tasksServices.validChainID &&
                widget.role == 'exchange')
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.green),
                  onPressed: () {
                    setState(() {
                      task.justLoaded = false;
                    });
                    tasksServices.taskParticipate(
                        task.contractAddress, task.nanoId);
                    Navigator.pop(context);

                    showDialog(
                        context: context,
                        builder: (context) => WalletAction(
                              nanoId: task.nanoId,
                              taskName: 'taskParticipate',
                            ));
                  },
                  child: const Text('Participate')),
            // ********************** CUSTOMER BUTTONS ************************* //
            if (task.taskState == "agreed" && (widget.role == 'performer'))
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.green),
                  onPressed: () {
                    setState(() {
                      task.justLoaded = false;
                    });
                    tasksServices.taskStateChange(task.contractAddress,
                        task.participant, 'progress', task.nanoId);
                    Navigator.pop(context);

                    showDialog(
                        context: context,
                        builder: (context) => WalletAction(
                              nanoId: task.nanoId,
                              taskName: 'taskStateChange',
                            ));
                  },
                  child: const Text('Start the job')),
            if (task.taskState == "progress" && (widget.role == 'performer'))
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.green),
                  onPressed: () {
                    setState(() {
                      task.justLoaded = false;
                    });
                    tasksServices.taskStateChange(task.contractAddress,
                        task.participant, 'review', task.nanoId);
                    Navigator.pop(context);

                    showDialog(
                        context: context,
                        builder: (context) => WalletAction(
                              nanoId: task.nanoId,
                              taskName: 'taskStateChange',
                            ));
                  },
                  child: const Text('Review')),
            if (task.taskState == "review" &&
                (widget.role == 'customer' ||
                    tasksServices.hardhatDebug == true))
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.orangeAccent),
                  onPressed: () {
                    setState(() {
                      task.justLoaded = false;
                    });
                    tasksServices.taskStateChange(task.contractAddress,
                        task.participant, 'audit', task.nanoId);
                    Navigator.pop(context);

                    showDialog(
                        context: context,
                        builder: (context) => WalletAction(
                              nanoId: task.nanoId,
                              taskName: 'taskStateChange',
                            ));
                  },
                  child: const Text('Request audit')),
            if (task.taskState == "completed" &&
                (widget.role == 'customer' ||
                    widget.role == 'performer' ||
                    tasksServices.hardhatDebug == true) &&
                (task.contractValue != 0 || task.contractValueToken != 0))
              WithdrawButton(object: task),

            // *********************** SUBMITTER BUTTONS *********************** //
            if (widget.role == 'customer')
              TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text('Topup contract'),
                            // backgroundColor: Colors.black,
                            content: const Payment(
                              purpose: 'topup',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  tasksServices.addTokens(task.contractAddress,
                                      interface.tokensEntered, task.nanoId);
                                  Navigator.pop(context);

                                  showDialog(
                                      context: context,
                                      builder: (context) => WalletAction(
                                            nanoId: task.nanoId,
                                            taskName: 'addTokens',
                                          ));
                                },
                                style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    backgroundColor: Colors.green),
                                child: const Text('Topup contract'),
                              ),
                              TextButton(
                                  child: const Text('Close'),
                                  onPressed: () => Navigator.pop(context)),
                            ],
                          ));
                },
                style: TextButton.styleFrom(
                    primary: Colors.white, backgroundColor: Colors.green),
                child: const Text('Topup'),
              ),

            // TextButton(
            //     child: Text('Withdraw to Chain'),
            //     style: TextButton.styleFrom(
            //         primary: Colors.white,
            //         backgroundColor: Colors.green),
            //     onPressed: () {
            //       setState(() {
            //         task.justLoaded = false;
            //       });
            //       tasksServices.withdrawToChain(
            //           task.contractAddress,
            //           task.nanoId);
            //       Navigator.pop(context);
            //
            //       showDialog(
            //           context: context,
            //           builder: (context) => WalletAction(
            //                 nanoId:
            //                     task.nanoId,
            //                 taskName: 'withdrawToChain',
            //               ));
            //     }),

            if (task.taskState == 'review' && (widget.role == 'customer'))
              // ******* Sign Review Button ******** //
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.green),
                  onPressed: () {
                    setState(() {
                      task.justLoaded = false;
                    });
                    tasksServices.taskStateChange(task.contractAddress,
                        task.participant, 'completed', task.nanoId);
                    Navigator.pop(context);

                    showDialog(
                        context: context,
                        builder: (context) => WalletAction(
                              nanoId: task.nanoId,
                              taskName: 'taskStateChange',
                            ));
                  },
                  child: const Text('Sign Review')),
            if (task.taskState == 'completed' && (widget.role == 'performer'))
              TextButton(
                  // ******* Rate task Button ******** //
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      disabledBackgroundColor: Colors.white10,
                      backgroundColor: Colors.green),
                  onPressed: (task.rating == 0 && enableRatingButton)
                      ? () {
                          setState(() {
                            task.justLoaded = false;
                          });
                          // tasksServices.rateTask(
                          //     task.contractAddress, ratingScore, task.nanoId);
                          Navigator.pop(context);

                          showDialog(
                              context: context,
                              builder: (context) => WalletAction(
                                    nanoId: task.nanoId,
                                    taskName: 'rateTask',
                                  ));
                        }
                      : null,
                  child: const Text('Rate task')),

            // **************** CUSTOMER AND PERFORMER BUTTONS ****************** //
            // ************************* AUDIT REQUEST ************************* //
            if ((widget.role == 'performer' || widget.role == 'customer') &&
                (task.taskState == "progress" || task.taskState == "review"))
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.orangeAccent),
                  onPressed: () {
                    setState(() {
                      task.justLoaded = false;
                    });
                    tasksServices.taskStateChange(task.contractAddress,
                        task.participant, 'audit', task.nanoId);
                    Navigator.pop(context);

                    showDialog(
                        context: context,
                        builder: (context) => WalletAction(
                              nanoId: task.nanoId,
                              taskName: 'taskStateChange',
                            ));
                  },
                  child: const Text('Request audit')),

            // ************************* AUDITOR BUTTONS ************************ //
            if ((widget.role == 'auditor') && task.auditState == 'performing')
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.green),
                  onPressed: () {
                    setState(() {
                      task.justLoaded = false;
                    });
                    tasksServices.taskAuditDecision(
                        task.contractAddress, 'Customer', task.nanoId);
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context) => WalletAction(
                              nanoId: task.nanoId,
                              taskName: 'taskAuditDecision',
                            ));
                  },
                  child: const Text('In favor of Customer')),
            if (widget.role == 'auditor' && task.auditState == 'performing')
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.green),
                  onPressed: () {
                    setState(() {
                      task.justLoaded = false;
                    });
                    tasksServices.taskAuditDecision(
                        task.contractAddress, 'Performer', task.nanoId);
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context) => WalletAction(
                              nanoId: task.nanoId,
                              taskName: 'taskAuditDecision',
                            ));
                  },
                  child: const Text('In favor of Performer')),

            // ************************ ALL ROLES BUTTONS ********************** //
            TextButton(
                child: const Text('Close'),
                onPressed: () => Navigator.pop(context)),
          ],
        );
      },
    );
  }
}
