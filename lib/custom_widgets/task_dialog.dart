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
import '../chat/main.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';

import 'package:devopsdao/blockchain/task_services.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'buttons.dart';

import 'package:beamer/beamer.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blockchain/task.dart';
import '../blockchain/task_services.dart';
import '../custom_widgets/task_dialog.dart';

class TaskDialog extends StatefulWidget {
  final String role;
  final String taskAddress;
  const TaskDialog({Key? key, required this.taskAddress, required this.role})
      : super(key: key);

  @override
  _TaskDialog createState() => _TaskDialog();
}

class _TaskDialog extends State<TaskDialog> {
  late Task task;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    // if (tasksServices.tasksCustomerSelection[widget.taskAddress] != null) {
    //   task = tasksServices.tasksCustomerSelection[widget.taskAddress]!;
    // } else if (tasksServices.tasksCustomerProgress[widget.taskAddress] !=
    //     null) {
    //   task = tasksServices.tasksCustomerProgress[widget.taskAddress]!;
    // } else if (tasksServices.tasksCustomerComplete[widget.taskAddress] !=
    //     null) {
    //   task = tasksServices.tasksCustomerComplete[widget.taskAddress]!;
    // }
    task = tasksServices.tasks[widget.taskAddress]!;
    print('taskAddress: ${widget.taskAddress}');

    return TaskInformationDialog(
      role: widget.role,
      object: task,
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();
    task = widget.object;
    final double borderRadius = interface.borderRadius;

    return LayoutBuilder(builder: (context, constraints) {
      // print('max:  ${constraints.maxHeight}');
      // print('max * : ${constraints.maxHeight * .65}');
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            insetPadding: const EdgeInsets.all(30),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  width: 400,
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        child: InkWell(
                          onTap: () {
                            interface.controller.animateToPage(0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(0.0),
                            height: 30,
                            width: 30,
                            child: Row(
                              children: const <Widget>[
                                Expanded(
                                  child: Icon(
                                    Icons.arrow_back,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        flex: 10,
                        child: Text(
                          task.title,
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          // print(widget.role);
                          context.beamToNamed('/${widget.role}');
                          // context.beamBack();
                          // Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(0.0),
                          height: 30,
                          width: 30,
                          // decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(6),
                          // ),
                          child: Row(
                            children: const <Widget>[
                              Expanded(
                                child: Icon(
                                  Icons.close,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: constraints.maxHeight * .665 < 400
                      ? 320
                      : constraints.maxHeight * .665,
                  // width: constraints.maxWidth * .8,
                  // height: 550,
                  width: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    image: const DecorationImage(
                      image: AssetImage("assets/images/cross.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: DialogPages(
                      borderRadius: borderRadius,
                      requiredTask: task,
                      requiredRole: widget.role,
                      topConstraints: constraints),
                ),
              ]),
            ),
            // actions: [
            //   // ##################### ACTION BUTTONS PART ######################## //
            //   // ************************ NEW (EXCHANGE) ************************** //
            //   if (task.contractOwner != tasksServices.ownAddress &&
            //       tasksServices.ownAddress != null &&
            //       tasksServices.validChainID && widget.role == 'tasks')
            //     TextButton(
            //         style: TextButton.styleFrom(
            //             primary: Colors.white, backgroundColor: Colors.green),
            //         onPressed: () {
            //           setState(() {
            //             task.justLoaded = false;
            //           });
            //           tasksServices.taskParticipation(
            //               task.contractAddress, task.nanoId);
            //           Navigator.pop(context);
            //
            //           showDialog(
            //               context: context,
            //               builder: (context) => WalletAction(
            //                 nanoId: task.nanoId,
            //                 taskName: 'taskParticipation',
            //               ));
            //         },
            //         child: const Text('Participate')),
            //   // ********************** CUSTOMER BUTTONS ************************* //
            //   if (task.taskState == "agreed" && widget.role == 'customer')
            //     TextButton(
            //         style: TextButton.styleFrom(
            //             primary: Colors.white, backgroundColor: Colors.green),
            //         onPressed: () {
            //           setState(() {
            //             task.justLoaded = false;
            //           });
            //           tasksServices.changeTaskStatus(task.contractAddress,
            //               task.participiant, 'progress', task.nanoId);
            //           Navigator.pop(context);
            //
            //           showDialog(
            //               context: context,
            //               builder: (context) => WalletAction(
            //                 nanoId: task.nanoId,
            //                 taskName: 'changeTaskStatus',
            //               ));
            //         },
            //         child: const Text('Start the job')),
            //   if (task.taskState == "progress" && widget.role == 'customer')
            //     TextButton(
            //         style: TextButton.styleFrom(
            //             primary: Colors.white, backgroundColor: Colors.green),
            //         onPressed: () {
            //           setState(() {
            //             task.justLoaded = false;
            //           });
            //           tasksServices.changeTaskStatus(task.contractAddress,
            //               task.participiant, 'review', task.nanoId);
            //           Navigator.pop(context);
            //
            //           showDialog(
            //               context: context,
            //               builder: (context) => WalletAction(
            //                 nanoId: task.nanoId,
            //                 taskName: 'changeTaskStatus',
            //               ));
            //         },
            //         child: const Text('Review')),
            //   if (task.taskState == "review" && widget.role == 'customer')
            //     TextButton(
            //         style: TextButton.styleFrom(
            //             primary: Colors.white, backgroundColor: Colors.orangeAccent),
            //         onPressed: () {
            //           setState(() {
            //             task.justLoaded = false;
            //           });
            //           tasksServices.changeTaskStatus(task.contractAddress,
            //               task.participiant, 'audit', task.nanoId);
            //           Navigator.pop(context);
            //
            //           showDialog(
            //               context: context,
            //               builder: (context) => WalletAction(
            //                 nanoId: task.nanoId,
            //                 taskName: 'changeTaskStatus',
            //               ));
            //         },
            //         child: const Text('Request audit')),
            //   if (task.taskState == "completed" && widget.role == 'customer' &&
            //       (task.contractValue != 0 || task.contractValueToken != 0))
            //     WithdrawButton(object: task),
            //
            //   // *********************** SUBMITTER BUTTONS *********************** //
            //   if (widget.role == 'submitter')
            //     TextButton(
            //       onPressed: () {
            //         showDialog(
            //             context: context,
            //             builder: (context) => AlertDialog(
            //               title: Text('Topup contract'),
            //               // backgroundColor: Colors.black,
            //               content: const Payment(
            //                 purpose: 'topup',
            //               ),
            //               actions: [
            //                 TextButton(
            //                   onPressed: () {
            //                     tasksServices.addTokens(task.contractAddress,
            //                         interface.tokensEntered, task.nanoId);
            //                     Navigator.pop(context);
            //
            //                     showDialog(
            //                         context: context,
            //                         builder: (context) => WalletAction(
            //                           nanoId: task.nanoId,
            //                           taskName: 'addTokens',
            //                         ));
            //                   },
            //                   style: TextButton.styleFrom(
            //                       primary: Colors.white,
            //                       backgroundColor: Colors.green),
            //                   child: const Text('Topup contract'),
            //                 ),
            //                 TextButton(
            //                     child: const Text('Close'),
            //                     onPressed: () => Navigator.pop(context)),
            //               ],
            //             ));
            //       },
            //       style: TextButton.styleFrom(
            //           primary: Colors.white, backgroundColor: Colors.green),
            //       child: const Text('Topup'),
            //     ),
            //
            //   // TextButton(
            //   //     child: Text('Withdraw to Chain'),
            //   //     style: TextButton.styleFrom(
            //   //         primary: Colors.white,
            //   //         backgroundColor: Colors.green),
            //   //     onPressed: () {
            //   //       setState(() {
            //   //         task.justLoaded = false;
            //   //       });
            //   //       tasksServices.withdrawToChain(
            //   //           task.contractAddress,
            //   //           task.nanoId);
            //   //       Navigator.pop(context);
            //   //
            //   //       showDialog(
            //   //           context: context,
            //   //           builder: (context) => WalletAction(
            //   //                 nanoId:
            //   //                     task.nanoId,
            //   //                 taskName: 'withdrawToChain',
            //   //               ));
            //   //     }),
            //
            //   if (task.taskState == 'review' && widget.role == 'submitter')
            //   // ******* Sign Review Button ******** //
            //     TextButton(
            //         style: TextButton.styleFrom(
            //             primary: Colors.white, backgroundColor: Colors.green),
            //         onPressed: () {
            //           setState(() {
            //             task.justLoaded = false;
            //           });
            //           tasksServices.changeTaskStatus(task.contractAddress,
            //               task.participiant, 'completed', task.nanoId);
            //           Navigator.pop(context);
            //
            //           showDialog(
            //               context: context,
            //               builder: (context) => WalletAction(
            //                 nanoId: task.nanoId,
            //                 taskName: 'changeTaskStatus',
            //               ));
            //         },
            //         child: const Text('Sign Review')),
            //   if (task.taskState == 'completed' && widget.role == 'submitter')
            //     TextButton(
            //       // ******* Rate task Button ******** //
            //         style: TextButton.styleFrom(
            //             primary: Colors.white,
            //             disabledBackgroundColor: Colors.white10,
            //             backgroundColor: Colors.green),
            //         onPressed: (task.score == 0 && enableRatingButton)
            //             ? () {
            //           setState(() {
            //             task.justLoaded = false;
            //           });
            //           tasksServices.rateTask(
            //               task.contractAddress, ratingScore, task.nanoId);
            //           Navigator.pop(context);
            //
            //           showDialog(
            //               context: context,
            //               builder: (context) => WalletAction(
            //                 nanoId: task.nanoId,
            //                 taskName: 'rateTask',
            //               ));
            //         }
            //             : null,
            //         child: const Text('Rate task')),
            //
            //   // **************** CUSTOMER AND PERFORMER BUTTONS ****************** //
            //   // ************************* AUDIT REQUEST ************************* //
            //   if ((widget.role == 'submitter' || widget.role == 'customer') &&
            //       (task.taskState == "progress" || task.taskState == "review"))
            //     TextButton(
            //         style: TextButton.styleFrom(
            //             primary: Colors.white, backgroundColor: Colors.orangeAccent),
            //         onPressed: () {
            //           setState(() {
            //             task.justLoaded = false;
            //           });
            //           tasksServices.changeTaskStatus(task.contractAddress,
            //               task.participiant, 'audit', task.nanoId);
            //           Navigator.pop(context);
            //
            //           showDialog(
            //               context: context,
            //               builder: (context) => WalletAction(
            //                 nanoId: task.nanoId,
            //                 taskName: 'changeTaskStatus',
            //               ));
            //         },
            //         child: const Text('Request audit')),
            //
            //   // ************************* AUDITOR BUTTONS ************************ //
            //   if(widget.role == 'auditor' && task.auditState == 'performing')
            //     TextButton(
            //         style: TextButton.styleFrom(
            //             primary: Colors.white,
            //             backgroundColor: Colors.green),
            //         onPressed: () {
            //           setState(() {task.justLoaded = false;});
            //           tasksServices.changeAuditTaskStatus(
            //               task.contractAddress,
            //               'Customer',
            //               task.nanoId);
            //           Navigator.pop(context);
            //           showDialog(
            //               context: context,
            //               builder: (context) => WalletAction( nanoId: task.nanoId,
            //                 taskName: 'changeAuditTaskStatus',));
            //         },
            //
            //         child: const Text('In favor of Customer')),
            //   if(widget.role == 'auditor' && task.auditState == 'performing')
            //     TextButton(
            //         style: TextButton.styleFrom(
            //             primary: Colors.white,
            //             backgroundColor: Colors.green),
            //         onPressed: () {
            //           setState(() {task.justLoaded = false;});
            //           tasksServices.changeAuditTaskStatus(
            //               task.contractAddress,
            //               'Performer',
            //               task.nanoId);
            //           Navigator.pop(context);
            //           showDialog(
            //               context: context,
            //               builder: (context) => WalletAction(
            //                 nanoId: task.nanoId,
            //                 taskName: 'changeAuditTaskStatus',
            //               ));
            //         },
            //
            //         child: const Text('In favor of Performer')),
            //
            //   // ************************ ALL ROLES BUTTONS ********************** //
            //   TextButton(
            //       child: const Text('Close'),
            //       onPressed: () => Navigator.pop(context)),
            // ],
          );
        },
      );
    });
  }
}

class DialogPages extends StatefulWidget {
  // final String buttonName;
  final double borderRadius;
  final Task requiredTask;
  final String requiredRole;
  final BoxConstraints topConstraints;

  const DialogPages(
      {Key? key,
      // required this.buttonName,
      required this.borderRadius,
      required this.requiredTask,
      required this.requiredRole,
      required this.topConstraints})
      : super(key: key);

  @override
  _DialogPagesState createState() => _DialogPagesState();
}

class _DialogPagesState extends State<DialogPages> {
  bool enableRatingButton = false;
  double ratingScore = 0;

  TextEditingController? messageForStateController;

  @override
  void initState() {
    super.initState();
    messageForStateController = TextEditingController();
  }

  @override
  void dispose() {
    // Don't forget to dispose all of your controllers!
    // _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var interface = context.watch<InterfaceServices>();
    var tasksServices = context.watch<TasksServices>();

    Task task = widget.requiredTask;
    String role = widget.requiredRole;

    return PageView(
      scrollDirection: Axis.horizontal,
      // pageSnapping: false,
      // physics: BouncingScrollPhysics(),
      // physics: const NeverScrollableScrollPhysics(),
      controller: interface.controller,
      // onPageChanged: (number) {
      //   interface.pageWalletViewNumber = number;
      //   tasksServices.myNotifyListeners();
      //   // print(number);
      // },
      children: <Widget>[
        Column(
          children: [
            // const SizedBox(height: 50),
            Center(
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: GestureDetector(
                  onTap: () {
                    interface.controller.animateToPage(1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease);
                    print('${MediaQuery.of(context).size.width} adfas');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    // height: MediaQuery.of(context).size.width * .08,
                    // width: MediaQuery.of(context).size.width * .57
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                    ),
                    child: Container(
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
                        Container(
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            task.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),

                        Container(
                            padding: const EdgeInsets.all(6),
                            child: RichText(
                                text: TextSpan(
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .apply(fontSizeFactor: 1.0),
                                    children: <TextSpan>[
                                  TextSpan(
                                    text: task.description,
                                  )
                                ]))),

                        // ********************** CUSTOMER ROLE ************************* //

                        if (task.taskState == 'completed' &&
                            (role == 'customer' ||
                                tasksServices.hardhatDebug == true))
                          Container(
                            padding: const EdgeInsets.all(6),
                            child: RichText(
                                text: TextSpan(
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .apply(fontSizeFactor: 1.0),
                                    children: const <TextSpan>[
                                  TextSpan(
                                      text: 'Rate the task:',
                                      style: TextStyle(
                                          height: 2,
                                          fontWeight: FontWeight.bold)),
                                ])),
                          ),

                        if (task.taskState == 'completed' &&
                            (role == 'customer' ||
                                tasksServices.hardhatDebug == true))
                          Container(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  RatingBar.builder(
                                    initialRating: 4,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
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
                          ),

                        // ************************ PERFORMER ROLE ************************** //

                        if (task.taskState == 'completed' &&
                            (role == 'performer' ||
                                tasksServices.hardhatDebug == true) &&
                            (task.contractValue != 0 ||
                                task.contractValueToken != 0))
                          SelectNetworkMenu(object: task),

                        // ****************** PERFORMER AND CUSTOMER ROLE ******************* //
                        // *************************** AUDIT ******************************** //

                        if (task.taskState == "audit" &&
                            task.auditState == "requested" &&
                            (role == 'customer' ||
                                role == 'performer' ||
                                tasksServices.hardhatDebug == true))
                          RichText(
                              text: TextSpan(
                                  style: DefaultTextStyle.of(context)
                                      .style
                                      .apply(fontSizeFactor: 1.0),
                                  children: const <TextSpan>[
                                TextSpan(
                                    text:
                                        'Warning, this contract on Audit state \n'
                                        'Please choose auditor: ',
                                    style: TextStyle(
                                        height: 2,
                                        fontWeight: FontWeight.bold)),
                              ])),
                        if (task.taskState == "audit" &&
                            task.auditState == "performing" &&
                            (role == 'customer' ||
                                role == 'performer' ||
                                tasksServices.hardhatDebug == true))
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
                                        height: 2,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: task.auditor.toString(),
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .apply(fontSizeFactor: 0.7))
                              ])),
                        if (task.taskState == "audit" &&
                            task.auditState == "requested" &&
                            (role == 'customer' ||
                                role == 'performer' ||
                                tasksServices.hardhatDebug == true))
                          ParticipantList(
                            listType: 'audit',
                            obj: task,
                          ),

                        // ************************ AUDITOR ROLE ************************** //
                        // ************************ EMPTY ************************** //
                      ],
                    )),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            if (task.taskState == "new" &&
                (role == 'customer' || tasksServices.hardhatDebug == true)
            // && task.participants.isNotEmpty
            )
              Center(
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                    ),
                    child: ListBody(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(6),
                          child: RichText(
                              text: TextSpan(
                                  style: DefaultTextStyle.of(context)
                                      .style
                                      .apply(fontSizeFactor: 1.0),
                                  children: const <TextSpan>[
                                TextSpan(
                                    text: 'Choose contractor: ',
                                    style: TextStyle(
                                        height: 2,
                                        fontWeight: FontWeight.bold)),
                              ])),
                        ),
                        ParticipantList(
                          listType: 'customer',
                          obj: task,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 14),
            Center(
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: ListBody(
                        children: <Widget>[
                          RichText(
                              text: TextSpan(
                                  style: DefaultTextStyle.of(context)
                                      .style
                                      .apply(fontSizeFactor: 1.0),
                                  children: <TextSpan>[
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
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            ),
            // ChooseWalletButton(
            //   active: tasksServices.platform == 'mobile' ? true : false,
            //   buttonName: 'metamask',
            //   borderRadius: widget.borderRadius,
            // ),
            const SizedBox(height: 14),

            Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: Container(
                // constraints: const BoxConstraints(maxHeight: 500),
                padding: const EdgeInsets.all(8.0),
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                ),
                child: SingleChildScrollView(
                  child: TextFormField(
                    controller: messageForStateController,
                    // onChanged: (_) => EasyDebounce.debounce(
                    //   'messageForStateController',
                    //   Duration(milliseconds: 2000),
                    //   () => setState(() {}),
                    // ),
                    autofocus: false,
                    obscureText: false,

                    decoration: const InputDecoration(
                      labelText: 'Tap to message',
                      labelStyle:
                          TextStyle(fontSize: 17.0, color: Colors.black54),
                      hintText: '[Enter your message here..]',
                      hintStyle:
                          TextStyle(fontSize: 15.0, color: Colors.black54),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                    ),
                    style: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Poppins',
                          color: Colors.black87,
                          lineHeight: 2,
                        ),
                    maxLines: 3,
                  ),
                ),
              ),
            ),
            // ChooseWalletButton(active: true, buttonName: 'wallet_connect', borderRadius: widget.borderRadius,),
            const Spacer(),
            Container(
              padding: const EdgeInsets.fromLTRB(26.0, 14.0, 26.0, 16.0),
              width: 362,
              child: Wrap(
                direction: Axis.horizontal,
                children: [
                  // ##################### ACTION BUTTONS PART ######################## //
                  // ************************ NEW (EXCHANGE) ************************** //
                  if ((task.contractOwner != tasksServices.publicAddress ||
                          tasksServices.hardhatDebug == true) &&
                      tasksServices.publicAddress != null &&
                      tasksServices.validChainID &&
                      role == 'tasks')
                    TaskDialogButton(
                      buttonName: 'Participate',
                      buttonColorRequired: Colors.lightBlue.shade600,
                      callback: () {
                        setState(() {
                          task.justLoaded = false;
                        });
                        tasksServices.taskParticipate(
                            task.taskAddress, task.nanoId,
                            message: messageForStateController!.text);
                        Navigator.pop(context);

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
                      (role == 'performer' ||
                          tasksServices.hardhatDebug == true))
                    TaskDialogButton(
                      buttonName: 'Start the task',
                      buttonColorRequired: Colors.lightBlue.shade600,
                      callback: () {
                        setState(() {
                          task.justLoaded = false;
                        });
                        tasksServices.taskStateChange(task.taskAddress,
                            task.participant, 'progress', task.nanoId,
                            message: messageForStateController!.text);
                        Navigator.pop(context);

                        showDialog(
                            context: context,
                            builder: (context) => WalletAction(
                                  nanoId: task.nanoId,
                                  taskName: 'taskStateChange',
                                ));
                      },
                    ),
                  if (task.taskState == "progress" &&
                      (role == 'performer' ||
                          tasksServices.hardhatDebug == true))
                    TaskDialogButton(
                      buttonName: 'Review',
                      buttonColorRequired: Colors.lightBlue.shade600,
                      callback: () {
                        setState(() {
                          task.justLoaded = false;
                        });
                        tasksServices.taskStateChange(task.taskAddress,
                            task.participant, 'review', task.nanoId,
                            message: messageForStateController!.text);
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (context) => WalletAction(
                                  nanoId: task.nanoId,
                                  taskName: 'taskStateChange',
                                ));
                      },
                    ),

                  if (task.taskState == "completed" &&
                      (role == 'customer' ||
                          role == 'performer' ||
                          tasksServices.hardhatDebug == true) &&
                      (task.contractValue != 0 || task.contractValueToken != 0))
                    // WithdrawButton(object: task),
                    TaskDialogButton(
                      buttonName: 'Withdraw',
                      buttonColorRequired: Colors.lightBlue.shade600,
                      callback: () {
                        setState(() {
                          task.justLoaded = false;
                        });
                        tasksServices.withdrawToChain(
                            task.taskAddress, task.nanoId);
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (context) => WalletAction(
                                  nanoId: task.nanoId,
                                  taskName: 'withdrawToChain',
                                ));
                      },
                      taskObject: task,
                    ),

                  // *********************** CUSTOMER BUTTONS *********************** //
                  if (role == 'customer' || tasksServices.hardhatDebug == true)
                    TaskDialogButton(
                      buttonName: 'Topup',
                      buttonColorRequired: Colors.lightBlue.shade600,
                      callback: () {
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
                                        tasksServices.addTokens(
                                            task.taskAddress,
                                            interface.tokensEntered,
                                            task.nanoId);
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
                                        onPressed: () =>
                                            context.beamToNamed('/tasks')
                                        // Navigator.pop(context),
                                        ),
                                  ],
                                ));
                      },
                    ),

                  if (task.taskState == 'review' &&
                      (role == 'customer' ||
                          tasksServices.hardhatDebug == true))
                    TaskDialogButton(
                      buttonName: 'Sign Review',
                      buttonColorRequired: Colors.lightBlue.shade600,
                      callback: () {
                        setState(() {
                          task.justLoaded = false;
                        });
                        tasksServices.taskStateChange(task.taskAddress,
                            task.participant, 'completed', task.nanoId,
                            message: messageForStateController!.text);
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (context) => WalletAction(
                                  nanoId: task.nanoId,
                                  taskName: 'taskStateChange',
                                ));
                      },
                    ),
                  if (task.taskState == 'completed' &&
                      (role == 'customer' ||
                          tasksServices.hardhatDebug == true))
                    TaskDialogButton(
                      buttonName: 'Rate task',
                      buttonColorRequired: Colors.lightBlue.shade600,
                      callback: () {
                        (task.rating == 0 && enableRatingButton)
                            ? () {
                                setState(() {
                                  task.justLoaded = false;
                                });
                                // tasksServices.rateTask(
                                //     task.taskAddress, ratingScore, task.nanoId);
                                Navigator.pop(context);
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

                  // **************** CUSTOMER AND PERFORMER BUTTONS ****************** //
                  // ************************* AUDIT REQUEST ************************* //
                  if ((role == 'performer' ||
                          role == 'customer' ||
                          tasksServices.hardhatDebug == true) &&
                      (task.taskState == "progress" ||
                          task.taskState == "review"))
                    TaskDialogButton(
                      buttonName: 'Request audit',
                      buttonColorRequired: Colors.orangeAccent.shade700,
                      callback: () {
                        setState(() {
                          task.justLoaded = false;
                        });
                        tasksServices.taskStateChange(task.taskAddress,
                            task.participant, 'audit', task.nanoId,
                            message: messageForStateController!.text);
                        Navigator.pop(context);

                        showDialog(
                            context: context,
                            builder: (context) => WalletAction(
                                  nanoId: task.nanoId,
                                  taskName: 'taskStateChange',
                                ));
                      },
                    ),

                  // ************************* AUDITOR BUTTONS ************************ //
                  if ((role == 'auditor' ||
                          tasksServices.hardhatDebug == true) &&
                      task.auditState == 'requested')
                    TaskDialogButton(
                      buttonName: 'Take audit',
                      buttonColorRequired: Colors.lightBlue.shade600,
                      callback: () {
                        setState(() {
                          task.justLoaded = false;
                        });
                        tasksServices.taskAuditParticipate(
                            task.taskAddress, task.nanoId,
                            message: messageForStateController!.text);
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (context) => WalletAction(
                                  nanoId: task.nanoId,
                                  taskName: 'taskAuditParticipate',
                                ));
                      },
                    ),

                  if ((role == 'auditor' ||
                          tasksServices.hardhatDebug == true) &&
                      task.auditState == 'performing')
                    TaskDialogButton(
                      buttonName: 'In favor of Customer',
                      buttonColorRequired: Colors.lightBlue.shade600,
                      callback: () {
                        setState(() {
                          task.justLoaded = false;
                        });
                        tasksServices.taskAuditDecision(
                            task.taskAddress, 'Customer', task.nanoId,
                            message: messageForStateController!.text);
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (context) => WalletAction(
                                  nanoId: task.nanoId,
                                  taskName: 'taskAuditDecision',
                                ));
                      },
                    ),
                  if ((role == 'auditor' ||
                          tasksServices.hardhatDebug == true) &&
                      task.auditState == 'performing')
                    TaskDialogButton(
                      buttonName: 'In favor of Performer',
                      buttonColorRequired: Colors.lightBlue.shade600,
                      callback: () {
                        setState(() {
                          task.justLoaded = false;
                        });
                        tasksServices.taskAuditDecision(
                            task.taskAddress, 'Performer', task.nanoId,
                            message: messageForStateController!.text);
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (context) => WalletAction(
                                  nanoId: task.nanoId,
                                  taskName: 'taskAuditDecision',
                                ));
                      },
                    ),

                  // ************************ ALL ROLES BUTTONS ********************** //
                  // TextButton(
                  //     child: const Text('Close'),
                  //     onPressed: () => Navigator.pop(context)),
                ],
              ),
            )
          ],
        ),
        Column(
          children: [
            Container(
                child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    child: GestureDetector(
                        onTap: () {
                          interface.controller.animateToPage(2,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease);
                        },
                        child: Column(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(8.0),
                                // height: MediaQuery.of(context).size.width * .08,
                                // width: MediaQuery.of(context).size.width * .57
                                width: 380,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      widget.borderRadius),
                                ),
                                child: Container(
                                    padding: const EdgeInsets.all(6),
                                    child: RichText(
                                        text: TextSpan(
                                            style: DefaultTextStyle.of(context)
                                                .style
                                                .apply(fontSizeFactor: 1.0),
                                            children: <TextSpan>[
                                          TextSpan(
                                            text: task.description,
                                          )
                                        ])))),
                            // const Spacer(),
                            Container(
                              padding: const EdgeInsets.all(6),
                              child: RichText(
                                  text: TextSpan(
                                      style: DefaultTextStyle.of(context)
                                          .style
                                          .apply(fontSizeFactor: 1.0),
                                      children: <TextSpan>[
                                    const TextSpan(
                                        text: 'Created: ',
                                        style: TextStyle(
                                            height: 2,
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text: DateFormat('MM/dd/yyyy, hh:mm a')
                                            .format(task.createTime),
                                        style: DefaultTextStyle.of(context)
                                            .style
                                            .apply(fontSizeFactor: 1.0))
                                  ])),
                            ),
                          ],
                        )))),
            const SizedBox(height: 14),
            Center(
                child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    child: GestureDetector(
                        child: Container(
                            padding: const EdgeInsets.all(8.0),
                            // height: MediaQuery.of(context).size.width * .08,
                            // width: MediaQuery.of(context).size.width * .57
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(widget.borderRadius),
                            ),
                            child: ListBody(children: <Widget>[
                              RichText(
                                  text: TextSpan(
                                      style: DefaultTextStyle.of(context)
                                          .style
                                          .apply(fontSizeFactor: 1.0),
                                      children: <TextSpan>[
                                    const TextSpan(
                                        text: 'Contract owner: \n',
                                        style: TextStyle(
                                            height: 2,
                                            fontWeight: FontWeight.bold)),
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
                                        style: TextStyle(
                                            height: 2,
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text: task.taskAddress.toString(),
                                        style: DefaultTextStyle.of(context)
                                            .style
                                            .apply(fontSizeFactor: 0.7))
                                  ])),
                              // RichText(
                              //   text: TextSpan(
                              //     style: DefaultTextStyle.of(context)
                              //         .style
                              //         .apply(fontSizeFactor: 1.0),
                              //     children: <TextSpan>[
                              //       const TextSpan(
                              //           text: 'Created: ',
                              //           style: TextStyle(height: 2, fontWeight: FontWeight.bold)),
                              //       TextSpan(
                              //           text: DateFormat('MM/dd/yyyy, hh:mm a')
                              //               .format(task.createdTime),
                              //           style: DefaultTextStyle.of(context)
                              //               .style
                              //               .apply(fontSizeFactor: 1.0))
                              //     ])),
                            ]))))),
            const SizedBox(height: 14),
          ],
        ),
        Center(
            child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    // height: MediaQuery.of(context).size.height * .58,
                    height: widget.topConstraints.maxHeight * .6 < 365
                        ? 280
                        : widget.topConstraints.maxHeight * .6,
                    // width: MediaQuery.of(context).size.width * .57
                    width: 300,
                    // height: 540,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                    ),
                    child: ChatPage(
                        taskAddress: task.taskAddress,
                        nanoId: task.nanoId,
                        messages: task.messages,
                        tasksServices: tasksServices))))
      ],
    );
  }
}

class TaskDialogButton extends StatefulWidget {
  final String buttonName;
  final Color buttonColorRequired;
  final VoidCallback callback;
  final Task? taskObject;
  const TaskDialogButton(
      {Key? key,
      required this.buttonName,
      required this.buttonColorRequired,
      required this.callback,
      this.taskObject})
      : super(key: key);

  @override
  _TaskDialogButtonState createState() => _TaskDialogButtonState();
}

class _TaskDialogButtonState extends State<TaskDialogButton> {
  late Color buttonColor;
  late Color textColor = Colors.white;
  late bool _buttonState = true;
  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    buttonColor = widget.buttonColorRequired;

    // this check for WITHDRAW button:
    if (widget.taskObject != null) {
      if (widget.taskObject!.contractValue != 0) {
        _buttonState = true;
      } else if (widget.taskObject!.contractValueToken != 0) {
        if (widget.taskObject!.contractValueToken > tasksServices.transferFee ||
            tasksServices.destinationChain == 'Moonbase') {
          _buttonState = true;
        } else {
          textColor = Colors.black26;
          buttonColor = Colors.black54;
          _buttonState = false;
        }
      }
    }

    return Container(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        elevation: 9,
        borderRadius: BorderRadius.circular(6),
        color: buttonColor,
        child: InkWell(
          onTap: _buttonState ? widget.callback : null,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            // height: 40.0,
            // width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              widget.buttonName,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
